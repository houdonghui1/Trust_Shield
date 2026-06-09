`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/03/30 10:34:05
// Design Name: 
// Module Name: counter_tb
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


module counter_tb;

    reg cnt_in;
    reg rst;
    reg cnt_ctrl;
    reg clear;
    wire done;
    wire [31:0] cnt_out;
    
    Counter uut (
        .cnt_in(cnt_in),
        .rst(rst),
        .cnt_ctrl(cnt_ctrl),
        .clear(clear),
        .done(done),
        .cnt_out(cnt_out)
    );
    
    always #2.5 cnt_in = ~ cnt_in;
    
    initial begin
        cnt_in = 1'b0;
        rst = 1'b1;
        cnt_ctrl = 1'b0;
        clear = 1'b0;
        #10;
        rst = 1'b0;
        #10;
        rst = 1'b1;
        #10;
        cnt_ctrl = 1'b1;
        #100;
        cnt_ctrl = 1'b0;
        #10;
        clear = 1'b1;
        #10;
        clear = 1'b0;
        #10;
        $finish;
    end
    
endmodule

