`timescale 1ns / 1ps
`include "sm3_cfg.v"
//////////////////////////////////////////////////////////////////////////////////
// Author:        ljgibbs / lf_gibbs@163.com
// Create Date: 2020/07/29
// Design Name: sm3
// Module Name: tb_sm3_core_top
// Description:
//      SM3 顶层 testbench
//          测试 sm3_core_top 
// Dependencies: 
//      inc/sm3_cfg.v
// Revision:
// Revision 0.01 - File Created
// Revision 0.02 - Pass random test with c model
// Revision 0.03 - Pass random test with c model (64bit)
// Revision 0.03 - Add more macro control
//////////////////////////////////////////////////////////////////////////////////
module tb_sm3_core_top;

`ifdef SM3_INPT_DW_32
    localparam [1:0]            INPT_WORD_NUM               =   2'd1;
    bit [31:0]                  urand_num;
`elsif SM3_INPT_DW_64
    localparam [1:0]            INPT_WORD_NUM               =   2'd2;
    bit [63:0]                  urand_num;
`endif

int i;
bit [7:0] data[1050];//TODO buff length limit the inpt data length 
bit [31:0] res[8];

int stat_test_cnt;
int stat_ok_cnt;
int stat_fail_cnt;
bit [60:0]  sm3_inpt_byte_num;

//interface
sm3_if sm3if();

//sm3_core_top
sm3_core_top U_sm3_core_top(

    .clk                (sm3if.clk              ),
    .rst_n              (sm3if.rst_n            ),
    .msg_inpt_d         (sm3if.msg_inpt_d       ),
    .msg_inpt_vld_byte  (sm3if.msg_inpt_vld_byte),
    .msg_inpt_vld       (sm3if.msg_inpt_vld     ),
    .msg_inpt_lst       (sm3if.msg_inpt_lst     ),
    .msg_inpt_rdy       (sm3if.msg_inpt_rdy     ),
    .cmprss_otpt_res    (sm3if.cmprss_otpt_res  ),
    .cmprss_otpt_vld    (sm3if.cmprss_otpt_vld  ),
    .msg_inpt_rdy_re    (sm3if.msg_inpt_rdy_re  ),
    .cmprss_vld_re      (sm3if.cmprss_vld_re    ),
    .cmprss_res_re      (sm3if.cmprss_res_re    )
);

initial begin
    sm3if.clk                     = 0;
    sm3if.rst_n                   = 0;
    sm3if.msg_inpt_d            = 0;
    sm3if.msg_inpt_vld_byte     = 0;
    sm3if.msg_inpt_vld          = 0;
    sm3if.msg_inpt_lst          = 0;

    #100;
    sm3if.rst_n                   =1;

        $display("LOG: run SM3 example under 32bit mode.");
        
        #20
        
    /*repeat(14) begin 
        begin 
            sm3if.msg_inpt_vld 		= 1;
            sm3if.msg_inpt_vld_byte = 4'b1111; 
            sm3if.msg_inpt_d 		= 32'h61626364;
            #10;
            sm3if.msg_inpt_vld      = 0;
            #40;	
        end	
    end
*/
    begin 
        sm3if.msg_inpt_vld 		= 1; 
        sm3if.msg_inpt_d 		= 32'h61626364;	
        sm3if.msg_inpt_lst      = 1'b1;
        sm3if.msg_inpt_vld_byte = 4'b1111;
        #10;				
    end	

    begin 
        sm3if.msg_inpt_vld 		= 0; 
        sm3if.msg_inpt_d 		= 0;	
        sm3if.msg_inpt_lst		= 0;
        sm3if.msg_inpt_vld_byte	= 0;
    end
        //task_pad_inpt_gntr_exmpl0_32(); 

end

always #5 sm3if.clk = ~sm3if.clk; 



//产生填充模块输入，采用示例输入 'abc' 32bit 输入
task automatic task_pad_inpt_gntr_exmpl0_32;

    
    sm3if.msg_inpt_vld      = 1'b1;
    sm3if.msg_inpt_lst      = 1'b1;
    sm3if.msg_inpt_d        = 32'h6162_6300;
    sm3if.msg_inpt_vld_byte = 4'b1110;
    @(posedge sm3if.clk);   
    sm3if.msg_inpt_vld    = 1'b0;
    sm3if.msg_inpt_lst    = 1'b0;
    sm3if.msg_inpt_d      = 0;
    
endtask //automatic

//产生填充模块输入，采用示例输入 512bit 重复的 'abcd' 32bit 输入
task automatic task_pad_inpt_gntr_exmpl1_32;

    sm3if.msg_inpt_vld      = 1'b1;
    sm3if.msg_inpt_d        = 32'h6162_6364;
    sm3if.msg_inpt_vld_byte = 4'b1111;
    repeat(15)begin
        @(posedge sm3if.clk);   
    end
    sm3if.msg_inpt_lst      = 1'b1;
    @(posedge sm3if.clk);   
    sm3if.msg_inpt_vld    = 1'b0;
    sm3if.msg_inpt_lst    = 1'b0;
    sm3if.msg_inpt_d      = 0;
    
endtask //automatic

endmodule