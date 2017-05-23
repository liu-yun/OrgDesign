module ctrl(clk, rst, instr, PrAddr, zero, IntReq, PCWr, npcSel, IRWr, GPRWr, DMWr, AluOp, AluBsel, GPRsel, WDsel, ExtOp, bmode, 
            Wen, EXLSet, EXLClr, PrWe, EPCWr);
    input clk, rst, zero, IntReq;
    input [31:0] instr;
    wire [5:0] opcode = instr[31:26], funct = instr[5:0];
    wire [4:0] mfmt = instr[25:21];
    input [31:2] PrAddr;
    output [2:0] npcSel, WDsel;
    output [1:0] GPRsel, ExtOp;
    output AluBsel, GPRWr, bmode, PCWr, IRWr, GPRWr, DMWr;
    output Wen, EXLSet, EXLClr, PrWe, EPCWr;
    output [3:0] AluOp;

    wire R_TYPE, ADDU, SUBU, SLT, JR, ORI, LUI, LW, SW, LB, SB, ADDI, ADDIU, BEQ, J, JAL, COP0, ERET, MFC0, MTC0, HitDEV;
    wire s0, s1, s2, s3, s4, s5;

    //R-type
    assign R_TYPE = (opcode === 6'b000000);
    assign ADDU  = R_TYPE && (funct === 6'b100001);
    assign SUBU  = R_TYPE && (funct === 6'b100011);
    assign SLT   = R_TYPE && (funct === 6'b101010);
    assign JR    = R_TYPE && (funct === 6'b001000);

    //I-type
    assign ORI   = (opcode === 6'b001101);
    assign LUI   = (opcode === 6'b001111);
    assign ADDI  = (opcode === 6'b001000);
    assign ADDIU = (opcode === 6'b001001);

    assign LW    = (opcode === 6'b100011);
    assign LB    = (opcode === 6'b100000);
    assign SW    = (opcode === 6'b101011);
    assign SB    = (opcode === 6'b101000);

    assign BEQ   = (opcode === 6'b000100);
    //J-type
    assign J     = (opcode === 6'b000010);
    assign JAL   = (opcode === 6'b000011);

    //COP0
    assign COP0 = (opcode === 6'b010000);
    assign ERET = COP0 && (funct === 6'b011000);
    assign MFC0 = COP0 && (mfmt === 5'b00000);
    assign MTC0 = COP0 && (mfmt === 5'b00100);

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
    parameter S5 = 4'b0101; //Interrupts

    reg [3:0] state = 0;
    assign s0 = (state === S0);
    assign s1 = (state === S1);
    assign s2 = (state === S2);
    assign s3 = (state === S3);
    assign s4 = (state === S4);
    assign s5 = (state === S5);
    
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
                    else if (BEQ | J | JAL | JR | ERET | MTC0 | MFC0) begin
                        if (IntReq)
                            state <= S5;
                        else
                            state <= S0;
                    end
                end
                S3:begin
                    if (LW | LB)
                        state <= S4;
                    else begin
                        if (IntReq)
                            state <= S5;
                        else
                            state <= S0;
                      end
                end
                S4:begin
                    if (IntReq)
                        state <= S5;
                    else
                        state <= S0;
                end
                S5:begin
                    state <= S0;
                end
            endcase
        end
    end

    assign AluOp = s0 ? 4'b1111: //Invalid
       (ADDU | ADDIU) ? Addu:
  (LW | LB | SW | SB) ? Addu:
                 ADDI ? Add:
                 SUBU ? Subu:
                  SLT ? Lt:
                  ORI ? Or:
                  LUI ? Bb:
                        Subu; // BEQ

    assign HitDEV = PrAddr[31:8] === 24'h00007f;
    assign PCWr = s0 | (s2 & ( J | JAL | JR | (BEQ & zero)) | ERET) | s5;
    assign npcSel = s0 ? 3'b000:  //Invalid
            (s2 & BEQ) ? 3'b001:
        s2 & (J | JAL) ? 3'b010:
             (s2 & JR) ? 3'b100:
         (s5 & IntReq) ? 3'b101: //to exception
           (s2 & ERET) ? 3'b110: //epc
                         3'b000; //PC+4
    assign IRWr = s0;
    assign GPRWr = (s4 & (ADDU | SUBU | SLT | ORI | LW | LB | LUI | ADDI | ADDIU)) | (s2 & (JAL | MFC0));
    assign DMWr = s3 & (SW | SB) & !HitDEV;
    assign PrWe = s3 & (SW | SB) & HitDEV;
    assign GPRsel = {(JAL), (ADDU | SUBU | SLT)}; //RegDst
    assign AluBsel = (ORI | LW | LB | SW | SB | LUI | ADDI | ADDIU);
    assign MemtoReg = (LW | LB) & !HitDEV;
    assign DEVtoReg = (LW | LB) & HitDEV;
    assign bmode = (LB | SB);
    assign ExtOp = s0 ? 2'b11: {(LUI), (LW | LB | SW | SB | ADDI | ADDIU)};
    assign WDsel =            s0 ? 3'b111: //Invalid
(!MemtoReg && !JAL && !DEVtoReg) ? 3'b000: //Alu
 (MemtoReg && !JAL && !DEVtoReg) ? 3'b001: //DM
                JAL && !DEVtoReg ? 3'b010: //JAL
                        DEVtoReg ? 3'b011: //Din
                                   3'b100; //cp0out
    assign EXLSet = s5 & IntReq;
    assign EXLClr = s2 & ERET;
    assign Wen = (s5 & IntReq) | (s2 & (MTC0 | ERET)); //we for cp0
    assign EPCWr = (s5 & IntReq);
endmodule
