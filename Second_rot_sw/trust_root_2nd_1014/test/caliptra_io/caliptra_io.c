#include "kernel_compat.h"
#include <linux/module.h>
#include <linux/kernel.h>
#include <linux/fs.h>
#include <linux/types.h>
#include <linux/device.h>
#include <linux/cdev.h>
#include <linux/slab.h>
#include <linux/delay.h>
#include <linux/uaccess.h>
#include "mailbox.h"
#include "mem_utils.h"
#include "serial_comm.h"

#define DEVICE_NAME "caliptra_dev"
#define CALIP_IOCTL_MAGIC 'C'
#define CALIP_TRNG_IOCTL_GEN _IOR(CALIP_IOCTL_MAGIC, 1, int)
#define CALIP_ECC_SIGH_IOCTL_GEN _IOR(CALIP_IOCTL_MAGIC, 2, int)
#define CALIP_ECC_VERIFY_IOCTL_GEN _IOR(CALIP_IOCTL_MAGIC, 3, int)
#define CALIP_GENERATE_2ND_CXT_IOCTL_GEN _IOR(CALIP_IOCTL_MAGIC, 4, int)
#define CALIP_SAVE_2ND_CTX_IOCTL_GEN _IOR(CALIP_IOCTL_MAGIC, 5, int)
#define CALIP_GET_2ND_CTX_IOCTL_GEN _IOR(CALIP_IOCTL_MAGIC, 6, int)
#define CALIP_SIGN_1ST_CTX_IOCTL_GEN _IOR(CALIP_IOCTL_MAGIC, 7, int)
#define CALIP_VERIFY_1ST_CTX_IOCTL_GEN _IOR(CALIP_IOCTL_MAGIC, 8, int)
#define CALIP_BLS_SIGN_L1_CERT_IOCTL_GEN _IOR(CALIP_IOCTL_MAGIC, 9, int)
#define CALIP_BLS_AGGREGATE_CHALLENGE_IOCTL_GEN _IOR(CALIP_IOCTL_MAGIC, 10, int)
#define CALIP_BLS_GET_L2_REGISTRATION_IOCTL_GEN _IOR(CALIP_IOCTL_MAGIC, 11, int)
#define CALIP_BLS_REGISTER_L1_IOCTL_GEN _IOR(CALIP_IOCTL_MAGIC, 12, int)
#define CALIP_ECDSA_SCALE_SIGN_IOCTL_GEN _IOR(CALIP_IOCTL_MAGIC, 13, int)
#define CALIP_ECDSA_CERT_VERIFY_IOCTL_GEN _IOR(CALIP_IOCTL_MAGIC, 14, int)

#define BLS_CHALLENGE_BYTES 32
#define BLS_SIGNATURE_BYTES 96
#define BLS_SCALE_AGGREGATE_BYTES (40 + 10 * BLS_SIGNATURE_BYTES)
#define BLS_SCALE_RESPONSE_BYTES 124
#define BLS_REGISTRATION_BYTES 162
#define BLS_MAX_DIRECT_CHILDREN 16
#define BLS_CBR1_MAX_BYTES 4608
#define BLS_CBR1_HEADER_BYTES 7
#define BLS_CBR1_PREFIX_BYTES \
    (BLS_CBR1_HEADER_BYTES + BLS_REGISTRATION_BYTES)
#define ECDSA_SCALE_REQUEST_BYTES 60
#define ECDSA_SCALE_RESPONSE_BYTES 116
#define OP_ECDSA_SCALE_SIGN_VALUE 0x44C0FFE6U
#define ECDSA_CERT_VERIFY_REQUEST_BYTES 4
#define ECDSA_CERT_VERIFY_RESPONSE_BYTES 24
#define OP_ECDSA_CERT_VERIFY_VALUE 0x44C0FFE7U

struct ioctl_data {
    unsigned int size;
    unsigned char *buf;
};

struct ecc_verify_data {
    unsigned int send_size;
    unsigned char *send_buf;
    unsigned int recv_size;
    unsigned char *recv_buf;
};

static int major;
static struct class *caliptra_class;
static struct cdev caliptra_cdev;

static int der_total_length(const uint8_t *der, size_t available,
                            size_t *total_length)
{
    size_t content_length;
    size_t header_length;

    if (der == NULL || total_length == NULL || available < 2 || der[0] != 0x30)
        return -EINVAL;

    if ((der[1] & 0x80) == 0) {
        header_length = 2;
        content_length = der[1];
    } else if (der[1] == 0x81 && available >= 3) {
        header_length = 3;
        content_length = der[2];
    } else if (der[1] == 0x82 && available >= 4) {
        header_length = 4;
        content_length = ((size_t)der[2] << 8) | der[3];
    } else {
        return -EINVAL;
    }

    if (header_length + content_length > available)
        return -ENOSPC;
    *total_length = header_length + content_length;
    return 0;
}

static int caliptra_open(struct inode *inode, struct file *file) {
    return 0;
}

static int caliptra_release(struct inode *inode, struct file *file) {
    return 0;
}

static ssize_t caliptra_read(struct file *filp, char __user *buf, size_t len, loff_t *off) {
    return 0;
}

static ssize_t caliptra_write(struct file *filp, const char __user *buf, size_t len, loff_t *off) {
    return len;
}

