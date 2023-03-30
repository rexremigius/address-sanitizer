# ADDRESS SANITIZER #

This README is to know what the project is all about.

### About this Repository ###

* This project works on the Address Sanitizer which is a memory bug detector tool used in LLVM.
* Till now Address Sanitizer is used to find memory bugs or memory leaks from a program and gets Aborted.
* We are working to make Address Sanitizer reporting the error and continue its execution to make the system Fault Tolerant and available throughout. 

### Set Up ###

* This project is a LLVM out-of-tree build.

* This project can be run by just cloning this repo to your Local machine.

* Move to the Testing folder and execute the following commands.

* To run the program with Address Sanitizer we need to enable a flag using clang.


        clang -S -emit-llvm Xclang -disable-O0-optnone -fsanitize=address -fno-omit-frame-pointer <test_file>.c -o <test_file>.ll


* Then we need to pass the LLVM IR to the opt to run the pass on it


        opt -load-pass-plugin LLVMAddressSan.so -passes="addressSan" -S <test_file>.ll -o <output_file>.ll


* The output will be given as LLVM IR and it can be made into an executable by


        clang <output_file>.ll -o <executable> -lasan


* This executable can be executed as


        ./<executable>


### MulticoreWare Confidential ###