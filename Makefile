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
	if [ -f macvlan.ko ]; then \
		if [ -f $(MACVLAN_DIR)/orig-macvlan.ko ]; then \
			echo "Original macvlan exists and skipped";\
		else \
			mv $(MACVLAN_DIR)/macvlan.ko $(MACVLAN_DIR)/orig-macvlan.ko || echo "OK!"; \
		fi
		rmmod macvlan || echo "OK!"
		cp macvlan.ko $(MACVLAN_DIR)/; \
		modprobe macvlan; \
		sed -zi "s/macvlan\n//g" /etc/modules
		echo "macvlan" >> /etc/modules; \
	fi

update:
	if [ -f macvlan.ko ]; then \
		rmmod macvlan || echo "OK!"; \
		rm -f $(MACVLAN_DIR)/macvlan.ko; \
		cp macvlan.ko $(MACVLAN_DIR)/; \
		modprobe macvlan; \
	fi
	
uninstall:
	rmmod macvlan || echo "OK!"
	if [ -f $(MACVLAN_DIR)/orig-macvlan.ko ]; then	\
        echo "Original macvlan exists and restored";\
		rm -f $(MACVLAN_DIR)/macvlan.ko;\
		mv $(MACVLAN_DIR)/orig-macvlan.ko $(MACVLAN_DIR)/macvlan.ko;\
	fi
	sed -zi "s/macvlan\n//g" /etc/modules
