LOCAL_PATH:= $(call my-dir)

common_src_files := \
	VolumeManager.cpp \
	CommandListener.cpp \
	VoldCommand.cpp \
	NetlinkManager.cpp \
	NetlinkHandler.cpp \
	Volume.cpp \
	DirectVolume.cpp \
	Process.cpp \
	Ext4.cpp \
	Fat.cpp \
	Loop.cpp \
	Devmapper.cpp \
	ResponseCode.cpp \
	CheckBattery.cpp \
	VoldUtil.c \
	fstrim.c \
	cryptfs.c

common_c_includes := \
	system/extras/ext4_utils \
	system/extras/f2fs_utils \
	external/openssl/include \
	external/stlport/stlport \
	bionic \
	external/scrypt/lib/crypto \
	frameworks/native/include \
	system/security/keystore \
	hardware/libhardware/include/hardware \
	system/security/softkeymaster/include/keymaster

common_shared_libraries := \
	libsysutils \
	libstlport \
	libbinder \
	libcutils \
	liblog \
	libdiskconfig \
	libhardware_legacy \
	liblogwrap \
	libext4_utils \
	libf2fs_sparseblock \
	libcrypto \
	libselinux \
	libutils \
	libhardware \
	libsoftkeymaster

common_static_libraries := \
	libfs_mgr \
	libscrypt_static \
	libmincrypt \
	libbatteryservice

include $(CLEAR_VARS)

LOCAL_MODULE := libvold

LOCAL_SRC_FILES := $(common_src_files)

LOCAL_C_INCLUDES := $(common_c_includes)

LOCAL_SHARED_LIBRARIES := $(common_shared_libraries)

LOCAL_STATIC_LIBRARIES := $(common_static_libraries)

LOCAL_MODULE_TAGS := eng tests

include $(BUILD_STATIC_LIBRARY)

include $(CLEAR_VARS)

LOCAL_MODULE:= vold

LOCAL_SRC_FILES := \
	main.cpp \
	$(common_src_files)

LOCAL_C_INCLUDES := $(common_c_includes)

LOCAL_CFLAGS := -Werror=format

ifeq ($(TARGET_HW_DISK_ENCRYPTION),true)
LOCAL_C_INCLUDES += $(TARGET_CRYPTFS_HW_PATH)
common_shared_libraries += libcryptfs_hw
LOCAL_CFLAGS += -DCONFIG_HW_DISK_ENCRYPTION
endif

LOCAL_SHARED_LIBRARIES := $(common_shared_libraries)

LOCAL_STATIC_LIBRARIES := $(common_static_libraries)

ifeq ($(BOARD_USES_HDMI),true)
	LOCAL_CFLAGS += -DBOARD_USES_HDMI
	LOCAL_SHARED_LIBRARIES += libhdmiclient
	LOCAL_C_INCLUDES += \
		device/samsung/$(TARGET_BOARD_PLATFORM)/libhdmi/libhdmiservice

ifeq ($(TARGET_SOC),exynos4x12)
        LOCAL_CFLAGS += -DSAMSUNG_EXYNOS4x12
endif

ifeq ($(TARGET_SOC),exynos5250)
        LOCAL_CFLAGS += -DSAMSUNG_EXYNOS5250
endif

ifeq ($(BOARD_USE_V4L2_ION),true)
        LOCAL_CFLAGS += -DBOARD_USE_V4L2_ION
endif

ifeq ($(BOARD_USE_V4L2),true)
        LOCAL_CFLAGS += -DBOARD_USE_V4L2
endif
endif

include $(BUILD_EXECUTABLE)

include $(CLEAR_VARS)

LOCAL_SRC_FILES:= vdc.c

LOCAL_MODULE:= vdc

LOCAL_C_INCLUDES :=

LOCAL_CFLAGS := 

LOCAL_SHARED_LIBRARIES := libcutils

include $(BUILD_EXECUTABLE)
