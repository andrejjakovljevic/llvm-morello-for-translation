// NOTE: Assertions have been autogenerated by utils/update_cc_test_checks.py UTC_ARGS: --function-signature
// RUN: %riscv64_cheri_cc1 -std=c11 -o - -emit-llvm -disable-O0-optnone -Wno-atomic-alignment -Wno-sync-fetch-and-nand-semantics-changed %s \
// RUN:   | opt -S -mem2reg | FileCheck --check-prefix=HYBRID %s
// RUN: %riscv64_cheri_purecap_cc1 -std=c11 -o - -emit-llvm -disable-O0-optnone -Wno-atomic-alignment -Wno-sync-fetch-and-nand-semantics-changed %s \
// RUN:   | opt -S -mem2reg | FileCheck --check-prefix=PURECAP %s

// HYBRID-LABEL: define {{[^@]+}}@test_xchg
// HYBRID-SAME: (i128* [[F:%.*]], i128 [[VALUE:%.*]]) #[[ATTR0:[0-9]+]] {
// HYBRID-NEXT:  entry:
// HYBRID-NEXT:    [[TMP0:%.*]] = atomicrmw xchg i128* [[F]], i128 [[VALUE]] seq_cst, align 16
// HYBRID-NEXT:    ret i128 [[TMP0]]
//
// PURECAP-LABEL: define {{[^@]+}}@test_xchg
// PURECAP-SAME: (i128 addrspace(200)* [[F:%.*]], i128 [[VALUE:%.*]]) addrspace(200) #[[ATTR0:[0-9]+]] {
// PURECAP-NEXT:  entry:
// PURECAP-NEXT:    [[TMP0:%.*]] = atomicrmw xchg i128 addrspace(200)* [[F]], i128 [[VALUE]] seq_cst, align 16
// PURECAP-NEXT:    ret i128 [[TMP0]]
//
__uint128_t test_xchg(__uint128_t *f, __uint128_t value) {
  return __sync_swap(f, value);
}

// HYBRID-LABEL: define {{[^@]+}}@test_lock_test_and_set
// HYBRID-SAME: (i128* [[F:%.*]], i128 [[VALUE:%.*]]) #[[ATTR0]] {
// HYBRID-NEXT:  entry:
// HYBRID-NEXT:    [[TMP0:%.*]] = atomicrmw xchg i128* [[F]], i128 [[VALUE]] seq_cst, align 16
// HYBRID-NEXT:    ret i128 [[TMP0]]
//
// PURECAP-LABEL: define {{[^@]+}}@test_lock_test_and_set
// PURECAP-SAME: (i128 addrspace(200)* [[F:%.*]], i128 [[VALUE:%.*]]) addrspace(200) #[[ATTR0]] {
// PURECAP-NEXT:  entry:
// PURECAP-NEXT:    [[TMP0:%.*]] = atomicrmw xchg i128 addrspace(200)* [[F]], i128 [[VALUE]] seq_cst, align 16
// PURECAP-NEXT:    ret i128 [[TMP0]]
//
__uint128_t test_lock_test_and_set(__uint128_t *f, __uint128_t value) {
  return __sync_lock_test_and_set(f, value);
}

// HYBRID-LABEL: define {{[^@]+}}@test_lock_release
// HYBRID-SAME: (i128* [[F:%.*]]) #[[ATTR0]] {
// HYBRID-NEXT:  entry:
// HYBRID-NEXT:    store atomic i128 0, i128* [[F]] release, align 16
// HYBRID-NEXT:    ret void
//
// PURECAP-LABEL: define {{[^@]+}}@test_lock_release
// PURECAP-SAME: (i128 addrspace(200)* [[F:%.*]]) addrspace(200) #[[ATTR0]] {
// PURECAP-NEXT:  entry:
// PURECAP-NEXT:    store atomic i128 0, i128 addrspace(200)* [[F]] release, align 16
// PURECAP-NEXT:    ret void
//
void test_lock_release(__uint128_t *f) {
  return __sync_lock_release(f);
}

