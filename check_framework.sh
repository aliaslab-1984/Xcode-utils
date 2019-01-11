#!/usr/bin/env bash

echo
if [ -z $1 ]; then
	echo "Indicare un framework"
	echo -e "\tes. $0 SmartOTPSDK-Universal.framework/SmartOTPSDK \n"
	exit
fi

echo -e "File size:\t $(ls -lh $1 | awk '{print $5}')"
echo -e "Last modified on: $(date -r $1)\n"
#lipo -info $1
ARCHITECTURES=$(lipo -archs $1)
echo -e "Architectures:\t $ARCHITECTURES"
echo

for ARCH in $ARCHITECTURES
do
	otool -l -arch $ARCH $1 | grep LLVM > /dev/null && echo -e "\t* $ARCH has BITCODE"
done
echo
