MAKE := make -w
PWD := $(shell pwd)

#CROSS_COMPILE=/opt/arm-linux-gnueabihf-4.7/bin/arm-linux-gnueabihf-
HOST := arm-linux-gnueabihf
CC := $(CROSS_COMPILE)gcc

OUT := $(PWD)/out

LIBNL_DIR = $(PWD)/libnl-3.5.0
OPENSSL_DIR = $(PWD)/openssl-1.1.1g
WPA_SUPPLICANT_DIR = $(PWD)/wpa_supplicant-2.9/wpa_supplicant

all:libnl openssl wpa_supplicant

wpa_supplicant:
#	cp -rf $(WPA_SUPPLICANT_DIR)/defconfig $(WPA_SUPPLICANT_DIR)/.config
	$(MAKE) -C $(WPA_SUPPLICANT_DIR) CC=$(CC) CFLAGS+='-static' LDFLAGS+='-static'
	cp -rf $(WPA_SUPPLICANT_DIR)/wpa_cli $(WPA_SUPPLICANT_DIR)/wpa_supplicant $(WPA_SUPPLICANT_DIR)/wpa_passphrase $(OUT)

openssl:
	cd $(OPENSSL_DIR) && ./config no-asm --prefix=$(OUT)/usr --cross-compile-prefix=$(CROSS_COMPILE)
	$(MAKE) -C $(OPENSSL_DIR) CC=$(CC)
	$(MAKE) -C $(OPENSSL_DIR) install
#	cp -rf libcrypto.a libssl.a $(OUT)/usr/lib

libnl:
	cd $(LIBNL_DIR) && ./configure CC=$(CC) --prefix=$(OUT)/usr --host=$(HOST)
	$(MAKE) -C $(LIBNL_DIR) CC=$(CC)
	$(MAKE) -C $(LIBNL_DIR) install


clean:clean_libnl clean_openssl clean_wpa
	rm -rf $(OUT)

clean_wpa:
	make -C $(WPA_SUPPLICANT_DIR) clean

clean_openssl:
	make -C $(OPENSSL_DIR) clean

clean_libnl:
	make -C $(LIBNL_DIR) clean
