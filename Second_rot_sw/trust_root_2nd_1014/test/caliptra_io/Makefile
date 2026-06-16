obj-m := caliptra_dev.o
caliptra_dev-y := caliptra_io.o mailbox.o mem_utils.o

KDIR := /lib/modules/$(shell uname -r)/build
PWD := $(shell pwd)

all:
	$(MAKE) -C $(KDIR) M=$(PWD) modules

clean:
	$(MAKE) -C $(KDIR) M=$(PWD) clean
