module ifu(clk, PCWr, rst, NpcSel, zero, instr, pcp4, AluOut);
    input clk, PCWr, rst, zero;
    input [2:0] NpcSel;
    input [31:0] AluOut;
    output [31:0] instr, pcp4;
    wire [31:2] pc, npc;

    im_4k U_IM(.addr(pc[11:2]), .dout(instr));
    pc U_PC(.npc(npc), .clk(clk), .PCWr(PCWr), .rst(rst), .pc(pc));
    npc npc0(.pc(pc), .imm(instr[25:0]), .target(AluOut), .NpcSel(NpcSel), .zero(zero), .npc(npc), .pcp4(pcp4));
endmodule
