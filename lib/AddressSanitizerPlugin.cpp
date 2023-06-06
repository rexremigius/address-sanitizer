#include "AddressSanitizer.h"
#include "llvm/Passes/PassBuilder.h"
#include "llvm/Passes/PassPlugin.h"

using namespace llvm;

extern "C" :: PassPluginLibraryInfo LLVM_ATTRIBUTE_WEAK
llvmGetPassPluginInfo(){
    return{
        LLVM_PLUGIN_API_VERSION,"AddressSan",LLVM_VERSION_STRING,
        [](PassBuilder &PB){
            using PipelineElements=typename PassBuilder::PipelineElement;
            PB.registerPipelineParsingCallback(
                [](StringRef Name,FunctionPassManager &FPM,ArrayRef<PassBuilder::PipelineElement>)
                {
                    if(Name=="addressSan"){
                        FPM.addPass(AddressSanPass(errs()));
                        return true;
                    }
                    return false;
                }
            );
        }
    };
}
