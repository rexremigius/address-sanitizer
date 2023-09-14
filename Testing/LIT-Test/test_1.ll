; ModuleID = '/home/rex-mcw/address-sanitizer/Testing/test.c'
;RUN: opt -S < %s -load-pass-plugin ~/address-sanitizer/build/lib/libAddressSanitizer.so -passes="addressSan" | FileCheck %s
source_filename = "/home/rex-mcw/address-sanitizer/Testing/test.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-gnu"

@.str = internal constant { [3 x i8], [29 x i8] } { [3 x i8] c"%d\00", [29 x i8] zeroinitializer }, align 32
@a = dso_local global { i32, [28 x i8] } zeroinitializer, align 32, !dbg !0
@.str.1 = internal constant { [5 x i8], [27 x i8] } { [5 x i8] c"%lf\0A\00", [27 x i8] zeroinitializer }, align 32
@.str.2 = internal constant { [4 x i8], [28 x i8] } { [4 x i8] c"%fn\00", [28 x i8] zeroinitializer }, align 32
@.str.3 = internal constant { [4 x i8], [28 x i8] } { [4 x i8] c"%d\0A\00", [28 x i8] zeroinitializer }, align 32
@.str.4 = internal constant { [4 x i8], [28 x i8] } { [4 x i8] c"%f\0A\00", [28 x i8] zeroinitializer }, align 32
@.str.5 = internal constant { [11 x i8], [21 x i8] } { [11 x i8] c"Hello McW\0A\00", [21 x i8] zeroinitializer }, align 32
@___asan_gen_ = private constant [47 x i8] c"/home/rex-mcw/address-sanitizer/Testing/test.c\00", align 1
@___asan_gen_.6 = private unnamed_addr constant [17 x i8] c"<string literal>\00", align 1
@___asan_gen_.7 = private unnamed_addr constant [47 x i8] c"/home/rex-mcw/address-sanitizer/Testing/test.c\00", align 1
@___asan_gen_.8 = private unnamed_addr constant { [47 x i8]*, i32, i32 } { [47 x i8]* @___asan_gen_.7, i32 10, i32 9 }
@___asan_gen_.9 = private unnamed_addr constant [2 x i8] c"a\00", align 1
@___asan_gen_.10 = private unnamed_addr constant [47 x i8] c"/home/rex-mcw/address-sanitizer/Testing/test.c\00", align 1
@___asan_gen_.11 = private unnamed_addr constant { [47 x i8]*, i32, i32 } { [47 x i8]* @___asan_gen_.10, i32 6, i32 5 }
@___asan_gen_.12 = private unnamed_addr constant [17 x i8] c"<string literal>\00", align 1
@___asan_gen_.13 = private unnamed_addr constant [47 x i8] c"/home/rex-mcw/address-sanitizer/Testing/test.c\00", align 1
@___asan_gen_.14 = private unnamed_addr constant { [47 x i8]*, i32, i32 } { [47 x i8]* @___asan_gen_.13, i32 19, i32 9 }
@___asan_gen_.15 = private unnamed_addr constant [17 x i8] c"<string literal>\00", align 1
@___asan_gen_.16 = private unnamed_addr constant [47 x i8] c"/home/rex-mcw/address-sanitizer/Testing/test.c\00", align 1
@___asan_gen_.17 = private unnamed_addr constant { [47 x i8]*, i32, i32 } { [47 x i8]* @___asan_gen_.16, i32 21, i32 9 }
@___asan_gen_.18 = private unnamed_addr constant [17 x i8] c"<string literal>\00", align 1
@___asan_gen_.19 = private unnamed_addr constant [47 x i8] c"/home/rex-mcw/address-sanitizer/Testing/test.c\00", align 1
@___asan_gen_.20 = private unnamed_addr constant { [47 x i8]*, i32, i32 } { [47 x i8]* @___asan_gen_.19, i32 29, i32 10 }
@___asan_gen_.21 = private unnamed_addr constant [17 x i8] c"<string literal>\00", align 1
@___asan_gen_.22 = private unnamed_addr constant [47 x i8] c"/home/rex-mcw/address-sanitizer/Testing/test.c\00", align 1
@___asan_gen_.23 = private unnamed_addr constant { [47 x i8]*, i32, i32 } { [47 x i8]* @___asan_gen_.22, i32 31, i32 10 }
@___asan_gen_.24 = private unnamed_addr constant [17 x i8] c"<string literal>\00", align 1
@___asan_gen_.25 = private unnamed_addr constant [47 x i8] c"/home/rex-mcw/address-sanitizer/Testing/test.c\00", align 1
@___asan_gen_.26 = private unnamed_addr constant { [47 x i8]*, i32, i32 } { [47 x i8]* @___asan_gen_.25, i32 39, i32 10 }
@llvm.compiler.used = appending global [7 x i8*] [i8* getelementptr inbounds ({ [3 x i8], [29 x i8] }, { [3 x i8], [29 x i8] }* @.str, i32 0, i32 0, i32 0), i8* bitcast ({ i32, [28 x i8] }* @a to i8*), i8* getelementptr inbounds ({ [5 x i8], [27 x i8] }, { [5 x i8], [27 x i8] }* @.str.1, i32 0, i32 0, i32 0), i8* getelementptr inbounds ({ [4 x i8], [28 x i8] }, { [4 x i8], [28 x i8] }* @.str.2, i32 0, i32 0, i32 0), i8* getelementptr inbounds ({ [4 x i8], [28 x i8] }, { [4 x i8], [28 x i8] }* @.str.3, i32 0, i32 0, i32 0), i8* getelementptr inbounds ({ [4 x i8], [28 x i8] }, { [4 x i8], [28 x i8] }* @.str.4, i32 0, i32 0, i32 0), i8* getelementptr inbounds ({ [11 x i8], [21 x i8] }, { [11 x i8], [21 x i8] }* @.str.5, i32 0, i32 0, i32 0)], section "llvm.metadata"
@0 = internal global [7 x { i64, i64, i64, i64, i64, i64, i64, i64 }] [{ i64, i64, i64, i64, i64, i64, i64, i64 } { i64 ptrtoint ({ [3 x i8], [29 x i8] }* @.str to i64), i64 3, i64 32, i64 ptrtoint ([17 x i8]* @___asan_gen_.6 to i64), i64 ptrtoint ([47 x i8]* @___asan_gen_ to i64), i64 0, i64 ptrtoint ({ [47 x i8]*, i32, i32 }* @___asan_gen_.8 to i64), i64 -1 }, { i64, i64, i64, i64, i64, i64, i64, i64 } { i64 ptrtoint ({ i32, [28 x i8] }* @a to i64), i64 4, i64 32, i64 ptrtoint ([2 x i8]* @___asan_gen_.9 to i64), i64 ptrtoint ([47 x i8]* @___asan_gen_ to i64), i64 0, i64 ptrtoint ({ [47 x i8]*, i32, i32 }* @___asan_gen_.11 to i64), i64 0 }, { i64, i64, i64, i64, i64, i64, i64, i64 } { i64 ptrtoint ({ [5 x i8], [27 x i8] }* @.str.1 to i64), i64 5, i64 32, i64 ptrtoint ([17 x i8]* @___asan_gen_.12 to i64), i64 ptrtoint ([47 x i8]* @___asan_gen_ to i64), i64 0, i64 ptrtoint ({ [47 x i8]*, i32, i32 }* @___asan_gen_.14 to i64), i64 -1 }, { i64, i64, i64, i64, i64, i64, i64, i64 } { i64 ptrtoint ({ [4 x i8], [28 x i8] }* @.str.2 to i64), i64 4, i64 32, i64 ptrtoint ([17 x i8]* @___asan_gen_.15 to i64), i64 ptrtoint ([47 x i8]* @___asan_gen_ to i64), i64 0, i64 ptrtoint ({ [47 x i8]*, i32, i32 }* @___asan_gen_.17 to i64), i64 -1 }, { i64, i64, i64, i64, i64, i64, i64, i64 } { i64 ptrtoint ({ [4 x i8], [28 x i8] }* @.str.3 to i64), i64 4, i64 32, i64 ptrtoint ([17 x i8]* @___asan_gen_.18 to i64), i64 ptrtoint ([47 x i8]* @___asan_gen_ to i64), i64 0, i64 ptrtoint ({ [47 x i8]*, i32, i32 }* @___asan_gen_.20 to i64), i64 -1 }, { i64, i64, i64, i64, i64, i64, i64, i64 } { i64 ptrtoint ({ [4 x i8], [28 x i8] }* @.str.4 to i64), i64 4, i64 32, i64 ptrtoint ([17 x i8]* @___asan_gen_.21 to i64), i64 ptrtoint ([47 x i8]* @___asan_gen_ to i64), i64 0, i64 ptrtoint ({ [47 x i8]*, i32, i32 }* @___asan_gen_.23 to i64), i64 -1 }, { i64, i64, i64, i64, i64, i64, i64, i64 } { i64 ptrtoint ({ [11 x i8], [21 x i8] }* @.str.5 to i64), i64 11, i64 32, i64 ptrtoint ([17 x i8]* @___asan_gen_.24 to i64), i64 ptrtoint ([47 x i8]* @___asan_gen_ to i64), i64 0, i64 ptrtoint ({ [47 x i8]*, i32, i32 }* @___asan_gen_.26 to i64), i64 -1 }]
@llvm.used = appending global [2 x i8*] [i8* bitcast (void ()* @asan.module_ctor to i8*), i8* bitcast (void ()* @asan.module_dtor to i8*)], section "llvm.metadata"
@llvm.global_ctors = appending global [1 x { i32, void ()*, i8* }] [{ i32, void ()*, i8* } { i32 1, void ()* @asan.module_ctor, i8* null }]
@llvm.global_dtors = appending global [1 x { i32, void ()*, i8* }] [{ i32, void ()*, i8* } { i32 1, void ()* @asan.module_dtor, i8* null }]

