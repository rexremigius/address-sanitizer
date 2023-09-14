; ModuleID = '/home/rex-mcw/address-sanitizer/Testing/LIT-Test/test_2.c'
;RUN: opt -S < %s -load-pass-plugin ~/address-sanitizer/build/lib/libAddressSanitizer.so -passes="addressSan" | FileCheck %s

  ;CHECK: call void @__asan_report
  ;CHECK-NEXT: %{{[0-9]+}} = alloca 
  ;CHECK-NEXT: %{{[0-9]+}} = load
  ;CHECK-NEXT: %{{[0-9]+}} = mul 
  ;CHECK-NEXT: store 
  ;CHECK-NEXT: %{{[0-9]+}} = load 
  ;CHECK-NEXT: %{{[0-9]+}} = sext 
  ;CHECK-NEXT: %{{[0-9]+}} = load 
  ;CHECK-NEXT: %{{[0-9]+}} = bitcast
  ;CHECK-NEXT: %{{[0-9]+}} = call i8* @realloc(i8* %{{[0-9]+}}, i64 %{{[0-9]+}})
  ;CHECK-NEXT: %{{[0-9]+}} = bitcast 
  ;CHECK-NEXT: store

source_filename = "/home/rex-mcw/address-sanitizer/Testing/LIT-Test/test_2.c"
target datalayout = "e-m:e-p270:32:32-p271:32:32-p272:64:64-i64:64-f80:128-n8:16:32:64-S128"
target triple = "x86_64-unknown-linux-gnu"

@.str = internal constant { [14 x i8], [18 x i8] } { [14 x i8] c"arr[%d] = %d\0A\00", [18 x i8] zeroinitializer }, align 32
@___asan_gen_ = private constant [58 x i8] c"/home/rex-mcw/address-sanitizer/Testing/LIT-Test/test_2.c\00", align 1
@___asan_gen_.1 = private unnamed_addr constant [17 x i8] c"<string literal>\00", align 1
@___asan_gen_.2 = private unnamed_addr constant [58 x i8] c"/home/rex-mcw/address-sanitizer/Testing/LIT-Test/test_2.c\00", align 1
@___asan_gen_.3 = private unnamed_addr constant { [58 x i8]*, i32, i32 } { [58 x i8]* @___asan_gen_.2, i32 12, i32 16 }
@llvm.compiler.used = appending global [1 x i8*] [i8* getelementptr inbounds ({ [14 x i8], [18 x i8] }, { [14 x i8], [18 x i8] }* @.str, i32 0, i32 0, i32 0)], section "llvm.metadata"
@0 = internal global [1 x { i64, i64, i64, i64, i64, i64, i64, i64 }] [{ i64, i64, i64, i64, i64, i64, i64, i64 } { i64 ptrtoint ({ [14 x i8], [18 x i8] }* @.str to i64), i64 14, i64 32, i64 ptrtoint ([17 x i8]* @___asan_gen_.1 to i64), i64 ptrtoint ([58 x i8]* @___asan_gen_ to i64), i64 0, i64 ptrtoint ({ [58 x i8]*, i32, i32 }* @___asan_gen_.3 to i64), i64 -1 }]
@llvm.used = appending global [2 x i8*] [i8* bitcast (void ()* @asan.module_ctor to i8*), i8* bitcast (void ()* @asan.module_dtor to i8*)], section "llvm.metadata"
@llvm.global_ctors = appending global [1 x { i32, void ()*, i8* }] [{ i32, void ()*, i8* } { i32 1, void ()* @asan.module_ctor, i8* null }]
@llvm.global_dtors = appending global [1 x { i32, void ()*, i8* }] [{ i32, void ()*, i8* } { i32 1, void ()* @asan.module_dtor, i8* null }]

