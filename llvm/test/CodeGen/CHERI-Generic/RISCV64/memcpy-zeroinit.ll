; NOTE: Assertions have been autogenerated by utils/update_test_checks.py UTC_ARGS: --function-signature --scrub-attributes --force-update
; DO NOT EDIT -- This file was generated from test/CodeGen/CHERI-Generic/Inputs/memcpy-zeroinit.ll
; RUN: llc -mtriple=riscv64 --relocation-model=pic -target-abi l64pc128d -mattr=+xcheri,+cap-mode,+f,+d < %s -o - | FileCheck %s
; Check that the copy from the zeroinitializer global is turned into a series of zero stores
; or memset() as long as the memcpy is not volatile:

%struct.umutex = type { i32, i32, [2 x i32], i8 addrspace(200)*, i32, [2 x i32] }

@_thr_umutex_init.default_mtx = internal addrspace(200) constant %struct.umutex zeroinitializer, align 16

; Function Attrs: nounwind
define void @_thr_umutex_init(%struct.umutex addrspace(200)* %mtx) local_unnamed_addr addrspace(200) nounwind "frame-pointer"="none" {
; CHECK-LABEL: _thr_umutex_init:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:    csc cnull, 32(ca0)
; CHECK-NEXT:    csc cnull, 16(ca0)
; CHECK-NEXT:    csc cnull, 0(ca0)
; CHECK-NEXT:    cret
entry:
  %0 = bitcast %struct.umutex addrspace(200)* %mtx to i8 addrspace(200)*
  tail call void @llvm.memcpy.p200i8.p200i8.i64(i8 addrspace(200)* align 16 %0, i8 addrspace(200)* align 16 bitcast (%struct.umutex addrspace(200)* @_thr_umutex_init.default_mtx to i8 addrspace(200)*), i64 48, i1 false)
  ret void
}

; Function Attrs: nounwind
define void @_thr_umutex_init_volatile(%struct.umutex addrspace(200)* %mtx) local_unnamed_addr addrspace(200) nounwind "frame-pointer"="none" {
; CHECK-LABEL: _thr_umutex_init_volatile:
; CHECK:       # %bb.0: # %entry
; CHECK-NEXT:  .LBB1_1: # %entry
; CHECK-NEXT:    # Label of block must be emitted
; CHECK-NEXT:    auipcc ca1, %captab_pcrel_hi(_thr_umutex_init.default_mtx)
; CHECK-NEXT:    clc ca1, %pcrel_lo(.LBB1_1)(ca1)
; CHECK-NEXT:    clc ca2, 32(ca1)
; CHECK-NEXT:    csc ca2, 32(ca0)
; CHECK-NEXT:    clc ca2, 16(ca1)
; CHECK-NEXT:    csc ca2, 16(ca0)
; CHECK-NEXT:    clc ca1, 0(ca1)
; CHECK-NEXT:    csc ca1, 0(ca0)
; CHECK-NEXT:    cret
entry:
  %0 = bitcast %struct.umutex addrspace(200)* %mtx to i8 addrspace(200)*
  tail call void @llvm.memcpy.p200i8.p200i8.i64(i8 addrspace(200)* align 16 %0, i8 addrspace(200)* align 16 bitcast (%struct.umutex addrspace(200)* @_thr_umutex_init.default_mtx to i8 addrspace(200)*), i64 48, i1 true)
  ret void
}

declare void @llvm.memcpy.p200i8.p200i8.i64(i8 addrspace(200)* noalias nocapture writeonly %0, i8 addrspace(200)* noalias nocapture readonly %1, i64 %2, i1 immarg %3) addrspace(200) #0
attributes #0 = { argmemonly nounwind willreturn }
