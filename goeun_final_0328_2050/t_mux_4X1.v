`timescale 1ns / 1ps


module t_mux_6X1(
    input [2:0] sel,
    input [3:0] x0,
    input [3:0] x1,
    input [3:0] x2,
    input [3:0] x3,
    input [3:0] x4,
    input [3:0] x5,
    output reg [3:0] y
    );

    always @(*) begin
        case(sel)
            3'h0: y=x0;
            3'h1: y=x1;
            3'h2: y=x2;
            3'h3: y=x3;
            3'h4: y=x4;
            3'h5: y=x5;
            default: y=x0;
        endcase
    end
endmodule