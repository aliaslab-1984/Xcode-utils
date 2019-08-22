#!/usr/bin/env bash

echo
if [ -z "$1" ]; then
	echo "Indicare un framework"
	echo -e "\tes. $0 SmartOTPSDK-Universal.framework/SmartOTPSDK \n"
	exit
fi

echo -e "File size:\t  $(ls -lh "$1" | awk '{print $5}')"
echo -e "Last modified on: $(date -r "$1")\n"
#lipo -info $1
ARCHITECTURES=$(lipo -archs "$1")
echo -e "Architectures:\t  $ARCHITECTURES"
echo

for ARCH in $ARCHITECTURES
do
	otool -l -arch $ARCH "$1" | grep -q LLVM
	if [ $? -eq 0 ]; then
		echo -e "\t[*] $ARCH has BITCODE"
	else
		echo -e "\t[X] $ARCH has not BITCODE"
	fi
done
echo

FW_PATH=$(dirname "$1")
PLIST="$FW_PATH/Info.plist"
if [ -f $PLIST ]; then
	VER=$(defaults read $PLIST | grep CFBundleShortVersionString | awk  '{print $3}' | tr -d \; | tr -d \")
	BUILD=$(defaults read $PLIST | grep CFBundleVersion | awk  '{print $3}' | tr -d \; | tr -d \")
	MIN_OS=$(defaults read $PLIST | grep MinimumOSVersion | awk  '{print $3}' | tr -d \; | tr -d \")

	echo "Version: $VER"
	echo "Build: $BUILD"
	echo "Min OS: $MIN_OS"
	echo
fi
