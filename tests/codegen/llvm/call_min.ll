; ModuleID = 'bpftrace'
source_filename = "bpftrace"
target datalayout = "e-m:e-p:64:64-i64:64-i128:128-n32:64-S128"
target triple = "bpf-pc-linux"

%"struct map_t" = type { i8*, i8*, i8*, i8* }
%"struct map_t.0" = type { i8*, i8* }
%"struct map_t.1" = type { i8*, i8*, i8*, i8* }

@LICENSE = global [4 x i8] c"GPL\00", section "license"
@AT_x = dso_local global %"struct map_t" zeroinitializer, section ".maps", !dbg !0
@ringbuf = dso_local global %"struct map_t.0" zeroinitializer, section ".maps", !dbg !20
@event_loss_counter = dso_local global %"struct map_t.1" zeroinitializer, section ".maps", !dbg !34
@num_cpus = dso_local externally_initialized constant i64 1, section ".rodata", !dbg !51

; Function Attrs: nounwind
declare i64 @llvm.bpf.pseudo(i64 %0, i64 %1) #0

define i64 @kprobe_f_1(i8* %0) section "s_kprobe_f_1" !dbg !57 {
entry:
  %initial_value = alloca i64, align 8
  %lookup_elem_val = alloca i64, align 8
  %"@x_key" = alloca i64, align 8
  %1 = bitcast i64* %"@x_key" to i8*
  call void @llvm.lifetime.start.p0i8(i64 -1, i8* %1)
  store i64 0, i64* %"@x_key", align 8
  %lookup_elem = call i8* inttoptr (i64 1 to i8* (%"struct map_t"*, i64*)*)(%"struct map_t"* @AT_x, i64* %"@x_key")
  %get_pid_tgid = call i64 inttoptr (i64 14 to i64 ()*)()
  %2 = lshr i64 %get_pid_tgid, 32
  %3 = bitcast i64* %lookup_elem_val to i8*
  call void @llvm.lifetime.start.p0i8(i64 -1, i8* %3)
  %map_lookup_cond = icmp ne i8* %lookup_elem, null
  br i1 %map_lookup_cond, label %lookup_success, label %lookup_failure

lookup_success:                                   ; preds = %entry
  %cast = bitcast i8* %lookup_elem to i64*
  %4 = load i64, i64* %cast, align 8
  %5 = icmp sge i64 %4, %2
  br i1 %5, label %min.ge, label %lookup_merge

lookup_failure:                                   ; preds = %entry
  %6 = bitcast i64* %initial_value to i8*
  call void @llvm.lifetime.start.p0i8(i64 -1, i8* %6)
  store i64 %2, i64* %initial_value, align 8
  %update_elem = call i64 inttoptr (i64 2 to i64 (%"struct map_t"*, i64*, i64*, i64)*)(%"struct map_t"* @AT_x, i64* %"@x_key", i64* %initial_value, i64 1)
  %7 = bitcast i64* %initial_value to i8*
  call void @llvm.lifetime.end.p0i8(i64 -1, i8* %7)
  br label %lookup_merge

lookup_merge:                                     ; preds = %lookup_failure, %min.ge, %lookup_success
  %8 = bitcast i64* %lookup_elem_val to i8*
  call void @llvm.lifetime.end.p0i8(i64 -1, i8* %8)
  %9 = bitcast i64* %"@x_key" to i8*
  call void @llvm.lifetime.end.p0i8(i64 -1, i8* %9)
  ret i64 0

min.ge:                                           ; preds = %lookup_success
  store i64 %2, i64* %cast, align 8
  br label %lookup_merge
}

; Function Attrs: argmemonly nofree nosync nounwind willreturn
declare void @llvm.lifetime.start.p0i8(i64 immarg %0, i8* nocapture %1) #1

; Function Attrs: argmemonly nofree nosync nounwind willreturn
declare void @llvm.lifetime.end.p0i8(i64 immarg %0, i8* nocapture %1) #1

attributes #0 = { nounwind }
attributes #1 = { argmemonly nofree nosync nounwind willreturn }

!llvm.dbg.cu = !{!53}
!llvm.module.flags = !{!56}