// HYBRID-LABEL: define {{[^@]+}}@test_cmpxchg_bool
// HYBRID-SAME: (i128* [[F:%.*]], i128 [[EXP:%.*]], i128 [[NEW:%.*]]) #[[ATTR0]] {
// HYBRID-NEXT:  entry:
// HYBRID-NEXT:    [[TMP0:%.*]] = cmpxchg i128* [[F]], i128 [[EXP]], i128 [[NEW]] seq_cst seq_cst, align 16
// HYBRID-NEXT:    [[TMP1:%.*]] = extractvalue { i128, i1 } [[TMP0]], 1
// HYBRID-NEXT:    ret i1 [[TMP1]]
//
// PURECAP-LABEL: define {{[^@]+}}@test_cmpxchg_bool
// PURECAP-SAME: (i128 addrspace(200)* [[F:%.*]], i128 [[EXP:%.*]], i128 [[NEW:%.*]]) addrspace(200) #[[ATTR0]] {
// PURECAP-NEXT:  entry:
// PURECAP-NEXT:    [[TMP0:%.*]] = cmpxchg i128 addrspace(200)* [[F]], i128 [[EXP]], i128 [[NEW]] seq_cst seq_cst, align 16
// PURECAP-NEXT:    [[TMP1:%.*]] = extractvalue { i128, i1 } [[TMP0]], 1
// PURECAP-NEXT:    ret i1 [[TMP1]]
//
_Bool test_cmpxchg_bool(__uint128_t *f, __uint128_t exp, __uint128_t new) {
  return __sync_bool_compare_and_swap(f, exp, new);
}

// HYBRID-LABEL: define {{[^@]+}}@test_cmpxchg_val
// HYBRID-SAME: (i128* [[F:%.*]], i128 [[EXP:%.*]], i128 [[NEW:%.*]]) #[[ATTR0]] {
// HYBRID-NEXT:  entry:
// HYBRID-NEXT:    [[TMP0:%.*]] = cmpxchg i128* [[F]], i128 [[EXP]], i128 [[NEW]] seq_cst seq_cst, align 16
// HYBRID-NEXT:    [[TMP1:%.*]] = extractvalue { i128, i1 } [[TMP0]], 0
// HYBRID-NEXT:    ret i128 [[TMP1]]
//
// PURECAP-LABEL: define {{[^@]+}}@test_cmpxchg_val
// PURECAP-SAME: (i128 addrspace(200)* [[F:%.*]], i128 [[EXP:%.*]], i128 [[NEW:%.*]]) addrspace(200) #[[ATTR0]] {
// PURECAP-NEXT:  entry:
// PURECAP-NEXT:    [[TMP0:%.*]] = cmpxchg i128 addrspace(200)* [[F]], i128 [[EXP]], i128 [[NEW]] seq_cst seq_cst, align 16
// PURECAP-NEXT:    [[TMP1:%.*]] = extractvalue { i128, i1 } [[TMP0]], 0
// PURECAP-NEXT:    ret i128 [[TMP1]]
//
__uint128_t test_cmpxchg_val(__uint128_t *f, __uint128_t exp, __uint128_t new) {
  return __sync_val_compare_and_swap(f, exp, new);
}

// HYBRID-LABEL: define {{[^@]+}}@test_fetch_add
// HYBRID-SAME: (i128* [[PTR:%.*]], i128 [[VALUE:%.*]]) #[[ATTR0]] {
// HYBRID-NEXT:  entry:
// HYBRID-NEXT:    [[TMP0:%.*]] = atomicrmw add i128* [[PTR]], i128 [[VALUE]] seq_cst, align 16
// HYBRID-NEXT:    ret i128 [[TMP0]]
//
// PURECAP-LABEL: define {{[^@]+}}@test_fetch_add
// PURECAP-SAME: (i128 addrspace(200)* [[PTR:%.*]], i128 [[VALUE:%.*]]) addrspace(200) #[[ATTR0]] {
// PURECAP-NEXT:  entry:
// PURECAP-NEXT:    [[TMP0:%.*]] = atomicrmw add i128 addrspace(200)* [[PTR]], i128 [[VALUE]] seq_cst, align 16
// PURECAP-NEXT:    ret i128 [[TMP0]]
//
__uint128_t test_fetch_add(__uint128_t *ptr, __uint128_t value) {
  return __sync_fetch_and_add(ptr, value);
}

// HYBRID-LABEL: define {{[^@]+}}@test_fetch_sub
// HYBRID-SAME: (i128* [[PTR:%.*]], i128 [[VALUE:%.*]]) #[[ATTR0]] {
// HYBRID-NEXT:  entry:
// HYBRID-NEXT:    [[TMP0:%.*]] = atomicrmw sub i128* [[PTR]], i128 [[VALUE]] seq_cst, align 16
// HYBRID-NEXT:    ret i128 [[TMP0]]
//
// PURECAP-LABEL: define {{[^@]+}}@test_fetch_sub
// PURECAP-SAME: (i128 addrspace(200)* [[PTR:%.*]], i128 [[VALUE:%.*]]) addrspace(200) #[[ATTR0]] {
// PURECAP-NEXT:  entry:
// PURECAP-NEXT:    [[TMP0:%.*]] = atomicrmw sub i128 addrspace(200)* [[PTR]], i128 [[VALUE]] seq_cst, align 16
// PURECAP-NEXT:    ret i128 [[TMP0]]
//
__uint128_t test_fetch_sub(__uint128_t *ptr, __uint128_t value) {
  return __sync_fetch_and_sub(ptr, value);
}

