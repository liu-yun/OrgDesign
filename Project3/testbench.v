module testbench();
    reg clk, rst;

    mips mips0(clk, rst);

    always begin
      #25 clk=~clk;
    end

    initial begin
      clk=0;
      rst=1;
      #5 rst=0;
    end

endmodule
