`timescale 1ns / 1ps

module fndController(
    input clk,
    input reset,
    input [2:0] sw_mode,
    input [3:0] msec_sec,
    input [3:0] min_hour,
    input [4:0] temp,
    input [4:0] humi,
    input [4:0] dist,
    output [7:0] fndFont,
    output [3:0] fndCom
    );

    

    //////// 8개 fndComm selection ////////
    wire [2:0] sel;
    wire o_clk;
    clk_divider U_Clk_Divider(
        .clk(clk),
        .reset(reset),
        .o_clk(o_clk)
    );
    counter_8 U_Counter_8(
        .clk(o_clk),
        .reset(reset),
        .o_sel(sel)
    );
    decoder U_Decoder(
        .x(sel),
        .y(fndCom)
    );
    ////////////////////////////////////////
    

    ///////////////mode select///////////////
    wire [5:0] w_digit;
    //sw[0], sw[2], sw[3]
    mux5_5X1 data_to_FND(
        .sel(sw_mode),
        .x0({1'b0, msec_sec}), //000
        .x1({1'b0, min_hour}), //001
        .x2(dist), //010 
        .x3(temp),    //100
        .x4(humi),    //101
        .y(w_digit)
    );

    BCDtoSEG U_BcdToSeg(
        .bcd(w_digit),
        .seg(fndFont)
    );
    /////////////////////////////////////////





endmodule