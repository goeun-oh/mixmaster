`timescale 1ns / 1ps

module top_watch#(
    parameter BIT_100HZ = 100,
    parameter SECOND_60 = 60,
    parameter HOUR = 24
)(
    input clk,
    input reset,
    input sw_mode,
    input btn_hour,
    input btn_min,
    input btn_sec,
    input i_h, i_m, i_s,
    output [$clog2(BIT_100HZ)-1:0] msec,
    output [$clog2(SECOND_60)-1:0] sec,
    output [$clog2(SECOND_60)-1:0] min,
    output [$clog2(HOUR)-1:0] hour,
    output tick_100hz,
    output tick_1s
    );

    assign f_hour= (btn_hour || i_h) && sw_mode;
    assign f_min = (btn_min || i_m) && sw_mode;
    assign f_sec= (btn_sec || i_s) && sw_mode;


    wire w_reset;
    assign w_reset = sw_mode && reset;

    datapath U_Watch_DP(
        .clk(clk),
        .reset(w_reset),
        .run(1'b1),
        .clear(1'b0),
        .sw_mode(sw_mode),
        .i_hour(f_hour),
        .i_min(f_min),
        .i_sec(f_sec),
        .msec(msec),
        .sec(sec),
        .min(min),
        .hour(hour),
        .tick_100hz(tick_100hz),
        .tick_1s(tick_1s)
    );


    


endmodule