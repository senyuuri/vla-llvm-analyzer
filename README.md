# LLVM-based Analyzer for VLA(Variable Length Array)

> This project is part of CS4239 Software Security's coursework. 

Author: @senyuuri, @difeng_tang

This project is a simple LLVM-based static analyzer that detects unsafe VLAs(variable length array) at three different levels. 

### 1. Build

Source code of the assignment is placed under the directory `/src`. To compile, make sure you have llvm4.0 installed and run the commands below.
```
./runclang.sh A2-ex1.cp -o A2-ex1
./runclang.sh A2-ex2.cp -o A2-ex2
./runclang.sh A2-ex3.cp -o A2-ex3
```

### 2. Test

We have prepared some test cases in _/test_. To begin the test, firstly convert the test code to LLVM IR (.ll) files:
```
clang-4.0 -emit-llvm -S -O1 -c A2-ex1-test.c
clang-4.0 -emit-llvm -S -O1 -c A2-ex2-test.c
clang-4.0 -emit-llvm -S -O1 -c A2-ex3-test.c
```

Then feed the .ll file to the executables as an argument such as:

> ./ex1 ../test/ex1-test.ll

### 3. Implementation Details

#### 3.1 Task 1: Detect All VLAs

`ex1.cpp` transverse through every instructions generated from the LLVM IR(.ll) file and checked for its instruction type using `dyn_cast<AllocaInst>`. The `dyn_cast` returns an `AllocaInst` object if an `alloca` instruction is found. Otherwise, `null` pointer is returned.

`AllocaInst` contains 1 operand which indicates the number of elements to be allocated. Hence, by using the `getOperand()` method to obtain the `Value` object and `dyn_cast` it to check for `Constant` object type, we will be able to differentiate a VLA from a fixed length array.




**List of Test Cases (ex1-test.c)**



#### 3.2 Task 2: Detect Unsafe VLAs in the Same Basic Block

`ex2.cp` is a modification from `ex1.cp` which detects some unsafe VLAs using simple heuristics. In this program, VLAs are considered unsafe if it the length variable originates from the same basic block.

As we iterate through instructions in a function, pointers to these instructions are stored in `vector<Instruction *> instVector` for later reference. Once we encounter an `alloca` instruction, we perform two heuristics tests on its operand `V`:

1.`*V` is compared with all instruction pointers in `instVector`. If any of the two are equivalent(line 59)1, that means the operand `*V` must originate from that instruction. We then use `getParent()`to find out which basic block does that instruction belong to. If the obtained basic block is different from the current block, `V` must be created in other basic blocks and the VLA is considered safe.
>  We are comparing a pointer to llvm::Value with a pointer to llvm::Instruction in order to find whether a value has been on the left-hand-side(LHS) of an instruction. Such comparison is possible because llvm::Instruction inherits from llvm::alue. The result of an instruction is stored as its value.

2. Use llvm's `users()` method to find out instructions that have used `V` as an operand. If the first heuristics could not determine the safety of the VLA and the total number of `V`'s users is 1, it can be inferred that `V` is only used by `alloca`. Hence, the length of the VLA must originates either from the same block or from the function parameters, which is unsafe.



**List of Test Cases (ex2-test.c)**

#### 3.3 Task 3: Detect Unsafe VLAs using Program Analysis

`ex3.cp` detects unsafe VLAs with lengths that are not constrained below a bound of 1000 (<1000). More specifically, the program is able to trace and analyse:


- Conditional of the form len\<K or len\<=K. In terms of the condition code of the icmp instruction2, it supports `ult`, `ule`, `slt`, `sle`.
- Multiple nested conditionals
- Multiple unsafe VLAs in a function
- Various types of VLA length, including `size_t`, `uint32_t`, `uint64_t`, `int32_t`, `int64_t`

> For a complete list of icmp condition codes, see https://llvm.org/docs/LangRef.html#icmp-instruction
 
To evaluate constraints on the length,  the program first identify all VLAs using the method from task 1. For each `alloca` instruction, we iterate through the def-use chain of the operands to find if any of the users is `IcmpInst` (i.e. icmp instruction), which represents the if-conditionals that involves the VLA's length. For each of the `IcmpInst`, we compare the conditional with the existing length constraints `len_max` and update it when necessary.

A VLA is considered unsafe if its `len_max` falls under any of the following categories:

- `len_max == 0`: `len_max` does not change, meaning there is no constraint on the length variable.
- `len_max > 1000`: the VLA is too large to be safe.



**Coping with LLVM Optimisation**

LLVM compiler may discard unnecessary portions of code based on the optimization level stated which may affect the our analysis. By using O1 optimization, we have observed the following two forms changes at the IR level:

1. LLVM replaces predicates for some icmp instructions. More specifically, `ule` is changed to `ult` and `sle` is changed to `slt` while the operand is increased by 1. For example, as shown in the screenshot below, the original condition `len<=1000` is replaced by `len < 1001` during compilation.

Given such optimisation convention, we actually have less icmp predicates to worry about. In line 75-76 of `ex3.cp`, although the switch case only contains `CmpInst::ICMP_ULT` and `CmpInst::ICMP_SLT`, the program can correctly handle `ule` and `sle` as well.

2. LLVM zero-extends variables from `i32` to `i64` before it is used by the alloca instruction. Although this enhances the overall security by eliminating potential sign extension issues, it adds difficulties to program analysis since we will loss track of the def-use chain of the length variable. For instance, in the code below, `alloca` uses `%4` as an operand. However, `%4` is actually converted from `%0` in the previous line. If we trace the def-use chain of `%4`, we are unable to obtain constraints that have been applied to `%0`.

 
**Design of Test Cases**

The design of test cases are based on branch condition testing, unsigned/signed integers, same/different basic blocks, boundary testing and fixed/variable length array. Some complicated test scenarios such as nested constraints and detecting multiple unsafe alloca Instructions.

**List of Test Cases (ex3-test.c)**


