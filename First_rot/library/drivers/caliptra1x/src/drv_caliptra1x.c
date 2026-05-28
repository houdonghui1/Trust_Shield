//===============================================
//
//	File: drv_caliptra1x.c
//	Author: afterGlow,4ever
//	Group: Fall For Laboratory
//	Date: 12272023
//	Version: v1.0
//
// 	This is source file for ucaliptra1xart driver.
//
//===============================================

#include "drv_caliptra1x.h"
#include "caliptra_top_reg.h"
#include <string.h>

#ifdef CALIPTRA1X_DRIVER

__attribute__((section("VPK_HASH"))) uint8_t vpk_hash[48];
__attribute__((section("OPK_HASH"))) uint8_t opk_hash[48];

// Arbitrary example only - values must be customized/tuned for the SoC
static const uint64_t wdt_timeout = 0xA0000000;         // approximately 5s for 500MHz clock
// Arbitrary example only - values must be customized/tuned for the SoC
static const uint16_t itrng_entropy_low_threshold = 0x1;
// Arbitrary example only - values must be customized/tuned for the SoC
static const uint16_t itrng_entropy_high_threshold = 0xFFFF;
// Arbitrary example only - values must be customized/tuned for the SoC
static const uint16_t itrng_entropy_repetition_count = 0xFFFF;

void delay_ms(unsigned int milliseconds) {
    while (milliseconds != 0) {
        milliseconds--;
    }
}

void set_fuses(test_info* info)
{
    struct caliptra_fuses* fuses = &info->fuses;
    *fuses = (struct caliptra_fuses){0};

    memcpy(&fuses->uds_seed, default_uds_seed, sizeof(fuses->uds_seed));
    memcpy(&fuses->field_entropy, default_field_entropy, sizeof(fuses->field_entropy));

/*     for (int x = 0; x < SHA384_DIGEST_WORD_SIZE; x++)
    {
        // Pub key hash fuses are stored as big-endian
        fuses->owner_pk_hash[x] = __builtin_bswap32(((uint32_t*)opk_hash)[x]);
        fuses->key_manifest_pk_hash[x] = __builtin_bswap32(((uint32_t*)vpk_hash)[x]);
    } */
    fuses->soc_stepping_id = 0x2a4c553b;
}

/**
 * caliptra_bootfsm_go
 *
 * Initiate caliptra hw startup
 *
 * @return 0 if successful
 */
int caliptra_bootfsm_go()
{
    // Write BOOTFSM_GO Register
    writereg32(CALIPTRA_TOP_REG_GENERIC_AND_FUSE_REG_CPTRA_BOOTFSM_GO, 1);

    // TODO: Check registers/provide async completion mechanism

    return 0;
}

/**
 * caliptra_read_status
 *
 * HELPER - Reads the caliptra flow status register
 *
 * @return Status value
 */
static inline uint32_t caliptra_read_status(void)
{
    uint32_t status;

    status = readreg32(CALIPTRA_TOP_REG_GENERIC_AND_FUSE_REG_CPTRA_FLOW_STATUS);

    return status;
}

void caliptra_req_idev_csr_start()
{
    uint32_t dbg_manuf_serv_req;

    dbg_manuf_serv_req = readreg32(CALIPTRA_TOP_REG_GENERIC_AND_FUSE_REG_CPTRA_DBG_MANUF_SERVICE_REG);

    // Write to Caliptra Fuse Done
    writereg32(CALIPTRA_TOP_REG_GENERIC_AND_FUSE_REG_CPTRA_DBG_MANUF_SERVICE_REG, dbg_manuf_serv_req | 0x01);
}

/**
 * caliptra_configure_itrng_entropy
 *
 * Write the provided iTRNG config values to their respective regs
 *
 * @param[in] low_threshold iTRNG config value
 * @param[in] high_threshold iTRNG config value
 * @param[in] repetition_count iTRNG config value
 */
void caliptra_configure_itrng_entropy(uint16_t low_threshold, uint16_t high_threshold, uint16_t repetition_count)
{
    caliptra_write_itrng_entropy_low_threshold(low_threshold);
    caliptra_write_itrng_entropy_high_threshold(high_threshold);
    caliptra_write_itrng_entropy_repetition_count(repetition_count);
}

void caliptra_set_wdt_timeout(uint64_t timeout)
{
    caliptra_wdt_cfg_write(timeout);
}

