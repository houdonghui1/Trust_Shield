// Copyright 1986-2021 Xilinx, Inc. All Rights Reserved.
// --------------------------------------------------------------------------------
// Tool Version: Vivado v.2021.1 (lin64) Build 3247384 Thu Jun 10 19:36:07 MDT 2021
// Date        : Mon Mar 17 10:25:29 2025
// Host        : secure-Precision-3660 running 64-bit Ubuntu 20.04.6 LTS
// Command     : write_verilog -force -mode funcsim
//               /home/houdonghui/cm3_ahbmtx_mcu/library/xilinx_ip/ram_8k/ram_8k_sim_netlist.v
// Design      : ram_8k
// Purpose     : This verilog netlist is a functional simulation representation of the design and should not be modified
//               or synthesized. This netlist cannot be used for SDF annotated simulation.
// Device      : xcku060-ffva1156-2-i
// --------------------------------------------------------------------------------
`timescale 1 ps / 1 ps

(* CHECK_LICENSE_TYPE = "ram_8k,blk_mem_gen_v8_4_4,{}" *) (* downgradeipidentifiedwarnings = "yes" *) (* x_core_info = "blk_mem_gen_v8_4_4,Vivado 2021.1" *) 
(* NotValidForBitStream *)
module ram_8k
   (clka,
    ena,
    wea,
    addra,
    dina,
    douta);
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTA CLK" *) (* x_interface_parameter = "XIL_INTERFACENAME BRAM_PORTA, MEM_SIZE 8192, MEM_WIDTH 32, MEM_ECC NONE, MASTER_TYPE OTHER, READ_LATENCY 1" *) input clka;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTA EN" *) input ena;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTA WE" *) input [3:0]wea;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTA ADDR" *) input [10:0]addra;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTA DIN" *) input [31:0]dina;
  (* x_interface_info = "xilinx.com:interface:bram:1.0 BRAM_PORTA DOUT" *) output [31:0]douta;

  wire [10:0]addra;
  wire clka;
  wire [31:0]dina;
  wire [31:0]douta;
  wire ena;
  wire [3:0]wea;
  wire NLW_U0_dbiterr_UNCONNECTED;
  wire NLW_U0_rsta_busy_UNCONNECTED;
  wire NLW_U0_rstb_busy_UNCONNECTED;
  wire NLW_U0_s_axi_arready_UNCONNECTED;
  wire NLW_U0_s_axi_awready_UNCONNECTED;
  wire NLW_U0_s_axi_bvalid_UNCONNECTED;
  wire NLW_U0_s_axi_dbiterr_UNCONNECTED;
  wire NLW_U0_s_axi_rlast_UNCONNECTED;
  wire NLW_U0_s_axi_rvalid_UNCONNECTED;
  wire NLW_U0_s_axi_sbiterr_UNCONNECTED;
  wire NLW_U0_s_axi_wready_UNCONNECTED;
  wire NLW_U0_sbiterr_UNCONNECTED;
  wire [31:0]NLW_U0_doutb_UNCONNECTED;
  wire [10:0]NLW_U0_rdaddrecc_UNCONNECTED;
  wire [3:0]NLW_U0_s_axi_bid_UNCONNECTED;
  wire [1:0]NLW_U0_s_axi_bresp_UNCONNECTED;
  wire [10:0]NLW_U0_s_axi_rdaddrecc_UNCONNECTED;
  wire [31:0]NLW_U0_s_axi_rdata_UNCONNECTED;
  wire [3:0]NLW_U0_s_axi_rid_UNCONNECTED;
  wire [1:0]NLW_U0_s_axi_rresp_UNCONNECTED;

  (* C_ADDRA_WIDTH = "11" *) 
  (* C_ADDRB_WIDTH = "11" *) 
  (* C_ALGORITHM = "1" *) 
  (* C_AXI_ID_WIDTH = "4" *) 
  (* C_AXI_SLAVE_TYPE = "0" *) 
  (* C_AXI_TYPE = "1" *) 
  (* C_BYTE_SIZE = "8" *) 
  (* C_COMMON_CLK = "0" *) 
  (* C_COUNT_18K_BRAM = "0" *) 
  (* C_COUNT_36K_BRAM = "2" *) 
  (* C_CTRL_ECC_ALGO = "NONE" *) 
  (* C_DEFAULT_DATA = "0" *) 
  (* C_DISABLE_WARN_BHV_COLL = "0" *) 
  (* C_DISABLE_WARN_BHV_RANGE = "0" *) 
  (* C_ELABORATION_DIR = "./" *) 
  (* C_ENABLE_32BIT_ADDRESS = "0" *) 
  (* C_EN_DEEPSLEEP_PIN = "0" *) 
  (* C_EN_ECC_PIPE = "0" *) 
  (* C_EN_RDADDRA_CHG = "0" *) 
  (* C_EN_RDADDRB_CHG = "0" *) 
  (* C_EN_SAFETY_CKT = "0" *) 
  (* C_EN_SHUTDOWN_PIN = "0" *) 
  (* C_EN_SLEEP_PIN = "0" *) 
  (* C_EST_POWER_SUMMARY = "Estimated Power for IP     :     0.65664 mW" *) 
  (* C_FAMILY = "kintexu" *) 
  (* C_HAS_AXI_ID = "0" *) 
  (* C_HAS_ENA = "1" *) 
  (* C_HAS_ENB = "0" *) 
  (* C_HAS_INJECTERR = "0" *) 
  (* C_HAS_MEM_OUTPUT_REGS_A = "0" *) 
  (* C_HAS_MEM_OUTPUT_REGS_B = "0" *) 
  (* C_HAS_MUX_OUTPUT_REGS_A = "0" *) 
  (* C_HAS_MUX_OUTPUT_REGS_B = "0" *) 
  (* C_HAS_REGCEA = "0" *) 
  (* C_HAS_REGCEB = "0" *) 
  (* C_HAS_RSTA = "0" *) 
  (* C_HAS_RSTB = "0" *) 
  (* C_HAS_SOFTECC_INPUT_REGS_A = "0" *) 
  (* C_HAS_SOFTECC_OUTPUT_REGS_B = "0" *) 
  (* C_INITA_VAL = "0" *) 
  (* C_INITB_VAL = "0" *) 
  (* C_INIT_FILE = "ram_8k.mem" *) 
  (* C_INIT_FILE_NAME = "no_coe_file_loaded" *) 
  (* C_INTERFACE_TYPE = "0" *) 
  (* C_LOAD_INIT_FILE = "0" *) 
  (* C_MEM_TYPE = "0" *) 
  (* C_MUX_PIPELINE_STAGES = "0" *) 
  (* C_PRIM_TYPE = "1" *) 
  (* C_READ_DEPTH_A = "2048" *) 
  (* C_READ_DEPTH_B = "2048" *) 
  (* C_READ_LATENCY_A = "1" *) 
  (* C_READ_LATENCY_B = "1" *) 
  (* C_READ_WIDTH_A = "32" *) 
  (* C_READ_WIDTH_B = "32" *) 
  (* C_RSTRAM_A = "0" *) 
  (* C_RSTRAM_B = "0" *) 
  (* C_RST_PRIORITY_A = "CE" *) 
  (* C_RST_PRIORITY_B = "CE" *) 
  (* C_SIM_COLLISION_CHECK = "ALL" *) 
  (* C_USE_BRAM_BLOCK = "0" *) 
  (* C_USE_BYTE_WEA = "1" *) 
  (* C_USE_BYTE_WEB = "1" *) 
  (* C_USE_DEFAULT_DATA = "1" *) 
  (* C_USE_ECC = "0" *) 
  (* C_USE_SOFTECC = "0" *) 
  (* C_USE_URAM = "0" *) 
  (* C_WEA_WIDTH = "4" *) 
  (* C_WEB_WIDTH = "4" *) 
  (* C_WRITE_DEPTH_A = "2048" *) 
  (* C_WRITE_DEPTH_B = "2048" *) 
  (* C_WRITE_MODE_A = "WRITE_FIRST" *) 
  (* C_WRITE_MODE_B = "WRITE_FIRST" *) 
  (* C_WRITE_WIDTH_A = "32" *) 
  (* C_WRITE_WIDTH_B = "32" *) 
  (* C_XDEVICEFAMILY = "kintexu" *) 
  (* downgradeipidentifiedwarnings = "yes" *) 
  (* is_du_within_envelope = "true" *) 
  ram_8k_blk_mem_gen_v8_4_4 U0
       (.addra(addra),
        .addrb({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .clka(clka),
        .clkb(1'b0),
        .dbiterr(NLW_U0_dbiterr_UNCONNECTED),
        .deepsleep(1'b0),
        .dina(dina),
        .dinb({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .douta(douta),
        .doutb(NLW_U0_doutb_UNCONNECTED[31:0]),
        .eccpipece(1'b0),
        .ena(ena),
        .enb(1'b0),
        .injectdbiterr(1'b0),
        .injectsbiterr(1'b0),
        .rdaddrecc(NLW_U0_rdaddrecc_UNCONNECTED[10:0]),
        .regcea(1'b0),
        .regceb(1'b0),
        .rsta(1'b0),
        .rsta_busy(NLW_U0_rsta_busy_UNCONNECTED),
        .rstb(1'b0),
        .rstb_busy(NLW_U0_rstb_busy_UNCONNECTED),
        .s_aclk(1'b0),
        .s_aresetn(1'b0),
        .s_axi_araddr({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .s_axi_arburst({1'b0,1'b0}),
        .s_axi_arid({1'b0,1'b0,1'b0,1'b0}),
        .s_axi_arlen({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .s_axi_arready(NLW_U0_s_axi_arready_UNCONNECTED),
        .s_axi_arsize({1'b0,1'b0,1'b0}),
        .s_axi_arvalid(1'b0),
        .s_axi_awaddr({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .s_axi_awburst({1'b0,1'b0}),
        .s_axi_awid({1'b0,1'b0,1'b0,1'b0}),
        .s_axi_awlen({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .s_axi_awready(NLW_U0_s_axi_awready_UNCONNECTED),
        .s_axi_awsize({1'b0,1'b0,1'b0}),
        .s_axi_awvalid(1'b0),
        .s_axi_bid(NLW_U0_s_axi_bid_UNCONNECTED[3:0]),
        .s_axi_bready(1'b0),
        .s_axi_bresp(NLW_U0_s_axi_bresp_UNCONNECTED[1:0]),
        .s_axi_bvalid(NLW_U0_s_axi_bvalid_UNCONNECTED),
        .s_axi_dbiterr(NLW_U0_s_axi_dbiterr_UNCONNECTED),
        .s_axi_injectdbiterr(1'b0),
        .s_axi_injectsbiterr(1'b0),
        .s_axi_rdaddrecc(NLW_U0_s_axi_rdaddrecc_UNCONNECTED[10:0]),
        .s_axi_rdata(NLW_U0_s_axi_rdata_UNCONNECTED[31:0]),
        .s_axi_rid(NLW_U0_s_axi_rid_UNCONNECTED[3:0]),
        .s_axi_rlast(NLW_U0_s_axi_rlast_UNCONNECTED),
        .s_axi_rready(1'b0),
        .s_axi_rresp(NLW_U0_s_axi_rresp_UNCONNECTED[1:0]),
        .s_axi_rvalid(NLW_U0_s_axi_rvalid_UNCONNECTED),
        .s_axi_sbiterr(NLW_U0_s_axi_sbiterr_UNCONNECTED),
        .s_axi_wdata({1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0,1'b0}),
        .s_axi_wlast(1'b0),
        .s_axi_wready(NLW_U0_s_axi_wready_UNCONNECTED),
        .s_axi_wstrb({1'b0,1'b0,1'b0,1'b0}),
        .s_axi_wvalid(1'b0),
        .sbiterr(NLW_U0_sbiterr_UNCONNECTED),
        .shutdown(1'b0),
        .sleep(1'b0),
        .wea(wea),
        .web({1'b0,1'b0,1'b0,1'b0}));
endmodule
`pragma protect begin_protected
`pragma protect version = 1
`pragma protect encrypt_agent = "XILINX"
`pragma protect encrypt_agent_info = "Xilinx Encryption Tool 2021.1"
`pragma protect key_keyowner="Synopsys", key_keyname="SNPS-VCS-RSA-2", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=128)
`pragma protect key_block
sbNGmomEbP78s1hfxgX3P1Jo01EKJk0i0C7iGpF+Yibr9EK0s4mcIifHDN/ag4jpPwW3bPllMHvn
U8AEY3mO8hCXVVoilrcRuCaEna/98GycCzy4G7FnYMfowsJb5k9ifRdE2jnurzeTLFbupUSpDF0H
Rl3Ci3DTGeExAZZ9UQE=

`pragma protect key_keyowner="Aldec", key_keyname="ALDEC15_001", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
zZZZoIprBFYfDWmCCcduELBM7HU98/+rvP9g8+y1mYyD3r3HEDm4ZwehwZvPoYWqoGXYoFqWZh3h
utt0abIfUW9/oF2vJ9hXn7nArtcm/Eui18rPYqp3aj/AItPNVXojk9zp7uFZLPTqcyig5v3Jtenl
qPnLi1Z84ZCW7NIRw6Y0bgmw6z26E8VPbYrZHs+0YW8Sztjo6CdIrQeEL5WBDolA0aHoKHWRZyFs
l5eRDmBAolj2uF07t/3eY3J7cYJmEDaoZ0TR1qcz25VFNu0OlcrEJ19IT+QdAxTah4jqJtknGZrT
6lUMwDZ7dBQwF1EuaE6p90gGNERhGAsbHLdvaw==

