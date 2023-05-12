#include "AddressSanitizer.h"
#include "llvm/IR/Function.h"
#include "llvm/IR/IRBuilder.h"
#include "llvm/IR/Instructions.h"
#include "llvm/IR/Value.h"
#include <map>
#include <vector>
using namespace std;
using namespace llvm;
PreservedAnalyses AddressSanPass::run(Function &F,
                                      FunctionAnalysisManager &FAM) {

  //  To get the function name to avoid asan invoked functions

  string funcName = F.getName().str();

  // To create LLVMContext for the function

  LLVMContext &Ctx = F.getContext();

  //  integer values for reallocation of the values - required Index and initial
  //  size which are used to get the reallocation size reallocated size is
  //  determined as (required_index+initial_size)*sizeof(dataType);
  //  Declared the variables required for the pass

  Module *M = F.getParent();
  Type *type_ptr;
  Type *type;
  int64_t required_index = 0;
  int64_t data_type_size = 0;
  int64_t reallocated_size = 0;

  // Map for selecting the initial size and allocation type

  map<string, int64_t> initialSize;
  map<string, string> allocationType;

  //  Vector to push the unwanted instruction and delete it at end.

  vector<Instruction *> instructions;

  //  this condition does not allow functions related to asan

  if (!(funcName.find("asan") != string::npos)) {

    //  iterating over the functions

    for (Function::iterator bb = F.begin(), e = F.end(); bb != e; bb++) {

      //  iterating over the basic blocks

      for (BasicBlock::iterator i = bb->begin(), i2 = bb->end(); i != i2; i++) {

        // for (auto e = arrSet.begin(); e != arrSet.end(); e++) {
        //   errs() <<"Array Value : "<< e->first << "-" << *(e->second)<< "\n";
        // }
        // dynamically casting the iterator to instructions

        auto *inst = dyn_cast<Instruction>(i);
        errs() << *inst << "\n";

        //  To get the array

        Value *arr;

        //  To check whether the instruction is a array index access instruction
        //  and get the required index and get the type of the input.

        //  To check whether the instruction is a call instruction and get the
        //  initial index from the calloc call and also check for the
        //  asan_report and perform the reallocation instrumentation
        //  Check whether the dynamic allocation is malloc or calloc

        if (isa<CallInst>(inst)) {
          auto *callInst = dyn_cast<CallInst>(inst);
          string call_inst = callInst->getCalledFunction()->getName().str();
          if ((call_inst.find("calloc") != string::npos)) {
            auto *initial_index = callInst->getOperand(0);
            int64_t initial_size =
                cast<ConstantInt>(initial_index)->getSExtValue();
            auto *dataTypeSize = callInst->getOperand(1);
            data_type_size = cast<ConstantInt>(dataTypeSize)->getSExtValue();

            string allocation = call_inst;
            string arrName;

            if (isa<BitCastInst>(callInst->getPrevNode()->getPrevNode())) {
              arrName = (callInst->getPrevNode()->getPrevNode())
                            ->getOperand(0)
                            ->getName()
                            .str();
              errs() << "Arr Name : " << arrName << "\n";
              initialSize.insert(make_pair(arrName, initial_size));
              allocationType.insert(make_pair(arrName, allocation));
            }

            //  Checks whether the instruction is bitcast and gets the type
            //  pointer which the destination type for further ref If not then
            //  the pointer is the return type of the instruction

            if (isa<BitCastInst>(inst->getNextNode())) {
              BitCastInst *bitcastInst =
                  dyn_cast<BitCastInst>(inst->getNextNode());
              type_ptr = bitcastInst->getDestTy();
            } else {
              type_ptr = inst->getType();
            }
          } else if (call_inst.find("malloc") != string::npos) {
            auto *initial_index = callInst->getOperand(0);
            int64_t initial_size =
                cast<ConstantInt>(initial_index)->getSExtValue();
            string allocation = call_inst;
            string arrName;
            if (isa<BitCastInst>(callInst->getPrevNode()->getPrevNode())) {
              arrName = (callInst->getPrevNode()->getPrevNode())
                            ->getOperand(0)
                            ->getName()
                            .str();
              errs() << "Arr Name : " << arrName << "\n";
              initialSize.insert(make_pair(arrName, initial_size));
              allocationType.insert(make_pair(arrName, allocation));
            }
          }

          //  To check whether it is a asan_report

          if (call_inst.find("__asan_report_") != string::npos) {
            
            bool idxprom = false;
            Value *index;
            int64_t initial_size;
            string allocation;
            Value *loadedValue;

            auto *ptrInst = dyn_cast<Instruction>(callInst->getArgOperand(0));
            errs() << "PtrInst : " << *ptrInst << "\n";
            auto *arrIdx = dyn_cast<Instruction>(ptrInst->getOperand(0));
            errs() << "arrIdx : " << *arrIdx << "\n";
            auto *arrIdxLoad = dyn_cast<Instruction>(arrIdx->getOperand(0));
            auto *arrNameReq = arrIdxLoad->getOperand(0);
            string nameReq = arrNameReq->getName().str();
            for (auto i = initialSize.begin(); i != initialSize.end(); i++) {
              string namePre = i->first;
              if (nameReq == namePre) {
                initial_size = i->second;
              }
            }
            for (auto i = allocationType.begin(); i != allocationType.end();
                 i++) {
              string namePre = i->first;
              if (nameReq == namePre) {
                allocation = i->second;
              }
            }
            errs() << "Arr Idx Name : " << *arrNameReq << "\n";
            if (isa<GetElementPtrInst>(arrIdx)) {
              auto *req_index = arrIdx->getOperand(1);
              if (req_index->getName().str().find("idxprom") != string::npos) {
                idxprom = true;
                auto *idxprom = dyn_cast<Instruction>(req_index)->getOperand(0);
                errs() << "idxprom : " << *idxprom << "\n";
                index = dyn_cast<Instruction>(idxprom)->getOperand(0);
                errs() << "index : " << *index << "\n";
                auto *constantExp = dyn_cast<ConstantExpr>(index);

                if (constantExp &&
                    isa<GlobalVariable>(constantExp->getOperand(0))) {
                  GlobalVariable *gVar =
                      dyn_cast<GlobalVariable>(constantExp->getOperand(0));
                  errs() << "GEP Instruction : " << *gVar << "\n";
                  errs() << "Operand Value : " << gVar->getNumOperands()
                         << "\n";
                  ConstantStruct *constantStruct =
                      dyn_cast<ConstantStruct>(gVar->getInitializer());
                  if (constantStruct) {
                    ConstantInt *value =
                        dyn_cast<ConstantInt>(constantStruct->getOperand(0));
                    APInt intValue = value->getValue();
                    required_index = intValue.getSExtValue();
                  } else {
                    int flag = 0;
                    for (Function::iterator bb = F.begin(), e = F.end();
                         bb != e; bb++) {
                      for (BasicBlock::iterator i = bb->begin(), i2 = bb->end();
                           i != i2; i++) {
                        auto *ins = dyn_cast<Instruction>(i);
                        if (ins == inst) {
                          flag = 1;
                          errs() << "equal...\n";
                          break;
                        }
                        if (isa<StoreInst>(ins)) {
                          errs() << *ins << *ins->getOperand(0)
                                 << *ins->getOperand(1) << "\n";
                          if (ins->getOperand(1) == index) {
                            ConstantInt *value =
                                dyn_cast<ConstantInt>(ins->getOperand(0));
                            APInt intValue = value->getValue();
                            required_index = intValue.getSExtValue();
                          }
                        }
                      }
                      if (flag == 1) {
                        break;
                      }
                    }
                  }

                } else {
                  int flag = 0;
                  for (Function::iterator bb = F.begin(), e = F.end(); bb != e;
                       bb++) {
                    for (BasicBlock::iterator i = bb->begin(), i2 = bb->end();
                         i != i2; i++) {
                      auto *ins = dyn_cast<Instruction>(i);
                      if (ins == inst) {
                        flag = 1;
                        errs() << "equal...\n";
                        break;
                      }
                      if (isa<StoreInst>(ins)) {
                        errs() << *ins << *ins->getOperand(0)
                               << *ins->getOperand(1) << "\n";
                        if (ins->getOperand(1) == index) {
                          ConstantInt *value =
                              dyn_cast<ConstantInt>(ins->getOperand(0));
                          APInt intValue = value->getValue();
                          required_index = intValue.getSExtValue();
                        }
                      }
                    }
                    if (flag == 1) {
                      break;
                    }
                  }
                }

              } else {
                required_index = cast<ConstantInt>(req_index)->getSExtValue();
              }
            }
            auto *gep = dyn_cast<Instruction>(arrIdx->getOperand(0));
            errs() << "gep : " << *gep << "\n";
            auto *arrReq = dyn_cast<Instruction>(gep->getOperand(0));
            errs() << "arrReq : " << *arrReq << "\n";
            type_ptr = gep->getType();
            type = type_ptr->getPointerElementType();
            errs() << "Arr Req : " << *arrReq << "\n";
            arr = dyn_cast<Value>(arrReq);

            errs() << "Required Array : " << *arr << "\n";

            auto *next = callInst->getNextNode();
            errs() << "Next : " << *next << "\n";

            // Memory reallocation instrumentation code.

            IRBuilder<> builder(next);

            if (idxprom) {
              AllocaInst *allocaInst =
                  builder.CreateAlloca(Type::getInt32Ty(Ctx), nullptr);
              auto *loadInstInput =
                  builder.CreateLoad(Type::getInt32Ty(Ctx), index);
              errs() << "Input Load : " << *loadInstInput << "\n";
              llvm::ConstantInt *initialSize =
                  llvm::ConstantInt::get(Ctx, llvm::APInt(64, initial_size));
              auto *inSize = cast<Value>(initialSize);
              errs() << "inSize : " << *inSize << "\n";
              llvm::ConstantInt *dataSize =
                  llvm::ConstantInt::get(Ctx, llvm::APInt(64, data_type_size));
              auto *dSize = cast<Value>(dataSize);
              errs() << "dSize : " << *dSize << "\n";
              llvm::Type *i32Ty = llvm::Type::getInt32Ty(Ctx);
              StoreInst *allocStore;

              if (allocation == "calloc") {
                auto *load = dyn_cast<Value>(loadInstInput);
                errs() << "Load Calloc: " << *load << "\n";
                llvm::Value *inSize32 = builder.CreateTrunc(inSize, i32Ty);
                auto *addInst = builder.CreateAdd(load, inSize32);
                errs() << "Add Inst : " << *addInst << "\n";
                llvm::Value *dSize32 = builder.CreateTrunc(dSize, i32Ty);
                auto *mulInst = builder.CreateMul(addInst, dSize32);
                errs() << "Mul Inst : " << *mulInst << "\n";
                auto *ptrToStore = allocaInst;
                allocStore = builder.CreateStore(mulInst, ptrToStore);
              } else if (allocation == "malloc") {
                auto *load = dyn_cast<Value>(loadInstInput);
                errs() << "Load Malloc: " << *load << "\n";
                llvm::Value *inSize32 = builder.CreateTrunc(inSize, i32Ty);
                auto *mulInst = builder.CreateMul(load, inSize32);
                errs() << "Mul Inst : " << *mulInst << "\n";
                errs() << "Alloc : " << *allocaInst << "\n";
                auto *ptrToStore = allocaInst;
                errs() << "ptrToStore : " << *ptrToStore << "\n";
                allocStore = builder.CreateStore(mulInst, ptrToStore);
                errs() << "allocStore : " << *allocStore << "\n";
              }
              Value *loadStore =
                  builder.CreateLoad(Type::getInt32Ty(Ctx), allocaInst);
              loadedValue =
                  builder.CreateSExt(loadStore, llvm::Type::getInt64Ty(Ctx));
              errs() << "loadedValue : " << *loadedValue << "\n";
            }
            Value *loadInst = builder.CreateLoad(type_ptr, arr);
            errs() << "Load 1 : " << *loadInst << "\n";

            //  get the int 8 pointer type_ptr

            Type *int8Ty = Type::getInt8PtrTy(Ctx);

            //  Bitcasting from Destination bits to 8 bits

            auto *bitinstDestTo8 = builder.CreateBitCast(loadInst, int8Ty);

            //  To create a call instruction for the reallocation process
            //  In this we are creating a call function which is a
            //  reallocation so that we can call the realloc function whenever
            //  needed We are first declaring the function so that there is no
            //  problem when calling the function.

            FunctionType *funcType = FunctionType::get(
                Type::getInt8PtrTy(Ctx),
                {Type::getInt8PtrTy(Ctx), Type::getInt64Ty(Ctx)}, false);
            Function *func = Function::Create(
                funcType, Function::ExternalLinkage, "realloc", M);

            //  Here functioncallee is used to call the function in the create
            //  call function

            FunctionCallee reallocFunc = M->getFunction("realloc");

            // errs()  << "Intial Size : " << initial_size
            //         << "\tRequired Index : " << required_index << "\n";

            //  Here is the process of reallocation of array and it is
            //  converted into a Constant for the createcall function

            if (idxprom == false) {
              errs() << "Require Index : " << required_index << "\n";
              if (allocation == "calloc") {
                reallocated_size =
                    (initial_size + required_index) * data_type_size;
                errs() << "Initial Size : \n"
                       << initial_size << "\n"
                       << "Calloc Size : " << reallocated_size << "\n";
              } else if (allocation == "malloc") {
                reallocated_size = initial_size * required_index;
                errs() << "Initial Size : " << initial_size << "\n"
                       << " Malloc Size : " << reallocated_size << "\n";
              }
              errs() << "Reallocated Size : " << reallocated_size << "\n";
            } 
            Constant *newSize =
                ConstantInt::get(Type::getInt64Ty(Ctx), reallocated_size);
            errs() << "new Size : " << *newSize << "\n";

            //  Here the create call function is used to call the reallocation
            //  function and point it to the pointer with the new size for the
            //  array and bitcasting it to the 32 bits from 8 bits.

            CallInst *reallocCall;

            if(idxprom){
            reallocCall =
                builder.CreateCall(reallocFunc, {bitinstDestTo8, loadedValue});
            }
            else{
              reallocCall =
                builder.CreateCall(reallocFunc, {bitinstDestTo8, newSize});
            }
            auto *bitinst8ToDest = builder.CreateBitCast(reallocCall, type_ptr);

            //  The bit casted value is stored and the unreachable statement
            //  is pushed into the vector.

            auto *storeInst = builder.CreateStore(bitinst8ToDest, arr);
            instructions.push_back(next);

            //  To access previous block and get the terminator and create a
            //  break statement to the next basic block

            auto *prevBB = bb->getPrevNode();
            if (prevBB != nullptr) {
              auto *lastInst = prevBB->getTerminator();
              if (lastInst) {

                //  Get the 1st successor of the previous block and add it to
                //  the break statement

                BasicBlock *target = lastInst->getSuccessor(1);
                IRBuilder<> builder(next);
                Instruction *BrInst = builder.CreateBr(target);
                lastInst->replaceAllUsesWith(BrInst);
              }
            }

            //  To access the next basic block

            auto *nextBB = bb->getNextNode();

            //  To get the first instruction of the basic block

            Instruction *firstInst = &(*nextBB->getFirstInsertionPt());

            //  Set the first instruction as the insert point for the
            //  instructions

            builder.SetInsertPoint(firstInst);

            if (nextBB != nullptr) {

              //  Create the load instruction to load the array with
              //  reallocated size

              auto *loadInst = builder.CreateLoad(type_ptr, arr);

              // Convert the required index from int to ConstantInt

              auto *Idx =
                  ConstantInt::get(Type::getInt64Ty(Ctx), required_index);

              //  Get Element Pointer instruction is created to access the
              //  required index of the array with reallocated size

              auto *GEP = builder.CreateGEP(type, loadInst, Idx);

              //  To check whether the next instruction is store and set the
              //  operand to the newly created GEP.

              auto *storeInst = loadInst->getNextNode()->getNextNode();
              if (isa<StoreInst>(storeInst)) {
                storeInst->setOperand(1, GEP);
              }
            }
          }
        }
      }
    }
  }

  //  To delete the unwanted/unused instruction from the IR which is stored in
  //  vector.
  for (auto *i : instructions) {
    i->eraseFromParent();
  }
  return PreservedAnalyses::all();
}
