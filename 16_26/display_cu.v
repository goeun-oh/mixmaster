`timescale 1ns / 1ps


module display_cu(
    input clk,
    input rst,
    input sig,
    output mode
    );
    

    parameter NORMAL=1'b0, DISPLAY = 1'b1;
    reg state, next;
    assign mode = state;
    always @(posedge clk or posedge rst) begin
        if(rst) begin
            state <= 0;
        end else begin
            state <= next;
        end
    end

    always @(*) begin
        next = state;
        case (state)
        NORMAL:begin
            if(sig) begin
                next=DISPLAY;
            end            
        end 
        DISPLAY: begin
            if(sig) begin
                next= NORMAL;
            end           
        end
        endcase
    end


endmodule