// HYBRID-LABEL: define {{[^@]+}}@test_fetch_and
// HYBRID-SAME: (i128* [[PTR:%.*]], i128 [[VALUE:%.*]]) #[[ATTR0]] {
// HYBRID-NEXT:  entry:
// HYBRID-NEXT:    [[TMP0:%.*]] = atomicrmw and i128* [[PTR]], i128 [[VALUE]] seq_cst, align 16
// HYBRID-NEXT:    ret i128 [[TMP0]]
//
// PURECAP-LABEL: define {{[^@]+}}@test_fetch_and
// PURECAP-SAME: (i128 addrspace(200)* [[PTR:%.*]], i128 [[VALUE:%.*]]) addrspace(200) #[[ATTR0]] {
// PURECAP-NEXT:  entry:
// PURECAP-NEXT:    [[TMP0:%.*]] = atomicrmw and i128 addrspace(200)* [[PTR]], i128 [[VALUE]] seq_cst, align 16
// PURECAP-NEXT:    ret i128 [[TMP0]]
//
__uint128_t test_fetch_and(__uint128_t *ptr, __uint128_t value) {
  return __sync_fetch_and_and(ptr, value);
}

// HYBRID-LABEL: define {{[^@]+}}@test_fetch_or
// HYBRID-SAME: (i128* [[PTR:%.*]], i128 [[VALUE:%.*]]) #[[ATTR0]] {
// HYBRID-NEXT:  entry:
// HYBRID-NEXT:    [[TMP0:%.*]] = atomicrmw or i128* [[PTR]], i128 [[VALUE]] seq_cst, align 16
// HYBRID-NEXT:    ret i128 [[TMP0]]
//
// PURECAP-LABEL: define {{[^@]+}}@test_fetch_or
// PURECAP-SAME: (i128 addrspace(200)* [[PTR:%.*]], i128 [[VALUE:%.*]]) addrspace(200) #[[ATTR0]] {
// PURECAP-NEXT:  entry:
// PURECAP-NEXT:    [[TMP0:%.*]] = atomicrmw or i128 addrspace(200)* [[PTR]], i128 [[VALUE]] seq_cst, align 16
// PURECAP-NEXT:    ret i128 [[TMP0]]
//
__uint128_t test_fetch_or(__uint128_t *ptr, __uint128_t value) {
  return __sync_fetch_and_or(ptr, value);
}

// HYBRID-LABEL: define {{[^@]+}}@test_fetch_xor
// HYBRID-SAME: (i128* [[PTR:%.*]], i128 [[VALUE:%.*]]) #[[ATTR0]] {
// HYBRID-NEXT:  entry:
// HYBRID-NEXT:    [[TMP0:%.*]] = atomicrmw xor i128* [[PTR]], i128 [[VALUE]] seq_cst, align 16
// HYBRID-NEXT:    ret i128 [[TMP0]]
//
// PURECAP-LABEL: define {{[^@]+}}@test_fetch_xor
// PURECAP-SAME: (i128 addrspace(200)* [[PTR:%.*]], i128 [[VALUE:%.*]]) addrspace(200) #[[ATTR0]] {
// PURECAP-NEXT:  entry:
// PURECAP-NEXT:    [[TMP0:%.*]] = atomicrmw xor i128 addrspace(200)* [[PTR]], i128 [[VALUE]] seq_cst, align 16
// PURECAP-NEXT:    ret i128 [[TMP0]]
//
__uint128_t test_fetch_xor(__uint128_t *ptr, __uint128_t value) {
  return __sync_fetch_and_xor(ptr, value);
}

// HYBRID-LABEL: define {{[^@]+}}@test_fetch_nand
// HYBRID-SAME: (i128* [[PTR:%.*]], i128 [[VALUE:%.*]]) #[[ATTR0]] {
// HYBRID-NEXT:  entry:
// HYBRID-NEXT:    [[TMP0:%.*]] = atomicrmw nand i128* [[PTR]], i128 [[VALUE]] seq_cst, align 16
// HYBRID-NEXT:    ret i128 [[TMP0]]
//
// PURECAP-LABEL: define {{[^@]+}}@test_fetch_nand
// PURECAP-SAME: (i128 addrspace(200)* [[PTR:%.*]], i128 [[VALUE:%.*]]) addrspace(200) #[[ATTR0]] {
// PURECAP-NEXT:  entry:
// PURECAP-NEXT:    [[TMP0:%.*]] = atomicrmw nand i128 addrspace(200)* [[PTR]], i128 [[VALUE]] seq_cst, align 16
// PURECAP-NEXT:    ret i128 [[TMP0]]
//
__uint128_t test_fetch_nand(__uint128_t *ptr, __uint128_t value) {
  return __sync_fetch_and_nand(ptr, value);
}