`pragma protect key_keyowner="Mentor Graphics Corporation", key_keyname="MGC-VELOCE-RSA", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=128)
`pragma protect key_block
KUbz0Iu2faeWqD6HFeuGLtSOAlqZmpKCCJfzym8tkcWUUNgNMn2mYvx6PTM7j4tyig8JdUG3uZYs
NfPgAsNXQtTI7b19u9CkMks9jR+oEzX1rW7QtTvSj/nHZLg2smoFwuB5Ieb7/B8IIs1NTUrIz6Rc
itLQVG+L+GMziamsrx4=

`pragma protect key_keyowner="Mentor Graphics Corporation", key_keyname="MGC-VERIF-SIM-RSA-2", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
G7XYdRx9VGclyxTEtwMG+rjJHV8bfBxEGdkcN82UL3koN3Dt0M5AWkzEvHcskt1W0hTOjyYgmvYj
/p70w1nz96tlg226+e4UubpRmBH9QXBBX6UmqIwSiHj9H+XI1yNfTIdlwBKGQvfzwCAMwBwrrrGL
/804k5Ux3RhWRvwezZB4+sj9DFm4akREVXmNpfeqjI2X02LU/MxWMUbKxvjJnD9YxikAAO6ccTd6
8DKv76V76MEFVyXc7E2FeQDToW3lqkRTa6MTpIXbYSekRihQC+qPVuhPUneA4kepvQDfgFYE8/Ir
gu5gK+s/qNfuXhJUAqyLjslrUcY4+XD9ckpSvQ==

`pragma protect key_keyowner="Real Intent", key_keyname="RI-RSA-KEY-1", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
YXkYRXpUPv/tETnwnThdQ46UaPmI23lN9vrxHQjIOhq3WNJCuz7TYZK9hyzSdo6k0U6QE9ihQy2L
rYZg68RGbrK8bzlcnQ41r18LZb4GYlAn9PH7IrF1B+aHm3578doOZHf8wzUE2s+d1aHQIn6VIZjL
14pCTAjErJfMO13fgX6h8sgxb4GFC3eIORmkrq2J/fB9HALyh/qdGiLi7DejMfmdsssbOcPQTZUh
6Belf7fHTkIEr9B44rFZgMyrMVx4N9p0XpXD3JPe7Xeg6a3jxdqxHATaMuLdIa4s+ZiAz1TRx0EO
FFihCnLLb7weBBITQyTIncRL817BrF/ZXZD8Yw==

