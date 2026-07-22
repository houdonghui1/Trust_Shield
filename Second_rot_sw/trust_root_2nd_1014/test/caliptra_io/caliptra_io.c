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

    switch (cmd) {
        case CALIP_TRNG_IOCTL_GEN:
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

    	    pack_and_execute_command(&parcel, false);
    	    udelay(1000);

    	    if (parcel.rx_buffer[0] != 0x30 || parcel.rx_buffer[1] != 0x82) {
                printk("invalid TBS DER header\n");
        	kfree(rx_buffer);
        	return -EPROTO;
    	    }


    	    content_len = (parcel.rx_buffer[j+2] << 8) | parcel.rx_buffer[j+3];
            value = 4 + content_len;

    	    if (value > req.size) {
        	printk("tbs too large: 0x%x > buffer 0x%x\n", value, req.size);
        	kfree(rx_buffer);
        	return -ENOSPC;
    	    }

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

            parcel.command = OP_SAVE_2ND_CERT;
            parcel.tx_buffer = tx_ctx_buffer;
            parcel.tx_bytes = req.size;
            parcel.rx_buffer = rx_buffer;
            parcel.rx_bytes = 0x1;

            pack_and_execute_command(&parcel, false);
            udelay(1000);

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

	case CALIP_GET_2ND_CTX_IOCTL_GEN:
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

            parcel.command = OP_GET_2ND_CERT;
            parcel.tx_buffer = tx_buffer;
            parcel.tx_bytes = sizeof(tx_buffer);
            parcel.rx_buffer = rx_buffer;
            parcel.rx_bytes = req.size;

            pack_and_execute_command(&parcel, false);
            udelay(1000);

            if (parcel.rx_buffer[0] != 0x30 || parcel.rx_buffer[1] != 0x82) {
                printk("invalid cert header\n");
                kfree(rx_buffer);
                return -EPROTO;
            }


            content_len = (parcel.rx_buffer[j+2] << 8) | parcel.rx_buffer[j+3];
            value = 4 + content_len;

            if (value > req.size) {
                printk("cert too large: 0x%x > buffer 0x%x\n", value, req.size);
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