// HYBRID-LABEL: define {{[^@]+}}@test_add_fetch
// HYBRID-SAME: (i128* [[PTR:%.*]], i128 [[VALUE:%.*]]) #[[ATTR0]] {
// HYBRID-NEXT:  entry:
// HYBRID-NEXT:    [[TMP0:%.*]] = atomicrmw add i128* [[PTR]], i128 [[VALUE]] seq_cst, align 16
// HYBRID-NEXT:    [[TMP1:%.*]] = add i128 [[TMP0]], [[VALUE]]
// HYBRID-NEXT:    ret i128 [[TMP1]]
//
// PURECAP-LABEL: define {{[^@]+}}@test_add_fetch
// PURECAP-SAME: (i128 addrspace(200)* [[PTR:%.*]], i128 [[VALUE:%.*]]) addrspace(200) #[[ATTR0]] {
// PURECAP-NEXT:  entry:
// PURECAP-NEXT:    [[TMP0:%.*]] = atomicrmw add i128 addrspace(200)* [[PTR]], i128 [[VALUE]] seq_cst, align 16
// PURECAP-NEXT:    [[TMP1:%.*]] = add i128 [[TMP0]], [[VALUE]]
// PURECAP-NEXT:    ret i128 [[TMP1]]
//
__uint128_t test_add_fetch(__uint128_t *ptr, __uint128_t value) {
  return __sync_add_and_fetch(ptr, value);
}

// HYBRID-LABEL: define {{[^@]+}}@test_sub_fetch
// HYBRID-SAME: (i128* [[PTR:%.*]], i128 [[VALUE:%.*]]) #[[ATTR0]] {
// HYBRID-NEXT:  entry:
// HYBRID-NEXT:    [[TMP0:%.*]] = atomicrmw sub i128* [[PTR]], i128 [[VALUE]] seq_cst, align 16
// HYBRID-NEXT:    [[TMP1:%.*]] = sub i128 [[TMP0]], [[VALUE]]
// HYBRID-NEXT:    ret i128 [[TMP1]]
//
// PURECAP-LABEL: define {{[^@]+}}@test_sub_fetch
// PURECAP-SAME: (i128 addrspace(200)* [[PTR:%.*]], i128 [[VALUE:%.*]]) addrspace(200) #[[ATTR0]] {
// PURECAP-NEXT:  entry:
// PURECAP-NEXT:    [[TMP0:%.*]] = atomicrmw sub i128 addrspace(200)* [[PTR]], i128 [[VALUE]] seq_cst, align 16
// PURECAP-NEXT:    [[TMP1:%.*]] = sub i128 [[TMP0]], [[VALUE]]
// PURECAP-NEXT:    ret i128 [[TMP1]]
//
__uint128_t test_sub_fetch(__uint128_t *ptr, __uint128_t value) {
  return __sync_sub_and_fetch(ptr, value);
}

// HYBRID-LABEL: define {{[^@]+}}@test_and_fetch
// HYBRID-SAME: (i128* [[PTR:%.*]], i128 [[VALUE:%.*]]) #[[ATTR0]] {
// HYBRID-NEXT:  entry:
// HYBRID-NEXT:    [[TMP0:%.*]] = atomicrmw and i128* [[PTR]], i128 [[VALUE]] seq_cst, align 16
// HYBRID-NEXT:    [[TMP1:%.*]] = and i128 [[TMP0]], [[VALUE]]
// HYBRID-NEXT:    ret i128 [[TMP1]]
//
// PURECAP-LABEL: define {{[^@]+}}@test_and_fetch
// PURECAP-SAME: (i128 addrspace(200)* [[PTR:%.*]], i128 [[VALUE:%.*]]) addrspace(200) #[[ATTR0]] {
// PURECAP-NEXT:  entry:
// PURECAP-NEXT:    [[TMP0:%.*]] = atomicrmw and i128 addrspace(200)* [[PTR]], i128 [[VALUE]] seq_cst, align 16
// PURECAP-NEXT:    [[TMP1:%.*]] = and i128 [[TMP0]], [[VALUE]]
// PURECAP-NEXT:    ret i128 [[TMP1]]
//
__uint128_t test_and_fetch(__uint128_t *ptr, __uint128_t value) {
  return __sync_and_and_fetch(ptr, value);
}

