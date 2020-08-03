; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt < %s -instcombine -S | FileCheck %s

@G1 = global i32 0
@G2 = global i32 0

define i1 @test0(i1 %A) {
; CHECK-LABEL: @test0(
; CHECK-NEXT:    ret i1 [[A:%.*]]
;
  %B = xor i1 %A, false
  ret i1 %B
}

define i32 @test1(i32 %A) {
; CHECK-LABEL: @test1(
; CHECK-NEXT:    ret i32 [[A:%.*]]
;
  %B = xor i32 %A, 0
  ret i32 %B
}

define i1 @test2(i1 %A) {
; CHECK-LABEL: @test2(
; CHECK-NEXT:    ret i1 false
;
  %B = xor i1 %A, %A
  ret i1 %B
}

define i32 @test3(i32 %A) {
; CHECK-LABEL: @test3(
; CHECK-NEXT:    ret i32 0
;
  %B = xor i32 %A, %A
  ret i32 %B
}

define i32 @test4(i32 %A) {
; CHECK-LABEL: @test4(
; CHECK-NEXT:    ret i32 -1
;
  %NotA = xor i32 -1, %A
  %B = xor i32 %A, %NotA
  ret i32 %B
}

define i32 @test5(i32 %A) {
; CHECK-LABEL: @test5(
; CHECK-NEXT:    [[TMP1:%.*]] = and i32 [[A:%.*]], -124
; CHECK-NEXT:    ret i32 [[TMP1]]
;
  %t1 = or i32 %A, 123
  %r = xor i32 %t1, 123
  ret i32 %r
}

define i8 @test6(i8 %A) {
; CHECK-LABEL: @test6(
; CHECK-NEXT:    ret i8 [[A:%.*]]
;
  %B = xor i8 %A, 17
  %C = xor i8 %B, 17
  ret i8 %C
}

define i32 @test7(i32 %A, i32 %B) {
; CHECK-LABEL: @test7(
; CHECK-NEXT:    [[A1:%.*]] = and i32 [[A:%.*]], 7
; CHECK-NEXT:    [[B1:%.*]] = and i32 [[B:%.*]], 128
; CHECK-NEXT:    [[C11:%.*]] = or i32 [[A1]], [[B1]]
; CHECK-NEXT:    ret i32 [[C11]]
;
  %A1 = and i32 %A, 7
  %B1 = and i32 %B, 128
  %C1 = xor i32 %A1, %B1
  ret i32 %C1
}

define i8 @test8(i1 %c) {
; CHECK-LABEL: @test8(
; CHECK-NEXT:    br i1 [[C:%.*]], label [[FALSE:%.*]], label [[TRUE:%.*]]
; CHECK:       True:
; CHECK-NEXT:    ret i8 1
; CHECK:       False:
; CHECK-NEXT:    ret i8 3
;
  %d = xor i1 %c, true
  br i1 %d, label %True, label %False

True:
  ret i8 1

False:
  ret i8 3
}

define i1 @test9(i8 %A) {
; CHECK-LABEL: @test9(
; CHECK-NEXT:    [[C:%.*]] = icmp eq i8 [[A:%.*]], 89
; CHECK-NEXT:    ret i1 [[C]]
;
  %B = xor i8 %A, 123
  %C = icmp eq i8 %B, 34
  ret i1 %C
}

define <2 x i1> @test9vec(<2 x i8> %a) {
; CHECK-LABEL: @test9vec(
; CHECK-NEXT:    [[C:%.*]] = icmp eq <2 x i8> [[A:%.*]], <i8 89, i8 89>
; CHECK-NEXT:    ret <2 x i1> [[C]]
;
  %b = xor <2 x i8> %a, <i8 123, i8 123>
  %c = icmp eq <2 x i8> %b, <i8 34, i8 34>
  ret <2 x i1> %c
}

define i8 @test10(i8 %A) {
; CHECK-LABEL: @test10(
; CHECK-NEXT:    [[B:%.*]] = and i8 [[A:%.*]], 3
; CHECK-NEXT:    [[C1:%.*]] = or i8 [[B]], 4
; CHECK-NEXT:    ret i8 [[C1]]
;
  %B = and i8 %A, 3
  %C = xor i8 %B, 4
  ret i8 %C
}

define i8 @test11(i8 %A) {
; CHECK-LABEL: @test11(
; CHECK-NEXT:    [[B:%.*]] = and i8 [[A:%.*]], -13
; CHECK-NEXT:    [[TMP1:%.*]] = or i8 [[B]], 8
; CHECK-NEXT:    ret i8 [[TMP1]]
;
  %B = or i8 %A, 12
  %C = xor i8 %B, 4
  ret i8 %C
}

define i1 @test12(i8 %A) {
; CHECK-LABEL: @test12(
; CHECK-NEXT:    [[C:%.*]] = icmp ne i8 [[A:%.*]], 4
; CHECK-NEXT:    ret i1 [[C]]
;
  %B = xor i8 %A, 4
  %c = icmp ne i8 %B, 0
  ret i1 %c
}

define <2 x i1> @test12vec(<2 x i8> %a) {
; CHECK-LABEL: @test12vec(
; CHECK-NEXT:    [[C:%.*]] = icmp ne <2 x i8> [[A:%.*]], <i8 4, i8 4>
; CHECK-NEXT:    ret <2 x i1> [[C]]
;
  %b = xor <2 x i8> %a, <i8 4, i8 4>
  %c = icmp ne <2 x i8> %b, zeroinitializer
  ret <2 x i1> %c
}

define i32 @test18(i32 %A) {
; CHECK-LABEL: @test18(
; CHECK-NEXT:    [[C:%.*]] = add i32 [[A:%.*]], 124
; CHECK-NEXT:    ret i32 [[C]]
;
  %B = xor i32 %A, -1
  %C = sub i32 123, %B
  ret i32 %C
}

define i32 @test19(i32 %A, i32 %B) {
; CHECK-LABEL: @test19(
; CHECK-NEXT:    ret i32 [[B:%.*]]
;
  %C = xor i32 %A, %B
  %D = xor i32 %C, %A
  ret i32 %D
}

define void @test20(i32 %A, i32 %B) {
; CHECK-LABEL: @test20(
; CHECK-NEXT:    store i32 [[B:%.*]], i32* @G1, align 4
; CHECK-NEXT:    store i32 [[A:%.*]], i32* @G2, align 4
; CHECK-NEXT:    ret void
;
  %t2 = xor i32 %B, %A
  %t5 = xor i32 %t2, %B
  %t8 = xor i32 %t5, %t2
  store i32 %t8, i32* @G1
  store i32 %t5, i32* @G2
  ret void
}

define i32 @test22(i1 %X) {
; CHECK-LABEL: @test22(
; CHECK-NEXT:    [[Z:%.*]] = zext i1 [[X:%.*]] to i32
; CHECK-NEXT:    ret i32 [[Z]]
;
  %Y = xor i1 %X, true
  %Z = zext i1 %Y to i32
  %Q = xor i32 %Z, 1
  ret i32 %Q
}

; Look through a zext between xors.

define i32 @fold_zext_xor_sandwich(i1 %X) {
; CHECK-LABEL: @fold_zext_xor_sandwich(
; CHECK-NEXT:    [[Z:%.*]] = zext i1 [[X:%.*]] to i32
; CHECK-NEXT:    [[Q:%.*]] = xor i32 [[Z]], 3
; CHECK-NEXT:    ret i32 [[Q]]
;
  %Y = xor i1 %X, true
  %Z = zext i1 %Y to i32
  %Q = xor i32 %Z, 2
  ret i32 %Q
}

define <2 x i32> @fold_zext_xor_sandwich_vec(<2 x i1> %X) {
; CHECK-LABEL: @fold_zext_xor_sandwich_vec(
; CHECK-NEXT:    [[Z:%.*]] = zext <2 x i1> [[X:%.*]] to <2 x i32>
; CHECK-NEXT:    [[Q:%.*]] = xor <2 x i32> [[Z]], <i32 3, i32 3>
; CHECK-NEXT:    ret <2 x i32> [[Q]]
;
  %Y = xor <2 x i1> %X, <i1 true, i1 true>
  %Z = zext <2 x i1> %Y to <2 x i32>
  %Q = xor <2 x i32> %Z, <i32 2, i32 2>
  ret <2 x i32> %Q
}

define i1 @test23(i32 %a, i32 %b) {
; CHECK-LABEL: @test23(
; CHECK-NEXT:    [[T4:%.*]] = icmp eq i32 [[B:%.*]], 0
; CHECK-NEXT:    ret i1 [[T4]]
;
  %t2 = xor i32 %b, %a
  %t4 = icmp eq i32 %t2, %a
  ret i1 %t4
}

define i1 @test24(i32 %c, i32 %d) {
; CHECK-LABEL: @test24(
; CHECK-NEXT:    [[T4:%.*]] = icmp ne i32 [[D:%.*]], 0
; CHECK-NEXT:    ret i1 [[T4]]
;
  %t2 = xor i32 %d, %c
  %t4 = icmp ne i32 %t2, %c
  ret i1 %t4
}

define i32 @test25(i32 %g, i32 %h) {
; CHECK-LABEL: @test25(
; CHECK-NEXT:    [[T4:%.*]] = and i32 [[H:%.*]], [[G:%.*]]
; CHECK-NEXT:    ret i32 [[T4]]
;
  %h2 = xor i32 %h, -1
  %t2 = and i32 %h2, %g
  %t4 = xor i32 %t2, %g
  ret i32 %t4
}

define i32 @test27(i32 %b, i32 %c, i32 %d) {
; CHECK-LABEL: @test27(
; CHECK-NEXT:    [[T6:%.*]] = icmp eq i32 [[B:%.*]], [[C:%.*]]
; CHECK-NEXT:    [[T7:%.*]] = zext i1 [[T6]] to i32
; CHECK-NEXT:    ret i32 [[T7]]
;
  %t2 = xor i32 %d, %b
  %t5 = xor i32 %d, %c
  %t6 = icmp eq i32 %t2, %t5
  %t7 = zext i1 %t6 to i32
  ret i32 %t7
}

define i32 @test28(i32 %indvar) {
; CHECK-LABEL: @test28(
; CHECK-NEXT:    [[T214:%.*]] = add i32 [[INDVAR:%.*]], 1
; CHECK-NEXT:    ret i32 [[T214]]
;
  %t7 = add i32 %indvar, -2147483647
  %t214 = xor i32 %t7, -2147483648
  ret i32 %t214
}

define <2 x i32> @test28vec(<2 x i32> %indvar) {
; CHECK-LABEL: @test28vec(
; CHECK-NEXT:    [[T214:%.*]] = add <2 x i32> [[INDVAR:%.*]], <i32 1, i32 1>
; CHECK-NEXT:    ret <2 x i32> [[T214]]
;
  %t7 = add <2 x i32> %indvar, <i32 -2147483647, i32 -2147483647>
  %t214 = xor <2 x i32> %t7, <i32 -2147483648, i32 -2147483648>
  ret <2 x i32> %t214
}

define i32 @test28_sub(i32 %indvar) {
; CHECK-LABEL: @test28_sub(
; CHECK-NEXT:    [[T214:%.*]] = sub i32 1, [[INDVAR:%.*]]
; CHECK-NEXT:    ret i32 [[T214]]
;
  %t7 = sub i32 -2147483647, %indvar
  %t214 = xor i32 %t7, -2147483648
  ret i32 %t214
}

define <2 x i32> @test28_subvec(<2 x i32> %indvar) {
; CHECK-LABEL: @test28_subvec(
; CHECK-NEXT:    [[T214:%.*]] = sub <2 x i32> <i32 1, i32 1>, [[INDVAR:%.*]]
; CHECK-NEXT:    ret <2 x i32> [[T214]]
;
  %t7 = sub <2 x i32> <i32 -2147483647, i32 -2147483647>, %indvar
  %t214 = xor <2 x i32> %t7, <i32 -2147483648, i32 -2147483648>
  ret <2 x i32> %t214
}

define i32 @test29(i1 %C) {
; CHECK-LABEL: @test29(
; CHECK-NEXT:    [[V:%.*]] = select i1 [[C:%.*]], i32 915, i32 113
; CHECK-NEXT:    ret i32 [[V]]
;
  %A = select i1 %C, i32 1000, i32 10
  %V = xor i32 %A, 123
  ret i32 %V
}

define <2 x i32> @test29vec(i1 %C) {
; CHECK-LABEL: @test29vec(
; CHECK-NEXT:    [[V:%.*]] = select i1 [[C:%.*]], <2 x i32> <i32 915, i32 915>, <2 x i32> <i32 113, i32 113>
; CHECK-NEXT:    ret <2 x i32> [[V]]
;
  %A = select i1 %C, <2 x i32> <i32 1000, i32 1000>, <2 x i32> <i32 10, i32 10>
  %V = xor <2 x i32> %A, <i32 123, i32 123>
  ret <2 x i32> %V
}

define <2 x i32> @test29vec2(i1 %C) {
; CHECK-LABEL: @test29vec2(
; CHECK-NEXT:    [[V:%.*]] = select i1 [[C:%.*]], <2 x i32> <i32 915, i32 2185>, <2 x i32> <i32 113, i32 339>
; CHECK-NEXT:    ret <2 x i32> [[V]]
;
  %A = select i1 %C, <2 x i32> <i32 1000, i32 2500>, <2 x i32> <i32 10, i32 30>
  %V = xor <2 x i32> %A, <i32 123, i32 333>
  ret <2 x i32> %V
}

define i32 @test30(i1 %which) {
; CHECK-LABEL: @test30(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br i1 [[WHICH:%.*]], label [[FINAL:%.*]], label [[DELAY:%.*]]
; CHECK:       delay:
; CHECK-NEXT:    br label [[FINAL]]
; CHECK:       final:
; CHECK-NEXT:    [[A:%.*]] = phi i32 [ 915, [[ENTRY:%.*]] ], [ 113, [[DELAY]] ]
; CHECK-NEXT:    ret i32 [[A]]
;
entry:
  br i1 %which, label %final, label %delay

delay:
  br label %final

final:
  %A = phi i32 [ 1000, %entry ], [ 10, %delay ]
  %value = xor i32 %A, 123
  ret i32 %value
}

define <2 x i32> @test30vec(i1 %which) {
; CHECK-LABEL: @test30vec(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br i1 [[WHICH:%.*]], label [[FINAL:%.*]], label [[DELAY:%.*]]
; CHECK:       delay:
; CHECK-NEXT:    br label [[FINAL]]
; CHECK:       final:
; CHECK-NEXT:    [[A:%.*]] = phi <2 x i32> [ <i32 915, i32 915>, [[ENTRY:%.*]] ], [ <i32 113, i32 113>, [[DELAY]] ]
; CHECK-NEXT:    ret <2 x i32> [[A]]
;
entry:
  br i1 %which, label %final, label %delay

delay:
  br label %final

final:
  %A = phi <2 x i32> [ <i32 1000, i32 1000>, %entry ], [ <i32 10, i32 10>, %delay ]
  %value = xor <2 x i32> %A, <i32 123, i32 123>
  ret <2 x i32> %value
}

define <2 x i32> @test30vec2(i1 %which) {
; CHECK-LABEL: @test30vec2(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br i1 [[WHICH:%.*]], label [[FINAL:%.*]], label [[DELAY:%.*]]
; CHECK:       delay:
; CHECK-NEXT:    br label [[FINAL]]
; CHECK:       final:
; CHECK-NEXT:    [[A:%.*]] = phi <2 x i32> [ <i32 915, i32 2185>, [[ENTRY:%.*]] ], [ <i32 113, i32 339>, [[DELAY]] ]
; CHECK-NEXT:    ret <2 x i32> [[A]]
;
entry:
  br i1 %which, label %final, label %delay

delay:
  br label %final

final:
  %A = phi <2 x i32> [ <i32 1000, i32 2500>, %entry ], [ <i32 10, i32 30>, %delay ]
  %value = xor <2 x i32> %A, <i32 123, i32 333>
  ret <2 x i32> %value
}

; B ^ (B | A) --> A & ~B
; The division ops are here to thwart complexity-based canonicalization: all ops are binops.

define i32 @or_xor_commute1(i32 %p1, i32 %p2) {
; CHECK-LABEL: @or_xor_commute1(
; CHECK-NEXT:    [[A:%.*]] = udiv i32 42, [[P1:%.*]]
; CHECK-NEXT:    [[B:%.*]] = udiv i32 42, [[P2:%.*]]
; CHECK-NEXT:    [[TMP1:%.*]] = xor i32 [[B]], -1
; CHECK-NEXT:    [[R:%.*]] = and i32 [[A]], [[TMP1]]
; CHECK-NEXT:    ret i32 [[R]]
;
  %a = udiv i32 42, %p1
  %b = udiv i32 42, %p2
  %o = or i32 %b, %a
  %r = xor i32 %b, %o
  ret i32 %r
}

; B ^ (B | A) --> A & ~B
; The division ops are here to thwart complexity-based canonicalization: all ops are binops.

define i32 @or_xor_commute2(i32 %p1, i32 %p2) {
; CHECK-LABEL: @or_xor_commute2(
; CHECK-NEXT:    [[A:%.*]] = udiv i32 42, [[P1:%.*]]
; CHECK-NEXT:    [[B:%.*]] = udiv i32 42, [[P2:%.*]]
; CHECK-NEXT:    [[TMP1:%.*]] = xor i32 [[B]], -1
; CHECK-NEXT:    [[R:%.*]] = and i32 [[A]], [[TMP1]]
; CHECK-NEXT:    ret i32 [[R]]
;
  %a = udiv i32 42, %p1
  %b = udiv i32 42, %p2
  %o = or i32 %a, %b
  %r = xor i32 %o, %b
  ret i32 %r
}

; B ^ (B | A) --> A & ~B
; The division ops are here to thwart complexity-based canonicalization: all ops are binops.

define i32 @or_xor_commute3(i32 %p1, i32 %p2) {
; CHECK-LABEL: @or_xor_commute3(
; CHECK-NEXT:    [[A:%.*]] = udiv i32 42, [[P1:%.*]]
; CHECK-NEXT:    [[B:%.*]] = udiv i32 42, [[P2:%.*]]
; CHECK-NEXT:    [[TMP1:%.*]] = xor i32 [[B]], -1
; CHECK-NEXT:    [[R:%.*]] = and i32 [[A]], [[TMP1]]
; CHECK-NEXT:    ret i32 [[R]]
;
  %a = udiv i32 42, %p1
  %b = udiv i32 42, %p2
  %o = or i32 %b, %a
  %r = xor i32 %o, %b
  ret i32 %r
}

; B ^ (B | A) --> A & ~B
; The division ops are here to thwart complexity-based canonicalization: all ops are binops.

define i32 @or_xor_commute4(i32 %p1, i32 %p2) {
; CHECK-LABEL: @or_xor_commute4(
; CHECK-NEXT:    [[A:%.*]] = udiv i32 42, [[P1:%.*]]
; CHECK-NEXT:    [[B:%.*]] = udiv i32 42, [[P2:%.*]]
; CHECK-NEXT:    [[TMP1:%.*]] = xor i32 [[B]], -1
; CHECK-NEXT:    [[R:%.*]] = and i32 [[A]], [[TMP1]]
; CHECK-NEXT:    ret i32 [[R]]
;
  %a = udiv i32 42, %p1
  %b = udiv i32 42, %p2
  %o = or i32 %a, %b
  %r = xor i32 %b, %o
  ret i32 %r
}

define i32 @or_xor_extra_use(i32 %a, i32 %b, i32* %p) {
; CHECK-LABEL: @or_xor_extra_use(
; CHECK-NEXT:    [[O:%.*]] = or i32 [[A:%.*]], [[B:%.*]]
; CHECK-NEXT:    store i32 [[O]], i32* [[P:%.*]], align 4
; CHECK-NEXT:    [[R:%.*]] = xor i32 [[O]], [[B]]
; CHECK-NEXT:    ret i32 [[R]]
;
  %o = or i32 %a, %b
  store i32 %o, i32* %p
  %r = xor i32 %b, %o
  ret i32 %r
}

; B ^ (B & A) --> ~A & B
; The division ops are here to thwart complexity-based canonicalization: all ops are binops.

define i32 @and_xor_commute1(i32 %p1, i32 %p2) {
; CHECK-LABEL: @and_xor_commute1(
; CHECK-NEXT:    [[A:%.*]] = udiv i32 42, [[P1:%.*]]
; CHECK-NEXT:    [[B:%.*]] = udiv i32 42, [[P2:%.*]]
; CHECK-NEXT:    [[TMP1:%.*]] = xor i32 [[A]], -1
; CHECK-NEXT:    [[R:%.*]] = and i32 [[B]], [[TMP1]]
; CHECK-NEXT:    ret i32 [[R]]
;
  %a = udiv i32 42, %p1
  %b = udiv i32 42, %p2
  %o = and i32 %b, %a
  %r = xor i32 %b, %o
  ret i32 %r
}

; B ^ (B & A) --> ~A & B
; The division ops are here to thwart complexity-based canonicalization: all ops are binops.

define i32 @and_xor_commute2(i32 %p1, i32 %p2) {
; CHECK-LABEL: @and_xor_commute2(
; CHECK-NEXT:    [[A:%.*]] = udiv i32 42, [[P1:%.*]]
; CHECK-NEXT:    [[B:%.*]] = udiv i32 42, [[P2:%.*]]
; CHECK-NEXT:    [[TMP1:%.*]] = xor i32 [[A]], -1
; CHECK-NEXT:    [[R:%.*]] = and i32 [[B]], [[TMP1]]
; CHECK-NEXT:    ret i32 [[R]]
;
  %a = udiv i32 42, %p1
  %b = udiv i32 42, %p2
  %o = and i32 %a, %b
  %r = xor i32 %o, %b
  ret i32 %r
}

; B ^ (B & A) --> ~A & B
; The division ops are here to thwart complexity-based canonicalization: all ops are binops.

define i32 @and_xor_commute3(i32 %p1, i32 %p2) {
; CHECK-LABEL: @and_xor_commute3(
; CHECK-NEXT:    [[A:%.*]] = udiv i32 42, [[P1:%.*]]
; CHECK-NEXT:    [[B:%.*]] = udiv i32 42, [[P2:%.*]]
; CHECK-NEXT:    [[TMP1:%.*]] = xor i32 [[A]], -1
; CHECK-NEXT:    [[R:%.*]] = and i32 [[B]], [[TMP1]]
; CHECK-NEXT:    ret i32 [[R]]
;
  %a = udiv i32 42, %p1
  %b = udiv i32 42, %p2
  %o = and i32 %b, %a
  %r = xor i32 %o, %b
  ret i32 %r
}

; B ^ (B & A) --> ~A & B
; The division ops are here to thwart complexity-based canonicalization: all ops are binops.

define i32 @and_xor_commute4(i32 %p1, i32 %p2) {
; CHECK-LABEL: @and_xor_commute4(
; CHECK-NEXT:    [[A:%.*]] = udiv i32 42, [[P1:%.*]]
; CHECK-NEXT:    [[B:%.*]] = udiv i32 42, [[P2:%.*]]
; CHECK-NEXT:    [[TMP1:%.*]] = xor i32 [[A]], -1
; CHECK-NEXT:    [[R:%.*]] = and i32 [[B]], [[TMP1]]
; CHECK-NEXT:    ret i32 [[R]]
;
  %a = udiv i32 42, %p1
  %b = udiv i32 42, %p2
  %o = and i32 %a, %b
  %r = xor i32 %b, %o
  ret i32 %r
}

define i32 @and_xor_extra_use(i32 %a, i32 %b, i32* %p) {
; CHECK-LABEL: @and_xor_extra_use(
; CHECK-NEXT:    [[O:%.*]] = and i32 [[A:%.*]], [[B:%.*]]
; CHECK-NEXT:    store i32 [[O]], i32* [[P:%.*]], align 4
; CHECK-NEXT:    [[R:%.*]] = xor i32 [[O]], [[B]]
; CHECK-NEXT:    ret i32 [[R]]
;
  %o = and i32 %a, %b
  store i32 %o, i32* %p
  %r = xor i32 %b, %o
  ret i32 %r
}

; (~X | C2) ^ C1 --> ((X & ~C2) ^ -1) ^ C1 --> (X & ~C2) ^ ~C1
; The extra use (store) is here because the simpler case
; may be transformed using demanded bits.

define i8 @xor_or_not(i8 %x, i8* %p) {
; CHECK-LABEL: @xor_or_not(
; CHECK-NEXT:    [[NX:%.*]] = xor i8 [[X:%.*]], -1
; CHECK-NEXT:    store i8 [[NX]], i8* [[P:%.*]], align 1
; CHECK-NEXT:    [[TMP1:%.*]] = and i8 [[X]], -8
; CHECK-NEXT:    [[R:%.*]] = xor i8 [[TMP1]], -13
; CHECK-NEXT:    ret i8 [[R]]
;
  %nx = xor i8 %x, -1
  store i8 %nx, i8* %p
  %or = or i8 %nx, 7
  %r = xor i8 %or, 12
  ret i8 %r
}

; Don't do this if the 'or' has extra uses.

define i8 @xor_or_not_uses(i8 %x, i8* %p) {
; CHECK-LABEL: @xor_or_not_uses(
; CHECK-NEXT:    [[TMP1:%.*]] = or i8 [[X:%.*]], 7
; CHECK-NEXT:    [[OR:%.*]] = xor i8 [[TMP1]], -8
; CHECK-NEXT:    store i8 [[OR]], i8* [[P:%.*]], align 1
; CHECK-NEXT:    [[R:%.*]] = xor i8 [[TMP1]], -12
; CHECK-NEXT:    ret i8 [[R]]
;
  %nx = xor i8 %x, -1
  %or = or i8 %nx, 7
  store i8 %or, i8* %p
  %r = xor i8 %or, 12
  ret i8 %r
}

; (~X & C2) ^ C1 --> ((X | ~C2) ^ -1) ^ C1 --> (X | ~C2) ^ ~C1
; The extra use (store) is here because the simpler case
; may be transformed using demanded bits.

define i8 @xor_and_not(i8 %x, i8* %p) {
; CHECK-LABEL: @xor_and_not(
; CHECK-NEXT:    [[NX:%.*]] = xor i8 [[X:%.*]], -1
; CHECK-NEXT:    store i8 [[NX]], i8* [[P:%.*]], align 1
; CHECK-NEXT:    [[TMP1:%.*]] = or i8 [[X]], -43
; CHECK-NEXT:    [[R:%.*]] = xor i8 [[TMP1]], -32
; CHECK-NEXT:    ret i8 [[R]]
;
  %nx = xor i8 %x, -1
  store i8 %nx, i8* %p
  %and = and i8 %nx, 42
  %r = xor i8 %and, 31
  ret i8 %r
}

; Don't do this if the 'and' has extra uses.

define i8 @xor_and_not_uses(i8 %x, i8* %p) {
; CHECK-LABEL: @xor_and_not_uses(
; CHECK-NEXT:    [[NX:%.*]] = and i8 [[X:%.*]], 42
; CHECK-NEXT:    [[AND:%.*]] = xor i8 [[NX]], 42
; CHECK-NEXT:    store i8 [[AND]], i8* [[P:%.*]], align 1
; CHECK-NEXT:    [[R:%.*]] = xor i8 [[NX]], 53
; CHECK-NEXT:    ret i8 [[R]]
;
  %nx = xor i8 %x, -1
  %and = and i8 %nx, 42
  store i8 %and, i8* %p
  %r = xor i8 %and, 31
  ret i8 %r
}

; The tests 39-47 are related to the canonicalization:
; %notx = xor i32 %x, -1
; %cmp = icmp sgt i32 %notx, %y
; %smax = select i1 %cmp, i32 %notx, i32 %y
; %res = xor i32 %smax, -1
;   =>
; %noty = xor i32 %y, -1
; %cmp2 = icmp slt %x, %noty
; %res = select i1 %cmp2, i32 %x, i32 %noty
;
; Same transformations is valid for smin/umax/umin.

define i32 @test39(i32 %x) {
; CHECK-LABEL: @test39(
; CHECK-NEXT:    [[TMP1:%.*]] = icmp slt i32 [[X:%.*]], 255
; CHECK-NEXT:    [[TMP2:%.*]] = select i1 [[TMP1]], i32 [[X]], i32 255
; CHECK-NEXT:    ret i32 [[TMP2]]
;
  %1 = xor i32 %x, -1
  %2 = icmp sgt i32 %1, -256
  %3 = select i1 %2, i32 %1, i32 -256
  %res = xor i32 %3, -1
  ret i32 %res
}

define i32 @test40(i32 %x, i32 %y) {
; CHECK-LABEL: @test40(
; CHECK-NEXT:    [[TMP1:%.*]] = xor i32 [[Y:%.*]], -1
; CHECK-NEXT:    [[TMP2:%.*]] = icmp sgt i32 [[TMP1]], [[X:%.*]]
; CHECK-NEXT:    [[RES:%.*]] = select i1 [[TMP2]], i32 [[X]], i32 [[TMP1]]
; CHECK-NEXT:    ret i32 [[RES]]
;
  %notx = xor i32 %x, -1
  %cmp1 = icmp sgt i32 %notx, %y
  %smax = select i1 %cmp1, i32 %notx, i32 %y
  %res = xor i32 %smax, -1
  ret i32 %res
}

define i32 @test41(i32 %x, i32 %y) {
; CHECK-LABEL: @test41(
; CHECK-NEXT:    [[TMP1:%.*]] = xor i32 [[Y:%.*]], -1
; CHECK-NEXT:    [[TMP2:%.*]] = icmp slt i32 [[TMP1]], [[X:%.*]]
; CHECK-NEXT:    [[RES:%.*]] = select i1 [[TMP2]], i32 [[X]], i32 [[TMP1]]
; CHECK-NEXT:    ret i32 [[RES]]
;
  %notx = xor i32 %x, -1
  %cmp1 = icmp slt i32 %notx, %y
  %smin = select i1 %cmp1, i32 %notx, i32 %y
  %res = xor i32 %smin, -1
  ret i32 %res
}

define i32 @test42(i32 %x, i32 %y) {
; CHECK-LABEL: @test42(
; CHECK-NEXT:    [[TMP1:%.*]] = xor i32 [[Y:%.*]], -1
; CHECK-NEXT:    [[TMP2:%.*]] = icmp ugt i32 [[TMP1]], [[X:%.*]]
; CHECK-NEXT:    [[RES:%.*]] = select i1 [[TMP2]], i32 [[X]], i32 [[TMP1]]
; CHECK-NEXT:    ret i32 [[RES]]
;
  %notx = xor i32 %x, -1
  %cmp1 = icmp ugt i32 %notx, %y
  %umax = select i1 %cmp1, i32 %notx, i32 %y
  %res = xor i32 %umax, -1
  ret i32 %res
}

define i32 @test43(i32 %x, i32 %y) {
; CHECK-LABEL: @test43(
; CHECK-NEXT:    [[TMP1:%.*]] = xor i32 [[Y:%.*]], -1
; CHECK-NEXT:    [[TMP2:%.*]] = icmp ult i32 [[TMP1]], [[X:%.*]]
; CHECK-NEXT:    [[RES:%.*]] = select i1 [[TMP2]], i32 [[X]], i32 [[TMP1]]
; CHECK-NEXT:    ret i32 [[RES]]
;
  %notx = xor i32 %x, -1
  %cmp1 = icmp ult i32 %notx, %y
  %umin = select i1 %cmp1, i32 %notx, i32 %y
  %res = xor i32 %umin, -1
  ret i32 %res
}

define i32 @test44(i32 %x, i32 %y) {
; CHECK-LABEL: @test44(
; CHECK-NEXT:    [[TMP1:%.*]] = sub i32 -4, [[Y:%.*]]
; CHECK-NEXT:    [[TMP2:%.*]] = icmp ugt i32 [[TMP1]], [[X:%.*]]
; CHECK-NEXT:    [[RES:%.*]] = select i1 [[TMP2]], i32 [[TMP1]], i32 [[X]]
; CHECK-NEXT:    ret i32 [[RES]]
;
  %z = add i32 %y, 3 ; thwart complexity-based canonicalization
  %notx = xor i32 %x, -1
  %cmp1 = icmp ult i32 %z, %notx
  %umin = select i1 %cmp1, i32 %z, i32 %notx
  %res = xor i32 %umin, -1
  ret i32 %res
}

define i32 @test45(i32 %x, i32 %y) {
; CHECK-LABEL: @test45(
; CHECK-NEXT:    [[TMP1:%.*]] = icmp ugt i32 [[Y:%.*]], [[X:%.*]]
; CHECK-NEXT:    [[TMP2:%.*]] = select i1 [[TMP1]], i32 [[Y]], i32 [[X]]
; CHECK-NEXT:    ret i32 [[TMP2]]
;
  %z = xor i32 %y, -1
  %notx = xor i32 %x, -1
  %cmp1 = icmp ult i32 %z, %notx
  %umin = select i1 %cmp1, i32 %z, i32 %notx
  %res = xor i32 %umin, -1
  ret i32 %res
}

; Check that we work with splat vectors also.
define <4 x i32> @test46(<4 x i32> %x) {
; CHECK-LABEL: @test46(
; CHECK-NEXT:    [[TMP1:%.*]] = icmp slt <4 x i32> [[X:%.*]], <i32 255, i32 255, i32 255, i32 255>
; CHECK-NEXT:    [[TMP2:%.*]] = select <4 x i1> [[TMP1]], <4 x i32> [[X]], <4 x i32> <i32 255, i32 255, i32 255, i32 255>
; CHECK-NEXT:    ret <4 x i32> [[TMP2]]
;
  %1 = xor <4 x i32> %x, <i32 -1, i32 -1, i32 -1, i32 -1>
  %2 = icmp sgt <4 x i32> %1, <i32 -256, i32 -256, i32 -256, i32 -256>
  %3 = select <4 x i1> %2, <4 x i32> %1, <4 x i32> <i32 -256, i32 -256, i32 -256, i32 -256>
  %4 = xor <4 x i32> %3, <i32 -1, i32 -1, i32 -1, i32 -1>
  ret <4 x i32> %4
}

; Test case when select pattern has more than one use.
define i32 @test47(i32 %x, i32 %y, i32 %z) {
; CHECK-LABEL: @test47(
; CHECK-NEXT:    [[NOTX:%.*]] = xor i32 [[X:%.*]], -1
; CHECK-NEXT:    [[CMP1:%.*]] = icmp ugt i32 [[NOTX]], [[Y:%.*]]
; CHECK-NEXT:    [[UMAX:%.*]] = select i1 [[CMP1]], i32 [[NOTX]], i32 [[Y]]
; CHECK-NEXT:    [[UMIN:%.*]] = xor i32 [[UMAX]], -1
; CHECK-NEXT:    [[ADD:%.*]] = add i32 [[UMAX]], [[Z:%.*]]
; CHECK-NEXT:    [[RES:%.*]] = mul i32 [[ADD]], [[UMIN]]
; CHECK-NEXT:    ret i32 [[RES]]
;
  %notx = xor i32 %x, -1
  %cmp1 = icmp ugt i32 %notx, %y
  %umax = select i1 %cmp1, i32 %notx, i32 %y
  %umin = xor i32 %umax, -1
  %add = add i32 %umax, %z
  %res = mul i32 %umin, %add
  ret i32 %res
}

define i32 @test48(i32 %x) {
; CHECK-LABEL: @test48(
; CHECK-NEXT:    [[TMP1:%.*]] = add i32 [[X:%.*]], 1
; CHECK-NEXT:    [[TMP2:%.*]] = icmp slt i32 [[TMP1]], -1
; CHECK-NEXT:    [[D:%.*]] = select i1 [[TMP2]], i32 [[TMP1]], i32 -1
; CHECK-NEXT:    ret i32 [[D]]
;
  %a = sub i32 -2, %x
  %b = icmp sgt i32 %a, 0
  %c = select i1 %b, i32 %a, i32 0
  %d = xor i32 %c, -1
  ret i32 %d
}

define <2 x i32> @test48vec(<2 x i32> %x) {
; CHECK-LABEL: @test48vec(
; CHECK-NEXT:    [[TMP1:%.*]] = add <2 x i32> [[X:%.*]], <i32 1, i32 1>
; CHECK-NEXT:    [[TMP2:%.*]] = icmp slt <2 x i32> [[TMP1]], <i32 -1, i32 -1>
; CHECK-NEXT:    [[D:%.*]] = select <2 x i1> [[TMP2]], <2 x i32> [[TMP1]], <2 x i32> <i32 -1, i32 -1>
; CHECK-NEXT:    ret <2 x i32> [[D]]
;
  %a = sub <2 x i32> <i32 -2, i32 -2>, %x
  %b = icmp sgt <2 x i32> %a, zeroinitializer
  %c = select <2 x i1> %b, <2 x i32> %a, <2 x i32> zeroinitializer
  %d = xor <2 x i32> %c, <i32 -1, i32 -1>
  ret <2 x i32> %d
}

define i32 @test49(i32 %x) {
; CHECK-LABEL: @test49(
; CHECK-NEXT:    [[TMP1:%.*]] = sub i32 1, [[X:%.*]]
; CHECK-NEXT:    [[TMP2:%.*]] = icmp sgt i32 [[TMP1]], 0
; CHECK-NEXT:    [[D:%.*]] = select i1 [[TMP2]], i32 [[TMP1]], i32 0
; CHECK-NEXT:    ret i32 [[D]]
;
  %a = add i32 %x, -2
  %b = icmp slt i32 %a, -1
  %c = select i1 %b, i32 %a, i32 -1
  %d = xor i32 %c, -1
  ret i32 %d
}

define <2 x i32> @test49vec(<2 x i32> %x) {
; CHECK-LABEL: @test49vec(
; CHECK-NEXT:    [[TMP1:%.*]] = sub <2 x i32> <i32 1, i32 1>, [[X:%.*]]
; CHECK-NEXT:    [[TMP2:%.*]] = icmp sgt <2 x i32> [[TMP1]], zeroinitializer
; CHECK-NEXT:    [[D:%.*]] = select <2 x i1> [[TMP2]], <2 x i32> [[TMP1]], <2 x i32> zeroinitializer
; CHECK-NEXT:    ret <2 x i32> [[D]]
;
  %a = add <2 x i32> %x, <i32 -2, i32 -2>
  %b = icmp slt <2 x i32> %a, <i32 -1, i32 -1>
  %c = select <2 x i1> %b, <2 x i32> %a, <2 x i32> <i32 -1, i32 -1>
  %d = xor <2 x i32> %c, <i32 -1, i32 -1>
  ret <2 x i32> %d
}

define i32 @test50(i32 %x, i32 %y) {
; CHECK-LABEL: @test50(
; CHECK-NEXT:    [[TMP1:%.*]] = sub i32 1, [[X:%.*]]
; CHECK-NEXT:    [[TMP2:%.*]] = add i32 [[Y:%.*]], 1
; CHECK-NEXT:    [[TMP3:%.*]] = icmp sgt i32 [[TMP1]], [[TMP2]]
; CHECK-NEXT:    [[E:%.*]] = select i1 [[TMP3]], i32 [[TMP1]], i32 [[TMP2]]
; CHECK-NEXT:    ret i32 [[E]]
;
  %a = add i32 %x, -2
  %b = sub i32 -2, %y
  %c = icmp slt i32 %a, %b
  %d = select i1 %c, i32 %a, i32 %b
  %e = xor i32 %d, -1
  ret i32 %e
}

define <2 x i32> @test50vec(<2 x i32> %x, <2 x i32> %y) {
; CHECK-LABEL: @test50vec(
; CHECK-NEXT:    [[TMP1:%.*]] = sub <2 x i32> <i32 1, i32 1>, [[X:%.*]]
; CHECK-NEXT:    [[TMP2:%.*]] = add <2 x i32> [[Y:%.*]], <i32 1, i32 1>
; CHECK-NEXT:    [[TMP3:%.*]] = icmp sgt <2 x i32> [[TMP1]], [[TMP2]]
; CHECK-NEXT:    [[E:%.*]] = select <2 x i1> [[TMP3]], <2 x i32> [[TMP1]], <2 x i32> [[TMP2]]
; CHECK-NEXT:    ret <2 x i32> [[E]]
;
  %a = add <2 x i32> %x, <i32 -2, i32 -2>
  %b = sub <2 x i32> <i32 -2, i32 -2>, %y
  %c = icmp slt <2 x i32> %a, %b
  %d = select <2 x i1> %c, <2 x i32> %a, <2 x i32> %b
  %e = xor <2 x i32> %d, <i32 -1, i32 -1>
  ret <2 x i32> %e
}

define i32 @test51(i32 %x, i32 %y) {
; CHECK-LABEL: @test51(
; CHECK-NEXT:    [[TMP1:%.*]] = sub i32 -3, [[X:%.*]]
; CHECK-NEXT:    [[TMP2:%.*]] = add i32 [[Y:%.*]], -3
; CHECK-NEXT:    [[TMP3:%.*]] = icmp slt i32 [[TMP1]], [[TMP2]]
; CHECK-NEXT:    [[E:%.*]] = select i1 [[TMP3]], i32 [[TMP1]], i32 [[TMP2]]
; CHECK-NEXT:    ret i32 [[E]]
;
  %a = add i32 %x, 2
  %b = sub i32 2, %y
  %c = icmp sgt i32 %a, %b
  %d = select i1 %c, i32 %a, i32 %b
  %e = xor i32 %d, -1
  ret i32 %e
}

define <2 x i32> @test51vec(<2 x i32> %x, <2 x i32> %y) {
; CHECK-LABEL: @test51vec(
; CHECK-NEXT:    [[TMP1:%.*]] = sub <2 x i32> <i32 -3, i32 -3>, [[X:%.*]]
; CHECK-NEXT:    [[TMP2:%.*]] = add <2 x i32> [[Y:%.*]], <i32 -3, i32 -3>
; CHECK-NEXT:    [[TMP3:%.*]] = icmp slt <2 x i32> [[TMP1]], [[TMP2]]
; CHECK-NEXT:    [[E:%.*]] = select <2 x i1> [[TMP3]], <2 x i32> [[TMP1]], <2 x i32> [[TMP2]]
; CHECK-NEXT:    ret <2 x i32> [[E]]
;
  %a = add <2 x i32> %x, <i32 2, i32 2>
  %b = sub <2 x i32> <i32 2, i32 2>, %y
  %c = icmp sgt <2 x i32> %a, %b
  %d = select <2 x i1> %c, <2 x i32> %a, <2 x i32> %b
  %e = xor <2 x i32> %d, <i32 -1, i32 -1>
  ret <2 x i32> %e
}

define i4 @or_or_xor(i4 %x, i4 %y, i4 %z) {
; CHECK-LABEL: @or_or_xor(
; CHECK-NEXT:    [[TMP1:%.*]] = xor i4 [[X:%.*]], [[Y:%.*]]
; CHECK-NEXT:    [[TMP2:%.*]] = xor i4 [[Z:%.*]], -1
; CHECK-NEXT:    [[R:%.*]] = and i4 [[TMP1]], [[TMP2]]
; CHECK-NEXT:    ret i4 [[R]]
;
  %o1 = or i4 %z, %x
  %o2 = or i4 %z, %y
  %r = xor i4 %o1, %o2
  ret i4 %r
}

define i4 @or_or_xor_commute1(i4 %x, i4 %y, i4 %z) {
; CHECK-LABEL: @or_or_xor_commute1(
; CHECK-NEXT:    [[TMP1:%.*]] = xor i4 [[X:%.*]], [[Y:%.*]]
; CHECK-NEXT:    [[TMP2:%.*]] = xor i4 [[Z:%.*]], -1
; CHECK-NEXT:    [[R:%.*]] = and i4 [[TMP1]], [[TMP2]]
; CHECK-NEXT:    ret i4 [[R]]
;
  %o1 = or i4 %x, %z
  %o2 = or i4 %z, %y
  %r = xor i4 %o1, %o2
  ret i4 %r
}

define i4 @or_or_xor_commute2(i4 %x, i4 %y, i4 %z) {
; CHECK-LABEL: @or_or_xor_commute2(
; CHECK-NEXT:    [[TMP1:%.*]] = xor i4 [[X:%.*]], [[Y:%.*]]
; CHECK-NEXT:    [[TMP2:%.*]] = xor i4 [[Z:%.*]], -1
; CHECK-NEXT:    [[R:%.*]] = and i4 [[TMP1]], [[TMP2]]
; CHECK-NEXT:    ret i4 [[R]]
;
  %o1 = or i4 %z, %x
  %o2 = or i4 %y, %z
  %r = xor i4 %o1, %o2
  ret i4 %r
}

define <2 x i4> @or_or_xor_commute3(<2 x i4> %x, <2 x i4> %y, <2 x i4> %z) {
; CHECK-LABEL: @or_or_xor_commute3(
; CHECK-NEXT:    [[TMP1:%.*]] = xor <2 x i4> [[X:%.*]], [[Y:%.*]]
; CHECK-NEXT:    [[TMP2:%.*]] = xor <2 x i4> [[Z:%.*]], <i4 -1, i4 -1>
; CHECK-NEXT:    [[R:%.*]] = and <2 x i4> [[TMP1]], [[TMP2]]
; CHECK-NEXT:    ret <2 x i4> [[R]]
;
  %o1 = or <2 x i4> %x, %z
  %o2 = or <2 x i4> %y, %z
  %r = xor <2 x i4> %o1, %o2
  ret <2 x i4> %r
}

define i4 @or_or_xor_use1(i4 %x, i4 %y, i4 %z, i4* %p) {
; CHECK-LABEL: @or_or_xor_use1(
; CHECK-NEXT:    [[O1:%.*]] = or i4 [[Z:%.*]], [[X:%.*]]
; CHECK-NEXT:    store i4 [[O1]], i4* [[P:%.*]], align 1
; CHECK-NEXT:    [[O2:%.*]] = or i4 [[Z]], [[Y:%.*]]
; CHECK-NEXT:    [[R:%.*]] = xor i4 [[O1]], [[O2]]
; CHECK-NEXT:    ret i4 [[R]]
;
  %o1 = or i4 %z, %x
  store i4 %o1, i4* %p
  %o2 = or i4 %z, %y
  %r = xor i4 %o1, %o2
  ret i4 %r
}

define i4 @or_or_xor_use2(i4 %x, i4 %y, i4 %z, i4* %p) {
; CHECK-LABEL: @or_or_xor_use2(
; CHECK-NEXT:    [[O1:%.*]] = or i4 [[Z:%.*]], [[X:%.*]]
; CHECK-NEXT:    [[O2:%.*]] = or i4 [[Z]], [[Y:%.*]]
; CHECK-NEXT:    store i4 [[O2]], i4* [[P:%.*]], align 1
; CHECK-NEXT:    [[R:%.*]] = xor i4 [[O1]], [[O2]]
; CHECK-NEXT:    ret i4 [[R]]
;
  %o1 = or i4 %z, %x
  %o2 = or i4 %z, %y
  store i4 %o2, i4* %p
  %r = xor i4 %o1, %o2
  ret i4 %r
}