/**
 * caliptra_ready_for_fuses
 *
 * Reports if the Caliptra hardware is ready for fuse data
 *
 * @return bool True if ready, false otherwise
 */
bool caliptra_ready_for_fuses(void)
{
    uint32_t status;

    status = readreg32(CALIPTRA_TOP_REG_GENERIC_AND_FUSE_REG_CPTRA_FLOW_STATUS);

    if ((status & GENERIC_AND_FUSE_REG_CPTRA_FLOW_STATUS_READY_FOR_FUSES_MASK) != 0) {
        return true;
    }

    return false;
}

/**
 * caliptra_init_fuses
 *
 * Initialize fuses based on contents of "fuses" argument
 *
 * @param[in] fuses Valid caliptra_fuses structure
 *
 * @return 0 for success, non-zero for failure (see enum libcaliptra_error)
 */
int caliptra_init_fuses(const struct caliptra_fuses *fuses)
{
    // Parameter check
    if (!fuses)
    {
        return -1;
    }

    // Check whether caliptra is ready for fuses
    if (!caliptra_ready_for_fuses())
	{
		return -2;
	}

    // Write Fuses
    caliptra_fuse_array_write(GENERIC_AND_FUSE_REG_FUSE_UDS_SEED_0, fuses->uds_seed, CALIPTRA_ARRAY_SIZE(fuses->uds_seed));
    caliptra_fuse_array_write(GENERIC_AND_FUSE_REG_FUSE_FIELD_ENTROPY_0, fuses->field_entropy, CALIPTRA_ARRAY_SIZE(fuses->field_entropy));
    //caliptra_fuse_array_write(GENERIC_AND_FUSE_REG_FUSE_KEY_MANIFEST_PK_HASH_0, fuses->key_manifest_pk_hash, CALIPTRA_ARRAY_SIZE(fuses->key_manifest_pk_hash));
    //caliptra_generic_and_fuse_write(GENERIC_AND_FUSE_REG_FUSE_KEY_MANIFEST_PK_HASH_MASK, fuses->key_manifest_pk_hash_mask);
    //caliptra_fuse_array_write(GENERIC_AND_FUSE_REG_FUSE_OWNER_PK_HASH_0, fuses->owner_pk_hash, CALIPTRA_ARRAY_SIZE(fuses->owner_pk_hash));
    //caliptra_generic_and_fuse_write(GENERIC_AND_FUSE_REG_FUSE_FMC_KEY_MANIFEST_SVN, fuses->fmc_key_manifest_svn);
    //caliptra_fuse_array_write(GENERIC_AND_FUSE_REG_FUSE_RUNTIME_SVN_0, fuses->runtime_svn, CALIPTRA_ARRAY_SIZE(fuses->runtime_svn));
    //caliptra_generic_and_fuse_write(GENERIC_AND_FUSE_REG_FUSE_ANTI_ROLLBACK_DISABLE, (uint32_t)fuses->anti_rollback_disable);
    //caliptra_fuse_array_write(GENERIC_AND_FUSE_REG_FUSE_IDEVID_CERT_ATTR_0, fuses->idevid_cert_attr, CALIPTRA_ARRAY_SIZE(fuses->idevid_cert_attr));
    //caliptra_fuse_array_write(GENERIC_AND_FUSE_REG_FUSE_IDEVID_MANUF_HSM_ID_0, fuses->idevid_manuf_hsm_id, CALIPTRA_ARRAY_SIZE(fuses->idevid_manuf_hsm_id));
    //caliptra_generic_and_fuse_write(GENERIC_AND_FUSE_REG_FUSE_LIFE_CYCLE, (uint32_t)fuses->life_cycle);
    //caliptra_generic_and_fuse_write(GENERIC_AND_FUSE_REG_FUSE_LMS_VERIFY, (uint32_t)fuses->lms_verify);
    //caliptra_generic_and_fuse_write(GENERIC_AND_FUSE_REG_FUSE_LMS_REVOCATION, fuses->lms_revocation);
    caliptra_generic_and_fuse_write(GENERIC_AND_FUSE_REG_FUSE_SOC_STEPPING_ID, fuses->soc_stepping_id);

    // Write to Caliptra Fuse Done
    writereg32(CALIPTRA_TOP_REG_GENERIC_AND_FUSE_REG_CPTRA_FUSE_WR_DONE, GENERIC_AND_FUSE_REG_CPTRA_FUSE_WR_DONE_DONE_MASK);

    // No longer ready for fuses
    if (caliptra_ready_for_fuses())
    {
		return -3;
	}

    return 0;
}

