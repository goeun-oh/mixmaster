`timescale 1ns / 1ps
module controllUnit #(
    parameter ADDR_WIDTH=4
)(
    input clk,
    input rst,
    input we,
    input re,
    output [ADDR_WIDTH-1:0] wptr,
    output [ADDR_WIDTH-1:0] rptr,
    output empty,
    output full
    );
    reg [1:0] state, next;    
    reg full_reg, full_next;
    reg empty_reg, empty_next;
    reg [ADDR_WIDTH-1:0] wptr_reg, wptr_next;
    reg [ADDR_WIDTH-1:0] rptr_reg, rptr_next;

    assign wptr= wptr_reg;
    assign rptr= rptr_reg;
    assign full=full_reg;
//    assign empty=empty_reg;
    assign empty=empty_reg;
    always @(posedge clk or posedge rst) begin
        if(rst) begin
            full_reg <=0;
//            empty_reg <=1'b1;
            empty_reg=1;
            wptr_reg <=0;
            rptr_reg <=0;
            state <=0;
        end else begin
            full_reg <= full_next;
            empty_reg <= empty_next;
            wptr_reg <= wptr_next;
            rptr_reg <= rptr_next;
            state <= next;
        end
    end

//포인터 증가 로직
    always @(*) begin
        wptr_next=wptr_reg;
        rptr_next=rptr_reg;
        next = 2'b00;

        case ({we, re})
            2'b01: begin //읽기만 할때
                if(!empty_reg) begin
                    rptr_next=rptr_reg+1;
                    next = 2'b01;
                end
            end
            2'b10: begin //쓰기만 할때
                if(!full_reg) begin
                    wptr_next =wptr_reg+1;
                    next=2'b10;
                end
            end
            2'b11: begin
                if(empty_reg) begin
                    wptr_next=wptr_reg+1;
                    next= 2'b10;
                end else if (full_reg) begin
                    rptr_next=rptr_reg+1;
                    next=2'b01;
                end else begin
                    wptr_next=wptr_reg+1;
                    rptr_next=rptr_reg+1;
                    next=2'b00;
                end
            end
        endcase
    end

// full, empty 정하는 로직
    always @(*) begin
       full_next= full_reg;
       empty_next=empty_reg;
        case (next)
            2'b00: begin
                empty_next=empty_next;
                full_next=full_next;
            end
            2'b01: begin //읽기만 할때
                if(rptr_next==wptr_reg) begin
                    empty_next = 1'b1;
                    full_next=1'b0;
                end else begin
                    empty_next = 1'b0;
                    full_next=1'b0;
                end
            end
            2'b10: begin
                if(wptr_next == rptr_reg) begin
                    full_next= 1'b1;
                    empty_next=1'b0;
                end else begin
                    full_next= 1'b0;
                    empty_next=1'b0;
                end
            end
        endcase
    end
    
endmodule
