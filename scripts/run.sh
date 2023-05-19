#!/bin/bash
# Removing .ll, .o, out, error.log. files if created before

rm -r ~/address-sanitizer/Testing/*.ll
rm -r ~/address-sanitizer/Testing/*.o 
rm -r ~/address-sanitizer/Testing/out
rm  -r ~/address-sanitizer/Testing/error.log.*

# Using clang command to convert .c file to .ll

clang -S -emit-llvm -Xclang -disable-O0-optnone -fsanitize=address -fno-omit-frame-pointer -fsanitize-address-use-after-return=never ~/address-sanitizer/Testing/test.c -o ~/address-sanitizer/Testing/test.ll

# Using opt to invoke the transformation pass - AddressSanitizer and write the output to out.ll

opt -load-pass-plugin ~/address-sanitizer/build/lib/libAddressSanitizer.so -passes="addressSan" -S ~/address-sanitizer/Testing/test.ll -o ~/address-sanitizer/Testing/out.ll

# llc is used to convert .ll file to .o file

llc -filetype=obj ~/address-sanitizer/Testing/out.ll -o ~/address-sanitizer/Testing/out.o

# Using clang to convert .o file into executable and using Address Sanitizer

clang -g -fsanitize=address -fsanitize-address-use-after-return=never ~/address-sanitizer/Testing/out.o -o ~/address-sanitizer/Testing/out

# Setting environmental variable for logging the error report

export ASAN_OPTIONS=log_path=error.log

# Moving to Testing folder

cd ..
cd Testing

# Running the executable

#./out

#echo 655366 632.168153 1553.531 | ./out
echo 175 4865.5844 6840.864 | ./out
#echo 200 785.153 463.5461 | ./out

size ./out

# Opening the error log file using text editor

gedit error.log.*