; Function Attrs: noinline nounwind sanitize_address uwtable
define dso_local i32 @main() #0 !dbg !27 {
entry:
  %retval = alloca i32, align 4
  %x = alloca double*, align 8
  %y = alloca float*, align 8
  store i32 0, i32* %retval, align 4
  %call = call i32 (i8*, ...) @__isoc99_scanf(i8* noundef getelementptr inbounds ({ [3 x i8], [29 x i8] }, { [3 x i8], [29 x i8] }* @.str, i32 0, i32 0, i64 0), i32* noundef getelementptr inbounds ({ i32, [28 x i8] }, { i32, [28 x i8] }* @a, i32 0, i32 0)), !dbg !31
  %0 = bitcast double** %x to i8*, !dbg !32
  call void @llvm.lifetime.start.p0i8(i64 8, i8* %0) #7, !dbg !32
  call void @llvm.dbg.declare(metadata double** %x, metadata !33, metadata !DIExpression()), !dbg !36
  %1 = load i32, i32* getelementptr inbounds ({ i32, [28 x i8] }, { i32, [28 x i8] }* @a, i32 0, i32 0), align 4, !dbg !37
  %conv = sext i32 %1 to i64, !dbg !37
  %mul = mul i64 %conv, 8, !dbg !38
  %call1 = call noalias i8* @malloc(i64 noundef %mul) #7, !dbg !39
  %2 = bitcast i8* %call1 to double*, !dbg !39
  store double* %2, double** %x, align 8, !dbg !36
  %3 = bitcast float** %y to i8*, !dbg !40
  call void @llvm.lifetime.start.p0i8(i64 8, i8* %3) #7, !dbg !40
  call void @llvm.dbg.declare(metadata float** %y, metadata !41, metadata !DIExpression()), !dbg !44
  %4 = load i32, i32* getelementptr inbounds ({ i32, [28 x i8] }, { i32, [28 x i8] }* @a, i32 0, i32 0), align 4, !dbg !45
  %conv2 = sext i32 %4 to i64, !dbg !45
  %call3 = call noalias i8* @calloc(i64 noundef %conv2, i64 noundef 4) #7, !dbg !46
  %5 = bitcast i8* %call3 to float*, !dbg !46
  store float* %5, float** %y, align 8, !dbg !44
  %6 = load double*, double** %x, align 8, !dbg !47
  %7 = load i32, i32* getelementptr inbounds ({ i32, [28 x i8] }, { i32, [28 x i8] }* @a, i32 0, i32 0), align 4, !dbg !48
  %idxprom = sext i32 %7 to i64, !dbg !47
  %arrayidx = getelementptr inbounds double, double* %6, i64 %idxprom, !dbg !47
  %call4 = call i32 (i8*, ...) @__isoc99_scanf(i8* noundef getelementptr inbounds ({ [5 x i8], [27 x i8] }, { [5 x i8], [27 x i8] }* @.str.1, i32 0, i32 0, i64 0), double* noundef %arrayidx), !dbg !49
  %8 = load float*, float** %y, align 8, !dbg !50
  %arrayidx5 = getelementptr inbounds float, float* %8, i64 150, !dbg !50
  %call6 = call i32 (i8*, ...) @__isoc99_scanf(i8* noundef getelementptr inbounds ({ [4 x i8], [28 x i8] }, { [4 x i8], [28 x i8] }* @.str.2, i32 0, i32 0, i64 0), float* noundef %arrayidx5), !dbg !51
  %9 = load i32, i32* getelementptr inbounds ({ i32, [28 x i8] }, { i32, [28 x i8] }* @a, i32 0, i32 0), align 4, !dbg !52
  %call7 = call i32 (i8*, ...) @printf(i8* noundef getelementptr inbounds ({ [4 x i8], [28 x i8] }, { [4 x i8], [28 x i8] }* @.str.3, i32 0, i32 0, i64 0), i32 noundef %9), !dbg !53
  %10 = load double*, double** %x, align 8, !dbg !54
  %11 = load i32, i32* getelementptr inbounds ({ i32, [28 x i8] }, { i32, [28 x i8] }* @a, i32 0, i32 0), align 4, !dbg !55
  %idxprom8 = sext i32 %11 to i64, !dbg !54
  %arrayidx9 = getelementptr inbounds double, double* %10, i64 %idxprom8, !dbg !54
  %12 = ptrtoint double* %arrayidx9 to i64, !dbg !54
  %13 = lshr i64 %12, 3, !dbg !54
  %14 = add i64 %13, 2147450880, !dbg !54
  %15 = inttoptr i64 %14 to i8*, !dbg !54
  %16 = load i8, i8* %15, align 1, !dbg !54
  %17 = icmp ne i8 %16, 0, !dbg !54
  br i1 %17, label %18, label %19, !dbg !54