; Function Attrs: noinline nounwind sanitize_address uwtable
define dso_local i32 @main() #0 !dbg !10 {
entry:
  %retval = alloca i32, align 4
  %arr = alloca i32*, align 8
  %i = alloca i32, align 4
  store i32 0, i32* %retval, align 4
  %0 = bitcast i32** %arr to i8*, !dbg !16
  call void @llvm.lifetime.start.p0i8(i64 8, i8* %0) #7, !dbg !16
  call void @llvm.dbg.declare(metadata i32** %arr, metadata !17, metadata !DIExpression()), !dbg !19
  %call = call noalias i8* @malloc(i64 noundef 20) #7, !dbg !20
  %1 = bitcast i8* %call to i32*, !dbg !20
  store i32* %1, i32** %arr, align 8, !dbg !19
  %2 = bitcast i32* %i to i8*, !dbg !21
  call void @llvm.lifetime.start.p0i8(i64 4, i8* %2) #7, !dbg !21
  call void @llvm.dbg.declare(metadata i32* %i, metadata !22, metadata !DIExpression()), !dbg !23
  store i32 0, i32* %i, align 4, !dbg !24
  br label %for.cond, !dbg !26

for.cond:                                         ; preds = %for.inc, %entry
  %3 = load i32, i32* %i, align 4, !dbg !27
  %cmp = icmp slt i32 %3, 10, !dbg !29
  br i1 %cmp, label %for.body, label %for.end, !dbg !30

for.body:                                         ; preds = %for.cond
  %4 = load i32, i32* %i, align 4, !dbg !31
  %5 = load i32*, i32** %arr, align 8, !dbg !33
  %6 = load i32, i32* %i, align 4, !dbg !34
  %idxprom = sext i32 %6 to i64, !dbg !33
  %arrayidx = getelementptr inbounds i32, i32* %5, i64 %idxprom, !dbg !33
  %7 = ptrtoint i32* %arrayidx to i64, !dbg !35
  %8 = lshr i64 %7, 3, !dbg !35
  %9 = add i64 %8, 2147450880, !dbg !35
  %10 = inttoptr i64 %9 to i8*, !dbg !35
  %11 = load i8, i8* %10, align 1, !dbg !35
  %12 = icmp ne i8 %11, 0, !dbg !35
  br i1 %12, label %13, label %19, !dbg !35, !prof !36

13:                                               ; preds = %for.body
  %14 = and i64 %7, 7, !dbg !35
  %15 = add i64 %14, 3, !dbg !35
  %16 = trunc i64 %15 to i8, !dbg !35
  %17 = icmp sge i8 %16, %11, !dbg !35
  br i1 %17, label %18, label %19, !dbg !35

18:                                               ; preds = %13
  call void @__asan_report_store4(i64 %7) #8, !dbg !35

  unreachable

19:                                               ; preds = %13, %for.body
  store i32 %4, i32* %arrayidx, align 4, !dbg !35
  %20 = load i32, i32* %i, align 4, !dbg !37
  %21 = load i32*, i32** %arr, align 8, !dbg !38
  %22 = load i32, i32* %i, align 4, !dbg !39
  %idxprom1 = sext i32 %22 to i64, !dbg !38
  %arrayidx2 = getelementptr inbounds i32, i32* %21, i64 %idxprom1, !dbg !38
  %23 = ptrtoint i32* %arrayidx2 to i64, !dbg !38
  %24 = lshr i64 %23, 3, !dbg !38
  %25 = add i64 %24, 2147450880, !dbg !38
  %26 = inttoptr i64 %25 to i8*, !dbg !38
  %27 = load i8, i8* %26, align 1, !dbg !38
  %28 = icmp ne i8 %27, 0, !dbg !38
  br i1 %28, label %29, label %35, !dbg !38, !prof !36

29:                                               ; preds = %19
  %30 = and i64 %23, 7, !dbg !38
  %31 = add i64 %30, 3, !dbg !38
  %32 = trunc i64 %31 to i8, !dbg !38
  %33 = icmp sge i8 %32, %27, !dbg !38
  br i1 %33, label %34, label %35, !dbg !38

34:                                               ; preds = %29
  call void @__asan_report_load4(i64 %23) #8, !dbg !38
  unreachable

