`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2025/03/12 09:16:33
// Design Name: 
// Module Name: detect_dot
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

module detect_dot(
    input [6:0] msec,
    output [3:0] dot
);
    assign dot = (msec > 50-1)?4'ha: 4'hf; //dot on/off
endmodule