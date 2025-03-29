`timescale 1ns / 1ps


module tb_top();
    reg clk, rst;
    reg [1:0] sw_mode;
    reg rx;
    wire tx;
    wire [3:0] fndCom;
    wire [7:0] fndFont;
    integer n;
  
    initial begin
        clk=0; rst=0; sw_mode=2'b10;
        #10
        rst=1;
        #10
        rst=0;
        #10;
        #100_000;
        send_data("R");
        #10;
        send_data("R");
        #10;
        send_data("X");
        #1_000_000;


    end

    always #5 clk=~clk;

    task send_data(input [7:0] data);
    integer  i;
    begin
        $display("Sending data: %h", data);
        //start bit
        #(10*10417);

        rx=0;     
        #(10*10417);
        for(i=0;i<8;i=i+1) begin
            rx=data[i];
            #(10*10417);
        end
        //stop bit
        rx=1;
        #(10*10417);
        $display("finish");
    end
    endtask


    top U_TOP(
        .clk(clk),
        .rst(rst),
        .rx(rx),
        .sw_mode(sw_mode),
        .btn_L(), 
        .btn_R(), 
        .btn_D(), 
        .btn_U(),
        .led(),
        .tx(tx),
        .fndCom(fndCom),
        .fndFont(fndFont)
    );
endmodule