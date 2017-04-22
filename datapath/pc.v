module pc(npc, clk, rst, pc);
    input [31:2] npc;
    input clk;
    input rst;
    output reg [31:2] pc;

    always @(posedge clk or posedge rst) begin
      if(rst) begin
        pc <= 32'h0000_3000;
      end
      else begin
        pc <= npc;
      end
    end
endmodule
