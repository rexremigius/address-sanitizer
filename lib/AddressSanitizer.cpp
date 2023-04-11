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
  for(auto &BB:F)
    {
        for(auto &inst:BB)
        {
            errs()<<inst<<"\n";
            if(isa<CallInst>(inst))
            {
                errs()<<"call instruction\n";
                auto *callInst=dyn_cast<CallInst>(&inst);
                string call_inst=callInst->getCalledFunction()->getName().str();
                if(call_inst.find("__asan_report_")!=string::npos)
                {
                    errs()<<"asan call ......\n";
                    // auto *illegal=dyn_cast<Instruction>(callInst->getOperand(0));
                    // auto *memory_access=dyn_cast<Instruction>(illegal->getOperand(0));

                    //to access previous block
                    auto *prevBB = BB.getPrevNode();

                    //to get last instruction of previous block
                    auto *lastInst = prevBB->getTerminator();
                   
                   // to get next block where target instruction is present
                    BasicBlock *nextBB = lastInst->getSuccessor(1);

                    //to get first instruction 
                    Instruction* initial = nextBB->getFirstNonPHI();

                    //target instruction
                    Instruction* instToSplit=initial->getNextNode();

                    //in case of intial instruction is load instruction ,check from second instruction whether instructions are depend on intial instruction
                    if(initial->getOpcode()==Instruction::Load)
                    {
                    for (BasicBlock::iterator i = ++nextBB->begin(), i2 = nextBB->end(); i != i2; i++) 
                    {
                     auto *in = dyn_cast<Instruction>(i);
                    
                        if(isUsedByInstruction(in,initial))
                        {
                            instToSplit=in->getNextNode();
                            continue;
                        }
                        
                    }
                    }
                    
                    //split basic block after finding target instruction
                    BasicBlock* newBlock = nextBB->splitBasicBlock(instToSplit);
                   errs()<<*newBlock->getSinglePredecessor()<<" "<<*newBlock<<"\n";

                   //check the cfg bypassing to target basic block
                   lastInst->setOperand(2,newBlock);
                    
                    
                }

            }
        }
    }
    return PreservedAnalyses::all();
}