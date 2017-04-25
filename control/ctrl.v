//R-type
`define R_TYPE 6'b000000
`define ADDU   6'b100001
`define SUBU   6'b100011
`define SLT    6'b101010
`define JR     6'b001000
//I-type
`define ORI    6'b001101
`define LUI    6'b001111
`define LW     6'b100011
`define SW     6'b101011
`define ADDI   6'b001000
`define ADDIU  6'b001001
`define BEQ    6'b010000
//J-type
`define J      6'b000010
`define JAL    6'b000011

//AluCtrl
`define Addu   4'b0000
`define Subu   4'b0001
`define Or     4'b0010
`define Bb     4'b0011
`define Aa     4'b0100
`define Add    4'b0101
`define Lt     4'b0110

module ctrl(opcode, funct, RegDst, AluSrc, MemWrite, RegWrite, wd_sel, NpcSel, ExtOp, AluCtrl);
    input [5:0] opcode, funct;
    output [2:0] NpcSel;
    output [1:0] RegDst, wd_sel, ExtOp;
    output AluSrc, MemWrite, RegWrite;
    output reg [3:0] AluCtrl;

    always @(opcode or funct) begin
      if (opcode == `R_TYPE) begin
        case (funct)
          `ADDU : AluCtrl <= `Addu;
          `SUBU : AluCtrl <= `Subu;
          `SLT  : AluCtrl <= `Lt;
          `JR   : AluCtrl <= `Aa;
          default: begin end
        endcase
      end
      else begin
        case (opcode)
          `ORI  : AluCtrl <= `Or;
          `LUI  : AluCtrl <= `Bb;
          `ADDI : AluCtrl <= `Add;
          `ADDIU: AluCtrl <= `Addu;
          `BEQ  : AluCtrl <= `Subu;
          default: begin end
        endcase
      end
    end

    assign RegDst = {(opcode == `JAL), (opcode == `R_TYPE&&(funct == `ADDU || funct == `SUBU))};
    assign AluSrc = (opcode == `ORI || opcode == `LW || opcode == `SW || opcode == `LUI || opcode == `ADDI || opcode == `ADDIU);
    assign MemWrite = (opcode == `SW);
    assign RegWrite = (opcode == `LUI || (opcode == `R_TYPE && (funct == `ADDU || funct == `SUBU)) || opcode == `ORI || opcode == `LW || opcode == `JAL);
    assign NpcSel = (opcode == `BEQ) ? 3'b001:
                    (opcode == `JAL) ? 3'b010:
                      (opcode == `J) ? 3'b011:
                     (opcode == `JR) ? 3'b100:
                                       3'b000;
    assign ExtOp = {(opcode == `LUI), (opcode == `LW || opcode == `SW || opcode == `ADDI || opcode == `ADDIU)};
    assign wd_sel = (!MemWrite&&opcode!=`JAL) ? 2'b00:
                     (MemWrite&&opcode!=`JAL) ? 2'b01:
                                                2'b10;

endmodule
