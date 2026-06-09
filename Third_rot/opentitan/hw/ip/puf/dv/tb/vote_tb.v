`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2023/03/30 11:24:25
// Design Name: 
// Module Name: vote_tb
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


module vote_tb;

reg clk;
reg rst;
reg ready;
reg vote;
reg clear;
wire done;
reg [127:0] data_in;
wire [127:0] data_out;

// 实例化被测试模块
Vote #(.Threshold(3)) vote_inst(
  .clk(clk),
  .rst(rst),
  .ready(ready),
  .vote(vote),
  .clear(clear),
  .done(done),
  .data_in(data_in),
  .data_out(data_out)
);

initial begin
  // 初始化信号
  clk = 0;
  rst = 1;
  ready = 0;
  vote = 0;
  clear = 0;
  data_in = 0;
  
  // 等待一段时间
  #10 rst = 0;
  #20 rst = 1;
  
  // 发送一些数据
  #10 ready = 1;
  data_in = 128'h00000000000000000000000000000001;
  #10 ready =0;
  
  #10 ready = 1;
  data_in = 128'h00000000000000000000000000000001;
  #10 ready =0;
  
  #10 ready = 1;
  data_in = 128'h00000000000000000000000000000001;
  #10 ready =0;
  
  #10 ready = 1;
  data_in = 128'h00000000000000000000000000000001;
  #10 ready =0;
  
  #10 ready = 1;
  data_in = 128'h00000000000000000000000000000001;
  #10 ready =0;
  
  #10 vote = 1;
  #20 vote =0;
  
  // 等待一段时间，检查输出是否正确
  #10;
  $display("data_out = %b", data_out);
  
  #20 clear = 1;
  #10 clear = 0;
  
  // 结束仿真
  #10 $finish;
end

// 时钟发生器
always #5 clk = ~ clk;

endmodule

