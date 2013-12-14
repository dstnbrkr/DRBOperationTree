CONFIGURATION ?= "Debug"
BUILD_DIR = $(shell pwd)/build
PROJECT = DRBOperationTree.xcodeproj

xctool_command:
	xctool -sdk $(SDK)         \
               -project $(PROJECT) \
               -scheme $(SCHEME)   \
               -configuration $(CONFIGURATION) $(COMMAND)

test_ios: SDK = iphonesimulator
test_ios: SCHEME = Tests-iOS
test_ios: COMMAND = test
test_ios: xctool_command

test_osx: SDK = macosx
test_osx: SCHEME = Tests-OSX
test_osx: COMMAND = test
test_osx: xctool_command



