`include "/datapath/mux.v"

module mips(clk, rst);
    input clk;   // clock
    input rst;   // reset

    wire [31:0] instr, AluOut, rd1, rd2, extout, AluB, writedata, pcp4, readdata;
    wire [4:0] writereg;
    wire [3:0] AluCtrl;
    wire [2:0] NpcSel;
    wire [1:0] RegDst, wd_sel, ExtOp;
    wire [1:0] lbsel;
    wire AluSrc, RegWrite, overflow, MemWrite, zero, lb;

    ctrl ctrl0(.opcode(instr[31:26]), .funct(instr[5:0]), .RegDst(RegDst), .AluSrc(AluSrc), 
                .MemWrite(MemWrite), .RegWrite(RegWrite), .wd_sel(wd_sel), .NpcSel(NpcSel), 
                .ExtOp(ExtOp), .AluCtrl(AluCtrl), .lb(lb));
    ifu ifu0(.clk(clk), .rst(rst), .NpcSel(NpcSel), .zero(zero), .instr(instr), .pcp4(pcp4), .AluOut(AluOut));
    alu alu0(.A(rd1), .B(AluB), .AluCtrl(AluCtrl), .dout(AluOut), .zero(zero), .overflow(overflow));
    gpr gpr0(.clk(clk), .rst(rst), .ra(instr[25:21]), .rb(instr[20:16]), .rw(writereg), 
             .wd(writedata), .RegWrite(RegWrite), .overflow(overflow), .rd1(rd1), .rd2(rd2));
    dm_4k dm0(.addr(AluOut[11:2]), .din(rd2), .we(MemWrite), .clk(clk), .dout(readdata), .lb(lb), .lbsel(AluOut[1:0]));
    ext ext0(.imm16(instr[15:0]), .ExtOp(ExtOp), .extout(extout));
    mux3_32 writedata_mux(.a(AluOut), .b(readdata), .c(pcp4), .sel(wd_sel), .out(writedata));
    mux3_5 writereg_mux(.a(instr[20:16]), .b(instr[15:11]), .c(5'h1f), .sel(RegDst), .out(writereg));
    mux2_32 aluB_mux(.a(rd2), .b(extout), .sel(AluSrc), .out(AluB));
endmodule
