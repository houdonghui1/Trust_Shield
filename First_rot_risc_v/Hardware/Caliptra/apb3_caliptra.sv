`include "common_defines.sv"
`include "config_defines.svh"
`include "caliptra_reg_defines.svh"
`include "caliptra_macros.svh"

import soc_ifc_pkg::*;

module apb3_caliptra(
    input						apb3_root_clk,
	input						apb3_root_rstn,

    input	[31:0]				paddr,  
	input						penable,
	input	[ 3:0]				pstrb,  
	//input	[ 2:0]				pprot,  
	input						pwrite, 
	input	[31:0]				pwdata, 
	input						psel,   
	output	[31:0]				prdata, 
	output						pready,
	//output						pslverr,

    input                       ca_jtag_tck,    // JTAG clk
    input                       ca_jtag_tms,    // JTAG TMS
    input                       ca_jtag_tdi,    // JTAG tdi
    input                       ca_jtag_trst_n, // JTAG Reset
    output                      ca_jtag_tdo,    // JTAG TDO

    //QSPI Interface
    output logic                                ca_qspi_clk,
    output logic                                ca_qspi_cs,
                                        inout wire [`CALIPTRA_QSPI_IO_WIDTH-1:0]    ca_qspi_data,
    //uart export
    output                                 ca_uart_tx,
    input                                  ca_uart_rx,

    input   [2:0]               security_state,
    input                       scan_mode

);

//上电信号的处理
wire pwrgood_15_high;

pwrgood_assert u_pwrgood_assert(
    .clk            (apb3_root_clk),  // 时钟信号
    .pwrgood        (pwrgood_15_high)  // 上电默认低电平，15个周期后拉高
);

//SPI
logic [`CALIPTRA_QSPI_IO_WIDTH-1:0]  qspi_data_host_to_device, qspi_data_device_to_host;
logic [`CALIPTRA_QSPI_IO_WIDTH-1:0]  qspi_data_host_to_device_en;

// Physical Source for Internal TRNG

logic             etrng_req;
logic [3:0]       itrng_data;
logic             itrng_valid;

el2_mem_if el2_mem_export ();

logic mbox_sram_cs;
logic mbox_sram_we;
logic [14:0] mbox_sram_addr;
logic [MBOX_DATA_AND_ECC_W-1:0] mbox_sram_wdata;
logic [MBOX_DATA_AND_ECC_W-1:0] mbox_sram_rdata;

logic imem_cs;
logic [`CALIPTRA_IMEM_ADDR_WIDTH-1:0] imem_addr;
logic [`CALIPTRA_IMEM_DATA_WIDTH-1:0] imem_rdata;



rng4bits u_rng4bits(
    .clk            (apb3_root_clk),          // 时钟
    .rst_n          (~apb3_root_rstn),        // 异步复位（低有效）
    .en             (etrng_req),           // 使能信号（1=允许更新LFSR）
    .valid          (itrng_valid),        // 输出有效标志（1=随机数稳定)
    .random         (itrng_data)      // 4位随机输出
);

//caliptra instance
caliptra_top caliptra_top_dut (
    .cptra_pwrgood              (pwrgood_15_high),
    .cptra_rst_b                (~apb3_root_rstn),
    .clk                        (apb3_root_clk),

    .cptra_obf_key              (256'h54682728db5035eb04b79645c64a95606abb6ba392b6633d79173c027c5acf77),

    .jtag_tck(ca_jtag_tck),
    .jtag_tdi(ca_jtag_tdi),
    .jtag_tms(ca_jtag_tms),
    .jtag_trst_n(ca_jtag_trst_n),
    .jtag_tdo(ca_jtag_tdo),

//APB SIGNALS
    .PADDR(paddr),
    .PPROT(3'b001),
    .PAUSER(32'hFFFF_FFFF),
    .PENABLE(penable),
    .PRDATA(prdata),
    .PREADY(pready),
    .PSEL(psel),
    .PSLVERR(),
    .PWDATA(pwdata),
    .PWRITE(pwrite),

    .qspi_clk_o (ca_qspi_clk),
    .qspi_cs_no (ca_qspi_cs),
    .qspi_d_i   (qspi_data_device_to_host),
    .qspi_d_o   (qspi_data_host_to_device),
    .qspi_d_en_o(qspi_data_host_to_device_en),

`ifdef CALIPTRA_INTERNAL_UART
    .uart_tx(ca_uart_tx),
    .uart_rx(ca_uart_rx),
`endif

//DCCM 和 ICCM接口的引出

    .el2_mem_export(el2_mem_export.veer_sram_src),

    .ready_for_fuses(),
    .ready_for_fw_push(),
    .ready_for_runtime(),

    .mbox_sram_cs(mbox_sram_cs),
    .mbox_sram_we(mbox_sram_we),
    .mbox_sram_addr(mbox_sram_addr),
    .mbox_sram_wdata(mbox_sram_wdata),
    .mbox_sram_rdata(mbox_sram_rdata),
        
    .imem_cs(imem_cs),
    .imem_addr(imem_addr),
    .imem_rdata(imem_rdata),

    .mailbox_data_avail(),
    .mailbox_flow_done(),
    .BootFSM_BrkPoint(1'b1),

    //SoC Interrupts
    .cptra_error_fatal    (),
    .cptra_error_non_fatal(),

`ifdef CALIPTRA_INTERNAL_TRNG
    .etrng_req             (etrng_req),
    .itrng_data            (itrng_data),
    .itrng_valid           (itrng_valid),
`else
    .etrng_req             (),
    .itrng_data            (4'b0),
    .itrng_valid           (1'b0),
`endif

    .generic_input_wires(),
    .generic_output_wires(),
//debug阶段将tap引出
    .security_state(security_state),
    .scan_mode     (scan_mode)
);


//=========================================================================
// SPI 
//=========================================================================
for (genvar ii = 0; ii < `CALIPTRA_QSPI_IO_WIDTH; ii += 1) begin: gen_qspi_io
  assign ca_qspi_data[ii] = qspi_data_host_to_device_en[ii]
      ? qspi_data_host_to_device[ii]
      : 1'bz;
  assign qspi_data_device_to_host[ii] = qspi_data_host_to_device_en[ii]
      ? 1'bz
      : ca_qspi_data[ii];
end


//el2 sram 

caliptra_veer_sram_export veer_sram_export_inst (
    .el2_mem_export(el2_mem_export.veer_sram_sink)
);

//mbox sim model
`ifdef SIMULATION
caliptra_sram 
#(
    .DATA_WIDTH(MBOX_DATA_AND_ECC_W),
    .DEPTH     (MBOX_DEPTH         )
)
mbox_sim
(
    .clk_i(apb3_root_clk),

    .cs_i(mbox_sram_cs),
    .we_i(mbox_sram_we),
    .addr_i(mbox_sram_addr),
    .wdata_i(mbox_sram_wdata),

    .rdata_o(mbox_sram_rdata)
);


//SRAM for imem
caliptra_sram #(
    .DEPTH     (`CALIPTRA_IMEM_DEPTH     ), // Depth in WORDS
    .DATA_WIDTH(`CALIPTRA_IMEM_DATA_WIDTH),
    .ADDR_WIDTH(`CALIPTRA_IMEM_ADDR_WIDTH)
) imem_sim (
    .clk_i   (apb3_root_clk   ),

    .cs_i    (imem_cs),
    .we_i    (1'b0/*sram_write && sram_dv*/      ),
    .addr_i  (imem_addr                          ),
    .wdata_i (`CALIPTRA_IMEM_DATA_WIDTH'(0)/*sram_wdata   */),
    .rdata_o (imem_rdata                         )
);

initial begin
    $readmemh("/home/houdonghui/cm3_ahbmtx_mcu/user/firmware/caliptra_sw/Ctest/build/Ctest.hex",  imem_sim.ram,0,`CALIPTRA_IMEM_BYTE_SIZE-1);
end

`endif 


fpga_imem u_fpga_imem (
  .clka(apb3_root_clk),    // input wire clka
  .ena(imem_cs),      // input wire ena
  .wea(8'h0),      // input wire [7 : 0] wea
  .addra(imem_addr),  // input wire [12 : 0] addra
  .dina(0),    // input wire [63 : 0] dina
  .douta(imem_rdata)  // output wire [63 : 0] douta
);

fpga_mbox_ram u_fpga_mbox_ram (
  .clka(apb3_root_clk),    // input wire clka
  .ena(mbox_sram_cs),      // input wire ena
  .wea(mbox_sram_we),      // input wire [0 : 0] wea
  .addra(mbox_sram_addr),  // input wire [14 : 0] addra
  .dina(mbox_sram_wdata),    // input wire [38 : 0] dina
  .douta(mbox_sram_rdata)  // output wire [38 : 0] douta
);
//！！！！！！！！！！！！！！！！！！！！！！！！！！！！
 

endmodule