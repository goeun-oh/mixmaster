module tick_gen #(
    parameter TICK = 100_000,
    parameter CLK_FREQ = 100_000_000
)(
    input clk,
    input rst,
    output o_tick
);

parameter TICK_FREQ = CLK_FREQ / TICK;

reg [$clog2(TICK_FREQ)-1:0] count_reg, count_next;
reg tick_reg, tick_next;

assign o_tick = tick_reg;

always @(posedge clk or posedge rst) begin
    if(rst) begin
        count_reg <=0;
        tick_reg <=0;
    end else begin
        count_reg <= count_next;
        tick_reg <= tick_next;
    end
end


always @(*) begin
    count_next = count_reg;
    tick_next = 1'b0;
    if(count_reg == TICK_FREQ -1) begin
        tick_next=1'b1;
        count_next=0;
    end else begin
        count_next=count_reg +1;
    end
end
endmodule