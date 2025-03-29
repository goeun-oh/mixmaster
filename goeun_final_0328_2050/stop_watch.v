`timescale 1ns / 1ps


module top_stop_watch #(
    parameter BIT_100HZ = 100,
    parameter SECOND_60 = 60,
    parameter HOUR = 24
)
(
    input clk,
    input reset,
    input sw_mode,
    input run,
    input clear,
    output [$clog2(BIT_100HZ)-1:0] msec,
    output [$clog2(SECOND_60)-1:0] sec,
    output [$clog2(SECOND_60)-1:0] min,
    output [$clog2(HOUR)-1:0] hour,
    output tick_100hz
    );

    wire o_run;
    wire o_clear;

    wire f_run;
    wire f_clear;

    assign f_run = o_run && !(sw_mode);
    assign f_clear = o_clear && !(sw_mode);

    controller Controller(
        .clk(clk),
        .reset(reset),
        .i_run(run),
        .i_clear(clear),
        .o_run(o_run),
        .o_clear(o_clear)
    );

    wire w_reset;
    assign w_reset = !sw_mode && reset;


    datapath U_StopWatch_DP(
        .clk(clk),
        .reset(w_reset),
        .run(f_run),
        .clear(f_clear),
        .i_hour(1'b0),
        .i_min(1'b0),
        .i_sec(1'b0),
        .msec(msec),
        .sec(sec),
        .min(min),
        .hour(hour),
        .sw_mode(1'b0),
        .tick_100hz(tick_100hz)
    );


endmodule
