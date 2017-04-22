module npc(pc, imm, target, NpcSel, zero, npc, pcp4);
    input [31:2] pc;
    input [25:0] imm;
    input [31:0] target;
    input [2:0] NpcSel; 
    input zero;
    output [31:2] npc;
    output [31:0] pcp4;

    wire [15:0] bimm;
    assign bimm = imm[15:0];
    assign npc = (zero & NpcSel == 3'b001) ? pc + 1 + {{14{bimm[15]}}, bimm} : //beq
                        (NpcSel == 3'b011) ? {pc[31:28], imm} :                //j
                        (NpcSel == 3'b100) ? target :                          //jr
                                             pc + 1;
    assign pcp4 = {2'b00, pc + 1} + 4;

endmodule
