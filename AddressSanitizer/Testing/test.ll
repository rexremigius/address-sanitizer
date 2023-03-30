; ModuleID = 'ex.c'
source_filename = "ex.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-gnu"

@.str = internal constant { [4 x i8], [28 x i8] } { [4 x i8] c"%p\0A\00", [28 x i8] zeroinitializer }, align 32
@___asan_gen_ = private constant [5 x i8] c"ex.c\00", align 1
@___asan_gen_.1 = private unnamed_addr constant [17 x i8] c"<string literal>\00", align 1
@___asan_gen_.2 = private unnamed_addr constant [5 x i8] c"ex.c\00", align 1
@___asan_gen_.3 = private unnamed_addr constant { [5 x i8]*, i32, i32 } { [5 x i8]* @___asan_gen_.2, i32 6, i32 9 }
@llvm.compiler.used = appending global [1 x i8*] [i8* getelementptr inbounds ({ [4 x i8], [28 x i8] }, { [4 x i8], [28 x i8] }* @.str, i32 0, i32 0, i32 0)], section "llvm.metadata"
@0 = internal global [1 x { i64, i64, i64, i64, i64, i64, i64, i64 }] [{ i64, i64, i64, i64, i64, i64, i64, i64 } { i64 ptrtoint ({ [4 x i8], [28 x i8] }* @.str to i64), i64 4, i64 32, i64 ptrtoint ([17 x i8]* @___asan_gen_.1 to i64), i64 ptrtoint ([5 x i8]* @___asan_gen_ to i64), i64 0, i64 ptrtoint ({ [5 x i8]*, i32, i32 }* @___asan_gen_.3 to i64), i64 -1 }]
@llvm.used = appending global [2 x i8*] [i8* bitcast (void ()* @asan.module_ctor to i8*), i8* bitcast (void ()* @asan.module_dtor to i8*)], section "llvm.metadata"
@llvm.global_ctors = appending global [1 x { i32, void ()*, i8* }] [{ i32, void ()*, i8* } { i32 1, void ()* @asan.module_ctor, i8* null }]
@llvm.global_dtors = appending global [1 x { i32, void ()*, i8* }] [{ i32, void ()*, i8* } { i32 1, void ()* @asan.module_dtor, i8* null }]

; Function Attrs: noinline nounwind sanitize_address uwtable
define dso_local i32 @main() #0 {
entry:
  %retval = alloca i32, align 4
  %x = alloca i32*, align 8
  store i32 0, i32* %retval, align 4
  %0 = bitcast i32** %x to i8*
  call void @llvm.lifetime.start.p0i8(i64 8, i8* %0) #6
  %call = call noalias i8* @calloc(i64 noundef 10, i64 noundef 4) #6
  %1 = bitcast i8* %call to i32*
  store i32* %1, i32** %x, align 8
  %2 = load i32*, i32** %x, align 8
  %arrayidx = getelementptr inbounds i32, i32* %2, i64 11
  %3 = ptrtoint i32* %arrayidx to i64
  %4 = lshr i64 %3, 3
  %5 = add i64 %4, 2147450880
  %6 = inttoptr i64 %5 to i8*
  %7 = load i8, i8* %6, align 1
  %8 = icmp ne i8 %7, 0
  br i1 %8, label %9, label %15, !prof !6

9:                                                ; preds = %entry
  %10 = and i64 %3, 7
  %11 = add i64 %10, 3
  %12 = trunc i64 %11 to i8
  %13 = icmp sge i8 %12, %7
  br i1 %13, label %14, label %15

14:                                               ; preds = %9
  call void @__asan_report_store4(i64 %3) #7
  unreachable

15:                                               ; preds = %9, %entry
  store i32 20, i32* %arrayidx, align 4
  %16 = load i32*, i32** %x, align 8
  %arrayidx1 = getelementptr inbounds i32, i32* %16, i64 11
  %17 = ptrtoint i32* %arrayidx1 to i64
  %18 = lshr i64 %17, 3
  %19 = add i64 %18, 2147450880
  %20 = inttoptr i64 %19 to i8*
  %21 = load i8, i8* %20, align 1
  %22 = icmp ne i8 %21, 0
  br i1 %22, label %23, label %29, !prof !6

23:                                               ; preds = %15
  %24 = and i64 %17, 7
  %25 = add i64 %24, 3
  %26 = trunc i64 %25 to i8
  %27 = icmp sge i8 %26, %21
  br i1 %27, label %28, label %29

28:                                               ; preds = %23
  call void @__asan_report_load4(i64 %17) #7
  unreachable

29:                                               ; preds = %23, %15
  %30 = load i32, i32* %arrayidx1, align 4
  %call2 = call i32 (i8*, ...) @printf(i8* noundef getelementptr inbounds ({ [4 x i8], [28 x i8] }, { [4 x i8], [28 x i8] }* @.str, i32 0, i32 0, i64 0), i32 noundef %30)
  %31 = load i32*, i32** %x, align 8
  %32 = bitcast i32* %31 to i8*
  call void @free(i8* noundef %32) #6
  %33 = bitcast i32** %x to i8*
  call void @llvm.lifetime.end.p0i8(i64 8, i8* %33) #6
  ret i32 0
}

; Function Attrs: argmemonly nofree nosync nounwind willreturn
declare void @llvm.lifetime.start.p0i8(i64 immarg, i8* nocapture) #1

; Function Attrs: nounwind
declare dso_local noalias i8* @calloc(i64 noundef, i64 noundef) #2

declare dso_local i32 @printf(i8* noundef, ...) #3

