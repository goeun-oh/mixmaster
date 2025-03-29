`timescale 1ns / 1ps


module ram_ip #(
    parameter  ADDR_WIDTH=4,
    DATA_WIDTH=8
)(
    input clk,
    input [ADDR_WIDTH-1:0] waddr,
    input [DATA_WIDTH-1:0] wdata,
    input [ADDR_WIDTH-1:0] raddr,
    input we,
    output [DATA_WIDTH-1:0] rdata
    );

    reg [DATA_WIDTH-1:0] ram [0:(2**ADDR_WIDTH)-1]; //2**4 2의 4승
    //reg [DATA_WIDTH-1:0] rdata_reg;
    //assign rdata=rdata_reg;

    always @(posedge clk) begin
        //write
        if(we) begin
            ram[waddr] = wdata;
        end
    end
    assign rdata=ram[raddr];
/*
    always @(posedge clk) begin
        if(!we) begin
            rdata_reg <= ram[waddr];
        end 
    end
*/


endmodule
