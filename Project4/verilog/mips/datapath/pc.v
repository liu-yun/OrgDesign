module pc(npc, clk, rst, PCWr, pc);
    input [31:2] npc;
    input clk, PCWr, rst;
    output reg [31:2] pc;

    initial pc = 32'h0000_0c00;

    always @(posedge clk or posedge rst) begin
      if(rst) begin
        pc <= 30'h0000_0c00;
      end
      else begin
        if(PCWr)
            pc <= npc;
      end
    end
endmodule
