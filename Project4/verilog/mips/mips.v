module mips(clk, rst, PrAddr, BE, PrDIn, PrDOut, PrWe, HWInt);
    input clk;   // clock
    input rst;   // reset
    output [31:2] PrAddr;
    output [3:0] BE; //????
    input [31:0] PrDIn;
    output [31:0] PrDOut;
    output PrWe;
    input [7:2] HWInt;

    wire [31:0] instr, instrR, AluOut, AluOutR, rda, rdb, rdaR, rdbR, extout, AluB, wd, pcp4, readData, readDataR, cp0out;
    wire [31:2] pc, npc, epc;
    wire [4:0] writeReg;
    wire [3:0] AluOp;
    wire [2:0] npcSel, WDsel;
    wire [1:0] GPRsel, ExtOp;
    wire [1:0] lbsel;
    wire AluBsel, zero, bmode, PCWr, IRWr, GPRWr, DMWr, IntReq, Wen, EXLSet, EXLClr;

    assign PrAddr = AluOutR[31:2];
    assign PrDOut = rdbR;

    ctrl u_ctrl(.clk(clk), .rst(rst), .instr(instrR), .PrAddr(PrAddr), .zero(zero), .IntReq(IntReq),
               .PCWr(PCWr), .npcSel(npcSel), .IRWr(IRWr), .GPRWr(GPRWr), .DMWr(DMWr), .AluOp(AluOp),
               .GPRsel(GPRsel), .AluBsel(AluBsel), .WDsel(WDsel), .ExtOp(ExtOp), .bmode(bmode),
               .Wen(Wen), .EXLSet(EXLSet), .EXLClr(EXLClr), .PrWe(PrWe));

    im_4k u_im(.addr(pc[15:2]), .dout(instr));
    pc u_pc(.npc(npc), .clk(clk), .PCWr(PCWr), .rst(rst), .pc(pc));
    reg_we IR(.clk(clk), .next(instr), .we(IRWr), .out(instrR));
    npc u_npc(.pc(pc), .imm(instrR[25:0]), .target(rdaR), .epc(epc), .npcSel(npcSel), .zero(zero), .npc(npc), .pcp4(pcp4));
    initial $monitor("Instr %8X at %8X", instr, {pc, 2'b00});

    cp0 u_cp0(.clk(clk), .rst(rst), .Wen(Wen), .EXLSet(EXLSet), .EXLClr(EXLClr), .pc(pc), .DIn(rdbR), .HWInt(HWInt), .sel(instrR[15:11]), .IntReq(IntReq), .epc(epc), .DOut(cp0out));
    
    mux3_5 writeReg_mux(.a(instrR[20:16]), .b(instrR[15:11]), .c(5'h1f), .sel(GPRsel), .out(writeReg));
    gpr u_rf(.clk(clk), .rst(rst), .ra(instrR[25:21]), .rb(instrR[20:16]), .rw(writeReg), 
             .wd(wd), .GPRWr(GPRWr), .rda(rda), .rdb(rdb));
    reg_nwe AR(.clk(clk), .next(rda), .out(rdaR));
    reg_nwe BR(.clk(clk), .next(rdb), .out(rdbR));

    ext u_ext(.imm16(instrR[15:0]), .ExtOp(ExtOp), .extout(extout));
    mux2_32 aluB_mux(.a(rdbR), .b(extout), .sel(AluBsel), .out(AluB));
    alu u_alu(.A(rdaR), .B(AluB), .AluOp(AluOp), .dout(AluOut), .zero(zero));
    reg_nwe AluR(.clk(clk), .next(AluOut), .out(AluOutR));

    dm_4k u_dm(.addr(AluOutR[15:2]), .din(rdbR), .we(DMWr), .clk(clk), .dout(readData), .bmode(bmode), .bsel(AluOutR[1:0]));
    reg_nwe DR(.clk(clk), .next(readData), .out(readDataR));

    mux5_32 wd_mux(.a(AluOutR), .b(readDataR), .c(pcp4), .d(PrDIn), .e(cp0out), .sel(WDsel), .out(wd));
endmodule
