; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -instcombine -S | FileCheck %s

declare i32 @llvm.abs.i32(i32, i1)

define i1 @abs_nsw_must_be_positive(i32 %x) {
; CHECK-LABEL: @abs_nsw_must_be_positive(
; CHECK-NEXT:    ret i1 true
;
  %abs = call i32 @llvm.abs.i32(i32 %x, i1 true)
  %c2 = icmp sge i32 %abs, 0
  ret i1 %c2
}

; Negative test, no nsw provides no information about the sign bit of the result.
define i1 @abs_nonsw(i32 %x) {
; CHECK-LABEL: @abs_nonsw(
; CHECK-NEXT:    [[ABS:%.*]] = call i32 @llvm.abs.i32(i32 [[X:%.*]], i1 false)
; CHECK-NEXT:    [[C2:%.*]] = icmp sgt i32 [[ABS]], -1
; CHECK-NEXT:    ret i1 [[C2]]
;
  %abs = call i32 @llvm.abs.i32(i32 %x, i1 false)
  %c2 = icmp sge i32 %abs, 0
  ret i1 %c2
}

; abs preserves trailing zeros so the second and is unneeded
define i32 @abs_trailing_zeros(i32 %x) {
; CHECK-LABEL: @abs_trailing_zeros(
; CHECK-NEXT:    [[AND:%.*]] = and i32 [[X:%.*]], -4
; CHECK-NEXT:    [[ABS:%.*]] = call i32 @llvm.abs.i32(i32 [[AND]], i1 false)
; CHECK-NEXT:    ret i32 [[ABS]]
;
  %and = and i32 %x, -4
  %abs = call i32 @llvm.abs.i32(i32 %and, i1 false)
  %and2 = and i32 %abs, -2
  ret i32 %and2
}

; negative test, can't remove the second and based on trailing zeroes.
; FIXME: Could remove the first and using demanded bits.
define i32 @abs_trailing_zeros_negative(i32 %x) {
; CHECK-LABEL: @abs_trailing_zeros_negative(
; CHECK-NEXT:    [[AND:%.*]] = and i32 [[X:%.*]], -2
; CHECK-NEXT:    [[ABS:%.*]] = call i32 @llvm.abs.i32(i32 [[AND]], i1 false)
; CHECK-NEXT:    [[AND2:%.*]] = and i32 [[ABS]], -4
; CHECK-NEXT:    ret i32 [[AND2]]
;
  %and = and i32 %x, -2
  %abs = call i32 @llvm.abs.i32(i32 %and, i1 false)
  %and2 = and i32 %abs, -4
  ret i32 %and2
}