18:                                               ; preds = %entry
  call void @__asan_report_load8(i64 %12) #8, !dbg !54
  ;CHECK: call void @__asan_report_load8
  ;CHECK-NEXT: %{{[0-9]+}} = alloca 
  ;CHECK-NEXT: %{{[0-9]+}} = load
  ;CHECK-NEXT: %{{[0-9]+}} = mul 
  ;CHECK-NEXT: store 
  ;CHECK-NEXT: %{{[0-9]+}} = load 
  ;CHECK-NEXT: %{{[0-9]+}} = sext 
  ;CHECK-NEXT: %{{[0-9]+}} = load double*, double** %x, align 8, !dbg !54
  ;CHECK-NEXT: %{{[0-9]+}} = bitcast 
  ;CHECK-NEXT: %{{[0-9]+}} = call i8* @realloc(i8* %{{[0-9]+}}, i64 %{{[0-9]+}})
  ;CHECK-NEXT: %{{[0-9]+}} = bitcast 
  ;CHECK-NEXT: store 
  unreachable, !dbg !54

19:                                               ; preds = %entry
  %20 = load double, double* %arrayidx9, align 8, !dbg !54
  %call10 = call i32 (i8*, ...) @printf(i8* noundef getelementptr inbounds ({ [5 x i8], [27 x i8] }, { [5 x i8], [27 x i8] }* @.str.1, i32 0, i32 0, i64 0), double noundef %20), !dbg !56
  %21 = load float*, float** %y, align 8, !dbg !57
  %arrayidx11 = getelementptr inbounds float, float* %21, i64 150, !dbg !57
  %22 = ptrtoint float* %arrayidx11 to i64, !dbg !57
  %23 = lshr i64 %22, 3, !dbg !57
  %24 = add i64 %23, 2147450880, !dbg !57
  %25 = inttoptr i64 %24 to i8*, !dbg !57
  %26 = load i8, i8* %25, align 1, !dbg !57
  %27 = icmp ne i8 %26, 0, !dbg !57
  br i1 %27, label %28, label %34, !dbg !57, !prof !58

