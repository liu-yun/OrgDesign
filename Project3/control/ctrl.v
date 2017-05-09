module ctrl(clk, rst, opcode, funct, zero, PCWr, npcSel, IRWr, GPRWr, DMWr, AluOp, AluBsel, GPRsel, WDsel, ExtOp, bmode);
    input [5:0] opcode, funct;
    input clk, rst, zero;
    output [2:0] npcSel;
    output [1:0] GPRsel, WDsel, ExtOp;
    output AluBsel, GPRWr, bmode, PCWr, IRWr, GPRWr, DMWr;
    output [3:0] AluOp;

    wire R_TYPE, ADDU, SUBU, SLT, JR, JALR, ORI, LUI, LW, SW, LB, SB, ADDI, ADDIU, BEQ, J, JAL;

    //R-type
    assign R_TYPE = (opcode === 6'b000000);
    assign ADDU   = R_TYPE && (funct === 6'b100001);
    assign SUBU   = R_TYPE && (funct === 6'b100011);
    assign SLT    = R_TYPE && (funct === 6'b101010);
    assign JR     = R_TYPE && (funct === 6'b001000);
    assign JALR   = R_TYPE && (funct === 6'b001001);
    //I-type
    assign ORI    = (opcode === 6'b001101);
    assign LUI    = (opcode === 6'b001111);
    assign ADDI   = (opcode === 6'b001000);
    assign ADDIU  = (opcode === 6'b001001);

    assign LW     = (opcode === 6'b100011);
    assign LB     = (opcode === 6'b100000);
    assign SW     = (opcode === 6'b101011);
    assign SB     = (opcode === 6'b101000);

    assign BEQ    = (opcode === 6'b000100);
    //J-type
    assign J      = (opcode === 6'b000010);
    assign JAL    = (opcode === 6'b000011);

    //AluOp
    parameter Addu = 4'b0000;
    parameter Subu = 4'b0001;
    parameter Or   = 4'b0010;
    parameter Bb   = 4'b0011;
    parameter Aa   = 4'b0100;
    parameter Add  = 4'b0101;
    parameter Lt   = 4'b0110;

    parameter S0 = 4'b0000; //Fetch
    parameter S1 = 4'b0001; //Regfile read
    parameter S2 = 4'b0010; //Execute
    parameter S3 = 4'b0011; //Mem read write
    parameter S4 = 4'b0100; //Regfile write

    reg [3:0] state = 0;
    always @(posedge clk or posedge rst) begin
      if (rst)
        state <= S0;
      else begin
        case (state)
          S0:begin
              state <= S1;
             end 
          S1:begin
              state <= S2;
             end
          S2:begin
              if (ADDU | SUBU | SLT | ORI | LUI | ADDI | ADDIU)
                state <= S4;
              else if (LW | LB | SW | SB)
                state <= S3;
              else if (BEQ | J | JAL | JR | JALR)
                state <= S0;
             end
          S3:begin
              if (LW | LB)
                state <= S4;
              else
                state <= S0;
             end
          S4:begin
              state <= S0;
             end
        endcase
      end
    end

    assign AluOp = (state === S0) ? 4'b1111: //Invalid
                   (ADDU | ADDIU) ? Addu:
              (LW | LB | SW | SB) ? Addu:
                             ADDI ? Add:
                             SUBU ? Subu:
                              SLT ? Lt:
                              ORI ? Or:
                              LUI ? Bb:
                                    Subu; // BEQ

    assign PCWr = (state === S0) | (state === S2 & ( J | JAL | JR | (BEQ & zero)));
    assign npcSel = (state === S0) ? 3'b000:  //Invalid
              (state === S2) & BEQ ? 3'b001:
        (state === S2) & (J | JAL) ? 3'b010:
      (state === S2) & (JR | JALR) ? 3'b100:
                                     3'b000; //PC+4
    assign IRWr = (state === S0);
    assign GPRWr = ((state === S4) & (ADDU | SUBU | SLT | ORI | LW | LB | LUI | ADDI | ADDIU)) | ((state === S2) & (JAL | JALR));
    assign DMWr = (state === S3) & (SW | SB);
    assign GPRsel = {(JAL | JALR), (ADDU | SUBU | SLT)}; //RegDst
    assign AluBsel = (ORI | LW | LB | SW | SB | LUI | ADDI | ADDIU);
    assign MemtoReg = (LW | LB);
    assign bmode = (LB | SB);
    assign ExtOp = (state === S0) ? 2'b11: {(LUI), (LW | LB | SW | SB | ADDI | ADDIU)};
    assign WDsel =       (state === S0) ? 2'b11: //Invalid
           (!MemtoReg && !JAL && !JALR) ? 2'b00:
            (MemtoReg && !JAL && !JALR) ? 2'b01:
                                          2'b10; //JAL JALR

endmodule