`pragma protect key_keyowner="Xilinx", key_keyname="xilinxt_2021_01", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
g7FbNw1ywd4TBNHq8OmK/4zoKI/t7vKmyT8R8SeiyUtKywhn0/7DZ/lV0Lf4IhY8X5MYsKtOQ5l6
DIl3fxtOhxpi8NHn9Nw3Nfb8NnS38Zuy6DSpwOL0f/GSmUSf2/YdB5Ben6xibQT0Oy//oBl5/1kR
pV5fWjj8WRgI6cnmfyj3g1MxepxPu1A/UHxlm1/i9yUHHi114N/hEQ0iujjrn6GxfZSiJUVF+r6c
rnxD//eOAl/YaxhdU/KhUkfsMn+MxtA5m6hTYYE0bnze8rpmEU5UGYKyY0p8KUs+MgsdTe+m/7gV
HSf6puBqQmEa1qksRfl742aL9B9y169or7Jp9Q==

`pragma protect key_keyowner="Metrics Technologies Inc.", key_keyname="DSim", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
kd1A2zIphLxXB0RyfHIqLkHXfWl0n38vROERuDghYrhK0ItcWGEP0XBrri6k1VZCSPYwiSu//pM6
83BfcPKbk09/A+ksvDIa3xS8Tg7DJK2AS+0pdnzBSjVWh+QD+glA3Hjk6LG9OMbjXyqD3hnMKacA
VRMwxKktV+KT5NXj5a7fMxXjo9exc0xM+woUJiSYs8onoUSwfBeH5/xhUy+iu+w0/OOydQE2LXZ0
1y+RObiz5C22dD4GGCfuvUCGAthYpUf633ZxRYN45mmAn5PxPsH4o+l2GhH/50Gu/VPVoAWDhgXQ
e93oPri++HinkK2uvDhDl4PI9HtRkq11Ky3uXQ==

