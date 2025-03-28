`timescale 1ns / 1ps


module datapath #(
    parameter BIT_100HZ = 100,
    parameter SECOND_60 = 60,
    parameter HOUR = 24
)(
    input clk,
    input reset,
    input run,
    input clear,
    input i_hour,
    input i_min,
    input i_sec,
    input sw_mode,
    output [$clog2(BIT_100HZ)-1:0] msec,
    output [$clog2(SECOND_60)-1:0] sec,
    output [$clog2(SECOND_60)-1:0] min,
    output [$clog2(HOUR)-1:0] hour,
    output tick_100hz,
    output tick_1s
    );
    wire o_tick_100hz;
    wire o_tick_1s;
    wire o_tick_1m;
    wire o_tick_1h;
    assign tick_100hz = o_tick_100hz;
    assign tick_1s=o_tick_1s;

    clk_div_100 u_tick_100hz(
        .clk(clk),
        .reset(reset),
        .run(run),
        .clear(clear),
        .o_clk(o_tick_100hz)
    );

    reg [5:0] count_bit, count_next;
    reg tick_reg, tick_next;
    reg count_10, r_count_10;
    always @(posedge clk, posedge reset) begin
        if(reset) begin
            count_bit <=0;
            tick_reg <=0;
            r_count_10 <=0;
        end else begin
            count_bit <= count_next;
            tick_reg <= tick_next;
            count_10 <= r_count_10;
        end
    end

    counter #(
        .COUNT(BIT_100HZ)
    ) count_msec(
        .clk(clk),
        .clear(clear),
        .tick(o_tick_100hz),
        .reset(reset),
        .i_btn(1'b0),
        .o_counter(msec),
        .o_tick(o_tick_1s),
        .sw_mode(1'b0)
    );

    counter #(
        .COUNT(SECOND_60)
    ) count_sec(
        .clk(clk),
        .clear(clear),
        .tick(o_tick_1s),
        .reset(reset),
        .i_btn(i_sec),
        .o_counter(sec),
        .o_tick(o_tick_1m),
        .sw_mode(1'b0)
    );

    
    counter #(
        .COUNT(SECOND_60)
    ) count_min(
        .clk(clk),
        .clear(clear),
        .tick(o_tick_1m),
        .reset(reset),
        .i_btn(i_min),
        .o_counter(min),
        .o_tick(o_tick_1h),
        .sw_mode(1'b0)
    );

    
    counter #(
        .COUNT(HOUR),
        .INIT(12)
    ) count_hour(
        .clk(clk),
        .clear(clear),
        .tick(o_tick_1h),
        .reset(reset),
        .i_btn(i_hour),
        .o_counter(hour),
        .sw_mode(sw_mode),
        .o_tick()
    );


endmodule