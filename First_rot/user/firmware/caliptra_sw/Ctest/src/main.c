#include <stdint.h>
#include <string.h>
#include "caliptra_reg.h"
#include "riscv_hw_if.h"
#include "uart.h"
#include "qspi.h"

int main() {
    int hwcfg;
    hwcfg =lsu_read_32(CLP_UART_STATUS);
    end_sim_if_uart_disabled();
    enable_uart();
    //uart_tx((uint8_t)hwcfg);
    lsu_write_32(CLP_SOC_IFC_REG_CPTRA_FLOW_STATUS, SOC_IFC_REG_CPTRA_FLOW_STATUS_READY_FOR_FW_MASK);
    lsu_write_32(CLP_SOC_IFC_REG_CPTRA_FLOW_STATUS, SOC_IFC_REG_CPTRA_FLOW_STATUS_READY_FOR_RUNTIME_MASK);
    
    run_loopback_test();

    return 0;
}