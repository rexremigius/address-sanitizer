add_library(AddressSanitizer MODULE 
    AddressSanitizer.cpp    
    AddressSanitizerPlugin.cpp
)
target_include_directories(AddressSanitizer PRIVATE
    "${CMAKE_CURRENT_SOURCE_DIR}/../include"
)

