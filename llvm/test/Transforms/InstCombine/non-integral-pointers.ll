; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt -instcombine -S < %s | FileCheck %s

target datalayout = "e-m:e-i64:64-f80:128-n8:16:32:64-S128-ni:4"
target triple = "x86_64-unknown-linux-gnu"

define i8 addrspace(4)* @f_0() {
; CHECK-LABEL: @f_0(
; CHECK-NEXT:    ret i8 addrspace(4)* getelementptr (i8, i8 addrspace(4)* null, i64 50)
;
  %result = getelementptr i8, i8 addrspace(4)* null, i64 50
  ret i8 addrspace(4)* %result
}

define i8 addrspace(3)* @f_1() {
; inttoptr is fine here since addrspace(3) is integral.
; CHECK-LABEL: @f_1(
; CHECK-NEXT:    ret i8 addrspace(3)* inttoptr (i64 50 to i8 addrspace(3)*)
;
  %result = getelementptr i8, i8 addrspace(3)* null, i64 50
  ret i8 addrspace(3)* %result
}

define void @f_2(i8 addrspace(4)** %ptr0, i8 addrspace(4)** %ptr1) {
; It is not okay to convert the load/store pair to load and store
; integers, since pointers in address space 4 are non-integral.
; CHECK-LABEL: @f_2(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[VAL:%.*]] = load i8 addrspace(4)*, i8 addrspace(4)** [[PTR0:%.*]], align 8
; CHECK-NEXT:    store i8 addrspace(4)* [[VAL]], i8 addrspace(4)** [[PTR1:%.*]], align 8
; CHECK-NEXT:    ret void
;
entry:
  %val = load i8 addrspace(4)*, i8 addrspace(4)** %ptr0
  store i8 addrspace(4)* %val, i8 addrspace(4)** %ptr1
  ret void
}

define void @f_3(i8 addrspace(3)** %ptr0, i8 addrspace(3)** %ptr1) {
; It *is* okay to convert the load/store pair to load and store
; integers, since pointers in address space 3 are integral.
; CHECK-LABEL: @f_3(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[VAL:%.*]] = load i8 addrspace(3)*, i8 addrspace(3)** [[PTR0:%.*]], align 8
; CHECK-NEXT:    store i8 addrspace(3)* [[VAL]], i8 addrspace(3)** [[PTR1:%.*]], align 8
; CHECK-NEXT:    ret void
;
entry:
  %val = load i8 addrspace(3)*, i8 addrspace(3)** %ptr0
  store i8 addrspace(3)* %val, i8 addrspace(3)** %ptr1
  ret void
}

define i64 @g(i8 addrspace(4)** %gp) {
;; TODO-CHERI: We don't perform the same GEP hoist as upstream here. Should find out why and if so determine whether
;; that is patch that should be upstreamed.
; CHECK-LABEL: @g(
; CHECK-NEXT:    [[DOTPRE:%.*]] = load i8 addrspace(4)*, i8 addrspace(4)** [[GP:%.*]], align 8
; CHECK-NEXT:    [[V74:%.*]] = call i8 addrspace(4)* @alloc()
; CHECK-NEXT:    [[TMP1:%.*]] = bitcast i8 addrspace(4)* [[V74]] to i8 addrspace(4)* addrspace(4)*
; CHECK-NEXT:    [[V76:%.*]] = addrspacecast i8 addrspace(4)* addrspace(4)* [[TMP1]] to i8 addrspace(4)**
; CHECK-NEXT:    [[V77:%.*]] = getelementptr i8 addrspace(4)*, i8 addrspace(4)** [[V76]], i64 -1
; CHECK-NEXT:    store i8 addrspace(4)* [[DOTPRE]], i8 addrspace(4)** [[V77]], align 8
; CHECK-NEXT:    [[V80:%.*]] = bitcast i8 addrspace(4)** [[V77]] to i64*
; CHECK-NEXT:    [[V81:%.*]] = load i64, i64* [[V80]], align 8
; CHECK-NEXT:    ret i64 [[V81]]
;
  %.pre = load i8 addrspace(4)*, i8 addrspace(4)** %gp, align 8
  %v74 = call i8 addrspace(4)* @alloc()
  %v75 = addrspacecast i8 addrspace(4)* %v74 to i8*
  %v76 = bitcast i8* %v75 to i8 addrspace(4)**
  %v77 = getelementptr i8 addrspace(4)*, i8 addrspace(4)** %v76, i64 -1
  store i8 addrspace(4)* %.pre, i8 addrspace(4)** %v77, align 8
  %v80 = bitcast i8 addrspace(4)** %v77 to i64*
  %v81 = load i64, i64* %v80, align 8
  ret i64 %v81
}

define i64 @g2(i8* addrspace(4)* %gp) {
; CHECK-LABEL: @g2(
; CHECK-NEXT:    [[DOTPRE:%.*]] = load i8*, i8* addrspace(4)* [[GP:%.*]], align 8
; CHECK-NEXT:    [[V74:%.*]] = call i8 addrspace(4)* @alloc()
; CHECK-NEXT:    [[V77:%.*]] = getelementptr i8, i8 addrspace(4)* [[V74]], i64 -8
; CHECK-NEXT:    [[TMP1:%.*]] = bitcast i8 addrspace(4)* [[V77]] to i8* addrspace(4)*
; CHECK-NEXT:    store i8* [[DOTPRE]], i8* addrspace(4)* [[TMP1]], align 8
; CHECK-NEXT:    [[V81_CAST:%.*]] = ptrtoint i8* [[DOTPRE]] to i64
; CHECK-NEXT:    ret i64 [[V81_CAST]]
;
  %.pre = load i8*, i8* addrspace(4)* %gp, align 8
  %v74 = call i8 addrspace(4)* @alloc()
  %v76 = bitcast i8 addrspace(4)* %v74 to i8* addrspace(4)*
  %v77 = getelementptr i8*, i8* addrspace(4)* %v76, i64 -1
  store i8* %.pre, i8* addrspace(4)* %v77, align 8
  %v80 = bitcast i8* addrspace(4)* %v77 to i64 addrspace(4)*
  %v81 = load i64, i64 addrspace(4)* %v80, align 8
  ret i64 %v81
}

declare i8 addrspace(4)* @alloc()

define i64 @f_4(i8 addrspace(4)* %v0) {
; CHECK-LABEL: @f_4(
; CHECK-NEXT:    [[V6:%.*]] = call i64 bitcast (i64 (i64)* @f_5 to i64 (i8 addrspace(4)*)*)(i8 addrspace(4)* [[V0:%.*]])
; CHECK-NEXT:    ret i64 [[V6]]
;
  %v5 = bitcast i64 (i64)* @f_5 to i64 (i8 addrspace(4)*)*
  %v6 = call i64 %v5(i8 addrspace(4)* %v0)
  ret i64 %v6
}

declare i64 @f_5(i64)
