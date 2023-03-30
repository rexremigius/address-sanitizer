#include "AddressSanitizer.h"
#include "llvm/IR/Function.h"
#include "llvm/IR/IRBuilder.h"
#include "llvm/IR/Instructions.h"
#include "llvm/IR/Value.h"
#include <vector>
using namespace std;
using namespace llvm;
PreservedAnalyses AddressSanPass::run(Function &F,FunctionAnalysisManager &FAM) 
{
    string funcName = F.getName().str();
    vector<Instruction *> instructions;
    if (funcName.find("main") != string::npos) {
        errs()<< "==================Address Sanitizer======================\n";
        for (Function::iterator bb = F.begin(), e = F.end(); bb != e; bb++) {
            for (BasicBlock::iterator i = bb->begin(), i2 = bb->end(); i != i2; i++) {
                auto *inst = dyn_cast<Instruction>(i);
                // errs() << *inst << "\n";
                if (isa<CallInst>(inst)) {
                    auto *callInstr = dyn_cast<CallInst>(inst);
                    errs() << "Call Instructions :" << *inst << "\n";
                    string asanCall = callInstr->getCalledFunction()->getName().str();
                    errs() << asanCall << "\n";
                    if (asanCall.find("__asan_report_") != string::npos) {
                        instructions.push_back(callInstr);
                        auto *next = inst->getNextNode();
                        instructions.push_back(next);
                        auto *prevBB = bb->getPrevNode();
                        if (prevBB != nullptr) {
                            errs() << "Previous BB : " << *prevBB << "\n";
                            auto *lastInst = prevBB->getTerminator();
                            errs() << *lastInst << "\n";

                            if (lastInst) {
                                BasicBlock *target = lastInst->getSuccessor(1);
                                IRBuilder<> builder(callInstr);
                                Instruction *BrInst = builder.CreateBr(target);
                                errs() << *BrInst << "\n";
                                lastInst->replaceAllUsesWith(BrInst);
                            }
                        }else {
                            errs() << "No Previous BB "<< "\n";
                        }
                    }
                }
            }
        }
    }
    for (auto *instr : instructions) {
        errs() << "Deleted Instructions : " << *instr << "\n";
    }
    for (auto *instr : instructions) {
        instr->eraseFromParent();
    }
    return PreservedAnalyses::all();
}