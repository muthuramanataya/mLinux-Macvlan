# SPDX-License-Identifier: GPL-2.0-or-later
#
# Makefile for the Macvlan device drivers.
#
# 11 Nov 2003, Muthuraman Elangovan <muthuraman@ataya.io>
#
KVERSION := $(shell uname -r)
KERNEL_DIR := /usr/src/linux-headers-$(KVERSION)
KDIR := /lib/modules/$(KVERSION)/build

INCLUDEDIR = $(KERNEL_DIR)/include

EXTRA_CFLAGS += -I $(KERNEL_DIR)
EXTRA_CFLAGS += -I $(INCLUDEDIR)
EXTRA_CFLAGS += -DDEBUG -g

obj-m += macvlan.o

all:
	@echo "KERNEL_DIR: $(KDIR)"
	$(MAKE) -C $(KDIR) M=$(PWD) modules

clean:
	$(MAKE) -C $(KDIR) M=$(PWD) clean
	rm -f macvlan.ko
