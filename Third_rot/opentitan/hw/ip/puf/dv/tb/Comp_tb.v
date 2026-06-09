`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/04/08 22:05:10
// Design Name: 
// Module Name: Comp_tb
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


module Comp_tb();

    reg clk;
    reg rst;
    reg [31:0] num1;
    reg [31:0] num2;
    reg comp_en;
    
    wire done;
    wire result;
    
    Comp dut(
        .clk(clk),
        .rst(rst),
        .num1(num1),
        .num2(num2),
        .comp_en(comp_en),
        .done(done),
        .result(result)
    );

    initial begin
        clk = 0;
        forever #5 clk = ~clk;
    end
    
    initial begin
        rst = 1;
        num1 = 0;
        num2 = 0;
        comp_en = 0;
        #100;
        rst = 0;
        #100 rst =1;
        
        # 100 num1 =50;
        num2=50;
        # 20 comp_en=1;
        
    end
    
//    always @(posedge clk) begin
//        num1 = $random();
//        num2 = $random();
//        comp_en = 1;
//        #10;
//        comp_en = 0;
//    end
    
endmodule