static long caliptra_ioctl(struct file *filp, unsigned int cmd, unsigned long arg)
{
    struct ioctl_data req;
    struct ecc_verify_data ecc_verify_req;
    struct parcel parcel = {0};
    uint32_t j = 0;
    uint8_t tx_buffer[4] = {0};
    uint8_t *ecc_verify_tx_buffer;
    uint8_t *rx_buffer;
    uint8_t *tx_ctx_buffer;
    int ret = 0;
    uint16_t content_len;
    int value;
    size_t response_len = 0;
    size_t mailbox_response_len;
    size_t request_len;

    switch (cmd) {
        case CALIP_TRNG_IOCTL_GEN:
            if (copy_from_user(&req, (struct ioctl_data __user *)arg, sizeof(req)))
                return -EFAULT;

            if (req.size == 0 || req.size > 4096)
                return -EINVAL;

            rx_buffer = kmalloc(req.size, GFP_KERNEL| __GFP_ZERO);
	    if (!rx_buffer) {
                return -ENOMEM;
	    }
	    
            if (memory_map_init(0x90000000, 0x100000) != 0) {
		kfree(rx_buffer);
       	        return -ENOMEM;
    	    }
       	    printk("req.size = 0x%x\n",req.size);
            
	    parcel.command = OP_GET_TRNG;
            parcel.tx_buffer = tx_buffer;
            parcel.tx_bytes = sizeof(tx_buffer);
            parcel.rx_buffer = rx_buffer;
            parcel.rx_bytes = req.size;

	    pack_and_execute_command(&parcel, false);
            udelay(1000);
            printk("random:\n");
            for(j = 0; j < parcel.rx_bytes; j++) {
                printk("0x%02x ", parcel.rx_buffer[j]);
                if (j % 16 == 15) {
                    printk("\n");
                }
            }

            if (copy_to_user(req.buf, parcel.rx_buffer, req.size)) {
                kfree(rx_buffer);
                return -EFAULT;
            }

            kfree(rx_buffer);
	    break;

	case CALIP_ECC_SIGH_IOCTL_GEN:
            if (copy_from_user(&req, (struct ioctl_data __user *)arg, sizeof(req)))
                return -EFAULT;

            if (req.size > 4096)
                return -EINVAL;

            rx_buffer = kmalloc(req.size, GFP_KERNEL| __GFP_ZERO);
            if (!rx_buffer) {
                return -ENOMEM;
            }

            if (memory_map_init(0x90000000, 0x100000) != 0) {
                kfree(rx_buffer);
                return -ENOMEM;
            }
            printk("req.size = 0x%x\n",req.size);
            
	    parcel.command = OP_ECC_SIGN;
            parcel.tx_buffer = tx_buffer;
            parcel.tx_bytes = sizeof(tx_buffer);
            parcel.rx_buffer = rx_buffer;
            parcel.rx_bytes = req.size;

            pack_and_execute_command(&parcel, false);
            udelay(1000);
            printk("recv:\n");
            for(j = 0; j < parcel.rx_bytes; j++) {
                printk("0x%02x ", parcel.rx_buffer[j]);
                if (j % 16 == 15) {
                    printk("\n");
                }
            }

            if (copy_to_user(req.buf, parcel.rx_buffer, req.size)) {
                kfree(rx_buffer);
                return -EFAULT;
            }

            kfree(rx_buffer);

	    break;

	case CALIP_ECC_VERIFY_IOCTL_GEN:
            if (copy_from_user(&ecc_verify_req, (struct ecc_verify_data __user *)arg, sizeof(ecc_verify_req)))
                return -EFAULT;

            if (ecc_verify_req.send_size > 4096)
                return -EINVAL;

            ecc_verify_tx_buffer = kmalloc(ecc_verify_req.send_size, GFP_KERNEL| __GFP_ZERO);
            if (!ecc_verify_tx_buffer) {
                return -ENOMEM;
            }

	    printk("111-ecc_verify_req.recv_size = 0x%x", ecc_verify_req.recv_size);
            rx_buffer = kmalloc(ecc_verify_req.recv_size, GFP_KERNEL| __GFP_ZERO);
            if (!rx_buffer) {
                return -ENOMEM;
            }

            if (memory_map_init(0x90000000, 0x100000) != 0) {
                kfree(ecc_verify_tx_buffer);
		kfree(rx_buffer);
                return -ENOMEM;
            }

            printk("ecc_verify_req.send_size = 0x%x\n",ecc_verify_req.send_size);
            printk("ecc_verify_req.recv_size = 0x%x\n",ecc_verify_req.recv_size);
            
	    //memcpy(ecc_verify_tx_buffer, ecc_verify_req.send_buf, ecc_verify_req.send_size);
	    if (copy_from_user(ecc_verify_tx_buffer, ecc_verify_req.send_buf, ecc_verify_req.send_size)) {
        	kfree(ecc_verify_tx_buffer);
        	kfree(rx_buffer);
        	return -EFAULT;
    	    }

	    parcel.command = OP_ECC_VERIFY;
            parcel.tx_buffer = ecc_verify_tx_buffer;
            parcel.tx_bytes = ecc_verify_req.send_size;
            parcel.rx_buffer = rx_buffer;
            parcel.rx_bytes = ecc_verify_req.recv_size;

            pack_and_execute_command(&parcel, false);
            udelay(10000);
            printk("recv:\n");
            for(j = 0; j < parcel.rx_bytes; j++) {
                printk("0x%02x ", parcel.rx_buffer[j]);
                if (j % 16 == 15) {
                    printk("\n");
                }
            }

	    if (copy_to_user(ecc_verify_req.recv_buf, parcel.rx_buffer, parcel.rx_bytes)) {
    		kfree(ecc_verify_tx_buffer);
    		kfree(rx_buffer);
    		return -EFAULT;
	    }

	    kfree(ecc_verify_tx_buffer);
            kfree(rx_buffer);

            break;

	case CALIP_GENERATE_2ND_CXT_IOCTL_GEN:
    	    if (copy_from_user(&req, (struct ioctl_data __user *)arg, sizeof(req)))
        	return -EFAULT;

	    if (req.size > 4096)
        	return -EINVAL;

    	    rx_buffer = kmalloc(req.size, GFP_KERNEL | __GFP_ZERO);
    	    if (!rx_buffer) {
        	return -ENOMEM;
    	    }

    	    if (memory_map_init(0x90000000, 0x100000) != 0) {
        	kfree(rx_buffer);
        	return -ENOMEM;
    	    }
    	    printk("user input size = 0x%x\n", req.size);

	    parcel.command = OP_GENERATE_2ND_CERT;
            parcel.tx_buffer = tx_buffer;
	    parcel.tx_bytes = sizeof(tx_buffer);
    	    parcel.rx_buffer = rx_buffer;
  	    parcel.rx_bytes = req.size;

	    ret = pack_and_execute_command(&parcel, false);
    	    udelay(1000);
	    if (ret != 0) {
		kfree(rx_buffer);
		return -EIO;
	    }

	    /* OP_GENERATE_2ND_CERT is the original TBS command.  Its response is
	     * plain DER; the CBR1 header and BLS registration are added later by
	     * rom_uart_send through the separate BLS-registration ioctl. */
	    mailbox_response_len = caliptra_mbox_last_response_size();
	    if (mailbox_response_len == 0 || mailbox_response_len > req.size) {
		printk("invalid L2 TBS response length: 0x%zx (capacity 0x%x)\n",
		       mailbox_response_len, req.size);
		kfree(rx_buffer);
		return -EPROTO;
	    }
	    if (der_total_length(parcel.rx_buffer, mailbox_response_len,
	                         &response_len) != 0 ||
	        response_len != mailbox_response_len) {
		printk("invalid L2 TBS DER response: mailbox=0x%zx der=0x%zx\n",
		       mailbox_response_len, response_len);
		kfree(rx_buffer);
		return -EPROTO;
	    }
	    value = response_len;

	    printk("tbs actual len = 0x%x\n", value);
	    printk("tbs data:\n");
	    for (j = 0; j < value; j++) {
        	printk("0x%02x ", parcel.rx_buffer[j]);
        	if (j % 16 == 15) {
            	    printk("\n");
                }
    	    }

	   parcel.rx_bytes = value;
	   req.size = value;

    	   if (copy_to_user(req.buf, parcel.rx_buffer, req.size)) {
           	kfree(rx_buffer);
           	return -EFAULT;
           }

    	   if (copy_to_user((struct ioctl_data __user *)arg, &req, sizeof(req))) {
        	kfree(rx_buffer);
        	return -EFAULT;
    	   }

    	   kfree(rx_buffer);
    	   break;

        case CALIP_SAVE_2ND_CTX_IOCTL_GEN:
            if (copy_from_user(&req, (struct ioctl_data __user *)arg, sizeof(req)))
                return -EFAULT;

            /* L2C1 adds a 53-byte authenticated parent-key header in front
             * of the DER certificate. */
            if (req.size == 0 || req.size > BLS_CBR1_MAX_BYTES)
                return -EINVAL;

            tx_ctx_buffer = kmalloc(req.size, GFP_KERNEL | __GFP_ZERO);
            if (!tx_ctx_buffer) {
                return -ENOMEM;
            }

            if (copy_from_user(tx_ctx_buffer, req.buf, req.size)) {
                kfree(tx_ctx_buffer);
                return -EFAULT;
            }

            rx_buffer = kmalloc(4096, GFP_KERNEL | __GFP_ZERO);
            if (!rx_buffer) {
                kfree(tx_ctx_buffer);
                return -ENOMEM;
            }

            if (memory_map_init(0x90000000, 0x100000) != 0) {
                kfree(tx_ctx_buffer);
                kfree(rx_buffer);
                return -ENOMEM;
            }

            printk("send ctx input size = 0x%x\n", req.size);

            parcel.command = OP_SAVE_2ND_CERT;
            parcel.tx_buffer = tx_ctx_buffer;
            parcel.tx_bytes = req.size;
            parcel.rx_buffer = rx_buffer;
            parcel.rx_bytes = sizeof(uint32_t);

            ret = pack_and_execute_command(&parcel, false);
            mailbox_response_len = caliptra_mbox_last_response_size();
            if (ret != 0 || mailbox_response_len != sizeof(uint32_t) ||
                *(uint32_t *)rx_buffer != MBOX_SUCCESS) {
                printk("save L2 cert mailbox failed: transport=%d dlen=0x%zx status=0x%08x\n",
                       ret, mailbox_response_len, *(uint32_t *)rx_buffer);
                kfree(tx_ctx_buffer);
                kfree(rx_buffer);
                return -EIO;
            }

            /* This is an input-only save operation.  Keep req.size equal to
             * the certificate length and do not overwrite the caller's DER
             * buffer with the firmware status word. */
            if (copy_to_user((struct ioctl_data __user *)arg, &req, sizeof(req))) {
                kfree(tx_ctx_buffer);
                kfree(rx_buffer);
                return -EFAULT;
            }

            kfree(tx_ctx_buffer);
            kfree(rx_buffer);
            break;

	case CALIP_SIGN_1ST_CTX_IOCTL_GEN:
    	    if (copy_from_user(&req, (struct ioctl_data __user *)arg, sizeof(req)))
        	return -EFAULT;
    	
	    if (req.size > 4096)
        	return -EINVAL;

   	    tx_ctx_buffer = kmalloc(req.size, GFP_KERNEL | __GFP_ZERO);
    	    if (!tx_ctx_buffer) {
        	return -ENOMEM;
    	    }
    	
	    if (copy_from_user(tx_ctx_buffer, req.buf, req.size)) {
        	kfree(tx_ctx_buffer);
        	return -EFAULT;
    	    }

    	    rx_buffer = kmalloc(4096, GFP_KERNEL | __GFP_ZERO);
    	    if (!rx_buffer) {
        	kfree(tx_ctx_buffer);
        	return -ENOMEM;
    	    }

    	    if (memory_map_init(0x90000000, 0x100000) != 0) {
        	kfree(tx_ctx_buffer);
        	kfree(rx_buffer);
        	return -ENOMEM;
    	    }

    	    printk("send ctx input size = 0x%x\n", req.size);

    	    parcel.command = OP_SIGN_1ST_CTX;
    	    parcel.tx_buffer = tx_ctx_buffer; 
    	    parcel.tx_bytes = req.size; 
    	    parcel.rx_buffer = rx_buffer; 
    	    parcel.rx_bytes = 4096; 

    	    pack_and_execute_command(&parcel, false);
    	    udelay(1000);

	    content_len = (parcel.rx_buffer[j+2] << 8) | parcel.rx_buffer[j+3];
            value = 4 + content_len;

            if (value > 4096) {
                printk("tbs too large: 0x%x > buffer 0x%x\n", value, req.size);
                kfree(rx_buffer);
                return -ENOSPC;
            }

	    printk("cert actual len = 0x%x\n", value);
            printk("cert data:\n");
            for (j = 0; j < value; j++) {
                printk("0x%02x ", parcel.rx_buffer[j]);
                if (j % 16 == 15) {
                    printk("\n");
                }
            }

           parcel.rx_bytes = value;
           req.size = value;

    	   if (copy_to_user(req.buf, rx_buffer, req.size)) {
        	kfree(tx_ctx_buffer);
        	kfree(rx_buffer);
        	return -EFAULT;
    	   }

           if (copy_to_user((struct ioctl_data __user *)arg, &req, sizeof(req))) {
                kfree(tx_ctx_buffer);
                kfree(rx_buffer);
                return -EFAULT;
           }

    	   kfree(tx_ctx_buffer);
    	   kfree(rx_buffer);
    	   break;

        /*
         * New CBR1 ABI.  Unlike CALIP_SIGN_1ST_CTX_IOCTL_GEN, this command
         * passes the complete CBR1 request to L2, so ROM validates the BLS
         * PoP and inserts the certificate binding before it signs.
         */
        case CALIP_BLS_SIGN_L1_CERT_IOCTL_GEN:
            if (copy_from_user(&req, (struct ioctl_data __user *)arg,
                               sizeof(req)))
                return -EFAULT;
            if (req.size < BLS_CBR1_PREFIX_BYTES || req.size > 4096)
                return -EINVAL;

            tx_ctx_buffer = kmalloc(req.size, GFP_KERNEL | __GFP_ZERO);
            if (!tx_ctx_buffer)
                return -ENOMEM;
            if (copy_from_user(tx_ctx_buffer, req.buf, req.size)) {
                kfree(tx_ctx_buffer);
                return -EFAULT;
            }
            if (memcmp(tx_ctx_buffer, "CBR1", 4) != 0 ||
                tx_ctx_buffer[4] != 1) {
                kfree(tx_ctx_buffer);
                return -EINVAL;
            }
            request_len = BLS_CBR1_PREFIX_BYTES +
                          ((size_t)tx_ctx_buffer[5] << 8) +
                          tx_ctx_buffer[6];
            if (request_len <= BLS_CBR1_PREFIX_BYTES ||
                request_len > req.size || request_len > 4096) {
                kfree(tx_ctx_buffer);
                return -EINVAL;
            }
            printk("BLS L1 CBR1 ioctl size=0x%x mailbox dlen=0x%zx\n",
                   req.size, request_len);

            rx_buffer = kmalloc(4096, GFP_KERNEL | __GFP_ZERO);
            if (!rx_buffer) {
                kfree(tx_ctx_buffer);
                return -ENOMEM;
            }
            if (memory_map_init(0x90000000, 0x100000) != 0) {
                kfree(tx_ctx_buffer);
                kfree(rx_buffer);
                return -ENOMEM;
            }

            parcel.command = OP_BLS_SIGN_L1_CERT;
            parcel.tx_buffer = tx_ctx_buffer;
            parcel.tx_bytes = request_len;
            parcel.rx_buffer = rx_buffer;
            parcel.rx_bytes = 4096;
            ret = pack_and_execute_command(&parcel, false);
            if (ret != 0) {
                kfree(tx_ctx_buffer);
                kfree(rx_buffer);
                return -EIO;
            }

            mailbox_response_len = caliptra_mbox_last_response_size();
            if (mailbox_response_len == sizeof(uint32_t)) {
                printk("BLS L1 certificate request rejected: status=0x%08x\n",
                       *(uint32_t *)rx_buffer);
                req.size = sizeof(uint32_t);
                if (copy_to_user(req.buf, rx_buffer, req.size) ||
                    copy_to_user((struct ioctl_data __user *)arg, &req,
                                 sizeof(req))) {
                    kfree(tx_ctx_buffer);
                    kfree(rx_buffer);
                    return -EFAULT;
                }
                kfree(tx_ctx_buffer);
                kfree(rx_buffer);
                return -EIO;
            }
            if (mailbox_response_len == 0 || mailbox_response_len > 4096 ||
                der_total_length(rx_buffer, mailbox_response_len,
                                 &response_len) != 0 ||
                response_len != mailbox_response_len) {
                kfree(tx_ctx_buffer);
                kfree(rx_buffer);
                return -EPROTO;
            }
            /*
             * The caller of this new ioctl must provide a 4096-byte output
             * buffer.  The input CBR1 length is deliberately not reused as a
             * certificate capacity.
             */
            req.size = response_len;
            if (copy_to_user(req.buf, rx_buffer, req.size) ||
                copy_to_user((struct ioctl_data __user *)arg, &req,
                             sizeof(req))) {
                kfree(tx_ctx_buffer);
                kfree(rx_buffer);
                return -EFAULT;
            }
            kfree(tx_ctx_buffer);
            kfree(rx_buffer);
            break;

        /*
         * A L2 coordinator sends the canonical 32-byte challenge digest
         * followed by one 96-byte signature for each participating L1.  The
         * L2 ROM adds its own signature and returns one aggregate signature.
         */
        case CALIP_BLS_AGGREGATE_CHALLENGE_IOCTL_GEN:
            if (copy_from_user(&req, (struct ioctl_data __user *)arg,
                               sizeof(req)))
                return -EFAULT;
            if (req.size != BLS_SCALE_AGGREGATE_BYTES &&
                (req.size < BLS_CHALLENGE_BYTES ||
                 ((req.size - BLS_CHALLENGE_BYTES) % BLS_SIGNATURE_BYTES) != 0 ||
                 (req.size - BLS_CHALLENGE_BYTES) / BLS_SIGNATURE_BYTES >
                     BLS_MAX_DIRECT_CHILDREN ||
                 req.size > 4096))
                return -EINVAL;
            response_len = req.size == BLS_SCALE_AGGREGATE_BYTES ?
                               BLS_SCALE_RESPONSE_BYTES : BLS_SIGNATURE_BYTES;

            tx_ctx_buffer = kmalloc(req.size, GFP_KERNEL | __GFP_ZERO);
            if (!tx_ctx_buffer)
                return -ENOMEM;
            if (copy_from_user(tx_ctx_buffer, req.buf, req.size)) {
                kfree(tx_ctx_buffer);
                return -EFAULT;
            }
            if (req.size == BLS_SCALE_AGGREGATE_BYTES &&
                memcmp(tx_ctx_buffer, "SCA2", 4) != 0) {
                kfree(tx_ctx_buffer);
                return -EINVAL;
            }
            rx_buffer = kmalloc(response_len, GFP_KERNEL | __GFP_ZERO);
            if (!rx_buffer) {
                kfree(tx_ctx_buffer);
                return -ENOMEM;
            }
            if (memory_map_init(0x90000000, 0x100000) != 0) {
                kfree(tx_ctx_buffer);
                kfree(rx_buffer);
                return -ENOMEM;
            }

            parcel.command = OP_BLS_AGGREGATE_CHALLENGE;
            parcel.tx_buffer = tx_ctx_buffer;
            parcel.tx_bytes = req.size;
            parcel.rx_buffer = rx_buffer;
            parcel.rx_bytes = response_len;
            ret = pack_and_execute_command(&parcel, false);
            mailbox_response_len = caliptra_mbox_last_response_size();
            if (ret != 0 || mailbox_response_len != response_len) {
                if (mailbox_response_len == sizeof(uint32_t))
                    printk("L2 BLS aggregate rejected: transport=%d status=0x%08x\n",
                           ret, *(uint32_t *)rx_buffer);
                else
                    printk("L2 BLS aggregate failed: transport=%d len=0x%x\n",
                           ret, mailbox_response_len);
                kfree(tx_ctx_buffer);
                kfree(rx_buffer);
                return -EIO;
            }

            req.size = response_len;
            if (copy_to_user(req.buf, rx_buffer, req.size) ||
                copy_to_user((struct ioctl_data __user *)arg, &req,
                             sizeof(req))) {
                kfree(tx_ctx_buffer);
                kfree(rx_buffer);
                return -EFAULT;
            }
            kfree(tx_ctx_buffer);
            kfree(rx_buffer);
            break;

        case CALIP_ECDSA_SCALE_SIGN_IOCTL_GEN:
            if (copy_from_user(&req, (struct ioctl_data __user *)arg,
                               sizeof(req)))
                return -EFAULT;
            if (req.size != ECDSA_SCALE_REQUEST_BYTES)
                return -EINVAL;
            tx_ctx_buffer = kmalloc(ECDSA_SCALE_REQUEST_BYTES,
                                    GFP_KERNEL | __GFP_ZERO);
            if (!tx_ctx_buffer)
                return -ENOMEM;
            if (copy_from_user(tx_ctx_buffer, req.buf,
                               ECDSA_SCALE_REQUEST_BYTES)) {
                kfree(tx_ctx_buffer);
                return -EFAULT;
            }
            if (memcmp(tx_ctx_buffer, "ECS1", 4) != 0 ||
                tx_ctx_buffer[4] != 0 || tx_ctx_buffer[5] != 0 ||
                tx_ctx_buffer[6] != 0 || tx_ctx_buffer[7] != 2) {
                kfree(tx_ctx_buffer);
                return -EINVAL;
            }
            rx_buffer = kmalloc(ECDSA_SCALE_RESPONSE_BYTES,
                                GFP_KERNEL | __GFP_ZERO);
            if (!rx_buffer) {
                kfree(tx_ctx_buffer);
                return -ENOMEM;
            }
            if (memory_map_init(0x90000000, 0x100000) != 0) {
                kfree(tx_ctx_buffer);
                kfree(rx_buffer);
                return -ENOMEM;
            }
            parcel.command =
                (enum mailbox_command)OP_ECDSA_SCALE_SIGN_VALUE;
            parcel.tx_buffer = tx_ctx_buffer;
            parcel.tx_bytes = ECDSA_SCALE_REQUEST_BYTES;
            parcel.rx_buffer = rx_buffer;
            parcel.rx_bytes = ECDSA_SCALE_RESPONSE_BYTES;
            ret = pack_and_execute_command(&parcel, false);
            mailbox_response_len = caliptra_mbox_last_response_size();
            memory_map_cleanup();
            if (ret != 0 ||
                mailbox_response_len != ECDSA_SCALE_RESPONSE_BYTES ||
                memcmp(rx_buffer, "ECR1", 4) != 0) {
                printk("L2 ECDSA scale sign failed: transport=%d len=0x%x\n",
                       ret, mailbox_response_len);
                kfree(tx_ctx_buffer);
                kfree(rx_buffer);
                return -EIO;
            }
            req.size = ECDSA_SCALE_RESPONSE_BYTES;
            if (copy_to_user(req.buf, rx_buffer, req.size) ||
                copy_to_user((struct ioctl_data __user *)arg, &req,
                             sizeof(req))) {
                kfree(tx_ctx_buffer);
                kfree(rx_buffer);
                return -EFAULT;
            }
            kfree(tx_ctx_buffer);
            kfree(rx_buffer);
            break;

        case CALIP_ECDSA_CERT_VERIFY_IOCTL_GEN:
            if (copy_from_user(&req, (struct ioctl_data __user *)arg,
                               sizeof(req)))
                return -EFAULT;
            if (req.size != ECDSA_CERT_VERIFY_REQUEST_BYTES)
                return -EINVAL;
            tx_ctx_buffer = kmalloc(ECDSA_CERT_VERIFY_REQUEST_BYTES,
                                    GFP_KERNEL | __GFP_ZERO);
            if (!tx_ctx_buffer)
                return -ENOMEM;
            if (copy_from_user(tx_ctx_buffer, req.buf,
                               ECDSA_CERT_VERIFY_REQUEST_BYTES)) {
                kfree(tx_ctx_buffer);
                return -EFAULT;
            }
            rx_buffer = kmalloc(ECDSA_CERT_VERIFY_RESPONSE_BYTES,
                                GFP_KERNEL | __GFP_ZERO);
            if (!rx_buffer) {
                kfree(tx_ctx_buffer);
                return -ENOMEM;
            }
            if (memory_map_init(0x90000000, 0x100000) != 0) {
                kfree(tx_ctx_buffer);
                kfree(rx_buffer);
                return -ENOMEM;
            }
            parcel.command =
                (enum mailbox_command)OP_ECDSA_CERT_VERIFY_VALUE;
            parcel.tx_buffer = tx_ctx_buffer;
            parcel.tx_bytes = ECDSA_CERT_VERIFY_REQUEST_BYTES;
            parcel.rx_buffer = rx_buffer;
            parcel.rx_bytes = ECDSA_CERT_VERIFY_RESPONSE_BYTES;
            ret = pack_and_execute_command(&parcel, false);
            mailbox_response_len = caliptra_mbox_last_response_size();
            memory_map_cleanup();
            if (ret != 0 ||
                mailbox_response_len != ECDSA_CERT_VERIFY_RESPONSE_BYTES ||
                memcmp(rx_buffer, "EVR2", 4) != 0) {
                printk("L2 ECDSA certificate verify failed: transport=%d len=0x%x\n",
                       ret, mailbox_response_len);
                kfree(tx_ctx_buffer);
                kfree(rx_buffer);
                return -EIO;
            }
            req.size = ECDSA_CERT_VERIFY_RESPONSE_BYTES;
            if (copy_to_user(req.buf, rx_buffer, req.size) ||
                copy_to_user((struct ioctl_data __user *)arg, &req,
                             sizeof(req))) {
                kfree(tx_ctx_buffer);
                kfree(rx_buffer);
                return -EFAULT;
            }
            kfree(tx_ctx_buffer);
            kfree(rx_buffer);
            break;

        case CALIP_BLS_REGISTER_L1_IOCTL_GEN:
            if (copy_from_user(&req, (struct ioctl_data __user *)arg,
                               sizeof(req)))
                return -EFAULT;
            if (req.size != BLS_REGISTRATION_BYTES)
                return -EINVAL;

            tx_ctx_buffer = kmalloc(BLS_REGISTRATION_BYTES,
                                    GFP_KERNEL | __GFP_ZERO);
            if (!tx_ctx_buffer)
                return -ENOMEM;
            if (copy_from_user(tx_ctx_buffer, req.buf,
                               BLS_REGISTRATION_BYTES)) {
                kfree(tx_ctx_buffer);
                return -EFAULT;
            }
            rx_buffer = kmalloc(sizeof(uint32_t), GFP_KERNEL | __GFP_ZERO);
            if (!rx_buffer) {
                kfree(tx_ctx_buffer);
                return -ENOMEM;
            }
            if (memory_map_init(0x90000000, 0x100000) != 0) {
                kfree(tx_ctx_buffer);
                kfree(rx_buffer);
                return -ENOMEM;
            }

            parcel.command = OP_BLS_REGISTER_L1;
            parcel.tx_buffer = tx_ctx_buffer;
            parcel.tx_bytes = BLS_REGISTRATION_BYTES;
            parcel.rx_buffer = rx_buffer;
            parcel.rx_bytes = sizeof(uint32_t);
            ret = pack_and_execute_command(&parcel, false);
            mailbox_response_len = caliptra_mbox_last_response_size();
            if (ret != 0 || mailbox_response_len != sizeof(uint32_t)) {
                printk("L1 BLS registration mailbox failed: transport=%d len=0x%x\n",
                       ret, mailbox_response_len);
                kfree(tx_ctx_buffer);
                kfree(rx_buffer);
                return -EIO;
            }

            req.size = sizeof(uint32_t);
            if (copy_to_user(req.buf, rx_buffer, req.size) ||
                copy_to_user((struct ioctl_data __user *)arg, &req,
                             sizeof(req))) {
                kfree(tx_ctx_buffer);
                kfree(rx_buffer);
                return -EFAULT;
            }
            if (*(uint32_t *)rx_buffer != MBOX_SUCCESS) {
                printk("L2 rejected L1 BLS registration: status=0x%08x\n",
                       *(uint32_t *)rx_buffer);
                kfree(tx_ctx_buffer);
                kfree(rx_buffer);
                return -EIO;
            }
            kfree(tx_ctx_buffer);
            kfree(rx_buffer);
            break;

	case CALIP_BLS_GET_L2_REGISTRATION_IOCTL_GEN:
            if (copy_from_user(&req, (struct ioctl_data __user *)arg,
                               sizeof(req)))
                return -EFAULT;
            if (req.size < BLS_REGISTRATION_BYTES || req.size > 4096)
                return -EINVAL;

            rx_buffer = kmalloc(BLS_REGISTRATION_BYTES,
                                GFP_KERNEL | __GFP_ZERO);
            if (!rx_buffer)
                return -ENOMEM;
            if (memory_map_init(0x90000000, 0x100000) != 0) {
                kfree(rx_buffer);
                return -ENOMEM;
            }

            parcel.command = OP_BLS_GET_REGISTRATION;
            parcel.tx_buffer = tx_buffer;
            parcel.tx_bytes = 0;
            parcel.rx_buffer = rx_buffer;
            parcel.rx_bytes = BLS_REGISTRATION_BYTES;
            ret = pack_and_execute_command(&parcel, false);
            if (ret != 0 ||
                caliptra_mbox_last_response_size() !=
                    BLS_REGISTRATION_BYTES) {
                kfree(rx_buffer);
                return -EIO;
            }

            req.size = BLS_REGISTRATION_BYTES;
            if (copy_to_user(req.buf, rx_buffer, req.size) ||
                copy_to_user((struct ioctl_data __user *)arg, &req,
                             sizeof(req))) {
                kfree(rx_buffer);
                return -EFAULT;
            }
            kfree(rx_buffer);
            break;

	case CALIP_GET_2ND_CTX_IOCTL_GEN:
            if (copy_from_user(&req, (struct ioctl_data __user *)arg, sizeof(req)))
                return -EFAULT;

            if (req.size < 4 || req.size > 4096)
                return -EINVAL;

            rx_buffer = kmalloc(req.size, GFP_KERNEL | __GFP_ZERO);
            if (!rx_buffer) {
                return -ENOMEM;
            }

            if (memory_map_init(0x90000000, 0x100000) != 0) {
                kfree(rx_buffer);
                return -ENOMEM;
            }
            printk("user input size = 0x%x\n", req.size);

            parcel.command = OP_GET_2ND_CERT;
            parcel.tx_buffer = tx_buffer;
            parcel.tx_bytes = 0;
            parcel.rx_buffer = rx_buffer;
            parcel.rx_bytes = req.size;

            ret = pack_and_execute_command(&parcel, false);
            if (ret != 0) {
                kfree(rx_buffer);
                return -EIO;
            }

            mailbox_response_len = caliptra_mbox_last_response_size();
            if (mailbox_response_len == 0 ||
                mailbox_response_len > req.size ||
                der_total_length(rx_buffer, mailbox_response_len,
                                 &response_len) != 0 ||
                response_len != mailbox_response_len) {
                kfree(rx_buffer);
                return -EPROTO;
            }

            printk("cert actual len = 0x%zx\n", response_len);
            printk("cert data:\n");
            for (j = 0; j < response_len; j++) {
                printk("0x%02x ", parcel.rx_buffer[j]);
                if (j % 16 == 15) {
                    printk("\n");
                }
            }

           parcel.rx_bytes = response_len;
           req.size = response_len;

           if (copy_to_user(req.buf, parcel.rx_buffer, req.size)) {
                kfree(rx_buffer);
                return -EFAULT;
           }

           if (copy_to_user((struct ioctl_data __user *)arg, &req, sizeof(req))) {
                kfree(rx_buffer);
                return -EFAULT;
           }

           kfree(rx_buffer);
           break;

        case CALIP_VERIFY_1ST_CTX_IOCTL_GEN:
           if (copy_from_user(&req, (struct ioctl_data __user *)arg, sizeof(req)))
               return -EFAULT;

           if (req.size > 4096)
               return -EINVAL;

           tx_ctx_buffer = kmalloc(req.size, GFP_KERNEL | __GFP_ZERO);
           if (!tx_ctx_buffer) {
               return -ENOMEM;
           }

           if (copy_from_user(tx_ctx_buffer, req.buf, req.size)) {
               kfree(tx_ctx_buffer);
               return -EFAULT;
           }

           rx_buffer = kmalloc(4096, GFP_KERNEL | __GFP_ZERO);
           if (!rx_buffer) {
               kfree(tx_ctx_buffer);
               return -ENOMEM;
           }

           if (memory_map_init(0x90000000, 0x100000) != 0) {
               kfree(tx_ctx_buffer);
               kfree(rx_buffer);
               return -ENOMEM;
           }

           printk("send ctx input size = 0x%x\n", req.size);

           parcel.command = OP_VERIFY_1ST_CTX;
           parcel.tx_buffer = tx_ctx_buffer;
           parcel.tx_bytes = req.size;
           parcel.rx_buffer = rx_buffer;
           parcel.rx_bytes = 0x4;

	   pack_and_execute_command(&parcel, false);
           udelay(1000);
           
	    if (parcel.rx_bytes > 0) {
        	printk("received data: 0x%02x, 0x%02x, 0x%02x, 0x%02x\n", parcel.rx_buffer[0], parcel.rx_buffer[1], parcel.rx_buffer[2], parcel.rx_buffer[3]);
    	    } else {
        	printk("no data received!\n");
   	    }

	   req.size = parcel.rx_bytes;

    	   if (copy_to_user(req.buf, parcel.rx_buffer, req.size)) {
               kfree(tx_ctx_buffer);
               kfree(rx_buffer);
               return -EFAULT;
    	   }

           if (copy_to_user((struct ioctl_data __user *)arg, &req, sizeof(req))) {
        	kfree(tx_ctx_buffer);
         	kfree(rx_buffer);
        	return -EFAULT;
    	   }


	   kfree(tx_ctx_buffer);
           kfree(rx_buffer);
	   break;

	default:
           return -ENOTTY;
    }

    memory_map_cleanup();
    return ret;
}

