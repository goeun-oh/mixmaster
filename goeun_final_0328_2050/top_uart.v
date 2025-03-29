`timescale 1ns / 1ps


module top_uart(
    input clk,
    input rst,
    input tx_start,
    input rx,
    output tx,
    input [7:0] tx_data_in,
    input tx_done,
    output [7:0] rx_data,
    output rx_done
    );

    wire w_tick;
/*
    btn_debounce u_BTN_DEBOUNCE(
        .clk(clk),
        .reset(rst),
        .tx_start(tx_start),
        .o_btn(w_start)
    );
*/    
    tx U_TX(
        .clk(clk),
        .rst(rst),
        .tick(w_tick),
//        .start_trigger(w_start),
        .tx_start(tx_start),
        .i_data(tx_data_in),
        .o_tx(tx),
        .o_tx_done(tx_done)
    );

    baud_tick_gen U_BAUD_Tick_Gen(
        .clk(clk),
        .rst(rst),
        .baud_tick(w_tick)
    );

    rx U_RX(
        .clk(clk),
        .rst(rst),
        .rx(rx),
        .tick(w_tick),
        .rx_data(rx_data),
        .rx_done(rx_done)
    );


endmodule