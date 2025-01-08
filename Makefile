BASEDIR = $(shell pwd)
BUILD_DIR = $(BASEDIR)/build
INSTALL_DIR = $(BUILD_DIR)/install
PROJECT = $(BASEDIR)/EnableQUIC.xcodeproj
SCHEME = EnableQUIC
CONFIGURATION = Release
SDK = iphoneos
DERIVED_DATA_PATH = $(BUILD_DIR)

all: ipa

ipa:
	mkdir -p ./build
	xcodebuild -jobs 8 -project $(PROJECT) -scheme $(SCHEME) -configuration $(CONFIGURATION) -sdk $(SDK) -derivedDataPath $(DERIVED_DATA_PATH) CODE_SIGN_IDENTITY="" CODE_SIGNING_REQUIRED=NO CODE_SIGNING_ALLOWED=NO ALWAYS_EMBED_SWIFT_STANDARD_LIBRARIES=NO DSTROOT=$(INSTALL_DIR)
	rm -rf ./build/EnableQUIC.ipa
	rm -rf ./build/Payload
	mkdir -p ./build/Payload
	ldid -Sentitlements.plist ./build/Build/Products/Release-iphoneos/EnableQUIC.app
	cp -rv ./build/Build/Products/Release-iphoneos/EnableQUIC.app ./build/Payload
	cd ./build && zip -r EnableQUIC.ipa Payload
	mv ./build/EnableQUIC.ipa ./

clean:
	rm -rf ./build
	rm -rf ./EnableQUIC.ipa