35:                                               ; preds = %29, %19
  %36 = load i32, i32* %arrayidx2, align 4, !dbg !38
  %call3 = call i32 (i8*, ...) @printf(i8* noundef getelementptr inbounds ({ [14 x i8], [18 x i8] }, { [14 x i8], [18 x i8] }* @.str, i32 0, i32 0, i64 0), i32 noundef %20, i32 noundef %36), !dbg !40
  br label %for.inc, !dbg !41

for.inc:                                          ; preds = %35
  %37 = load i32, i32* %i, align 4, !dbg !42
  %inc = add nsw i32 %37, 1, !dbg !42
  store i32 %inc, i32* %i, align 4, !dbg !42
  br label %for.cond, !dbg !43, !llvm.loop !44

for.end:                                          ; preds = %for.cond
  %38 = load i32*, i32** %arr, align 8, !dbg !47
  %39 = bitcast i32* %38 to i8*, !dbg !47
  call void @free(i8* noundef %39) #7, !dbg !48
  %40 = bitcast i32* %i to i8*, !dbg !49
  call void @llvm.lifetime.end.p0i8(i64 4, i8* %40) #7, !dbg !49
  %41 = bitcast i32** %arr to i8*, !dbg !49
  call void @llvm.lifetime.end.p0i8(i64 8, i8* %41) #7, !dbg !49
  ret i32 0, !dbg !50
}

; Function Attrs: argmemonly nofree nosync nounwind willreturn
declare void @llvm.lifetime.start.p0i8(i64 immarg, i8* nocapture) #1

; Function Attrs: nofree nosync nounwind readnone speculatable willreturn
declare void @llvm.dbg.declare(metadata, metadata, metadata) #2

; Function Attrs: nounwind
declare dso_local noalias i8* @malloc(i64 noundef) #3

declare dso_local i32 @printf(i8* noundef, ...) #4

; Function Attrs: nounwind
declare dso_local void @free(i8* noundef) #3

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
  call void @__asan_register_globals(i64 ptrtoint ([1 x { i64, i64, i64, i64, i64, i64, i64, i64 }]* @0 to i64), i64 1)
  ret void
}

declare void @__asan_version_mismatch_check_v8()

; Function Attrs: nounwind uwtable
define internal void @asan.module_dtor() #6 {
  call void @__asan_unregister_globals(i64 ptrtoint ([1 x { i64, i64, i64, i64, i64, i64, i64, i64 }]* @0 to i64), i64 1)
  ret void
}

attributes #0 = { noinline nounwind sanitize_address uwtable "frame-pointer"="all" "min-legal-vector-width"="0" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #1 = { argmemonly nofree nosync nounwind willreturn }
attributes #2 = { nofree nosync nounwind readnone speculatable willreturn }
attributes #3 = { nounwind "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #4 = { "frame-pointer"="all" "no-trapping-math"="true" "stack-protector-buffer-size"="8" "target-cpu"="x86-64" "target-features"="+cx8,+fxsr,+mmx,+sse,+sse2,+x87" "tune-cpu"="generic" }
attributes #5 = { nounwind readnone speculatable willreturn }
attributes #6 = { nounwind uwtable "frame-pointer"="all" }
attributes #7 = { nounwind }
attributes #8 = { nomerge }

!llvm.dbg.cu = !{!0}
!llvm.asan.globals = !{!2}
!llvm.module.flags = !{!4, !5, !6, !7, !8}
!llvm.ident = !{!9}

