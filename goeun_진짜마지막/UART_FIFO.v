`timescale 1ns / 1ps


module UART_FIFO #(
    parameter DATA_WIDTH =8,
        ADDR_WIDTH=4
)(
    input clk,
    input rst,
    input rx,
    input sel,
    input tick_100hz,
    input tick_1s,
    input [7:0] i_watch,
    output tx,
    output [DATA_WIDTH-1:0] o_data,
    output re_rx
);
wire [DATA_WIDTH-1:0] w_rdata, RX_out;
wire w_rdone;
wire RX_empty;
wire TX_empty, TX_full, TX_done;
wire [DATA_WIDTH-1:0] TX_wdata;
wire [DATA_WIDTH-1:0] TX_out;
wire RX_RE, TX_WE, TX_START;
reg tick_reg, tick_next;

assign TX_START = sel? (!TX_done &!TX_empty)&tick_reg:!TX_empty;
assign TX_wdata=sel?i_watch:RX_out;
assign TX_WE=sel?(!TX_full & tick_100hz):!RX_empty;
assign RX_RE=sel?!RX_empty:!TX_full;

assign o_data=RX_out;
assign re_rx= RX_RE;


always @(posedge clk or posedge rst) begin
    if(rst) begin
        tick_reg <=0;
    end else begin
        tick_reg <= tick_next;
    end
end

always @(*) begin
    tick_next=1'b0;
    if(tick_100hz) begin
        tick_next= 1'b1;
    end
end

top_uart U_UART(
    .clk(clk),
    .rst(rst),
    .tx_start(TX_START),
    .rx(rx),
    .tx_data_in(TX_out),
    .tx_done(TX_done),
    .tx(tx), //o
    .rx_data(w_rdata),
    .rx_done(w_rdone)
);


FIFO #(
    .ADDR_WIDTH(ADDR_WIDTH)
)FIFO_RX(
    .clk(clk),
    .rst(rst),
    .wdata(w_rdata),
    .we(w_rdone), 
    .re(RX_RE),
    .full(), //o
    .empty(RX_empty),
    .rdata(RX_out)
    );

FIFO #(
    .ADDR_WIDTH(ADDR_WIDTH)
)FIFO_TX(
    .clk(clk),
    .rst(rst),
    .wdata(TX_wdata),
    .we(TX_WE), 
    .re(!TX_done &!TX_empty),
    .full(TX_full), //o
    .empty(TX_empty),
    .rdata(TX_out)
    );




endmodule