// HYBRID-LABEL: define {{[^@]+}}@test_or_fetch
// HYBRID-SAME: (i128* [[PTR:%.*]], i128 [[VALUE:%.*]]) #[[ATTR0]] {
// HYBRID-NEXT:  entry:
// HYBRID-NEXT:    [[TMP0:%.*]] = atomicrmw or i128* [[PTR]], i128 [[VALUE]] seq_cst, align 16
// HYBRID-NEXT:    [[TMP1:%.*]] = or i128 [[TMP0]], [[VALUE]]
// HYBRID-NEXT:    ret i128 [[TMP1]]
//
// PURECAP-LABEL: define {{[^@]+}}@test_or_fetch
// PURECAP-SAME: (i128 addrspace(200)* [[PTR:%.*]], i128 [[VALUE:%.*]]) addrspace(200) #[[ATTR0]] {
// PURECAP-NEXT:  entry:
// PURECAP-NEXT:    [[TMP0:%.*]] = atomicrmw or i128 addrspace(200)* [[PTR]], i128 [[VALUE]] seq_cst, align 16
// PURECAP-NEXT:    [[TMP1:%.*]] = or i128 [[TMP0]], [[VALUE]]
// PURECAP-NEXT:    ret i128 [[TMP1]]
//
__uint128_t test_or_fetch(__uint128_t *ptr, __uint128_t value) {
  return __sync_or_and_fetch(ptr, value);
}

// HYBRID-LABEL: define {{[^@]+}}@test_xor_fetch
// HYBRID-SAME: (i128* [[PTR:%.*]], i128 [[VALUE:%.*]]) #[[ATTR0]] {
// HYBRID-NEXT:  entry:
// HYBRID-NEXT:    [[TMP0:%.*]] = atomicrmw xor i128* [[PTR]], i128 [[VALUE]] seq_cst, align 16
// HYBRID-NEXT:    [[TMP1:%.*]] = xor i128 [[TMP0]], [[VALUE]]
// HYBRID-NEXT:    ret i128 [[TMP1]]
//
// PURECAP-LABEL: define {{[^@]+}}@test_xor_fetch
// PURECAP-SAME: (i128 addrspace(200)* [[PTR:%.*]], i128 [[VALUE:%.*]]) addrspace(200) #[[ATTR0]] {
// PURECAP-NEXT:  entry:
// PURECAP-NEXT:    [[TMP0:%.*]] = atomicrmw xor i128 addrspace(200)* [[PTR]], i128 [[VALUE]] seq_cst, align 16
// PURECAP-NEXT:    [[TMP1:%.*]] = xor i128 [[TMP0]], [[VALUE]]
// PURECAP-NEXT:    ret i128 [[TMP1]]
//
__uint128_t test_xor_fetch(__uint128_t *ptr, __uint128_t value) {
  return __sync_xor_and_fetch(ptr, value);
}

// HYBRID-LABEL: define {{[^@]+}}@test_nand_fetch
// HYBRID-SAME: (i128* [[PTR:%.*]], i128 [[VALUE:%.*]]) #[[ATTR0]] {
// HYBRID-NEXT:  entry:
// HYBRID-NEXT:    [[TMP0:%.*]] = atomicrmw nand i128* [[PTR]], i128 [[VALUE]] seq_cst, align 16
// HYBRID-NEXT:    [[TMP1:%.*]] = and i128 [[TMP0]], [[VALUE]]
// HYBRID-NEXT:    [[TMP2:%.*]] = xor i128 [[TMP1]], -1
// HYBRID-NEXT:    ret i128 [[TMP2]]
//
// PURECAP-LABEL: define {{[^@]+}}@test_nand_fetch
// PURECAP-SAME: (i128 addrspace(200)* [[PTR:%.*]], i128 [[VALUE:%.*]]) addrspace(200) #[[ATTR0]] {
// PURECAP-NEXT:  entry:
// PURECAP-NEXT:    [[TMP0:%.*]] = atomicrmw nand i128 addrspace(200)* [[PTR]], i128 [[VALUE]] seq_cst, align 16
// PURECAP-NEXT:    [[TMP1:%.*]] = and i128 [[TMP0]], [[VALUE]]
// PURECAP-NEXT:    [[TMP2:%.*]] = xor i128 [[TMP1]], -1
// PURECAP-NEXT:    ret i128 [[TMP2]]
//
__uint128_t test_nand_fetch(__uint128_t *ptr, __uint128_t value) {
  return __sync_nand_and_fetch(ptr, value);
}
