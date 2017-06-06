ARCHS = armv7 arm64
TARGET = iphone:clang:latest
SDK = iPhoneOS8.1
THEOS_BUILD_DIR = DEBs

include theos/makefiles/common.mk

TWEAK_NAME = CCWallCustomizer
CCWallCustomizer_FILES = Tweak.xm
CCWallCustomizer_FRAMEWORKS = UIKit CoreGraphics QuartzCore
CCWallCustomizer_LIBRARIES += cephei
CCWallCustomizer_CFLAGS = -Wno-error
CCWallCustomizer += -Wl,-segalign,4000
CFLAGS = -Wno-deprecated -Wno-deprecated-declarations -Wno-error

include $(THEOS_MAKE_PATH)/tweak.mk

after-install::
	install.exec "killall -9 SpringBoard"
SUBPROJECTS += ccwallcustomizer
include $(THEOS_MAKE_PATH)/aggregate.mk