`pragma protect key_keyowner="Atrenta", key_keyname="ATR-SG-RSA-1", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=384)
`pragma protect key_block
gDrrFgXHVyBo+Cn0bYn+SOSOCXPg7besukY6l0JmA/nu4gap105Wxbg11c7TJZ9ctHVLc5DXAxr+
EIvFpAIepoZBREtMjTlaIdNJ8k1nUpwAv2jaQeseq1TudTjugV1jtOYYk0RKd88z/6SJ8t9urDW0
yKqsfEWU3PwGcUGHOWtTn2hfAceNznmEIFWLmFmzSQJ1hQNdsIQn3jHnfMVYu8cAz5xvPVQWYyJW
pMHXhNYk6GyAjIshh991slb1g01K1ilR2tKD1EmxH5WGrX9BEUqBjHQo6uluC/d3mvcEQ5nJ1v+P
hIlj4qzUQT1wXjpk6d/BvNx7LyWmj5iq35dzNm+cdhfGwaFGG//vgmB6D/dFfs2BYSjHsa6VlpVM
7e2OgoFenuG9p1SVPI6gAs2MuFtnDKfxW7jS3RGhvsquS3tg1iFCDH/OU7E5aWfY7twF3yyN6G10
l72RZw62DfNoCdyUMG9sA8nc4qf6dEhyrr5S6XxpJhoBDJvkeq0TCUQZ

