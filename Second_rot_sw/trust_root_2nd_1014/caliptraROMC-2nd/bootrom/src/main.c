#include <stdint.h>
#include <string.h>
#include <stdlib.h>
#include <stdbool.h>
#include "caliptra_reg.h"
#include "caliptra_isr.h"
#include "riscv_hw_if.h"
#include "defines.h"
#include "uart.h"
#include "qspi.h"
#include "printf.h"
#include "hmac.h"
#include "ecc.h"
#include "sha384.h"
#include "sha512.h"
#include "keyvault.h"
#include "datavault.h"
#include "x509.h"
#include "mailbox.h"
#include "trng.h"

volatile caliptra_intr_received_s cptra_intr_rcv = {
    .doe_error        = 0,
    .doe_notif        = 0,
    .ecc_error        = 0,
    .ecc_notif        = 0,
    .hmac_error       = 0,
    .hmac_notif       = 0,
    .kv_error         = 0,
    .kv_notif         = 0,
    .sha512_error     = 0,
    .sha512_notif     = 0,
    .sha256_error     = 0,
    .sha256_notif     = 0,
    .qspi_error       = 0,
    .qspi_notif       = 0,
    .uart_error       = 0,
    .uart_notif       = 0,
    .i3c_error        = 0,
    .i3c_notif        = 0,
    .soc_ifc_error    = 0,
    .soc_ifc_notif    = 0,
    .sha512_acc_error = 0,
    .sha512_acc_notif = 0,
};

void main() {
    int status;
    uint32_t word;
    mbox_op_s op;

    init_uart();
    enable_csrng();

    printf("------------------------------------\n");
    printf("            Caliptra ROM...         \n");
    printf("------------------------------------\n");
    printf("Compiled on: %s at %s\n", __DATE__, __TIME__);

    while(1) {
        op = soc_ifc_read_mbox_cmd();
        if (op.cmd & MBOX_CMD_FIELD_RESP_MASK) {
            printf("Received mailbox command (expecting RESP) from SOC! Got 0x%x\n", op.cmd);
            if (op.cmd == MBOX_CMD_GET_TRNG) {
                int num_randoms = 32;
                uint8_t randoms[num_randoms];
                if (generate_random_numbers(num_randoms, randoms) == 0) {
                    printf("Get randoms:\n");
                    for (int i = 0; i < num_randoms; i++) {
                        printf("%02x ", randoms[i]);
                    }
                    printf("\n");
                    mailbox_send_data((uint32_t *)randoms, num_randoms);
                }
            } else if (op.cmd == MBOX_CMD_ECC_SIGN) {
                int num_pk_and_sg_val = 192;
                uint8_t pk_and_sg_val[num_pk_and_sg_val];
                uint8_t msg_digest[op.dlen];
                for(int i = 0; i < op.dlen; i++) {
                    word = lsu_read_32(CLP_MBOX_CSR_MBOX_DATAOUT);
                    memcpy(msg_digest + i*4, &word, 4);
                }
                for (int i = 0; i < op.dlen; i++) {
                    printf("%02x ", msg_digest[i]);
                }
                printf("\n");

                ecc_sigh_test(msg_digest, pk_and_sg_val);

                mailbox_send_data((uint32_t *)pk_and_sg_val, num_pk_and_sg_val);

            } else if (op.cmd == MBOX_CMD_ECC_VERIFY) {
                uint8_t msg_digest[48];
                uint8_t pk_and_sg_val[192];
                
                for(int i = 0; i < 12; i++) {
                    word = lsu_read_32(CLP_MBOX_CSR_MBOX_DATAOUT);
                    memcpy(msg_digest + i*4, &word, 4);
                }
                
                for(int i = 0; i < 12; i++) {
                    word = lsu_read_32(CLP_MBOX_CSR_MBOX_DATAOUT);
                    memcpy(pk_and_sg_val + i*4, &word, 4);
                }

                status = ecc_verify_test(msg_digest, pk_and_sg_val);

                mailbox_send_data((uint32_t *)status, 0x1);
            }
        }
    }



    printf("\n");
    printf("------------------------------------\n");
    printf(" Reached end of ROM FW unexpectedly!\n");
    printf("------------------------------------\n");
    while(1);
}
