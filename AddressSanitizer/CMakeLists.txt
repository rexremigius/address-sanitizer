cmake_minimum_required(VERSION 3.20)

# need at least c++11 to compile successfully, I chose c++17 just to be cool
set (CMAKE_CXX_STANDARD 11)

# maybe not needed, but just to be safe
set(CMAKE_C_COMPILER "clang")
set(CMAKE_CXX_COMPILER "clang++")

find_package(LLVM REQUIRED CONFIG)

message(STATUS "Found LLVM ${LLVM_PACKAGE_VERSION}")
message(STATUS "Using LLVMConfig.cmake in: ${LLVM_DIR}")

# just copied from the docs
separate_arguments(LLVM_DEFINITIONS_LIST NATIVE_COMMAND ${LLVM_DEFINITIONS})
add_definitions(${LLVM_DEFINITIONS_LIST})
include_directories(${LLVM_INCLUDE_DIRS})

# this is very important, to link with the passes library
llvm_map_components_to_libnames(llvm_libs passes)

add_subdirectory(addressSan)