static struct file_operations fops = {
    .owner = THIS_MODULE,
    .open = caliptra_open,
    .release = caliptra_release,
    .write = caliptra_write,
    .read = caliptra_read,
    .unlocked_ioctl = caliptra_ioctl,
};

static int __init caliptra_init(void) {
    dev_t dev;
    int ret = 0;

    printk(KERN_EMERG "--- CALIPTRA DRIVER INIT START ---\n");

    if ((ret = alloc_chrdev_region(&dev, 0, 1, DEVICE_NAME))) {
        printk(KERN_ERR "Caliptra: Failed to allocate device number. Error code: %d\n", ret);
        return ret;
    }
    major = MAJOR(dev);
    printk(KERN_INFO "Caliptra: Allocated major number %d\n", major);

    caliptra_class = class_create(THIS_MODULE, "caliptra");
    if (IS_ERR(caliptra_class)) {
        ret = PTR_ERR(caliptra_class);
        printk(KERN_ERR "Caliptra: Failed to create device class. Error code: %d\n", ret);
        goto fail_class;
    }
    printk(KERN_INFO "Caliptra: Device class created successfully.\n");

    if (IS_ERR(device_create(caliptra_class, NULL, dev, NULL, DEVICE_NAME))) {
        ret = PTR_ERR(device_create(caliptra_class, NULL, dev, NULL, DEVICE_NAME));
        printk(KERN_ERR "Caliptra: Failed to create device node. Error code: %d\n", ret);
        goto fail_device;
    }
    printk(KERN_INFO "Caliptra: Device node created successfully.\n");

    cdev_init(&caliptra_cdev, &fops);
    if ((ret = cdev_add(&caliptra_cdev, dev, 1))) {
        printk(KERN_ERR "Caliptra: Failed to add cdev. Error code: %d\n", ret);
        goto fail_cdev;
    }
    printk(KERN_INFO "Caliptra: Character device added successfully.\n");

    printk(KERN_EMERG "CALIPTRA INIT COMPLETE (major=%d)\n", major);
    return 0;

fail_cdev:
    device_destroy(caliptra_class, dev);
fail_device:
    class_destroy(caliptra_class);
fail_class:
    unregister_chrdev_region(dev, 1);
    return ret;
}

static void __exit caliptra_exit(void) {
    device_destroy(caliptra_class,  MKDEV(major, 0));
    class_destroy(caliptra_class);
    cdev_del(&caliptra_cdev);
    unregister_chrdev_region(major, 1);
    printk("Caliptra device removed\n");
}

module_init(caliptra_init);
module_exit(caliptra_exit);

MODULE_LICENSE("GPL");
MODULE_AUTHOR("caliptraIO");
MODULE_DESCRIPTION("Caliptra IO Device Driver");