/**
 * caliptra_ready_for_firmware
 *
 * Reports if the Caliptra hardware is ready for firmware upload
 *
 * @return bool True if ready, false otherwise
 */
bool caliptra_ready_for_firmware(void)
{
    uint32_t status;
    bool ready = false;

    do
    {
        status = caliptra_read_status();

        if ((status & GENERIC_AND_FUSE_REG_CPTRA_FLOW_STATUS_READY_FOR_FW_MASK) == GENERIC_AND_FUSE_REG_CPTRA_FLOW_STATUS_READY_FOR_FW_MASK)
        {
            ready = true;
        }
        else
        {
            delay_ms(1000);
        }
		
    } while (ready == false);

    return true;
}

bool drv_caliptra1x_init(const test_info* info, bool req_idev_csr)
{
	uint32_t	status = 0;

   	// Request CSR if needed
    if (req_idev_csr)
	{
		caliptra_req_idev_csr_start();
	}

    caliptra_set_wdt_timeout(wdt_timeout);

    caliptra_configure_itrng_entropy(itrng_entropy_low_threshold,
                                     itrng_entropy_high_threshold,
                                     itrng_entropy_repetition_count);
                                     
	if ((status = caliptra_init_fuses(&info->fuses)) != 0) {
		drv_uart_printf("Failed to init fuses: %d\n", status);
		return status;
	}

/*     if (req_idev_csr == false)
    {
        // Wait until ready for FW
        caliptra_ready_for_firmware();
    }
 */
    // Initialize FSM GO
	//caliptra_bootfsm_go();

	return false;
}

bool drv_caliptra1x_tx_data(data_comm* data)
{
	uint8_t		lock_status;
	volatile uint32_t *datain_addr = (uint32_t *)CALIPTRA_TOP_REG_MBOX_CSR_MBOX_DATAIN;
	
	if(data->indata == NULL || data->inlen <= 0) {
		return false;
	}

	//Read lock status
	lock_status = readreg8(CALIPTRA_TOP_REG_MBOX_CSR_MBOX_LOCK);
	if(lock_status) {
		return false;
	}

	writereg8(CALIPTRA_TOP_REG_MBOX_CSR_MBOX_LOCK, MBOX_CSR_MBOX_LOCK_LOCK_MASK);

	writereg32(CALIPTRA_TOP_REG_MBOX_CSR_MBOX_DLEN, data->inlen);

	for(uint32_t i = 0; i < data->outlen; i++) {
		*(datain_addr + i) = data->indata[i];
	}

	writereg8(CALIPTRA_TOP_REG_MBOX_CSR_MBOX_EXECUTE, MBOX_CSR_MBOX_EXECUTE_EXECUTE_MASK);

	return true;
}

bool drv_caliptra1x_rx_data(data_comm* data)
{
	volatile uint32_t *dataout_addr = (uint32_t *)CALIPTRA_TOP_REG_MBOX_CSR_MBOX_DATAOUT;

	data->outlen = readreg32(CALIPTRA_TOP_REG_MBOX_CSR_MBOX_DLEN);
	if(data->outlen <= 0) {
		return false;
	}

	data->outdata = malloc(data->outlen);
	if(data->outdata == NULL) {
		return false;
	}
	for(uint32_t i = 0; i < data->outlen; i++) {
		data->outdata[i] = *(dataout_addr + i);
	}

	return true;
}

bool drv_caliptra1x_comm(data_comm* data) 
{
	bool		comm_status;
	uint32_t	mbox_status;

	comm_status = drv_caliptra1x_tx_data(data);
	if(comm_status) {
		do {
			//Read mailbox status
			mbox_status = readreg32(CALIPTRA_TOP_REG_MBOX_CSR_MBOX_STATUS);
			switch (mbox_status)
			{
				case DATA_READY:
				 	comm_status = drv_caliptra1x_rx_data(data);
					break;
				case CMD_COMPLETE:
					break;
				case CMD_FAILURE:
					comm_status = false;
					break;
				case CMD_BUSY:
					break;
				default:
					comm_status = false;
					break;
			}
		} while(mbox_status == CMD_BUSY);
	}
	
	//Clear lock
	writereg8(CALIPTRA_TOP_REG_MBOX_CSR_MBOX_EXECUTE, MBOX_CSR_MBOX_EXECUTE_EXECUTE_LOW);

	return comm_status;
}
#endif

