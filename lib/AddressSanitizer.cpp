#include "AddressSanitizer.h"
#include "llvm/IR/Function.h"
#include "llvm/IR/IRBuilder.h"
#include "llvm/IR/Instructions.h"
#include "llvm/IR/Value.h"
#include <vector>
using namespace std;
using namespace llvm;
/*
bool isUsedByInstruction(Instruction *inst1, Instruction *inst2) {
  for (Use &use : inst1->operands()) {
    if (use.get() == inst2) {
      return true;
    }
  }
  return false;
}
*/
PreservedAnalyses AddressSanPass::run(Function &F,
                                      FunctionAnalysisManager &FAM) {
  string funcName = F.getName().str();
  LLVMContext &Ctx = F.getContext();
  int initial_size;

  vector<Instruction *> instructions;
  if (!(funcName.find("asan") != string::npos)) {
    for (Function::iterator bb = F.begin(), e = F.end(); bb != e; bb++) {
      for (BasicBlock::iterator i = bb->begin(), i2 = bb->end(); i != i2; i++) {
        auto *inst = dyn_cast<Instruction>(i);
        errs() << *inst << "\n";
        Value *arr;
        if (isa<AllocaInst>(inst)) {
          if (inst->getNameOrAsOperand().find("retval") == string::npos) {
            arr = inst;
            errs() << " alloc : " << *arr << "\n";
          }
        }
        if (isa<CallInst>(inst)) {
          // errs()<<"call instruction\n";
          auto *callInst = dyn_cast<CallInst>(inst);
          string call_inst = callInst->getCalledFunction()->getName().str();
          if (call_inst.find("calloc") != string::npos) {
            errs() << " Calloc : " << *callInst << "\n";
            errs()<<*(callInst->getArgOperand(0))<<"\n";
          }
          if (call_inst.find("__asan_report_") != string::npos) {

            // auto
            // *illegal=dyn_cast<Instruction>(callInst->getOperand(0));Stack
            // dump: auto
            // *memory_access=dyn_cast<Instruction>(illegal->getOperand(0));
            
            auto *next = callInst->getNextNode();
            
            // Memory reallocation instrumentation code.
            IRBuilder<> builder(next);
            Type *fromTy = Type::getInt32PtrTy(Ctx);
            Value *loadInst = builder.CreateLoad(fromTy,arr);
            Type *toTy = Type::getInt8PtrTy(Ctx);
            auto *bitinst32To8 = builder.CreateBitCast(loadInst,toTy);
            auto *bitinst8To32 = builder.CreateBitCast(bitinst32To8,fromTy);
            auto *storeInst = builder.CreateStore(bitinst8To32,arr);

            instructions.push_back(next);

            // to access previous block
            auto *prevBB = bb->getPrevNode();
            if (prevBB != nullptr) {
              auto *lastInst = prevBB->getTerminator();
              if (lastInst) {
                BasicBlock *target = lastInst->getSuccessor(1);
                IRBuilder<> builder(next);
                Instruction *BrInst = builder.CreateBr(target);
                lastInst->replaceAllUsesWith(BrInst);
              }
            }
            // to get basic block where target instruction is present
            /*
            //first instruction of of next basic block
            Instruction* initial = nextBB->getFirstNonPHI();

            //target instruction where spliting take place
            Instruction* instToSplit=initial->getNextNode();

            //in case intial instruction is load instruction , check from second
            instruction to end of basic block whether instruction is depend on
            initial instruction if(initial->getOpcode()==Instruction::Load)
            {
            for (BasicBlock::iterator i = ++nextBB->begin(), i2 = nextBB->end();
            i != i2; i++)
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
  for (auto *i : instructions) {
    i->eraseFromParent();
  }
  return PreservedAnalyses::all();
}