; ModuleID = 'A2-ex3-test.c'
source_filename = "A2-ex3-test.c"
target datalayout = "e-m:e-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

; Function Attrs: nounwind uwtable
define i32 @unsafe_func(i64) local_unnamed_addr #0 {
  %2 = alloca i32, i64 %0, align 16
  %3 = call i32 @f(i32* nonnull %2) #4
  ret i32 %3
}

declare i32 @f(i32*) local_unnamed_addr #1

; Function Attrs: nounwind uwtable
define i32 @safe_func(i64) local_unnamed_addr #0 {
  %2 = icmp ult i64 %0, 100
  br i1 %2, label %3, label %4

; <label>:3:                                      ; preds = %1
  tail call void @abort() #5
  unreachable

; <label>:4:                                      ; preds = %1
  %5 = alloca i32, i64 %0, align 16
  %6 = call i32 @f(i32* nonnull %5) #4
  ret i32 %6
}

; Function Attrs: noreturn nounwind
declare void @abort() local_unnamed_addr #2

; Function Attrs: nounwind uwtable
define i32 @unsafe_func_2(i64, i32) local_unnamed_addr #0 {
  %3 = icmp sgt i32 %1, 100
  br i1 %3, label %4, label %5

; <label>:4:                                      ; preds = %2
  tail call void @abort() #5
  unreachable

; <label>:5:                                      ; preds = %2
  %6 = alloca i32, i64 %0, align 16
  %7 = call i32 @f(i32* nonnull %6) #4
  ret i32 %7
}

; Function Attrs: nounwind uwtable
define i32 @const_func() local_unnamed_addr #0 {
  %1 = alloca [10 x i32], align 16
  %2 = bitcast [10 x i32]* %1 to i8*
  call void @llvm.lifetime.start(i64 40, i8* nonnull %2) #4
  %3 = getelementptr inbounds [10 x i32], [10 x i32]* %1, i64 0, i64 0
  %4 = call i32 @f(i32* nonnull %3) #4
  call void @llvm.lifetime.end(i64 40, i8* nonnull %2) #4
  ret i32 %4
}

; Function Attrs: argmemonly nounwind
declare void @llvm.lifetime.start(i64, i8* nocapture) #3

; Function Attrs: argmemonly nounwind
declare void @llvm.lifetime.end(i64, i8* nocapture) #3

; Function Attrs: nounwind uwtable
define i32 @ult_safe_func(i64) local_unnamed_addr #0 {
  %2 = icmp ult i64 %0, 1000
  br i1 %2, label %3, label %6

; <label>:3:                                      ; preds = %1
  %4 = alloca i32, i64 %0, align 16
  %5 = call i32 @f(i32* nonnull %4) #4
  ret i32 %5

; <label>:6:                                      ; preds = %1
  tail call void @abort() #5
  unreachable
}

; Function Attrs: nounwind uwtable
define i32 @ult_unsafe_func(i64) local_unnamed_addr #0 {
  %2 = icmp ult i64 %0, 1001
  br i1 %2, label %3, label %6

; <label>:3:                                      ; preds = %1
  %4 = alloca i32, i64 %0, align 16
  %5 = call i32 @f(i32* nonnull %4) #4
  ret i32 %5

; <label>:6:                                      ; preds = %1
  tail call void @abort() #5
  unreachable
}

; Function Attrs: nounwind uwtable
define i32 @ule_safe_func(i64) local_unnamed_addr #0 {
  %2 = icmp ult i64 %0, 1000
  br i1 %2, label %3, label %6

; <label>:3:                                      ; preds = %1
  %4 = alloca i32, i64 %0, align 16
  %5 = call i32 @f(i32* nonnull %4) #4
  ret i32 %5

; <label>:6:                                      ; preds = %1
  tail call void @abort() #5
  unreachable
}

; Function Attrs: nounwind uwtable
define i32 @ule_unsafe_func(i64) local_unnamed_addr #0 {
  %2 = icmp ult i64 %0, 1001
  br i1 %2, label %3, label %6

; <label>:3:                                      ; preds = %1
  %4 = alloca i32, i64 %0, align 16
  %5 = call i32 @f(i32* nonnull %4) #4
  ret i32 %5

; <label>:6:                                      ; preds = %1
  tail call void @abort() #5
  unreachable
}

; Function Attrs: nounwind uwtable
define i32 @ult32_safe_func(i32) local_unnamed_addr #0 {
  %2 = icmp ult i32 %0, 1000
  br i1 %2, label %3, label %7

; <label>:3:                                      ; preds = %1
  %4 = zext i32 %0 to i64
  %5 = alloca i32, i64 %4, align 16
  %6 = call i32 @f(i32* nonnull %5) #4
  ret i32 %6

; <label>:7:                                      ; preds = %1
  tail call void @abort() #5
  unreachable
}

; Function Attrs: nounwind uwtable
define i32 @ult32_unsafe_func(i32) local_unnamed_addr #0 {
  %2 = icmp ult i32 %0, 1001
  br i1 %2, label %3, label %7

; <label>:3:                                      ; preds = %1
  %4 = zext i32 %0 to i64
  %5 = alloca i32, i64 %4, align 16
  %6 = call i32 @f(i32* nonnull %5) #4
  ret i32 %6

; <label>:7:                                      ; preds = %1
  tail call void @abort() #5
  unreachable
}

; Function Attrs: nounwind uwtable
define i32 @ult64_safe_func(i64) local_unnamed_addr #0 {
  %2 = icmp ult i64 %0, 1000
  br i1 %2, label %3, label %6