28:                                               ; preds = %19
  %29 = and i64 %22, 7, !dbg !57
  %30 = add i64 %29, 3, !dbg !57
  %31 = trunc i64 %30 to i8, !dbg !57
  %32 = icmp sge i8 %31, %26, !dbg !57
  br i1 %32, label %33, label %34, !dbg !57

33:                                               ; preds = %28
  call void @__asan_report_load4(i64 %22) #8, !dbg !57
  ;CHECK: call void @__asan_report_load4
  ;CHECK-NEXT: %{{[0-9]+}} = load
  ;CHECK-NEXT: %{{[0-9]+}} = bitcast
  ;CHECK-NEXT: %{{[0-9]+}} = call i8* @realloc(i8* %{{[0-9]+}}, i64 {{[0-9]+}})
  ;CHECK-NEXT: %{{[0-9]+}} = bitcast 
  ;CHECK-NEXT: store
  unreachable

34:                                               ; preds = %28, %19
  %35 = load float, float* %arrayidx11, align 4, !dbg !57
  %conv12 = fpext float %35 to double, !dbg !57
  %call13 = call i32 (i8*, ...) @printf(i8* noundef getelementptr inbounds ({ [4 x i8], [28 x i8] }, { [4 x i8], [28 x i8] }* @.str.4, i32 0, i32 0, i64 0), double noundef %conv12), !dbg !59
  %call14 = call i32 (i8*, ...) @printf(i8* noundef getelementptr inbounds ({ [4 x i8], [28 x i8] }, { [4 x i8], [28 x i8] }* @.str.3, i32 0, i32 0, i64 0), i64 noundef 8), !dbg !60
  %call15 = call i32 (i8*, ...) @printf(i8* noundef getelementptr inbounds ({ [4 x i8], [28 x i8] }, { [4 x i8], [28 x i8] }* @.str.3, i32 0, i32 0, i64 0), i64 noundef 8), !dbg !61
  %36 = load double*, double** %x, align 8, !dbg !62
  %37 = bitcast double* %36 to i8*, !dbg !62
  call void @free(i8* noundef %37) #7, !dbg !63
  %38 = load float*, float** %y, align 8, !dbg !64
  %39 = bitcast float* %38 to i8*, !dbg !64
  call void @free(i8* noundef %39) #7, !dbg !65
  %call16 = call i32 (i8*, ...) @printf(i8* noundef getelementptr inbounds ({ [11 x i8], [21 x i8] }, { [11 x i8], [21 x i8] }* @.str.5, i32 0, i32 0, i64 0)), !dbg !66
  %40 = bitcast float** %y to i8*, !dbg !67
  call void @llvm.lifetime.end.p0i8(i64 8, i8* %40) #7, !dbg !67
  %41 = bitcast double** %x to i8*, !dbg !67
  call void @llvm.lifetime.end.p0i8(i64 8, i8* %41) #7, !dbg !67
  ret i32 0, !dbg !68
}

