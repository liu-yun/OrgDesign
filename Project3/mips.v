module mips(clk, rst);
    input clk;   // clock
    input rst;   // reset

    wire [31:0] instrR, AluOut, AluOutR, rd1, rd2, rd1R, rd2R, extout, AluB, wd, pcp4, readdata, readdataR;
    wire [4:0] writereg;
    wire [3:0] AluOp;
    wire [2:0] NpcSel;
    wire [1:0] GPRsel, WDsel, ExtOp;
    wire [1:0] lbsel;
    wire AluBsel, overflow, zero, bmode, PCWr, IRWr, GPRWr, DMWr;

    ctrl ctrl0(.clk(clk), .rst(rst), .opcode(instrR[31:26]), .funct(instrR[5:0]), .zero(zero),
               .PCWr(PCWr), .NpcSel(NpcSel), .IRWr(IRWr), .GPRWr(GPRWr), .DMWr(DMWr), .AluOp(AluOp),
               .GPRsel(GPRsel), .AluBsel(AluBsel), .WDsel(WDsel), .ExtOp(ExtOp), .bmode(bmode));

    ifu ifu0(.clk(clk), .PCWr(PCWr), .IRWr(IRWr), .rst(rst), .NpcSel(NpcSel), .zero(zero), .instrR(instrR), .pcp4(pcp4), .A(rd1R));

    gpr U_RF(.clk(clk), .rst(rst), .ra(instrR[25:21]), .rb(instrR[20:16]), .rw(writereg), 
             .wd(wd), .RegWrite(GPRWr), .overflow(overflow), .rd1(rd1), .rd2(rd2));
    register_nwe AR(.clk(clk), .next(rd1), .out(rd1R));
    register_nwe BR(.clk(clk), .next(rd2), .out(rd2R));

    alu alu0(.A(rd1R), .B(AluB), .AluOp(AluOp), .dout(AluOut), .zero(zero), .overflow(overflow));
    register_nwe AluR(.clk(clk), .next(AluOut), .out(AluOutR));

    dm_4k U_DM(.addr(AluOutR[11:2]), .din(rd2R), .we(DMWr), .clk(clk), .dout(readdata), .bmode(bmode), .bsel(AluOutR[1:0]));
    register_nwe DR(.clk(clk), .next(readdata), .out(readdataR));

    ext ext0(.imm16(instrR[15:0]), .ExtOp(ExtOp), .extout(extout));
    mux3_32 wd_mux(.a(AluOutR), .b(readdataR), .c(pcp4), .sel(WDsel), .out(wd));
    mux3_5 writereg_mux(.a(instrR[20:16]), .b(instrR[15:11]), .c(5'h1f), .sel(GPRsel), .out(writereg));
    mux2_32 aluB_mux(.a(rd2R), .b(extout), .sel(AluBsel), .out(AluB));
endmodule

//todo
//sb
//lb refactor
//