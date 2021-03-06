module ifu(clk, rst, NpcSel, zero, instr, pcp4, AluOut);
    input clk, rst, zero;
    input [2:0] NpcSel;
    input [31:0] AluOut;
    output [31:0] instr, pcp4;
    wire [31:2] pc, npc;

    im_4k im0(.addr(pc[11:2]), .dout(instr));
    pc pc0(.npc(npc), .clk(clk), .rst(rst), .pc(pc));
    npc npc0(.pc(pc), .imm(instr[25:0]), .target(AluOut), .NpcSel(NpcSel), .zero(zero), .npc(npc), .pcp4(pcp4));
endmodule