!0 = distinct !DICompileUnit(language: DW_LANG_C99, file: !1, producer: "clang version 14.0.6 (https://github.com/llvm/llvm-project.git f28c006a5895fc0e329fe15fead81e37457cb1d1)", isOptimized: false, runtimeVersion: 0, emissionKind: FullDebug, splitDebugInlining: false, nameTableKind: None)
!1 = !DIFile(filename: "/home/rex-mcw/address-sanitizer/Testing/LIT-Test/test_2.c", directory: "/home/rex-mcw/address-sanitizer/Testing", checksumkind: CSK_MD5, checksum: "3f36242b67bb37e4c47d26546cc10313")
!2 = !{[14 x i8]* getelementptr inbounds ({ [14 x i8], [18 x i8] }, { [14 x i8], [18 x i8] }* @.str, i32 0, i32 0), !3, !"<string literal>", i1 false, i1 false}
!3 = !{!"/home/rex-mcw/address-sanitizer/Testing/LIT-Test/test_2.c", i32 12, i32 16}
!4 = !{i32 7, !"Dwarf Version", i32 5}
!5 = !{i32 2, !"Debug Info Version", i32 3}
!6 = !{i32 1, !"wchar_size", i32 4}
!7 = !{i32 7, !"uwtable", i32 1}
!8 = !{i32 7, !"frame-pointer", i32 2}
!9 = !{!"clang version 14.0.6 (https://github.com/llvm/llvm-project.git f28c006a5895fc0e329fe15fead81e37457cb1d1)"}
!10 = distinct !DISubprogram(name: "main", scope: !11, file: !11, line: 3, type: !12, scopeLine: 3, spFlags: DISPFlagDefinition, unit: !0, retainedNodes: !15)
!11 = !DIFile(filename: "LIT-Test/test_2.c", directory: "/home/rex-mcw/address-sanitizer/Testing", checksumkind: CSK_MD5, checksum: "3f36242b67bb37e4c47d26546cc10313")
!12 = !DISubroutineType(types: !13)
!13 = !{!14}
!14 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!15 = !{}
!16 = !DILocation(line: 4, column: 3, scope: !10)
!17 = !DILocalVariable(name: "arr", scope: !10, file: !11, line: 4, type: !18)
!18 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !14, size: 64)
!19 = !DILocation(line: 4, column: 8, scope: !10)
!20 = !DILocation(line: 4, column: 14, scope: !10)
!21 = !DILocation(line: 5, column: 3, scope: !10)
!22 = !DILocalVariable(name: "i", scope: !10, file: !11, line: 5, type: !14)
!23 = !DILocation(line: 5, column: 7, scope: !10)
!24 = !DILocation(line: 7, column: 10, scope: !25)
!25 = distinct !DILexicalBlock(scope: !10, file: !11, line: 7, column: 3)
!26 = !DILocation(line: 7, column: 8, scope: !25)
!27 = !DILocation(line: 7, column: 15, scope: !28)
!28 = distinct !DILexicalBlock(scope: !25, file: !11, line: 7, column: 3)
!29 = !DILocation(line: 7, column: 17, scope: !28)
!30 = !DILocation(line: 7, column: 3, scope: !25)
!31 = !DILocation(line: 9, column: 14, scope: !32)
!32 = distinct !DILexicalBlock(scope: !28, file: !11, line: 7, column: 28)
!33 = !DILocation(line: 9, column: 5, scope: !32)
!34 = !DILocation(line: 9, column: 9, scope: !32)
!35 = !DILocation(line: 9, column: 12, scope: !32)
!36 = !{!"branch_weights", i32 1, i32 100000}
!37 = !DILocation(line: 12, column: 34, scope: !32)
!38 = !DILocation(line: 12, column: 37, scope: !32)
!39 = !DILocation(line: 12, column: 41, scope: !32)
!40 = !DILocation(line: 12, column: 9, scope: !32)
!41 = !DILocation(line: 13, column: 3, scope: !32)
!42 = !DILocation(line: 7, column: 24, scope: !28)
!43 = !DILocation(line: 7, column: 3, scope: !28)
!44 = distinct !{!44, !30, !45, !46}
!45 = !DILocation(line: 13, column: 3, scope: !25)
!46 = !{!"llvm.loop.mustprogress"}
!47 = !DILocation(line: 15, column: 8, scope: !10)
!48 = !DILocation(line: 15, column: 3, scope: !10)
!49 = !DILocation(line: 18, column: 1, scope: !10)
!50 = !DILocation(line: 17, column: 3, scope: !10)
