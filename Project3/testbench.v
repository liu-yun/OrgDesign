module testbench();
    reg clk, rst;

    mips mips0(clk, rst);

    always begin
      #25 clk=~clk;
    end

    always begin
        #50 $displayh(mips0.instr);
    end

    initial begin
      clk=0;
      rst=1;
      #100 rst=0;
    end

endmodule
