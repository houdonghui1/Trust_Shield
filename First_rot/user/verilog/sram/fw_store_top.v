module fw_store_top
(
	input						sys_root_clk,
	input						sys_root_rstn,

	input						hsel_fw,
	input						hready_fw,
	input	[ 1:0]				htrans_fw,
	input	[ 2:0]				hsize_fw,
	input						hwrite_fw,
	input	[31:0]				haddr_fw,
	input	[ 3:0]				hprot_fw,
	input	[31:0]				hwdata_fw,
	output						hreadyout_fw,
	output	[ 1:0]				hresp_fw,
	output	[31:0]				hrdata_fw

);


//===============================================
// fw_store 256k
// adder:0x00040000~0x0006ffff
//===============================================

wire	[15:0]					fw_addr;
wire	[31:0]					fw_wdata;
wire	[ 3:0]					fw_wen;
wire							fw_cs;
wire	[31:0]					fw_rdata;

assign hresp_fw[1] = 1'b0;

cmsdk_ahb_to_sram
#(
	.AW							(18)	
)
u_ahb_to_fw 
(
	.HCLK						(sys_root_clk),
	.HRESETn					(sys_root_rstn),

	.HSEL						(hsel_fw),
	.HREADY						(hready_fw),
	.HTRANS						(htrans_fw),
	.HSIZE						(hsize_fw),
	.HWRITE						(hwrite_fw),
	.HADDR						(haddr_fw[17:0]),
//	.HPROT						(hprot_fw),
	.HWDATA						(hwdata_fw),
	.HREADYOUT					(hreadyout_fw),
	.HRESP						(hresp_fw[0]),
	.HRDATA						(hrdata_fw),

	.SRAMRDATA					(fw_rdata),
	.SRAMADDR					(fw_addr),
	.SRAMWEN					(fw_wen),
	.SRAMWDATA					(fw_wdata),
	.SRAMCS						(fw_cs)
);

`ifdef FPGA_SRAM
`ifdef ZYNQ_7020

ram_256k	u_fw
(
	.addra						(fw_addr),
	.clka						(sys_root_clk),
	.dina						(fw_wdata),
	.ena						(fw_cs),
	.wea						(fw_wen),
	.douta						(fw_rdata)
);

`endif
`else

cmsdk_fpga_sram
#(
	.AW							(16)
)
u_fw
(
	.CLK						(sys_root_clk),
	.ADDR						(fw_addr),
	.WDATA						(fw_wdata),
	.WREN						(fw_wen),
	.CS							(fw_cs),

	.RDATA						(fw_rdata)
);

`endif
// normal version

endmodule