!0 = !DIGlobalVariableExpression(var: !1, expr: !DIExpression())
!1 = distinct !DIGlobalVariable(name: "AT_x", linkageName: "global", scope: !2, file: !2, type: !3, isLocal: false, isDefinition: true)
!2 = !DIFile(filename: "bpftrace.bpf.o", directory: ".")
!3 = !DICompositeType(tag: DW_TAG_structure_type, scope: !2, file: !2, size: 256, elements: !4)
!4 = !{!5, !11, !16, !19}
!5 = !DIDerivedType(tag: DW_TAG_member, name: "type", scope: !2, file: !2, baseType: !6, size: 64)
!6 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !7, size: 64)
!7 = !DICompositeType(tag: DW_TAG_array_type, baseType: !8, size: 160, elements: !9)
!8 = !DIBasicType(name: "int", size: 32, encoding: DW_ATE_signed)
!9 = !{!10}
!10 = !DISubrange(count: 5, lowerBound: 0)
!11 = !DIDerivedType(tag: DW_TAG_member, name: "max_entries", scope: !2, file: !2, baseType: !12, size: 64, offset: 64)
!12 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !13, size: 64)
!13 = !DICompositeType(tag: DW_TAG_array_type, baseType: !8, size: 131072, elements: !14)
!14 = !{!15}
!15 = !DISubrange(count: 4096, lowerBound: 0)
!16 = !DIDerivedType(tag: DW_TAG_member, name: "key", scope: !2, file: !2, baseType: !17, size: 64, offset: 128)
!17 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !18, size: 64)
!18 = !DIBasicType(name: "int64", size: 64, encoding: DW_ATE_signed)
!19 = !DIDerivedType(tag: DW_TAG_member, name: "value", scope: !2, file: !2, baseType: !17, size: 64, offset: 192)
!20 = !DIGlobalVariableExpression(var: !21, expr: !DIExpression())
!21 = distinct !DIGlobalVariable(name: "ringbuf", linkageName: "global", scope: !2, file: !2, type: !22, isLocal: false, isDefinition: true)
!22 = !DICompositeType(tag: DW_TAG_structure_type, scope: !2, file: !2, size: 128, elements: !23)
!23 = !{!24, !29}
!24 = !DIDerivedType(tag: DW_TAG_member, name: "type", scope: !2, file: !2, baseType: !25, size: 64)
!25 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !26, size: 64)
!26 = !DICompositeType(tag: DW_TAG_array_type, baseType: !8, size: 864, elements: !27)
!27 = !{!28}
!28 = !DISubrange(count: 27, lowerBound: 0)
!29 = !DIDerivedType(tag: DW_TAG_member, name: "max_entries", scope: !2, file: !2, baseType: !30, size: 64, offset: 64)
!30 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !31, size: 64)
!31 = !DICompositeType(tag: DW_TAG_array_type, baseType: !8, size: 8388608, elements: !32)
!32 = !{!33}
!33 = !DISubrange(count: 262144, lowerBound: 0)
!34 = !DIGlobalVariableExpression(var: !35, expr: !DIExpression())
!35 = distinct !DIGlobalVariable(name: "event_loss_counter", linkageName: "global", scope: !2, file: !2, type: !36, isLocal: false, isDefinition: true)
!36 = !DICompositeType(tag: DW_TAG_structure_type, scope: !2, file: !2, size: 256, elements: !37)
!37 = !{!38, !43, !48, !19}
!38 = !DIDerivedType(tag: DW_TAG_member, name: "type", scope: !2, file: !2, baseType: !39, size: 64)
!39 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !40, size: 64)
!40 = !DICompositeType(tag: DW_TAG_array_type, baseType: !8, size: 64, elements: !41)
!41 = !{!42}
!42 = !DISubrange(count: 2, lowerBound: 0)
!43 = !DIDerivedType(tag: DW_TAG_member, name: "max_entries", scope: !2, file: !2, baseType: !44, size: 64, offset: 64)
!44 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !45, size: 64)
!45 = !DICompositeType(tag: DW_TAG_array_type, baseType: !8, size: 32, elements: !46)
!46 = !{!47}
!47 = !DISubrange(count: 1, lowerBound: 0)
!48 = !DIDerivedType(tag: DW_TAG_member, name: "key", scope: !2, file: !2, baseType: !49, size: 64, offset: 128)
!49 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !50, size: 64)
!50 = !DIBasicType(name: "int32", size: 32, encoding: DW_ATE_signed)
!51 = !DIGlobalVariableExpression(var: !52, expr: !DIExpression())
!52 = distinct !DIGlobalVariable(name: "num_cpus", linkageName: "global", scope: !2, file: !2, type: !18, isLocal: false, isDefinition: true)
!53 = distinct !DICompileUnit(language: DW_LANG_C, file: !2, producer: "bpftrace", isOptimized: false, runtimeVersion: 0, emissionKind: LineTablesOnly, enums: !54, globals: !55)
!54 = !{}
!55 = !{!0, !20, !34, !51}
!56 = !{i32 2, !"Debug Info Version", i32 3}
!57 = distinct !DISubprogram(name: "kprobe_f_1", linkageName: "kprobe_f_1", scope: !2, file: !2, type: !58, flags: DIFlagPrototyped, spFlags: DISPFlagDefinition, unit: !53, retainedNodes: !62)
!58 = !DISubroutineType(types: !59)
!59 = !{!18, !60}
!60 = !DIDerivedType(tag: DW_TAG_pointer_type, baseType: !61, size: 64)
!61 = !DIBasicType(name: "int8", size: 8, encoding: DW_ATE_signed)
!62 = !{!63}
!63 = !DILocalVariable(name: "ctx", arg: 1, scope: !57, file: !2, type: !60)
