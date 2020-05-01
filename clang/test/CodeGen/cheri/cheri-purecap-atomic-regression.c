// REQUIRES: mips-registered-target

// NOTE: Assertions have been autogenerated by utils/update_cc_test_checks.py
// RUN: %cheri_purecap_cc1 -std=c11 %s -emit-llvm -o - -O0 | %cheri_FileCheck %s
// RUN: %cheri_purecap_cc1 -std=c11 %s -emit-llvm -o - -O2 | %cheri_FileCheck %s -check-prefixes OPT,NULL_INVALID-OPT
// RUN: %cheri_purecap_cc1 -std=c11 %s -emit-llvm -o - -O2 -fno-delete-null-pointer-checks | %cheri_FileCheck %s -check-prefixes OPT,NO_DELETE_NULL-OPT
// Check that we can generate assembly without crashing
// RUN: %cheri_purecap_cc1 -mllvm -cheri-cap-table-abi=plt -std=c11 %s -S -o - -O2 -fno-delete-null-pointer-checks | FileCheck %s -check-prefix ASM

// This previously crashed in codegen when generating the *p
// CHECK-LABEL: @main(
// CHECK-NEXT:  entry:
// CHECK-NEXT:    [[RETVAL:%.*]] = alloca i32, align 4, addrspace(200)
// CHECK-NEXT:    [[P:%.*]] = alloca i32 addrspace(200)*, align [[#CAP_SIZE]], addrspace(200)
// CHECK-NEXT:    store i32 0, i32 addrspace(200)* [[RETVAL]], align 4
// CHECK-NEXT:    store i32 addrspace(200)* null, i32 addrspace(200)* addrspace(200)* [[P]], align [[#CAP_SIZE]]
// CHECK-NEXT:    [[ATOMIC_LOAD:%.*]] = load atomic i32 addrspace(200)*, i32 addrspace(200)* addrspace(200)* [[P]] seq_cst, align [[#CAP_SIZE]]
// CHECK-NEXT:    [[TMP0:%.*]] = load i32, i32 addrspace(200)* [[ATOMIC_LOAD]], align 4
// CHECK-NEXT:    ret i32 [[TMP0]]
//
// OPT-LABEL: @main(
// OPT-NEXT:  entry:
// Now clang can tell that it is dereferncing a null pointer an returns undef
// NULL_INVALID-OPT-NEXT:    ret i32 undef
// This uses a crazy alignment value (the maximum) because it is loading a null pointer, not a bug!
// NO_DELETE_NULL-OPT-NEXT:    [[TMP0:%.*]] = load i32, i32 addrspace(200)* null, align 536870912, !tbaa !2
// NO_DELETE_NULL-OPT-NEXT:    ret i32 [[TMP0]]
int main(void) {
  _Atomic(int*) p = (int*)0;
  return *p;

  // TODO: why is this not going in the delay slot?
  // ASM-LABEL: main:
  // ASM:      cgetnull	$c1
  // ASM-NEXT: clw	$2, $zero, 0($c1)
  // ASM-NEXT: cjr	$c17
  // ASM-NEXT: nop
}

// This previously crashed in codegen when generating the *p
// CHECK-LABEL: @main2(
// CHECK-NEXT:  entry:
// CHECK-NEXT:    [[P_ADDR:%.*]] = alloca i32 addrspace(200)*, align [[#CAP_SIZE]], addrspace(200)
// CHECK-NEXT:    store i32 addrspace(200)* [[P:%.*]], i32 addrspace(200)* addrspace(200)* [[P_ADDR]], align [[#CAP_SIZE]]
// CHECK-NEXT:    [[ATOMIC_LOAD:%.*]] = load atomic i32 addrspace(200)*, i32 addrspace(200)* addrspace(200)* [[P_ADDR]] seq_cst, align [[#CAP_SIZE]]
// CHECK-NEXT:    [[TMP0:%.*]] = load i32, i32 addrspace(200)* [[ATOMIC_LOAD]], align 4
// CHECK-NEXT:    ret i32 [[TMP0]]
//
// OPT-LABEL: @main2(
// OPT-NEXT:  entry:
// OPT-NEXT:    [[TMP0:%.*]] = load i32, i32 addrspace(200)* [[P:%.*]], align 4, !tbaa !2
// OPT-NEXT:    ret i32 [[TMP0]]
//
int main2(_Atomic(int*) p) {
  return *p;
  // ASM-LABEL: main2:
  // TODO: why is this not going in the delay slot?
  // ASM:      clw	$2, $zero, 0($c3)
  // ASM-NEXT: cjr	$c17
  // ASM-NEXT: nop
}


// This was also crashing:
_Atomic(int *) a;
// CHECK-LABEL: @test_store(
// CHECK-NEXT:  entry:
// CHECK-NEXT:    store atomic i32 addrspace(200)* bitcast (i8 addrspace(200)* getelementptr (i8, i8 addrspace(200)* null, i64 1) to i32 addrspace(200)*), i32 addrspace(200)* addrspace(200)* @a seq_cst, align [[#CAP_SIZE]]
// CHECK-NEXT:    ret void
//
// OPT-LABEL: @test_store(
// OPT-NEXT:  entry:
// OPT-NEXT:    store atomic i32 addrspace(200)* bitcast (i8 addrspace(200)* getelementptr (i8, i8 addrspace(200)* null, i64 1) to i32 addrspace(200)*), i32 addrspace(200)* addrspace(200)* @a seq_cst, align [[#CAP_SIZE]], !tbaa !6
// OPT-NEXT:    ret void
//
void test_store() {
  a = (void *)1;
  // ASM-LABEL: test_store:
  // TODO: why is this not going in the delay slot?
  // ASM: clcbi	$c1, %captab20(a)($c26)
  // ASM-NEXT: sync
  // ASM-NEXT: cincoffset	$c2, $cnull, 1
  // ASM-NEXT: csc	$c2, $zero, 0($c1)
  // ASM-NEXT: sync
  // ASM-NEXT: cjr	$c17
  // ASM-NEXT: nop
}