; Function Attrs: nounwind
declare dso_local void @free(i8* noundef) #2

; Function Attrs: argmemonly nofree nosync nounwind willreturn
declare void @llvm.lifetime.end.p0i8(i64 immarg, i8* nocapture) #1

declare void @__asan_report_load_n(i64, i64)

declare void @__asan_loadN(i64, i64)

declare void @__asan_report_load1(i64)

declare void @__asan_load1(i64)

declare void @__asan_report_load2(i64)

declare void @__asan_load2(i64)

declare void @__asan_report_load4(i64)

declare void @__asan_load4(i64)

declare void @__asan_report_load8(i64)

declare void @__asan_load8(i64)

declare void @__asan_report_load16(i64)

declare void @__asan_load16(i64)

declare void @__asan_report_store_n(i64, i64)

declare void @__asan_storeN(i64, i64)

declare void @__asan_report_store1(i64)

declare void @__asan_store1(i64)

declare void @__asan_report_store2(i64)

declare void @__asan_store2(i64)

declare void @__asan_report_store4(i64)

declare void @__asan_store4(i64)

declare void @__asan_report_store8(i64)

declare void @__asan_store8(i64)

declare void @__asan_report_store16(i64)

declare void @__asan_store16(i64)

declare void @__asan_report_exp_load_n(i64, i64, i32)

declare void @__asan_exp_loadN(i64, i64, i32)

declare void @__asan_report_exp_load1(i64, i32)

declare void @__asan_exp_load1(i64, i32)

declare void @__asan_report_exp_load2(i64, i32)

declare void @__asan_exp_load2(i64, i32)

declare void @__asan_report_exp_load4(i64, i32)

declare void @__asan_exp_load4(i64, i32)

declare void @__asan_report_exp_load8(i64, i32)

declare void @__asan_exp_load8(i64, i32)

declare void @__asan_report_exp_load16(i64, i32)

declare void @__asan_exp_load16(i64, i32)

declare void @__asan_report_exp_store_n(i64, i64, i32)

declare void @__asan_exp_storeN(i64, i64, i32)

declare void @__asan_report_exp_store1(i64, i32)

declare void @__asan_exp_store1(i64, i32)

declare void @__asan_report_exp_store2(i64, i32)

declare void @__asan_exp_store2(i64, i32)

declare void @__asan_report_exp_store4(i64, i32)

declare void @__asan_exp_store4(i64, i32)

declare void @__asan_report_exp_store8(i64, i32)

declare void @__asan_exp_store8(i64, i32)

declare void @__asan_report_exp_store16(i64, i32)

declare void @__asan_exp_store16(i64, i32)

declare i8* @__asan_memmove(i8*, i8*, i64)

declare i8* @__asan_memcpy(i8*, i8*, i64)

declare i8* @__asan_memset(i8*, i32, i64)

declare void @__asan_handle_no_return()

declare void @__sanitizer_ptr_cmp(i64, i64)

declare void @__sanitizer_ptr_sub(i64, i64)

; Function Attrs: nounwind readnone speculatable willreturn
declare i1 @llvm.amdgcn.is.shared(i8* nocapture) #4

; Function Attrs: nounwind readnone speculatable willreturn
declare i1 @llvm.amdgcn.is.private(i8* nocapture) #4

declare void @__asan_before_dynamic_init(i64)

declare void @__asan_after_dynamic_init()

declare void @__asan_register_globals(i64, i64)

declare void @__asan_unregister_globals(i64, i64)

declare void @__asan_register_image_globals(i64)

declare void @__asan_unregister_image_globals(i64)

declare void @__asan_register_elf_globals(i64, i64, i64)

declare void @__asan_unregister_elf_globals(i64, i64, i64)

declare void @__asan_init()

; Function Attrs: nounwind uwtable
define internal void @asan.module_ctor() #5 {
  call void @__asan_init()
  call void @__asan_version_mismatch_check_v8()
  call void @__asan_register_globals(i64 ptrtoint ([1 x { i64, i64, i64, i64, i64, i64, i64, i64 }]* @0 to i64), i64 1)
  ret void
}

declare void @__asan_version_mismatch_check_v8()

; Function Attrs: nounwind uwtable
define internal void @asan.module_dtor() #5 {
  call void @__asan_unregister_globals(i64 ptrtoint ([1 x { i64, i64, i64, i64, i64, i64, i64, i64 }]* @0 to i64), i64 1)
  ret void
}

attributes #0 = { noinline nounwind sanitize_address uwtable "frame-pointer"="all" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #1 = { argmemonly nofree nosync nounwind willreturn }
attributes #2 = { nounwind "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #3 = { "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #4 = { nounwind readnone speculatable willreturn }
attributes #5 = { nounwind uwtable "frame-pointer"="all" }
attributes #6 = { nounwind }
attributes #7 = { nomerge }

!llvm.asan.globals = !{!0}
!llvm.module.flags = !{!2, !3, !4}
!llvm.ident = !{!5}

!0 = !{[4 x i8]* getelementptr inbounds ({ [4 x i8], [28 x i8] }, { [4 x i8], [28 x i8] }* @.str, i32 0, i32 0), !1, !"<string literal>", i1 false, i1 false}
!1 = !{!"ex.c", i32 6, i32 9}
!2 = !{i32 1, !"wchar_size", i32 4}
!3 = !{i32 7, !"uwtable", i32 1}
!4 = !{i32 7, !"frame-pointer", i32 2}
!5 = !{!"clang version 14.0.6"}
!6 = !{!"branch_weights", i32 1, i32 100000}
