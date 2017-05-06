module register_we(clk, next, we, out);
    input clk, we;
    input [31:0] next;
    output reg [31:0] out;

    always @(posedge clk) begin
      if(we)
        out <= next;
    end
    initial out <= 32'b0;
endmodule

module register_nwe(clk, next, out);
    input clk;
    input [31:0] next;
    output reg [31:0] out;

    always @(posedge clk) begin
      out <= next;
    end
    initial out <= 32'b0;
endmodule
