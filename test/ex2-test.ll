; ModuleID = 'A2-ex2-test.c'
source_filename = "A2-ex2-test.c"
target datalayout = "e-m:e-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-pc-linux-gnu"

; Function Attrs: nounwind uwtable
define i32 @unsafe_func(i64) local_unnamed_addr #0 {
  %2 = alloca i32, i64 %0, align 16
  %3 = call i32 @f(i32* nonnull %2) #5
  ret i32 %3
}

declare i32 @f(i32*) local_unnamed_addr #1

; Function Attrs: nounwind uwtable
define i32 @safe_func(i64) local_unnamed_addr #0 {
  %2 = icmp ugt i64 %0, 100
  br i1 %2, label %3, label %4

; <label>:3:                                      ; preds = %1
  tail call void @abort() #6
  unreachable

; <label>:4:                                      ; preds = %1
  %5 = alloca i32, i64 %0, align 16
  %6 = call i32 @f(i32* nonnull %5) #5
  ret i32 %6
}

; Function Attrs: noreturn nounwind
declare void @abort() local_unnamed_addr #2

; Function Attrs: nounwind uwtable
define i32 @unsafe_func_2(i64, i32) local_unnamed_addr #0 {
  %3 = icmp sgt i32 %1, 100
  br i1 %3, label %4, label %5

; <label>:4:                                      ; preds = %2
  tail call void @abort() #6
  unreachable

; <label>:5:                                      ; preds = %2
  %6 = alloca i32, i64 %0, align 16
  %7 = call i32 @f(i32* nonnull %6) #5
  ret i32 %7
}

; Function Attrs: nounwind uwtable
define i32 @const_func() local_unnamed_addr #0 {
  %1 = alloca [10 x i32], align 16
  %2 = bitcast [10 x i32]* %1 to i8*
  call void @llvm.lifetime.start(i64 40, i8* nonnull %2) #5
  %3 = getelementptr inbounds [10 x i32], [10 x i32]* %1, i64 0, i64 0
  %4 = call i32 @f(i32* nonnull %3) #5
  call void @llvm.lifetime.end(i64 40, i8* nonnull %2) #5
  ret i32 %4
}

; Function Attrs: argmemonly nounwind
declare void @llvm.lifetime.start(i64, i8* nocapture) #3

; Function Attrs: argmemonly nounwind
declare void @llvm.lifetime.end(i64, i8* nocapture) #3

; Function Attrs: nounwind uwtable
define i32 @same_blK_assign_unsafe_func(i64, i32) local_unnamed_addr #0 {
  %3 = icmp sgt i32 %1, 100
  br i1 %3, label %4, label %5

; <label>:4:                                      ; preds = %2
  tail call void @abort() #6
  unreachable

; <label>:5:                                      ; preds = %2
  %6 = tail call i32 @rand() #5
  %7 = srem i32 %6, 10
  %8 = add nsw i32 %7, 1
  %9 = zext i32 %8 to i64
  %10 = alloca i32, i64 %9, align 16
  %11 = call i32 @f(i32* nonnull %10) #5
  ret i32 %11
}

; Function Attrs: nounwind
declare i32 @rand() local_unnamed_addr #4

; Function Attrs: nounwind uwtable
define i32 @diff_blK_assign_safe_func(i64, i32) local_unnamed_addr #0 {
  %3 = shl i64 %0, 1
  %4 = icmp ult i64 %0, 100
  br i1 %4, label %5, label %11

; <label>:5:                                      ; preds = %2
  %6 = icmp sgt i32 %1, 100
  br i1 %6, label %7, label %8

; <label>:7:                                      ; preds = %5
  tail call void @abort() #6
  unreachable

; <label>:8:                                      ; preds = %5
  %9 = alloca i32, i64 %3, align 16
  %10 = call i32 @f(i32* nonnull %9) #5
  ret i32 %10

; <label>:11:                                     ; preds = %2
  tail call void @abort() #6
  unreachable
}

attributes #0 = { nounwind uwtable "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "less-precise-fpmad"="false" "no-frame-pointer-elim"="false" "no-infs-fp-math"="false" "no-jump-tables"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #1 = { "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "less-precise-fpmad"="false" "no-frame-pointer-elim"="false" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #2 = { noreturn nounwind "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "less-precise-fpmad"="false" "no-frame-pointer-elim"="false" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #3 = { argmemonly nounwind }
attributes #4 = { nounwind "correctly-rounded-divide-sqrt-fp-math"="false" "disable-tail-calls"="false" "less-precise-fpmad"="false" "no-frame-pointer-elim"="false" "no-infs-fp-math"="false" "no-nans-fp-math"="false" "no-signed-zeros-fp-math"="false" "no-trapping-math"="false" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+fxsr,+mmx,+sse,+sse2,+x87" "unsafe-fp-math"="false" "use-soft-float"="false" }
attributes #5 = { nounwind }
attributes #6 = { noreturn nounwind }

!llvm.ident = !{!0}

!0 = !{!"clang version 4.0.1-10 (tags/RELEASE_401/final)"}
