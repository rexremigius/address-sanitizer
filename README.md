# ADDRESS SANITIZER #

This README is to know what the project is all about.

### About this Repository ###

* This project works on the Address Sanitizer which is a memory bug detector tool used in LLVM.
* Till now Address Sanitizer is used to find memory bugs or memory leaks from a program and gets Aborted.
* We are working to make Address Sanitizer reporting the error and continue its execution to make the system Fault Tolerant and available throughout. 

### Repositry Structure ###

        
        /include
          - AddressSanitizer.h

        /lib
          - AddressSanitizer.cpp
          - AddressSanitizerPlugin.cpp
          - CMakeLists.txt

        /Testing
          - test.c
          - test.ll

        CMakeLists.txt
        
        README

        .gitignore

        


### Set Up ###

* This project is a LLVM out-of-tree build.

* This project can be run by just cloning this repo to your Local machine.

* To set up build folder run the following commands (Note that LLVM should be installed before to run this code)


        LLVM_INSTALL_DIR= <LLVM PATH TO SOURCE>/build/
        
        LLVM_OPT=$LLVM_INSTALL_DIR/bin/opt
        
        cmake -DLLVM_INSTALL_DIR=$LLVM_INSTALL_DIR -G Ninja -B build/.
        
        cd build
        
        ninja


* Move to the Testing folder and execute the following commands.

* To run the program with Address Sanitizer we need to enable a flag using clang.


        clang -S -emit-llvm Xclang -disable-O0-optnone -fsanitize=address -fno-omit-frame-pointer <test_file>.c -o <test_file>.ll


* Then we need to pass the LLVM IR to the opt to run the pass on it


        opt -load-pass-plugin /home/<username>/address-sanitizer/build/lib/libAddressSanitizer.so -passes="addressSan" -S <test_file>.ll -o <output_file>.ll


* The output will be given as LLVM IR and it can be made into an executable by


        llc -filetype=obj <output_file>.ll -o <output>.o

        clang -g -fsanitize=address <output>.o -o <executable>



* This executable can be executed as


        ./<executable>


### MulticoreWare Confidential ###