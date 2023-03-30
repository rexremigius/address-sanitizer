add_library(LLVMAddressSan MODULE 
    AddressSan.cpp
    AddressSanPlugin.cpp
)

# this is very important, to link with the passes library
target_link_libraries(LLVMAddressSan ${llvm_libs})