`pragma protect key_keyowner="Cadence Design Systems.", key_keyname="CDS_RSA_KEY_VER_1", key_method="rsa"
`pragma protect encoding = (enctype="BASE64", line_length=76, bytes=256)
`pragma protect key_block
XR7vRF1m+9DS2Pv4r/O4uHwmvtXkChnKbsJCYczn1dvkZbcZSbBm/2UH78dXUaNorOh9XAuCvSjb
ER73y7e0anAfaIf1tJ9Y9pIb8EuNxGS/Pqdvg36cWarwGac9tsscdv/HWfb5Z+qWEk0/uFcLI7pH
CZO7fF2/ONQjA0NtUFBjW4idlx8WrySIuJgDs4jyGkMhbHR3U/ghF1YhMhwgwsbbcptfC1XLrIqQ
OecZnZu8E2hyc5eK/ccYdKcHnXoL55z1p5amI6Fuvz0wKTz2QQ/mwXodfGjEC1ZRWwTn7zCFM91M
qrA1Is49i6pSa7/VICjgn8ULMT1oKGfJLPm7hg==

`pragma protect data_method = "AES128-CBC"
`pragma protect encoding = (enctype = "BASE64", line_length = 76, bytes = 49296)
`pragma protect data_block
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
`pragma protect end_protected
`ifndef GLBL
`define GLBL
`timescale  1 ps / 1 ps

