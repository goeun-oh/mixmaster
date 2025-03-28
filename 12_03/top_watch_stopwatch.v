`timescale 1ns / 1ps


module top_watch_stopwatch #(
    parameter BIT_100HZ = 100,
    parameter SECOND_60 = 60,
    parameter HOUR = 24
)(
    input [1:0] sw_mode,
    input btn_L, btn_R, btn_D, btn_U,
    input run,
    input clear,
    input i_h, i_m, i_s,
    input clk,
    input reset,
    output [3:0] led,
    output [3:0] fndCom,
    output [7:0] fndFont,
    output [3:0] digit_msec_1, 
    output [3:0] digit_msec_10,
    output [3:0] digit_sec_1, 
    output [3:0] digit_sec_10,
    output [3:0] digit_min_1, 
    output [3:0] digit_min_10,
    output [3:0] digit_hour_1, 
    output [3:0] digit_hour_10,
    output tick_100hz,
    output tick_1s
    );

    wire [$clog2(BIT_100HZ)-1:0] w_msec [1:0];
    wire [$clog2(SECOND_60)-1:0] w_sec [1:0];
    wire [$clog2(SECOND_60)-1:0] w_min [1:0];
    wire [$clog2(HOUR)-1:0] w_hour [1:0];

    wire w_btn_L, w_btn_D, w_btn_U, btn_clear;


    //btn_L: run, hour
    btn_debounce L_btn_debounce(
        .clk(clk),
        .reset(reset),
        .i_btn(btn_L),
        .o_btn(w_btn_L)
    );

    //btn_R: clear    
    btn_debounce CLEAR_btn_debounce(
        .clk(clk),
        .reset(reset),
        .i_btn(btn_R),
        .o_btn(btn_clear)
    );

    //btn_D: min
    btn_debounce MIN_btn_debounce(
        .clk(clk),
        .reset(reset),
        .i_btn(btn_D),
        .o_btn(w_btn_D)
    );
    //btn_U: sec
    btn_debounce SEC_btn_debounce(
        .clk(clk),
        .reset(reset),
        .i_btn(btn_U),
        .o_btn(w_btn_U)
    );

    top_stop_watch u_stop_watch(
        .clk(clk),
        .reset(reset),
        .sw_mode(sw_mode[1]),
        .run(w_btn_L || run),
        .clear(btn_clear || clear),
        .msec(w_msec[0]),
        .sec(w_sec[0]),
        .min(w_min[0]),
        .hour(w_hour[0])
    );
    
    top_watch u_top_watch(
        .clk(clk),
        .reset(reset),
        .sw_mode(sw_mode[1]),
        .btn_hour(w_btn_L),
        .btn_min(w_btn_D),
        .btn_sec(w_btn_U),
        .i_h(i_h),
        .i_m(i_m),
        .i_s(i_s),
        .msec(w_msec[1]),
        .sec(w_sec[1]),
        .min(w_min[1]),
        .hour(w_hour[1]),
        .tick_100hz(tick_100hz),
        .tick_1s(tick_1s)
    );



    led_indicator u_led(
        .sw_mode(sw_mode),
        .led(led)
    );

    // 시계 1, stopwatch 0


    wire set_mode;
    assign set_mode = sw_mode[1];

    fndController U_FndController(
        .clk(clk),
        .reset(reset),
        .sw_mode(sw_mode[0]),
        .msec(w_msec[set_mode]),
        .sec(w_sec[set_mode]),
        .min(w_min[set_mode]),
        .hour(w_hour[set_mode]),
        .fndFont(fndFont),
        .fndCom(fndCom),
        .digit_msec_1(digit_msec_1), 
        .digit_msec_10(digit_msec_10),
        .digit_sec_1(digit_sec_1), 
        .digit_sec_10(digit_sec_10),
        .digit_min_1(digit_min_1), 
        .digit_min_10(digit_min_10),
        .digit_hour_1(digit_hour_1), 
        .digit_hour_10(digit_hour_10)
    );
endmodule