#! /bin/bash
clang++-4.0 $* -Wno-unknown-warning-option `llvm-config-4.0 --cxxflags` `llvm-config-4.0 --ldflags` `llvm-config-4.0 --libs` 
