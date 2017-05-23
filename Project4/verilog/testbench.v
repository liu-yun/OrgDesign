module testbench();
    reg clk, rst;
    reg [31:0] switch_in;

    mini_machine u_mc(clk, rst, switch_in);

    always begin
      #25 clk=~clk;
    end

    initial begin
      clk=0;
      rst=1;
      #5 rst=0;
      switch_in = 'h123;
      #10000 switch_in = 'h456;
    end

endmodule
