module testbench();
    reg clk, rst;
    reg [31:0] switch_in;

    micro_computer u_mc(clk, rst, switch_in);

    always begin
      #25 clk=~clk;
    end

    initial begin
      clk=0;
      rst=1;
      #5 rst=0;
    end

endmodule