; <label>:3:                                      ; preds = %1
  %4 = alloca i32, i64 %0, align 16
  %5 = call i32 @f(i32* nonnull %4) #4
  ret i32 %5

; <label>:6:                                      ; preds = %1
  tail call void @abort() #5
  unreachable
}

; Function Attrs: nounwind uwtable
define i32 @ult64_unsafe_func(i64) local_unnamed_addr #0 {
  %2 = icmp ult i64 %0, 1001
  br i1 %2, label %3, label %6

; <label>:3:                                      ; preds = %1
  %4 = alloca i32, i64 %0, align 16
  %5 = call i32 @f(i32* nonnull %4) #4
  ret i32 %5

; <label>:6:                                      ; preds = %1
  tail call void @abort() #5
  unreachable
}

; Function Attrs: nounwind uwtable
define i32 @slt32_safe_func(i32) local_unnamed_addr #0 {
  %2 = icmp slt i32 %0, 1000
  br i1 %2, label %3, label %7

; <label>:3:                                      ; preds = %1
  %4 = zext i32 %0 to i64
  %5 = alloca i32, i64 %4, align 16
  %6 = call i32 @f(i32* nonnull %5) #4
  ret i32 %6

; <label>:7:                                      ; preds = %1
  tail call void @abort() #5
  unreachable
}

; Function Attrs: nounwind uwtable
define i32 @slt32_unsafe_func(i32) local_unnamed_addr #0 {
  %2 = icmp slt i32 %0, 1001
  br i1 %2, label %3, label %7

; <label>:3:                                      ; preds = %1
  %4 = zext i32 %0 to i64
  %5 = alloca i32, i64 %4, align 16
  %6 = call i32 @f(i32* nonnull %5) #4
  ret i32 %6

; <label>:7:                                      ; preds = %1
  tail call void @abort() #5
  unreachable
}

; Function Attrs: nounwind uwtable
define i32 @slt64_safe_func(i64) local_unnamed_addr #0 {
  %2 = icmp slt i64 %0, 1000
  br i1 %2, label %3, label %6

; <label>:3:                                      ; preds = %1
  %4 = alloca i32, i64 %0, align 16
  %5 = call i32 @f(i32* nonnull %4) #4
  ret i32 %5

; <label>:6:                                      ; preds = %1
  tail call void @abort() #5
  unreachable
}

; Function Attrs: nounwind uwtable
define i32 @slt64_unsafe_func(i64) local_unnamed_addr #0 {
  %2 = icmp slt i64 %0, 1001
  br i1 %2, label %3, label %6

; <label>:3:                                      ; preds = %1
  %4 = alloca i32, i64 %0, align 16
  %5 = call i32 @f(i32* nonnull %4) #4
  ret i32 %5

; <label>:6:                                      ; preds = %1
  tail call void @abort() #5
  unreachable
}

; Function Attrs: nounwind uwtable
define i32 @nested_cond_safe_func(i64) local_unnamed_addr #0 {
  %2 = icmp slt i64 %0, 1000
  br i1 %2, label %3, label %6

; <label>:3:                                      ; preds = %1
  %4 = alloca i32, i64 %0, align 16
  %5 = call i32 @f(i32* nonnull %4) #4
  ret i32 %5

; <label>:6:                                      ; preds = %1
  tail call void @abort() #5
  unreachable
}

; Function Attrs: nounwind uwtable
define i32 @nested_cond_unsafe_func(i64) local_unnamed_addr #0 {
  %2 = icmp slt i64 %0, 1100
  br i1 %2, label %3, label %6

; <label>:3:                                      ; preds = %1
  %4 = alloca i32, i64 %0, align 16
  %5 = call i32 @f(i32* nonnull %4) #4
  ret i32 %5

; <label>:6:                                      ; preds = %1
  tail call void @abort() #5
  unreachable
}

; Function Attrs: nounwind uwtable
define i32 @two_vars_unsafe_func(i64) local_unnamed_addr #0 {
  %2 = and i64 %0, 4294967295
  %3 = alloca i32, i64 %2, align 16
  %4 = call i32 @f(i32* nonnull %3) #4
  ret i32 %4
}

; Function Attrs: nounwind uwtable
define i32 @two_vla_unsafe_func(i64, i32) local_unnamed_addr #0 {
  %3 = icmp sgt i32 %1, 100
  br i1 %3, label %4, label %5

; <label>:4:                                      ; preds = %2
  tail call void @abort() #5
  unreachable

; <label>:5:                                      ; preds = %2
  %6 = alloca i32, i64 %0, align 16
  %7 = alloca i32, i64 %0, align 16
  %8 = call i32 @f(i32* nonnull %6) #4
  %9 = call i32 @f(i32* nonnull %7) #4
  %10 = add nsw i32 %9, %8
  ret i32 %10
}

attributes #0 = { nounwind uwtable "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "less-precise-fpmad"="false" "no-frame-pointer-elim"="false" "no-infs-fp-math"="false" "no-jump-tables"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #1 = { "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "less-precise-fpmad"="false" "no-frame-pointer-elim"="false" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #2 = { noreturn nounwind "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "less-precise-fpmad"="false" "no-frame-pointer-elim"="false" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #3 = { argmemonly nounwind }
attributes #4 = { nounwind }
attributes #5 = { noreturn nounwind }

!llvm.ident = !{!0}

!0 = !{!"clang version 4.0.1-10 (tags/RELEASE_401/final)"}
