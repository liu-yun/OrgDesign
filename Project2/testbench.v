module testbench();
    reg clk, rst;

    mips mips0(clk, rst);

    always begin
      #50 clk=~clk;
    end

    always begin
        #100 $displayh(mips0.instr);
    end

    initial begin
      clk=0;
      rst=1;
      #200 rst=0;
    end

endmodule
