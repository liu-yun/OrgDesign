module mini_machine(clk, rst, switch_in);
    input clk, rst;
    input [31:0] switch_in;

    wire [31:2] PrAddr;
    wire [3:2] addr;
    wire [31:0] PrRD, PrDOut, DEV_WD, DEVSwitch_RD, DEVTimer_RD, DEVLed_RD;
    wire [7:2] HWInt;
    wire [3:0] BE;
    wire PrWe, DEVSwitch_we, DEVTimer_we, DEVLed_we, DEVTimer_IRQ;

    mips u_mips(.clk(clk), .rst(rst), .PrAddr(PrAddr), .BE(BE), .PrDIn(PrRD), .PrDOut(PrDOut), .PrWe(PrWe), .HWInt(HWInt));

    bridge u_bridge(.PrAddr(PrAddr), .PrRD(PrRD), .PrWD(PrDOut), .PrWe(PrWe), .HWInt(HWInt), .BE(BE),
            .DEV_Addr(addr), .DEV_WD(DEV_WD), .DEVSwitch_RD(DEVSwitch_RD), .DEVTimer_RD(DEVTimer_RD), .DEVLed_RD(DEVLed_RD),
            .DEVSwitch_we(), .DEVTimer_we(DEVTimer_we), .DEVLed_we(DEVLed_we), .DEVTimer_IRQ(DEVTimer_IRQ));

    timer u_timer(.clk(clk), .rst(rst), .addr(addr), .we(DEVTimer_we), .DEV_WD(DEV_WD), .DEVTimer_RD(DEVTimer_RD), .IRQ(DEVTimer_IRQ));
    switch u_switch(.clk(clk), .rst(rst), .addr(addr), .DEVSwitch_RD(DEVSwitch_RD), .switch_in(switch_in));
    led u_led(.clk(clk), .rst(rst), .addr(addr), .we(DEVLed_we), .DEV_WD(DEV_WD), .DEVLed_RD(DEVLed_RD));

endmodule
