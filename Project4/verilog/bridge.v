module bridge(PrAddr, PrRD, PrWD, PrWe, HWInt, DEV_Addr, DEV_WD, DEVSwitch_RD, DEVTimer_RD, DEVLed_RD,
              DEVSwitch_we, DEVTimer_we, DEVLed_we, DEVTimer_IRQ);
    input [31:2] PrAddr;
    output [31:0] PrRD;
    input [31:0] PrWD;
    input PrWe;
    output [7:2] HWInt;
    
    output [3:2] DEV_Addr;
    
    output [31:0] DEV_WD;
    input [31:0] DEVSwitch_RD, DEVTimer_RD, DEVLed_RD;
    output DEVSwitch_we, DEVTimer_we, DEVLed_we;
    input DEVTimer_IRQ;
    assign HWInt = {5'b0, DEVTimer_IRQ};

    assign DEV_Addr = PrAddr[3:2];
    wire HitDEVTimer = PrAddr[31:4] === 28'h00007f0;
    wire HitDEVSwitch = PrAddr[31:4] === 28'h00007f1;
    wire HitDEVLed = PrAddr[31:4] === 28'h00007f2;

    assign PrRD = HitDEVTimer ? DEVTimer_RD :
                 HitDEVSwitch ? DEVSwitch_RD :
                    HitDEVLed ? DEVLed_RD : 32'b0;
    assign DEV_WD = PrWD;
    assign DEVTimer_we = PrWe & HitDEVTimer;
    assign DEVSwitch_we = PrWe & HitDEVSwitch;
    assign DEVLed_we = PrWe & HitDEVLed;
endmodule
