`timescale 1ns / 1ps


module mux4_2X1(
    input sel,
    input [3:0] x0,
    input [3:0] x1,
    output reg [3:0] y
    );

    always @(*) begin
        case(sel)
            1'b0: y=x0;
            1'b1: y=x1;
            default: y=3'bx; 
        endcase
    end
endmodule