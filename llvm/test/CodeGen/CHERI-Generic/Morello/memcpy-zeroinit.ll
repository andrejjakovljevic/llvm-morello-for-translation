; NOTE: Assertions have been autogenerated by utils/update_test_checks.py UTC_ARGS: --function-signature --scrub-attributes --force-update
; DO NOT EDIT -- This file was generated from test/CodeGen/CHERI-Generic/Inputs/memcpy-zeroinit.ll
; RUN: llc -mtriple=aarch64 --relocation-model=pic -target-abi purecap -mattr=+morello,+c64 < %s -o - | FileCheck %s
; Check that the copy from the zeroinitializer global is turned into a series of zero stores
; or memset() as long as the memcpy is not volatile:

%struct.umutex = type { i32, i32, [2 x i32], i8 addrspace(200)*, i32, [2 x i32] }

@_thr_umutex_init.default_mtx = internal addrspace(200) constant %struct.umutex zeroinitializer, align 16

define void @_thr_umutex_init(%struct.umutex addrspace(200)* %mtx) local_unnamed_addr addrspace(200) nounwind "frame-pointer"="none" {
; CHECK-LABEL: _thr_umutex_init:
; CHECK:       .Lfunc_begin0:
; CHECK-NEXT:  // %bb.0:
; CHECK-NEXT:    movi v0.2d, #0000000000000000
; CHECK-NEXT:    stp q0, q0, [c0, #16]
; CHECK-NEXT:    str q0, [c0]
; CHECK-NEXT:    ret c30
  %1 = bitcast %struct.umutex addrspace(200)* %mtx to i8 addrspace(200)*
  tail call void @llvm.memcpy.p200i8.p200i8.i64(i8 addrspace(200)* align 16 %1, i8 addrspace(200)* align 16 bitcast (%struct.umutex addrspace(200)* @_thr_umutex_init.default_mtx to i8 addrspace(200)*), i64 48, i1 false)
  ret void
}

define void @_thr_umutex_init_volatile(%struct.umutex addrspace(200)* %mtx) local_unnamed_addr addrspace(200) nounwind "frame-pointer"="none" {
; CHECK-LABEL: _thr_umutex_init_volatile:
; CHECK:       .Lfunc_begin1:
; CHECK-NEXT:  // %bb.0:
; CHECK-NEXT:    adrp c1, .L__cap_merged_table
; CHECK-NEXT:    ldr c1, [c1, :lo12:.L__cap_merged_table]
; CHECK-NEXT:    ldr c2, [c1, #0]
; CHECK-NEXT:    ldr c3, [c1, #16]
; CHECK-NEXT:    ldr c1, [c1, #32]
; CHECK-NEXT:    str c1, [c0, #32]
; CHECK-NEXT:    str c3, [c0, #16]
; CHECK-NEXT:    str c2, [c0, #0]
; CHECK-NEXT:    ret c30
  %1 = bitcast %struct.umutex addrspace(200)* %mtx to i8 addrspace(200)*
  tail call void @llvm.memcpy.p200i8.p200i8.i64(i8 addrspace(200)* align 16 %1, i8 addrspace(200)* align 16 bitcast (%struct.umutex addrspace(200)* @_thr_umutex_init.default_mtx to i8 addrspace(200)*), i64 48, i1 true)
  ret void
}

declare void @llvm.memcpy.p200i8.p200i8.i64(i8 addrspace(200)* noalias nocapture writeonly %0, i8 addrspace(200)* noalias nocapture readonly %1, i64 %2, i1 immarg %3) addrspace(200)
