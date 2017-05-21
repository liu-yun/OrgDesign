module switch(clk, rst, addr, DEVSwitch_RD, switch_in);
    input clk, rst;
    input [3:2] addr;
    input [31:0] switch_in;
    output [31:0] DEVSwitch_RD;

    assign DEVSwitch_RD = (addr == 2'b00) ? switch_in : 32'b0;
endmodule
