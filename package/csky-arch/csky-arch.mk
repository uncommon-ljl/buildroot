###############################################################################
#
# csky arch
#
################################################################################

CSKY_ARCH_VERSION_4_9  = e68b1635ac2711d5fc939bce66318aa118c9484a 
CSKY_ARCH_VERSION_4_14 = 512d273739f3746734861f19f038439f685dfdd0
CSKY_ARCH_VERSION_4_19 = 00385fad53fa4d77aabb783b07e873d86a9a4ecc

CSKY_ARCH_VERSION = none


ifneq ($(findstring y,$(BR2_PACKAGE_HOST_LINUX_HEADERS_CUSTOM_4_9) $(BR2_TOOLCHAIN_EXTERNAL_HEADERS_4_9)),)
CSKY_ARCH_VERSION = $(CSKY_ARCH_VERSION_4_9)
endif

ifneq ($(findstring y,$(BR2_PACKAGE_HOST_LINUX_HEADERS_CUSTOM_4_14) $(BR2_TOOLCHAIN_EXTERNAL_HEADERS_4_14)),)
CSKY_ARCH_VERSION = $(CSKY_ARCH_VERSION_4_14)
endif

ifneq ($(findstring y,$(BR2_PACKAGE_HOST_LINUX_HEADERS_CUSTOM_4_19) $(BR2_TOOLCHAIN_EXTERNAL_HEADERS_4_19)),)
CSKY_ARCH_VERSION = $(CSKY_ARCH_VERSION_4_19)
endif

ifneq ($(CSKY_ARCH_VERSION), none)
CSKY_ARCH_SITE = $(call github,c-sky,csky-linux,$(CSKY_ARCH_VERSION))

define CSKY_ARCH_PREPARE_KERNEL
	cd $(CSKY_ARCH_DIR)/; bash merge.sh $(LINUX_DIR); cd -;
	echo "CFLAGS_cpu-probe.o := -DCSKY_ARCH_VERSION=\"\\\"$(CSKY_ARCH_VERSION)\\\"\"" >> $(LINUX_DIR)/arch/csky/kernel/Makefile;
endef
LINUX_POST_PATCH_HOOKS += CSKY_ARCH_PREPARE_KERNEL

# Prepare linux headers
ifeq ($(BR2_PACKAGE_LINUX_HEADERS), y)
LINUX_HEADERS_DEPENDENCIES += csky-arch
define LINUX_HEADERS_CSKY_ARCH
	cp $(CSKY_ARCH_DIR)/arch/csky $(LINUX_HEADERS_DIR)/arch -raf
endef
LINUX_HEADERS_POST_PATCH_HOOKS += LINUX_HEADERS_CSKY_ARCH
endif

$(eval $(generic-package))
endif
