#include "llvm/Pass.h"
#include "llvm/IR/LLVMContext.h"
#include "llvm/IR/Module.h"
#include "llvm/IR/Function.h"
#include "llvm/IR/Instructions.h"
#include "llvm/IR/Instruction.h"
#include "llvm/IRReader/IRReader.h"
#include "llvm/Support/SourceMgr.h"
#include "llvm/ADT/APFloat.h"
#include "llvm/Support/Regex.h"
#include "llvm/Support/raw_ostream.h"
#include <iostream>
#include <set>
#include <string>

using namespace llvm;
using namespace std;

int main(int argc, char **argv)
{
    LLVMContext Context;
    SMDiagnostic Err;
    auto M = parseIRFile(argv[1], Err, Context);
    raw_ostream *out = &outs();
    if (!M)
    {
        cerr << "error: failed to read IR file \"" << argv[1] << '\"' << endl;
        return 1;
    }
  
    // Step (2) Traverse all instructions
    for (auto &F: *M)     // For each function F
        for (auto &BB: F)   // For each basic block BB
            for (auto &I: BB) // For each instruction I
            {
                //I.dump(); // dump the instruction
                auto *Inst = dyn_cast<AllocaInst>(&I);
                if (Inst != nullptr && Inst->isArrayAllocation()) {// highlight alloca instruction
            	    //1 Operand in AllocaInst
            	    auto *V = I.getOperand(0);
            	    const Constant *CV = dyn_cast<Constant>(V);
            	    if(CV && !isa<GlobalValue>(CV)) {
                		//Length == Constant
                		//cerr << "Variable Length is a Constant \n";
            	    } else {
                		//VLA
                		*out << "var length stack alloc: " << F.getName().str() << ":";
                		I.print(*out, false);
                		*out << "\n";
            	    }  
                }   
            }
}
