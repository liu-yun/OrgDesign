module pc(npc, clk, rst, pc);
    input [31:2] npc;
    input clk;
    input rst;
    output reg [31:2] pc;

    initial pc = 32'h0000_0c00;

    always @(posedge clk or posedge rst) begin
      if(rst) begin
        pc <= 30'h0000_0c00;
      end
      else begin
        pc <= npc;
      end
    end
endmodule
