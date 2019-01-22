#include "llvm/Pass.h"
#include "llvm/IR/LLVMContext.h"
#include "llvm/IR/Module.h"
#include "llvm/IR/Function.h"
#include "llvm/IR/Instructions.h"
#include "llvm/IR/ValueSymbolTable.h"
#include "llvm/IR/Instruction.h"
#include "llvm/IRReader/IRReader.h"
#include "llvm/Support/SourceMgr.h"
#include "llvm/Support/raw_ostream.h"

// ..
#include <vector>
#include <iostream>
#include <set>
#include <stdio.h>

using namespace llvm;
using namespace std;

int main(int argc, char **argv)
{
  // Step (1) Parse the given IR File
	LLVMContext Context;
	SMDiagnostic Err;
	auto M = parseIRFile(argv[1], Err, Context);
	if (!M)
	{
		cerr << "error: failed to read IR file \"" << argv[1] << '\"' << endl;
		return 1;
	}

	// Step (2) Traverse all instructions
	for (auto &F: *M)
	{     
	  	vector<Instruction *> instVector;
	    for (auto &BB: F)
	    {  // For each basic block BB
	      	for (auto &I: BB) 
	      	{  // For each instruction I
		      	uint8_t numOperands = I.getNumOperands();
		      	auto *Inst = dyn_cast<AllocaInst>(&I);
		      	bool isSafe = false;
			    if (Inst != nullptr) // highlight alloca instruction
			    { 
			     	// alloc only have 1 operand
					auto *V = I.getOperand(0);
					const Constant *CV = dyn_cast<Constant>(V);
					if (CV) 
					{
						// not VLA
						continue;
					}
					else
					{
						// VLA
						uint8_t user_count = 0;
						for (Instruction *prevInst: instVector){
							if(V == prevInst){
								BasicBlock *B = prevInst->getParent();
							    if(B!=&BB){
							    	// the operand is created by instructions from 
							    	// other blocks
							    	// errs() << "LENGTH created in diff blk";
							    	isSafe = true;
							    } else {
							    	// errs() << "LENGTH created in same blk";
							    }
							}
						}
						for (User *U : V->users()) {
							// iterate through all users of the value 
							if (Instruction *Inst = dyn_cast<Instruction>(U)) {
							    user_count++;
							}
						}
						if(!isSafe && user_count == 1){
							// the varible is either a function pointer or
							// originates from the same block
							errs() << "unsafe var lenth stack alloc: "<<F.getName() <<":";
							errs() << I << "\n";
						}
					}
				} 
				else
				{
					instVector.push_back(&I);
				}
			}
		}
	}

}
