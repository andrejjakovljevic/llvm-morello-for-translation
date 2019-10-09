; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: %cheri128_purecap_llc -O0 %s -o - | FileCheck '-D#CAP_SIZE=16' %s -check-prefix C128
; RUN: %cheri256_purecap_llc -O0 %s -o - | FileCheck '-D#CAP_SIZE=32' %s -check-prefix C256
; This was crashing after https://reviews.llvm.org/D40095 was merged
source_filename = "/Users/alex/cheri/llvm/test/CodeGen/Mips/cheri-stack-reduce.test.ll"
target datalayout = "E-m:e-pf200:256:256-i8:8:32-i16:16:32-i64:64-n32:64-S128-A200"

declare i32 @a(i32 addrspace(200)*)

define i32 @d(i64 %i) nounwind {
; C128-LABEL: d:
; C128:       # %bb.0: # %entry
; C128-NEXT:    cincoffset $c11, $c11, -[[#STACKFRAME_SIZE:]]
; C128-NEXT:    csc $c24, $zero, [[#CAP_SIZE * 1]]($c11)
; C128-NEXT:    csc $c17, $zero, 0($c11)
; C128-NEXT:    cincoffset $c24, $c11, $zero
; C128-NEXT:    lui $1, %hi(%neg(%captab_rel(d)))
; C128-NEXT:    daddiu $1, $1, %lo(%neg(%captab_rel(d)))
; C128-NEXT:    cincoffset $c26, $c12, $1
; C128-NEXT:    cmove $c1, $c26
; C128-NEXT:    dsll $1, $4, 2
; C128-NEXT:    daddiu $2, $1, 15
; C128-NEXT:    daddiu $3, $zero, -16
; C128-NEXT:    and $2, $2, $3
; C128-NEXT:    croundrepresentablelength $3, $2
; C128-NEXT:    cmove $c2, $c11
; C128-NEXT:    cgetaddr $4, $c2
; C128-NEXT:    dsubu $4, $4, $3
; C128-NEXT:    crepresentablealignmentmask $2, $2
; C128-NEXT:    and $2, $4, $2
; C128-NEXT:    csetaddr $c2, $c2, $2
; C128-NEXT:    csetbounds $c3, $c2, $3
; C128-NEXT:    cmove $c11, $c2
; C128-NEXT:    csetbounds $c3, $c3, $1
; C128-NEXT:    clcbi $c12, %capcall20(a)($c1)
; C128-NEXT:    cgetnull $c13
; C128-NEXT:    cjalr $c12, $c17
; C128-NEXT:    nop
; C128-NEXT:    cincoffset $c11, $c24, $zero
; C128-NEXT:    clc $c17, $zero, 0($c11)
; C128-NEXT:    clc $c24, $zero, [[#CAP_SIZE * 1]]($c11)
; C128-NEXT:    cincoffset $c11, $c11, [[#STACKFRAME_SIZE]]
; C128-NEXT:    cjr $c17
; C128-NEXT:    nop
;
; C256-LABEL: d:
; C256:       # %bb.0: # %entry
; C256-NEXT:    cincoffset $c11, $c11, -[[#STACKFRAME_SIZE:]]
; C256-NEXT:    csc $c24, $zero, [[#CAP_SIZE * 1]]($c11)
; C256-NEXT:    csc $c17, $zero, 0($c11)
; C256-NEXT:    cincoffset $c24, $c11, $zero
; C256-NEXT:    lui $1, %hi(%neg(%captab_rel(d)))
; C256-NEXT:    daddiu $1, $1, %lo(%neg(%captab_rel(d)))
; C256-NEXT:    cincoffset $c26, $c12, $1
; C256-NEXT:    cmove $c1, $c26
; C256-NEXT:    dsll $1, $4, 2
; C256-NEXT:    daddiu $2, $1, 31
; C256-NEXT:    daddiu $3, $zero, -32
; C256-NEXT:    and $2, $2, $3
; C256-NEXT:    cmove $c2, $c11
; C256-NEXT:    cgetaddr $3, $c2
; C256-NEXT:    dsubu $3, $3, $2
; C256-NEXT:    csetaddr $c2, $c2, $3
; C256-NEXT:    csetbounds $c3, $c2, $2
; C256-NEXT:    cmove $c11, $c2
; C256-NEXT:    csetbounds $c3, $c3, $1
; C256-NEXT:    clcbi $c12, %capcall20(a)($c1)
; C256-NEXT:    cgetnull $c13
; C256-NEXT:    cjalr $c12, $c17
; C256-NEXT:    nop
; C256-NEXT:    cincoffset $c11, $c24, $zero
; C256-NEXT:    clc $c17, $zero, 0($c11)
; C256-NEXT:    clc $c24, $zero, [[#CAP_SIZE * 1]]($c11)
; C256-NEXT:    cincoffset $c11, $c11, [[#STACKFRAME_SIZE]]
; C256-NEXT:    cjr $c17
; C256-NEXT:    nop
entry:
  %e = alloca i32, i64 %i, addrspace(200)
  %call = call i32 @a(i32 addrspace(200)* %e)
  ret i32 %call
}
