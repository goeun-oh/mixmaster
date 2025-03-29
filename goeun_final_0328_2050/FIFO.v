`timescale 1ns / 1ps

module FIFO #(
    parameter ADDR_WIDTH =4,
    parameter DATA_WIDTH =8
)(
    input clk,
    input rst,
    input [DATA_WIDTH-1:0] wdata,
    input we, re,
    output full, empty,
    output [DATA_WIDTH-1:0] rdata
    );
    
    wire [ADDR_WIDTH-1:0] w_raddr, w_waddr;
    wire [DATA_WIDTH-1:0] w_rdata;

    ram_ip #(
        .ADDR_WIDTH(ADDR_WIDTH),
        .DATA_WIDTH(DATA_WIDTH)
    )U_REG(
        .clk(clk),
        .waddr(w_waddr),
        .wdata(wdata),
        .raddr(w_raddr),
        .we(we&&!full),
        .rdata(w_rdata)
    );

    controllUnit #(
        .ADDR_WIDTH(ADDR_WIDTH)
    )U_CU(
        .clk(clk),
        .rst(rst),
        .we(we),
        .re(re),
        .wptr(w_waddr),
        .rptr(w_raddr),
        .empty(empty),
        .full(full)
    );

    assign rdata=(re && !empty)?w_rdata :8'hxx;
    


endmodule