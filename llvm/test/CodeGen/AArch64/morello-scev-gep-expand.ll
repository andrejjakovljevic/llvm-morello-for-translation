; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt %s -loop-reduce -march=aarch64 -mattr=+morello,+c64 -target-abi purecap -S -o - | FileCheck %s

target datalayout = "e-m:e-pf200:128:128:128:64-i8:8:32-i16:16:32-i64:64-i128:128-n32:64-S128-A200-P200-G200"
target triple = "aarch64-none-unknown-elf"

; Expand to an ugly GEP instead of expanding to two GEPs.
; We can't use two GEPs for capabilities because we don't want to take the
; pointer out of bounds.

%struct.widget = type <{ %struct.baz, %struct.widget addrspace(200)*, %struct.baz addrspace(200)*, i8, [15 x i8] }>
%struct.baz = type { %struct.widget addrspace(200)* }
%struct.snork = type { [10 x %struct.spam] }
%struct.spam = type { [8 x %struct.zot] }
%struct.zot = type { i32, [8 x %struct.wombat] }
%struct.wombat = type { [32 x i8], i8 }

define void @wombat() local_unnamed_addr addrspace(200) {
; CHECK-LABEL: @wombat(
; CHECK-NEXT:  bb:
; CHECK-NEXT:    br i1 undef, label [[BB2:%.*]], label [[BB3_PREHEADER:%.*]]
; CHECK:       bb3.preheader:
; CHECK-NEXT:    br label [[BB3:%.*]]
; CHECK:       bb2:
; CHECK-NEXT:    ret void
; CHECK:       bb3:
; CHECK-NEXT:    [[LSR_IV:%.*]] = phi [[STRUCT_WIDGET:%.*]] addrspace(200)* [ undef, [[BB3_PREHEADER]] ], [ [[TMP0:%.*]], [[BB3]] ]
; CHECK-NEXT:    [[LSR_IV1:%.*]] = bitcast [[STRUCT_WIDGET]] addrspace(200)* [[LSR_IV]] to i8 addrspace(200)*
; CHECK-NEXT:    [[TMPLD:%.*]] = load i8, i8 addrspace(200)* [[LSR_IV1]], align 1
; CHECK-NEXT:    [[UGLYGEP:%.*]] = getelementptr i8, i8 addrspace(200)* [[LSR_IV1]], i64 33
; CHECK-NEXT:    [[TMP0]] = bitcast i8 addrspace(200)* [[UGLYGEP]] to [[STRUCT_WIDGET]] addrspace(200)*
; CHECK-NEXT:    br label [[BB3]]
;
bb:
  %tmp = getelementptr inbounds %struct.widget, %struct.widget addrspace(200)* undef, i64 0, i32 4, i64 7
  %tmp1 = bitcast i8 addrspace(200)* %tmp to %struct.snork addrspace(200)*
  br i1 undef, label %bb2, label %bb3

bb2:                                              ; preds = %bb
  ret void

bb3:                                              ; preds = %bb3, %bb
  %tmp4 = phi i64 [ %tmp7, %bb3 ], [ 0, %bb ]
  %tmp5 = getelementptr inbounds %struct.snork, %struct.snork addrspace(200)* %tmp1, i64 0, i32 0, i64 undef, i32 0, i64 undef, i32 1, i64 %tmp4, i32 1
  %tmpld = load i8, i8 addrspace(200)* %tmp5, align 1
  %tmp7 = add nuw nsw i64 %tmp4, 1
  br label %bb3
}
