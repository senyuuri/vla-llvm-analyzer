#include "llvm/Pass.h"
#include "llvm/IR/LLVMContext.h"
#include "llvm/IR/Module.h"
#include "llvm/IR/Function.h"
#include "llvm/IR/Instructions.h"
#include "llvm/IR/InstrTypes.h"
#include "llvm/IR/ValueSymbolTable.h"
#include "llvm/IR/Instruction.h"
#include "llvm/IRReader/IRReader.h"
#include "llvm/Support/SourceMgr.h"
#include "llvm/Support/raw_ostream.h"

#include <iostream>
#include <vector>
#include <set>
#include <map>
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
		vector<ZExtInst *> zextVector;
	    for (auto &BB: F)
	    {  // For each basic block BB
	      	for (auto &I: BB) 
	      	{  // For each instruction I
		      	uint8_t numOperands = I.getNumOperands();
		      	auto *Inst = dyn_cast<AllocaInst>(&I);
			    if (Inst != nullptr) // highlight alloca instruction
			    { 
			     	// alloc only have 1 operand
					Value *V = I.getOperand(0);
					const Constant *CV = dyn_cast<Constant>(V);
					if (CV) 
					{
						// not VLA
						continue;
					}
					else
					{
						// if the opreand of alloca is i32, llvm will zero-extend it to i64
						// in such case we will trace the constrain of the original i32 SSA
						for(auto &ZV: zextVector)
						{
							// instructions are also values in llvm
							if(V == ZV)
								V = ZV->getOperand(0);
						} 
						uint64_t len_max = 0;
						uint8_t user_count = 0;
						for (User *U : V->users()) {
							// iterate through all users of the value 
							if (Instruction *Inst = dyn_cast<Instruction>(U)) {
							  	if (auto *Icmp = dyn_cast<ICmpInst>(Inst)){
							  		auto *V1 = Icmp->getOperand(0);
									auto *V2 = Icmp->getOperand(1);
									// for simplicity, the analysis only consider conditionals of the form
	  								// len<K or len<=K for some constant k.
									switch(Icmp->getPredicate()){
										case CmpInst::ICMP_ULT:
										case CmpInst::ICMP_SLT:
											if(Constant *CV2 = dyn_cast<Constant>(V2)){
												uint64_t val = CV2->getUniqueInteger().getLimitedValue();
												// update constrains
												if(val > len_max){
													len_max = val;
												}
											}
											break;
										default:
											break;
									}
							  		
							  	}
							}
						}
						if(len_max > 1000 || len_max == 0){
							errs() << "unsafe var lenth stack alloc: "<<F.getName() <<":";
							errs() << I << "\n";
						}
					}
				}
				// save all zext instructions that we have encountered so far
				// used later to trace the users of the original i32 SSA 
				ZExtInst *zextInst = dyn_cast<ZExtInst>(&I);
			    if (zextInst != nullptr)
			    {
			    	zextVector.push_back(zextInst);
			    } 
			}
		}
	}

}
