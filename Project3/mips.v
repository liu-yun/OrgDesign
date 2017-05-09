module mips(clk, rst);
    input clk;   // clock
    input rst;   // reset

    wire [31:0] instrR, AluOut, AluOutR, rda, rdb, rdaR, rdbR, extout, AluB, wd, pcp4, readData, readDataR;
    wire [4:0] writeReg;
    wire [3:0] AluOp;
    wire [2:0] npcSel;
    wire [1:0] GPRsel, WDsel, ExtOp;
    wire [1:0] lbsel;
    wire AluBsel, overflow, zero, bmode, PCWr, IRWr, GPRWr, DMWr;

    ctrl ctrl0(.clk(clk), .rst(rst), .opcode(instrR[31:26]), .funct(instrR[5:0]), .zero(zero),
               .PCWr(PCWr), .npcSel(npcSel), .IRWr(IRWr), .GPRWr(GPRWr), .DMWr(DMWr), .AluOp(AluOp),
               .GPRsel(GPRsel), .AluBsel(AluBsel), .WDsel(WDsel), .ExtOp(ExtOp), .bmode(bmode));

    ifu ifu0(.clk(clk), .PCWr(PCWr), .IRWr(IRWr), .rst(rst), .npcSel(npcSel), .zero(zero), .instrR(instrR), .pcp4(pcp4), .A(rdaR));

    gpr U_RF(.clk(clk), .rst(rst), .ra(instrR[25:21]), .rb(instrR[20:16]), .rw(writeReg), 
             .wd(wd), .GPRWr(GPRWr), .overflow(overflow), .rda(rda), .rdb(rdb));
    register_nwe AR(.clk(clk), .next(rda), .out(rdaR));
    register_nwe BR(.clk(clk), .next(rdb), .out(rdbR));

    alu alu0(.A(rdaR), .B(AluB), .AluOp(AluOp), .dout(AluOut), .zero(zero), .overflow(overflow));
    register_nwe AluR(.clk(clk), .next(AluOut), .out(AluOutR));

    dm_4k U_DM(.addr(AluOutR[11:2]), .din(rdbR), .we(DMWr), .clk(clk), .dout(readData), .bmode(bmode), .bsel(AluOutR[1:0]));
    register_nwe DR(.clk(clk), .next(readData), .out(readDataR));

    ext ext0(.imm16(instrR[15:0]), .ExtOp(ExtOp), .extout(extout));
    mux3_32 wd_mux(.a(AluOutR), .b(readDataR), .c(pcp4), .sel(WDsel), .out(wd));
    mux3_5 writeReg_mux(.a(instrR[20:16]), .b(instrR[15:11]), .c((instrR[15:11] === 5'b0) ? 5'h1f : instrR[15:11]), .sel(GPRsel), .out(writeReg));
    mux2_32 aluB_mux(.a(rdbR), .b(extout), .sel(AluBsel), .out(AluB));
endmodule
