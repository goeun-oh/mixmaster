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
    input [1:0] led,
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
    wire [DATA_WIDTH-1:0] o_out;
    
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
    assign sel_out = sel_reg;
    always @(posedge clk or posedge rst) begin
        if(rst) begin
            sel_reg <= 0;
        end else begin
            sel_reg <= sel_next;
        end
    end

    always @(*) begin
        sel_next = sel_reg;
        if(tick_100hz) begin
            if(sel_reg == 10-1) begin
                sel_next = 0;
            end else begin
                sel_next= sel_reg +1;
            end
        end
    end

    wire [DATA_WIDTH-1:0] pc_to_sec0, pc_to_sec1, pc_to_min0, pc_to_min1, pc_to_hour0, pc_to_hour1;

    t_mux_10X1 U_MUX_t(
        .sel(sel_out),
        .x0(pc_to_hour1),
        .x1(pc_to_hour0),
        .x2(8'h3a),
        .x3(pc_to_min1),
        .x4(pc_to_min0),
        .x5(8'h3a),
        .x6(pc_to_sec1),
        .x7(pc_to_sec0),
        .x8(8'h0d),
        .x9(8'h0a),
        .y(o_out)
    );

    timeTOascii sec0_to_ascii(
        .i_time(sec0),
        .ascii(pc_to_sec0)
    );
    timeTOascii sec1_to_ascii(
        .i_time(sec1),
        .ascii(pc_to_sec1)
    );
    timeTOascii min0_to_ascii(
        .i_time(min0),
        .ascii(pc_to_min0)
    );    
    timeTOascii min1_to_ascii(
        .i_time(min1),
        .ascii(pc_to_min1)
    );    
    timeTOascii hour0_to_ascii(
        .i_time(hour0),
        .ascii(pc_to_hour0)
    );    
    timeTOascii hour1_to_ascii(
        .i_time(hour1),
        .ascii(pc_to_hour1)
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
        .i_watch(o_out),
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