module glbl ();

    parameter ROC_WIDTH = 100000;
    parameter TOC_WIDTH = 0;
    parameter GRES_WIDTH = 10000;
    parameter GRES_START = 10000;

//--------   STARTUP Globals --------------
    wire GSR;
    wire GTS;
    wire GWE;
    wire PRLD;
    wire GRESTORE;
    tri1 p_up_tmp;
    tri (weak1, strong0) PLL_LOCKG = p_up_tmp;

    wire PROGB_GLBL;
    wire CCLKO_GLBL;
    wire FCSBO_GLBL;
    wire [3:0] DO_GLBL;
    wire [3:0] DI_GLBL;
   
    reg GSR_int;
    reg GTS_int;
    reg PRLD_int;
    reg GRESTORE_int;

//--------   JTAG Globals --------------
    wire JTAG_TDO_GLBL;
    wire JTAG_TCK_GLBL;
    wire JTAG_TDI_GLBL;
    wire JTAG_TMS_GLBL;
    wire JTAG_TRST_GLBL;

    reg JTAG_CAPTURE_GLBL;
    reg JTAG_RESET_GLBL;
    reg JTAG_SHIFT_GLBL;
    reg JTAG_UPDATE_GLBL;
    reg JTAG_RUNTEST_GLBL;

    reg JTAG_SEL1_GLBL = 0;
    reg JTAG_SEL2_GLBL = 0 ;
    reg JTAG_SEL3_GLBL = 0;
    reg JTAG_SEL4_GLBL = 0;

    reg JTAG_USER_TDO1_GLBL = 1'bz;
    reg JTAG_USER_TDO2_GLBL = 1'bz;
    reg JTAG_USER_TDO3_GLBL = 1'bz;
    reg JTAG_USER_TDO4_GLBL = 1'bz;

    assign (strong1, weak0) GSR = GSR_int;
    assign (strong1, weak0) GTS = GTS_int;
    assign (weak1, weak0) PRLD = PRLD_int;
    assign (strong1, weak0) GRESTORE = GRESTORE_int;

    initial begin
	GSR_int = 1'b1;
	PRLD_int = 1'b1;
	#(ROC_WIDTH)
	GSR_int = 1'b0;
	PRLD_int = 1'b0;
    end

    initial begin
	GTS_int = 1'b1;
	#(TOC_WIDTH)
	GTS_int = 1'b0;
    end

    initial begin 
	GRESTORE_int = 1'b0;
	#(GRES_START);
	GRESTORE_int = 1'b1;
	#(GRES_WIDTH);
	GRESTORE_int = 1'b0;
    end

endmodule
`endif
