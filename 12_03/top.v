`timescale 1ns / 1ps
module top #(
    parameter DATA_WIDTH=8,
    parameter ADDR_WIDTH=4,    
    parameter BIT_100HZ = 100,
    parameter SECOND_60 = 60,
    parameter HOUR = 24
)(
    input clk,
    input rst,
    input rx,
    input [1:0] sw_mode,
    input btn_L, btn_R, btn_D, btn_U,
    input [3:0] led,
    output tx,
    output [3:0] fndCom,
    output [7:0] fndFont
);
    wire w_run, w_clear, w_hour, w_min, w_sec, valid, w_mode, sel;
    wire [$clog2(BIT_100HZ)-1:0] msec0;
    wire [$clog2(BIT_100HZ)-1:0] msec1;
    wire [$clog2(SECOND_60)-1:0] sec0;
    wire [$clog2(SECOND_60)-1:0] sec1;
    wire [$clog2(SECOND_60)-1:0] min0;
    wire [$clog2(SECOND_60)-1:0] min1;
    wire [$clog2(HOUR)-1:0] hour0;
    wire [$clog2(HOUR)-1:0] hour1;
    wire [DATA_WIDTH-1:0] w_cmd;
    wire [DATA_WIDTH-1:0] time_data;
    
    wire [3:0] sel_out;
    reg [3:0] sel_reg, sel_next;
    wire tick_100hz, tick_1s;

    display_cu U_display_cu(
        .clk(clk),
        .rst(rst),
        .sig(w_mode),
        .mode(sel)
    );

    uart_cu U_CU(
        .clk(clk),
        .rst(rst),
        .i_cmd(w_cmd),
        .run(w_run),
        .clear(w_clear),
        .hour(w_hour),
        .min(w_min),
        .sec(w_sec),
        .valid(valid),
        .mode(w_mode)
    );

    time_to_data U_Time_to_Data(
        .clk(clk),
        .rst(rst),
        .tick_100hz(tick_100hz),
        .sec0(sec0),
        .sec1(sec1),
        .min0(min0),
        .min1(min1),
        .hour0(hour0),
        .hour1(hour1),
        .time_data(time_data)

    );

    UART_FIFO #(
        .ADDR_WIDTH(ADDR_WIDTH)
    )
    U_UART_FIFO (
        .clk(clk),
        .rst(rst),
        .rx(rx),
        .tx(tx),
        .o_data(w_cmd),
        .re_rx(valid),
        .sel(sel),
        .i_watch(time_data),
        .tick_100hz(tick_100hz),
        .tick_1s(tick_1s)
    );
    


    top_watch_stopwatch U_top_watch_stopwatch(
        .clk(clk),
        .reset(rst),
        .sw_mode(sw_mode),
        .btn_L(btn_L), 
        .btn_R(btn_R), 
        .btn_D(btn_D), 
        .btn_U(btn_U),
        .run(w_run),
        .clear(w_clear),
        .i_h(w_hour),
        .i_m(w_min),
        .i_s(w_sec),
        .led(led),
        .fndCom(fndCom),
        .fndFont(fndFont),
        .digit_msec_1(msec0), 
        .digit_msec_10(msec1),
        .digit_sec_1(sec0), 
        .digit_sec_10(sec1),
        .digit_min_1(min0), 
        .digit_min_10(min1),
        .digit_hour_1(hour0), 
        .digit_hour_10(hour1),
        .tick_100hz(tick_100hz),
        .tick_1s(tick_1s)
    );

endmodule
