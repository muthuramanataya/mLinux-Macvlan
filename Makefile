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

ifeq ($(TARGET),debug)
EXTRA_CFLAGS += -DATAYA_MACVLAN_DBG
endif

obj-m += macvlan.o

all:
	@echo "KERNEL_DIR: $(KDIR)"
	$(MAKE) -C $(KDIR) M=$(PWD) modules

clean:
	$(MAKE) -C $(KDIR) M=$(PWD) clean
	rm -f macvlan.ko

install:
ifneq (,$(wildcard ./macvlan.ko))
ifneq ("$(wildcard  $(MACVLAN_DIR)/orig-macvlan.ko)","")
	echo "Original macvlan exists and skipped!!!"
else
	mv $(MACVLAN_DIR)/macvlan.ko $(MACVLAN_DIR)/orig-macvlan.ko || echo "OK!"
endif
	rmmod macvlan || echo "OK!"
	cp macvlan.ko $(MACVLAN_DIR)/
	modprobe macvlan
	sed -zi "s/macvlan\n//g" /etc/modules
	echo "macvlan" >> /etc/modules
endif

update:
ifneq (,$(wildcard ./macvlan.ko))
ifeq ("$(wildcard  $(MACVLAN_DIR)/orig-macvlan.ko)","")
	echo "Original macvlan doesn't exists and skipped!!!"
else
	rmmod macvlan || echo "OK!"
	rm -f $(MACVLAN_DIR)/macvlan.ko
	cp macvlan.ko $(MACVLAN_DIR)/
	modprobe macvlan
	sed -zi "s/macvlan\n//g" /etc/modules
	echo "macvlan" >> /etc/modules
endif
endif
	
uninstall:
ifneq ("$(wildcard  $(MACVLAN_DIR)/orig-macvlan.ko)","")
	echo "Original macvlan exists and restored!!!"
	rmmod macvlan || echo "OK!"
	rm -f $(MACVLAN_DIR)/macvlan.ko
	mv $(MACVLAN_DIR)/orig-macvlan.ko $(MACVLAN_DIR)/macvlan.ko
	sed -zi "s/macvlan\n//g" /etc/modules
endif
