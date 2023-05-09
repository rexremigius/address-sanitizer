#include "AddressSanitizer.h"
#include "llvm/IR/Function.h"
#include "llvm/IR/IRBuilder.h"
#include "llvm/IR/Instructions.h"
#include "llvm/IR/Value.h"
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
  int64_t initial_size = 0;
  int64_t data_type_size = 4;
  int64_t reallocated_size = 0;
  string allocation;
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

        if (isa<GetElementPtrInst>(inst)) {
          auto *req_index = inst->getOperand(1);
          // auto *typePtr = inst->getType();
          // type = typePtr->getPointerElementType();
          if (req_index->getName().str().find("idxprom") != string::npos) {
            auto *idxprom = dyn_cast<Instruction>(req_index)->getOperand(0);
            errs() << "idxprom : " << *idxprom << "\n";
            auto *index = dyn_cast<Instruction>(idxprom)->getOperand(0);
            errs() << "index : " << *index << "\n";
              //auto *require_index =dyn_cast<Instruction>(index);
            // auto* gepInst = dyn_cast<GetElementPtrInst>(require_index->getPointerOperand());
              auto *constantExp=dyn_cast<ConstantExpr>(index);
              if(isa<GlobalVariable>(constantExp->getOperand(0))){
              GlobalVariable *gVar = dyn_cast<GlobalVariable>(constantExp->getOperand(0));
              errs() << "GEP Instruction : " << *gVar << "\n";
              errs()<<"Operand Value : "<<gVar->getNumOperands()<<"\n";
              }
              else{
                
              }
          } else {
            required_index = cast<ConstantInt>(req_index)->getSExtValue();
          }
        }

        //  To check whether the instruction is a allocation instruction to get
        //  the array declaration
        // std::string instStr;
        // if (isa<AllocaInst>(inst)) {
        //   raw_string_ostream rso(instStr);
        //   inst->print(rso);
        //   StringRef instStringRef = rso.str();
        //   std::string myString = instStringRef.str();
        //   if (myString.find("*") != string::npos) {
        //     errs() << "Array Allocation : " << *inst << "\n";
        //     string arrName = inst->getNameOrAsOperand();
        //     arrSet.insert(make_pair(arrName, inst));
        //   }
        // }
        //  To check whether the instruction is a call instruction and get the
        //  initial index from the calloc call and also check for the
        //  asan_report and perform the reallocation instrumentation
        //  Check whether the dynamic allocation is malloc or calloc

        if (isa<CallInst>(inst)) {
          auto *callInst = dyn_cast<CallInst>(inst);
          string call_inst = callInst->getCalledFunction()->getName().str();
          if ((call_inst.find("calloc") != string::npos)) {
            auto *initial_index = callInst->getOperand(0);
            initial_size = cast<ConstantInt>(initial_index)->getSExtValue();
            auto *dataTypeSize = callInst->getOperand(1);
            data_type_size = cast<ConstantInt>(dataTypeSize)->getSExtValue();
            allocation = call_inst;

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
            initial_size = cast<ConstantInt>(initial_index)->getSExtValue();
            allocation = call_inst;
          }

          //  To check whether it is a asan_report
          if (call_inst.find("__asan_report_") != string::npos) 
          {
          
            auto *ptrInst = dyn_cast<Instruction>(callInst->getArgOperand(0));
            auto *arrIdx = dyn_cast<Instruction>(ptrInst->getOperand(0));
            auto *gep = dyn_cast<Instruction>(arrIdx->getOperand(0));
            auto *arrReq = dyn_cast<Instruction>(gep->getOperand(0));
            type_ptr = gep->getType();
            type = type_ptr->getPointerElementType();
            errs() << "Arr Req : " << *arrReq << "\n";
            arr = dyn_cast<Value>(arrReq);

            errs() << "Required Array : " << *arr << "\n";

            auto *next = callInst->getNextNode();
            errs() << "Next : " << *next << "\n";
            // Memory reallocation instrumentation code.

            IRBuilder<> builder(next);

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
            errs()<<"Require Index : "<<required_index<<"\n";
            if (allocation == "calloc") {
              reallocated_size =(initial_size + required_index) * data_type_size;
            } else if (allocation == "malloc") {
              reallocated_size = initial_size * required_index;
            }
            errs()<<"Reallocated Size : "<<reallocated_size<<"\n";
            Constant *newSize =
                ConstantInt::get(Type::getInt64Ty(Ctx), reallocated_size);
            errs()<<"new Size : "<<*newSize<<"\n";
            //  Here the create call function is used to call the reallocation
            //  function and point it to the pointer with the new size for the
            //  array and bitcasting it to the 32 bits from 8 bits.

            auto *reallocCall =
                builder.CreateCall(reallocFunc, {bitinstDestTo8, newSize});
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
