# SPDX-License-Identifier: GPL-2.0-or-later
#
# Makefile for the Macvlan device drivers.
#
# 11 Nov 2003, Muthuraman Elangovan <muthuraman@ataya.io>
#
KVERSION := $(shell uname -r)
KERNEL_DIR := /usr/src/linux-headers-$(KVERSION)
KDIR := /lib/modules/$(KVERSION)/build
MACVLAN_DIR := /usr/lib/modules/$(KVERSION)/kernel/drivers/net

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

install:
	mv $(MACVLAN_DIR)/macvlan.ko $(MACVLAN_DIR)/orig-macvlan.ko || echo "OK!"
	rmmod macvlan || echo "OK!"
	cp macvlan.ko $(MACVLAN_DIR)/
	modprobe macvlan
	echo "macvlan" >> /etc/modules

update:
	rmmod macvlan || echo "OK!"
	rm -f $(MACVLAN_DIR)/macvlan.ko
	cp macvlan.ko $(MACVLAN_DIR)/
	modprobe macvlan
	
uninstall:
	rmmod macvlan || echo "OK!"
	rm -f $(MACVLAN_DIR)/macvlan.ko
	sed -zi "s/macvlan\n//g" /etc/modules
	mv $(MACVLAN_DIR)/orig-macvlan.ko $(MACVLAN_DIR)/macvlan.ko || echo "OK!"
