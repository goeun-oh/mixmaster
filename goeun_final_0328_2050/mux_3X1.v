`timescale 1ns / 1ps

module mux_3X1  #(
    parameter DATA_WIDTH=8 
)(
    input [3:0] sw_mode,
    input [DATA_WIDTH-1:0] x0,
    input [DATA_WIDTH-1:0] x1,
    input [DATA_WIDTH-1:0] x2,
    output reg [DATA_WIDTH-1:0] y
    );

    always @(*) begin
        case(sw_mode)
            4'b0000: y=x0;
            4'b0001: y=x0;
            4'b0010: y=x0;
            4'b0011: y=x0;
            4'b0100: y=x1;
            4'b0101: y=x1;
            4'b1000: y=x2;
            4'b1001: y=x2;
            default: y=x0;
        endcase
    end
endmodule