declare dso_local i32 @__isoc99_scanf(i8* noundef, ...) #1

; Function Attrs: argmemonly nofree nosync nounwind willreturn
declare void @llvm.lifetime.start.p0i8(i64 immarg, i8* nocapture) #2

; Function Attrs: nofree nosync nounwind readnone speculatable willreturn
declare void @llvm.dbg.declare(metadata, metadata, metadata) #3

; Function Attrs: nounwind
declare dso_local noalias i8* @malloc(i64 noundef) #4

; Function Attrs: nounwind
declare dso_local noalias i8* @calloc(i64 noundef, i64 noundef) #4

declare dso_local i32 @printf(i8* noundef, ...) #1

; Function Attrs: nounwind
declare dso_local void @free(i8* noundef) #4

; Function Attrs: argmemonly nofree nosync nounwind willreturn
declare void @llvm.lifetime.end.p0i8(i64 immarg, i8* nocapture) #2

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
declare i1 @llvm.amdgcn.is.shared(i8* nocapture) #5

; Function Attrs: nounwind readnone speculatable willreturn
declare i1 @llvm.amdgcn.is.private(i8* nocapture) #5

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
define internal void @asan.module_ctor() #6 {
  call void @__asan_init()
  call void @__asan_version_mismatch_check_v8()
  call void @__asan_register_globals(i64 ptrtoint ([7 x { i64, i64, i64, i64, i64, i64, i64, i64 }]* @0 to i64), i64 7)
  ret void
}

