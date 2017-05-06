module ifu(clk, PCWr, IRWr, rst, NpcSel, zero, instrR, pcp4, A);
    input clk, PCWr, IRWr, rst, zero;
    input [2:0] NpcSel;
    input [31:0] A;
    output [31:0] instrR, pcp4;
    wire [31:0] instr;
    wire [31:2] pc, npc;

    im_4k U_IM(.addr(pc[11:2]), .dout(instr));
    pc U_PC(.npc(npc), .clk(clk), .PCWr(PCWr), .rst(rst), .pc(pc));
    register_we IR(.clk(clk), .next(instr), .we(IRWr), .out(instrR));
    npc npc0(.pc(pc), .imm(instrR[25:0]), .target(A), .NpcSel(NpcSel), .zero(zero), .npc(npc), .pcp4(pcp4));

    initial $monitor("Instr %8X at %8X", instr, {pc, 2'b00});
endmodule
