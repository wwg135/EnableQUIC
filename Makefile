BASEDIR = $(shell pwd)
BUILD_DIR = $(BASEDIR)/build
INSTALL_DIR = $(BUILD_DIR)/install
PROJECT = $(BASEDIR)/EnableQUIC.xcodeproj
SCHEME = EnableQUIC
CONFIGURATION = Release
SDK = iphoneos
DERIVED_DATA_PATH = $(BUILD_DIR)

all: ipa

before-package::
	@if [ -f $(THEOS_STAGING_DIR)/Applications/$(XCODEPROJ_NAME).app/Info.plist ]; then \
		echo -e "\033[32mSigning with ldid...\033[0m"; \
		ldid -Sentitlements.plist $(THEOS_STAGING_DIR)/Applications/$(XCODEPROJ_NAME).app; \
	else \
		@echo -e "\033[31mNo Info.plist found. Skipping ldid signing.\033[0m"; \
	fi
	@echo -e "\033[32mRemoving _CodeSignature folder..."

ipa:
	mkdir -p ./build
	xcodebuild -jobs 8 -project $(PROJECT) -scheme $(SCHEME) -configuration $(CONFIGURATION) -sdk $(SDK) -derivedDataPath $(DERIVED_DATA_PATH) CODE_SIGN_IDENTITY="" CODE_SIGNING_REQUIRED=NO CODE_SIGNING_ALLOWED=NO ALWAYS_EMBED_SWIFT_STANDARD_LIBRARIES=NO DSTROOT=$(INSTALL_DIR)
	rm -rf ./build/EnableQUIC.ipa
	rm -rf ./build/Payload
	mkdir -p ./build/Payload
	cp -rv ./build/Build/Products/Release-iphoneos/EnableQUIC.app ./build/Payload
	cd ./build && zip -r EnableQUIC.ipa Payload
	mv ./build/EnableQUIC.ipa ./

clean:
	rm -rf ./build
	rm -rf ./EnableQUIC.ipa
