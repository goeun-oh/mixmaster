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
    input [3:0] sw_mode,
    input btn_L, btn_R, btn_D, btn_U,
    input [3:0] led,
    output tx,
    output [3:0] fndCom,
    output [7:0] fndFont
);
    wire pc_run, pc_clear, pc_hour, pc_min, pc_sec, valid, w_mode, sel;
    wire [$clog2(BIT_100HZ)-1:0] msec;
    wire [$clog2(SECOND_60)-1:0] sec, min, hour;

    wire [3:0] msec0, msec1;
    wire [3:0] sec0, sec1;
    wire [3:0] min0, min1;
    wire [3:0] hour0, hour1;
    wire [DATA_WIDTH-1:0] w_cmd;
    wire [DATA_WIDTH-1:0] time_data;
    wire [3:0] w_msec_sec;
    wire [3:0] w_min_hour;
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
        .run(pc_run),
        .clear(pc_clear),
        .hour(pc_hour),
        .min(pc_min),
        .sec(pc_sec),
        .valid(valid),
        .mode(w_mode)
    );


    
    top_DHT(
        .clk,
        .rst,
        .2:0] sw,
        .i_btn,
        .io_dht,
        .7:0] temp_integral,
        .7:0] temp_decimal,
        .7:0] humi_integral,
        .7:0] humi_decimal,
        .7:0] parity,
        .o_tOut,
        .o_error
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
        .sw_mode(sw_mode[1:0]),
        .btn_L(btn_L), 
        .btn_R(btn_R), 
        .btn_D(btn_D), 
        .btn_U(btn_U),
        .run(pc_run),
        .clear(pc_clear),
        .i_h(pc_hour),
        .i_m(pc_min),
        .i_s(pc_sec),

        //// 시계 or 스탑워치 output ////
        .msec(msec),
        .sec(sec),
        .min(min),
        .hour(hour),
        ///////tick/////////
        .tick_100hz(tick_100hz),
        .tick_1s(tick_1s)
    );



    fndController U_FND(
        .clk(clk),
        .reset(rst),
        .sw_mode({sw_mode[3:2], sw_mode[0]}),
        .msec_sec(w_msec_sec),
        .min_hour(w_min_hour),
        .fndFont(fndFont),
        .fndCom(fndCom)
    );
    
    watch_digitSplitter watch_digitSplitter(
        .msec(msec),
        .sec(sec),
        .min(min),
        .hour(hour),
        .digit_msec_1(msec0), 
        .digit_msec_10(msec1),
        .digit_sec_1(sec0), 
        .digit_sec_10(sec1),
        .digit_min_1(min0), 
        .digit_min_10(min1),
        .digit_hour_1(hour0), 
        .digit_hour_10(hour1)
    );

    
    WATCHtoFND U_WATCHtoFND(
        .clk(clk),
        .rst(rst),
        .msec(msec),
        .digit_msec_1(msec0), 
        .digit_msec_10(msec1),
        .digit_sec_1(sec0), 
        .digit_sec_10(sec1),
        .digit_min_1(min0), 
        .digit_min_10(min1),
        .digit_hour_1(hour0), 
        .digit_hour_10(hour1),
        .msec_sec(w_msec_sec),
        .min_hour(w_min_hour)
    );

endmodule
