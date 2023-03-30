#ifndef ADDRESS_SAN_H
#define ADDRESS_SAN_H

#include "llvm/IR/InstrTypes.h"
#include "llvm/IR/PassManager.h"
#include "llvm/Support/raw_ostream.h"

namespace llvm{
struct AddressSanPass : public PassInfoMixin<AddressSanPass>{
	explicit AddressSanPass(raw_ostream &OS) : OS(OS) {}
	public:
		PreservedAnalyses run(Function &F,FunctionAnalysisManager &FAM);
	
    private:
    	raw_ostream &OS;
};
}
#endif
