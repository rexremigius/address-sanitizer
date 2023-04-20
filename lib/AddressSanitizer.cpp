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
  vector<Instruction *> instructions;
  if (!(funcName.find("asan") != string::npos)) 
  {
  for(auto &BB:F)
    {
        for(auto &inst:BB)
        {
            errs()<<inst<<"\n";
            if(isa<CallInst>(inst))
            {
               // errs()<<"call instruction\n";
                auto *callInst=dyn_cast<CallInst>(&inst);
                string call_inst=callInst->getCalledFunction()->getName().str();
                if(call_inst.find("__asan_report_")!=string::npos)
                {
                   // errs()<<"asan call ......\n";
                    // auto *illegal=dyn_cast<Instruction>(callInst->getOperand(0));Stack dump:
                    // auto *memory_access=dyn_cast<Instruction>(illegal->getOperand(0));
                    auto *next = callInst->getNextNode();
                    instructions.push_back(next);
                    //to access previous block
                    auto *prevBB = BB.getPrevNode();
                    if (prevBB != nullptr) {
                    errs() << "Previous BB : " << *prevBB << "\n";
                    //to get last instruction of previous block
                    auto *lastInst = prevBB->getTerminator();
                    errs() << *lastInst << "\n";
                      if (lastInst) {
                        BasicBlock *target = lastInst->getSuccessor(1);
                        IRBuilder<> builder(next);
                        Instruction *BrInst = builder.CreateBr(target);
                      errs() << *BrInst << "\n";
                        lastInst->replaceAllUsesWith(BrInst);
                      }
                    } 
                    //to get basic block where target instruction is present
                    /*
                    //first instruction of of next basic block
                    Instruction* initial = nextBB->getFirstNonPHI();

                    //target instruction where spliting take place
                    Instruction* instToSplit=initial->getNextNode();

                    //in case intial instruction is load instruction , check from second instruction to end of basic block whether instruction is depend on initial instruction
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
                        break;
                    }
                    }

                    //target basic block
                    BasicBlock* newBlock = nextBB->splitBasicBlock(instToSplit);
                    errs()<<*newBlock->getSinglePredecessor()<<" "<<*newBlock<<"\n";
*/
                    
                    
                }

            }
        }
    }
  }
  for(auto *i : instructions){
    i->eraseFromParent();
  }
    return PreservedAnalyses::all();
    
}