declare void @__asan_version_mismatch_check_v8()

; Function Attrs: nounwind uwtable
define internal void @asan.module_dtor() #6 {
  call void @__asan_unregister_globals(i64 ptrtoint ([7 x { i64, i64, i64, i64, i64, i64, i64, i64 }]* @0 to i64), i64 7)
  ret void
}

attributes #0 = { noinline nounwind sanitize_address uwtable "frame-pointer"="all" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #1 = { "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #2 = { argmemonly nofree nosync nounwind willreturn }
attributes #3 = { nofree nosync nounwind readnone speculatable willreturn }
attributes #4 = { nounwind "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #5 = { nounwind readnone speculatable willreturn }
attributes #6 = { nounwind uwtable "frame-pointer"="all" }
attributes #7 = { nounwind }
attributes #8 = { nomerge }

!llvm.dbg.cu = !{!2}
!llvm.asan.globals = !{!7, !9, !11, !13, !15, !17, !19}
!llvm.module.flags = !{!21, !22, !23, !24, !25}
!llvm.ident = !{!26}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "a", scope: !2, file: !5, line: 6, type: !6, isLocal: false, isDefinition: true)
!2 = distinct !DICompileUnit(language: DW_LANG_C99, file: !3, producer: "clang version 14.0.6 (https://github.com/llvm/llvm-project.git f28c006a5895fc0e329fe15fead81e37457cb1d1)", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, globals: !4, splitDebugInlining: false, nameTableKind: None)
!3 = !DIFile(filename: "/home/rex-mcw/address-sanitizer/Testing/test.c", directory: "/home/rex-mcw/address-sanitizer/scripts", checksumkind: CSK_MD5, checksum: "5d1ab960a1beb8de5b36da5a872af2d2")
!4 = !{!0}
!5 = !DIFile(filename: "Testing/test.c", directory: "/home/rex-mcw/address-sanitizer", checksumkind: CSK_MD5, checksum: "5d1ab960a1beb8de5b36da5a872af2d2")
!6 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!7 = !{[3 x i8]* getelementptr inbounds ({ [3 x i8], [29 x i8] }, { [3 x i8], [29 x i8] }* @.str, i32 0, i32 0), !8, !"<string literal>", i1 false, i1 false}
!8 = !{!"/home/rex-mcw/address-sanitizer/Testing/test.c", i32 10, i32 9}
!9 = !{[5 x i8]* getelementptr inbounds ({ [5 x i8], [27 x i8] }, { [5 x i8], [27 x i8] }* @.str.1, i32 0, i32 0), !10, !"<string literal>", i1 false, i1 false}
!10 = !{!"/home/rex-mcw/address-sanitizer/Testing/test.c", i32 19, i32 9}
!11 = !{[4 x i8]* getelementptr inbounds ({ [4 x i8], [28 x i8] }, { [4 x i8], [28 x i8] }* @.str.2, i32 0, i32 0), !12, !"<string literal>", i1 false, i1 false}
!12 = !{!"/home/rex-mcw/address-sanitizer/Testing/test.c", i32 21, i32 9}
!13 = !{[4 x i8]* getelementptr inbounds ({ [4 x i8], [28 x i8] }, { [4 x i8], [28 x i8] }* @.str.3, i32 0, i32 0), !14, !"<string literal>", i1 false, i1 false}
!14 = !{!"/home/rex-mcw/address-sanitizer/Testing/test.c", i32 29, i32 10}
!15 = !{[4 x i8]* getelementptr inbounds ({ [4 x i8], [28 x i8] }, { [4 x i8], [28 x i8] }* @.str.4, i32 0, i32 0), !16, !"<string literal>", i1 false, i1 false}
!16 = !{!"/home/rex-mcw/address-sanitizer/Testing/test.c", i32 31, i32 10}
!17 = !{[11 x i8]* getelementptr inbounds ({ [11 x i8], [21 x i8] }, { [11 x i8], [21 x i8] }* @.str.5, i32 0, i32 0), !18, !"<string literal>", i1 false, i1 false}
!18 = !{!"/home/rex-mcw/address-sanitizer/Testing/test.c", i32 39, i32 10}
!19 = !{i32* getelementptr inbounds ({ i32, [28 x i8] }, { i32, [28 x i8] }* @a, i32 0, i32 0), !20, !"a", i1 false, i1 false}
!20 = !{!"/home/rex-mcw/address-sanitizer/Testing/test.c", i32 6, i32 5}
!21 = !{i32 7, !"Dwarf Version", i32 5}
!22 = !{i32 2, !"Debug Info Version", i32 3}
!23 = !{i32 1, !"wchar_size", i32 4}
!24 = !{i32 7, !"uwtable", i32 1}
!25 = !{i32 7, !"frame-pointer", i32 2}
!26 = !{!"clang version 14.0.6 (https://github.com/llvm/llvm-project.git f28c006a5895fc0e329fe15fead81e37457cb1d1)"}
!27 = distinct !DISubprogram(name: "main", scope: !5, file: !5, line: 7, type: !28, scopeLine: 7, spFlags: DISPFlagDefinition, unit: !2, retainedNodes: !30)
!28 = !DISubroutineType(types: !29)
!29 = !{!6}
!30 = !{}
!31 = !DILocation(line: 10, column: 3, scope: !27)
!32 = !DILocation(line: 11, column: 3, scope: !27)
!33 = !DILocalVariable(name: "x", scope: !27, file: !5, line: 11, type: !34)
!34 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !35, size: 64)
!35 = !DIBasicType(name: "double", size: 64, encoding: DW_ATE_float)
!36 = !DILocation(line: 11, column: 11, scope: !27)
!37 = !DILocation(line: 11, column: 22, scope: !27)
!38 = !DILocation(line: 11, column: 24, scope: !27)
!39 = !DILocation(line: 11, column: 15, scope: !27)
!40 = !DILocation(line: 12, column: 3, scope: !27)
!41 = !DILocalVariable(name: "y", scope: !27, file: !5, line: 12, type: !42)
!42 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !43, size: 64)
!43 = !DIBasicType(name: "float", size: 32, encoding: DW_ATE_float)
!44 = !DILocation(line: 12, column: 10, scope: !27)
!45 = !DILocation(line: 12, column: 21, scope: !27)
!46 = !DILocation(line: 12, column: 14, scope: !27)
!47 = !DILocation(line: 19, column: 19, scope: !27)
!48 = !DILocation(line: 19, column: 21, scope: !27)
!49 = !DILocation(line: 19, column: 3, scope: !27)
!50 = !DILocation(line: 21, column: 17, scope: !27)
!51 = !DILocation(line: 21, column: 3, scope: !27)
!52 = !DILocation(line: 29, column: 17, scope: !27)
!53 = !DILocation(line: 29, column: 3, scope: !27)
!54 = !DILocation(line: 30, column: 19, scope: !27)
!55 = !DILocation(line: 30, column: 21, scope: !27)
!56 = !DILocation(line: 30, column: 3, scope: !27)
!57 = !DILocation(line: 31, column: 18, scope: !27)
!58 = !{!"branch_weights", i32 1, i32 100000}
!59 = !DILocation(line: 31, column: 3, scope: !27)
!60 = !DILocation(line: 32, column: 3, scope: !27)
!61 = !DILocation(line: 33, column: 3, scope: !27)
!62 = !DILocation(line: 37, column: 8, scope: !27)
!63 = !DILocation(line: 37, column: 3, scope: !27)
!64 = !DILocation(line: 38, column: 8, scope: !27)
!65 = !DILocation(line: 38, column: 3, scope: !27)
!66 = !DILocation(line: 39, column: 3, scope: !27)
!67 = !DILocation(line: 41, column: 1, scope: !27)
!68 = !DILocation(line: 40, column: 3, scope: !27)
