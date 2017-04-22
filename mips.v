`include "/datapath/mux.v"

module mips(clk, rst);
    input clk;   // clock
    input rst;   // reset

    wire [31:0] instr, AluOut, rd1, rd2, extout, AluB, writedata, pcp4, readdata;
    wire [31:2] pc, npc;
    wire [4:0] writereg;
    wire [3:0] AluCtrl;
    wire [2:0] NpcSel;
    wire [1:0] RegDst, wd_sel, ExtOp;
    wire AluSrc, RegWrite, MemWrite, zero;

    ctrl ctrl0(.opcode(instr[31:26]), .funct(instr[5:0]), .RegDst(RegDst), .AluSrc(AluSrc), 
                .MemWrite(MemWrite), .RegWrite(RegWrite), .wd_sel(wd_sel), .NpcSel(NpcSel), 
                .ExtOp(ExtOp), .AluCtrl(AluCtrl));
    im_4k im0(.addr(pc[11:2]), .dout(instr));
    pc pc0(.npc(npc), .clk(clk), .rst(rst), .pc(pc));
    npc npc0(.pc(pc), .imm(instr[25:0]), .target(AluOut), .NpcSel(NpcSel), .zero(zero), .npc(npc), .pcp4(pcp4));
    alu alu0(.A(rd1), .B(AluB), .AluCtrl(AluCtrl), .dout(AluOut), .zero(zero), .overflow());
    gpr gpr0(.clk(clk), .rst(rst), .ra(instr[25:21]), .rb(instr[20:16]), .rw(writereg), 
             .wd(writedata), .RegWrite(RegWrite), .rd1(rd1), .rd2(rd2), .NpcSel(NpcSel));
    dm_4k dm0(.addr(AluOut[9:0]), .din(rd2), .MemWrite(MemWrite), .clk(clk), .dout(readdata));
    ext ext0(.imm16(instr[15:0]), .ExtOp(ExtOp), .extout(extout));
    mux3_32 writedata_mux(.a(AluOut), .b(readdata), .c(pcp4), .sel(wd_sel), .out(writedata));
    mux3_5 writereg_mux(.a(instr[20:16]), .b(instr[15:11]), .c(5'h1f), .sel(RegDst), .out(writereg));
    mux2_32 aluB_mux(.a(rd2), .b(extout), .sel(AluSrc), .out(AluB));
endmodule

//TODO
//add overflow
//jr
//slt