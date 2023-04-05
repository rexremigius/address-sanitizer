#include "AddressSanitizer.h"
#include "llvm/IR/Function.h"
#include "llvm/IR/IRBuilder.h"
#include "llvm/IR/Instructions.h"
#include "llvm/IR/Value.h"
#include <vector>
using namespace std;
using namespace llvm;

bool isUsedByInstruction(Instruction *inst1, Instruction *inst2) {
  for (Use &use : inst1->operands()) {
    if (use.get() == inst2) {
      return true;
    }
  }
  return false;
}

PreservedAnalyses AddressSanPass::run(Function &F,FunctionAnalysisManager &FAM) 
{
  string funcName = F.getName().str();
  if (!(funcName.find("asan") != string::npos)) {
    for(auto &BB:F) {
      for(auto &inst:BB) {
        errs()<<inst<<"\n";
        if(isa<CallInst>(inst)) {
          errs()<<"call instruction\n";
          auto *callInst=dyn_cast<CallInst>(&inst);
          string call_inst=callInst->getCalledFunction()->getName().str();
          if(call_inst.find("__asan_report_")!=string::npos){
            errs()<<"asan call ......\n";
            auto *illegal=dyn_cast<Instruction>(callInst->getOperand(0));
            auto *memory_access=dyn_cast<Instruction>(illegal->getOperand(0));
            auto *prevBB = BB.getPrevNode();
            auto *lastInst = prevBB->getTerminator();
            errs()<<*lastInst<<"\n";
            BasicBlock *nextBB = lastInst->getSuccessor(1);
            Instruction* initial = nextBB->getFirstNonPHI();
            Instruction* instToSplit=initial->getNextNode();
            if(initial->getOpcode()==Instruction::Load) {
              for (BasicBlock::iterator i = ++nextBB->begin(), i2 = nextBB->end(); i != i2; i++) {
                auto *in = dyn_cast<Instruction>(i);
                  if(isUsedByInstruction(in,initial)) {
                    instToSplit=in->getNextNode();
                    continue;
                  }
                break;
              }
            }
            BasicBlock* newBlock = nextBB->splitBasicBlock(instToSplit);
            errs()<<*newBlock->getSinglePredecessor()<<" "<<*newBlock<<"\n";
            lastInst->setOperand(2,newBlock);
          }
        }
      }
    }
  }
  return PreservedAnalyses::all();
}