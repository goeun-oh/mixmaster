`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 03/23/2025 04:51:56 PM
// Design Name: 
// Module Name: timeTOascii
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module timeTOascii(
    input [3:0] i_time,
    output reg [7:0] ascii
    );

    always @(*) begin
        case(i_time)
            4'h0: begin
                ascii = 8'h30;
            end
            4'h1: begin
                ascii = 8'h31;
            end
            4'h2: begin
                ascii=8'h32;
            end
            4'h3: begin
                ascii=8'h33;
            end
            4'h4: begin
                ascii=8'h34;
            end
            4'h5: begin
                ascii=8'h35;
            end
            4'h6: begin
                ascii=8'h36;
            end
            4'h7: begin
                ascii=8'h37;
            end
            4'h8: begin
                ascii=8'h38;
            end
            4'h9: begin
                ascii=8'h39;
            end
        endcase
    end
endmodule
