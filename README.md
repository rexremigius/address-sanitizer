# ADDRESS SANITIZER #

This README is to know what the project is all about.

## ABOUT THIS REPOSITORY ##

* This project works on the Address Sanitizer which is a memory bug detector tool used in LLVM.
* Till now Address Sanitizer is used to find memory bugs or memory leaks from a program and gets Aborted.
* We are working to make Address Sanitizer reporting the error and continue its execution to make the system Fault Tolerant and available throughout. 

## REPOSITORY STRUCTURE ##

        
        /compiler-rt
          /lib
             /asan
                - asan_report.cpp

        /include
          - AddressSanitizer.h

        /lib
          - AddressSanitizer.cpp
          - AddressSanitizerPlugin.cpp
          - CMakeLists.txt

        /llvm
          /lib
            /Passes
               -StandardInstrumentations.cpp

        /Testing
          - test.c
          - test.ll

        CMakeLists.txt
        
        README

        .gitignore

        


## SETUP ##

* This project is a LLVM out-of-tree build.

* This project can be run by just cloning this repo to your Local machine.

* Note that LLVM should be installed before to run this code.

#### STEPS TO BUILD LLVM ####

* Download the LLVM source file from LLVM website - https://releases.llvm.org/ or https://github.com/llvm/llvm-project/releases

* Download the Source code (tar.gz) for Linux.

* Unzip it using the following commands


        tar -xf <llvm_filename>.tar.gz


* Use the following command to build llvm with clang,compiler-rt etc and build the 


        cmake -G Ninja -B build -DLLVM_ENABLE_PROJECTS="clang;lld;compiler-rt" -DCMAKE_BUILD_TYPE=Debug -DLLVM_ENABLE_ASSERTIONS=ON  -DLLVM_OPTIMIZED_TABLEGEN=ON -DBUILD_SHARED_LIBS=ON -DLLVM_TARGETS_TO_BUILD=X86 ../llvm

        cd ..

        cd build


* Using ninja to build the llvm and $(nproc) to use all the cores of the cpu. Note we can also use less number of cores too.


        ninja -j$(nproc)


* Once the build is complete we need to setup the environmental variables in order to use the llvm libraries and files.


        vim ~/.bashrc

        export PATH=PATH:~/<path/to/llvm/build/folder>/build/bin

        sudo vim /etc/ld.so.conf.d/<llvm_filename>.conf

        home/<username>/<path/to/llvm/build/folder>/build/lib

        source ~/.bashrc

        sudo ldconfig


* First we need to replace some of the existing files in the llvm source tree


        compiler-rt -> lib -> asan -> asan_report.cpp

   * Replace the above file with the file we have in this repository under the same folder structure.


        llvm -> lib -> Passes -> StandardInstrumentations.cpp

   * Replace the above file with the file we have in this repository under the same folder structure.

* Again build the llvm using the command


        ninja


#### SET UP BUILD FOLDER ####

* To set up build folder run the following commands 


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

* To log the report we can use the following command to enable log file


        export ASAN_OPTIONS=log_path=error.log


* This executable can be executed as


        ./<executable>


* Log file will be created in the Testing folder as


        error.log.$(pid)


* To create CFG for the files we can use the below commands


        opt -dot-cfg <filename>.ll


* CFG's will be created in the function name such as

        .<functionname>.dot


* To view the CFG use need to have xdot or graphviz viewer
* If xdot is present we can use the command,


        xdot .<functionname>.dot


* CFG's can be viewed as Graphs in this method for better understanding of control flow

# MulticoreWare Confidential #