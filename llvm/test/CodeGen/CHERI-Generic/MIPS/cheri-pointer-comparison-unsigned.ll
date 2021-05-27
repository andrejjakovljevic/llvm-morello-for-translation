; NOTE: Assertions have been autogenerated by utils/update_test_checks.py UTC_ARGS: --function-signature --scrub-attributes --force-update
; DO NOT EDIT -- This file was generated from test/CodeGen/CHERI-Generic/Inputs/cheri-pointer-comparison-unsigned.ll
; RUN: llc -mtriple=mips64 -mcpu=cheri128 -mattr=+cheri128 --relocation-model=pic -target-abi n64 %s -o - | FileCheck %s --check-prefix=HYBRID
; RUN: llc -mtriple=mips64 -mcpu=cheri128 -mattr=+cheri128 --relocation-model=pic -target-abi purecap %s -o - | FileCheck %s --check-prefix=PURECAP
; Check that selects and branches using capability compares use unsigned comparisons.
; NGINX has a loop with (void*)-1 as a sentinel value which was never entered due to this bug.
; Original issue: https://github.com/CTSRD-CHERI/llvm/issues/199
; Fixed upstream in https://reviews.llvm.org/D70917 (be15dfa88fb1ed94d12f374797f98ede6808f809)
;
; Original source code showing this surprising behaviour (for CHERI-MIPS):
; int
; main(void)
; {
;         void *a, *b;
;
;         a = (void *)0x12033091e;
;         b = (void *)0xffffffffffffffff;
;
;         if (a < b) {
;                 printf("ok\n");
;                 return (0);
;         }
;
;         printf("surprising result\n");
;         return (1);
; }
;
; Morello had a similar code generation issue for selects, where a less than
; generated a csel instruction using a singed predicate instead of the unsigned one:
; void *select_lt(void *p1, void *p2) {
;   return p1 < p2 ? p1 : p2;
; }
; See https://git.morello-project.org/morello/llvm-project/-/issues/22


define i32 @lt(i8 addrspace(200)* %a, i8 addrspace(200)* %b) nounwind {
; HYBRID-LABEL: lt:
; HYBRID:       # %bb.0: # %entry
; HYBRID-NEXT:    jr $ra
; HYBRID-NEXT:    cltu $2, $c3, $c4
;
; PURECAP-LABEL: lt:
; PURECAP:       # %bb.0: # %entry
; PURECAP-NEXT:    cjr $c17
; PURECAP-NEXT:    cltu $2, $c3, $c4
entry:
  %cmp = icmp ult i8 addrspace(200)* %a, %b
  %conv = zext i1 %cmp to i32
  ret i32 %conv
}

define i32 @le(i8 addrspace(200)* %a, i8 addrspace(200)* %b) nounwind {
; HYBRID-LABEL: le:
; HYBRID:       # %bb.0: # %entry
; HYBRID-NEXT:    jr $ra
; HYBRID-NEXT:    cleu $2, $c3, $c4
;
; PURECAP-LABEL: le:
; PURECAP:       # %bb.0: # %entry
; PURECAP-NEXT:    cjr $c17
; PURECAP-NEXT:    cleu $2, $c3, $c4
entry:
  %cmp = icmp ule i8 addrspace(200)* %a, %b
  %conv = zext i1 %cmp to i32
  ret i32 %conv
}

define i32 @gt(i8 addrspace(200)* %a, i8 addrspace(200)* %b) nounwind {
; HYBRID-LABEL: gt:
; HYBRID:       # %bb.0: # %entry
; HYBRID-NEXT:    jr $ra
; HYBRID-NEXT:    cltu $2, $c4, $c3
;
; PURECAP-LABEL: gt:
; PURECAP:       # %bb.0: # %entry
; PURECAP-NEXT:    cjr $c17
; PURECAP-NEXT:    cltu $2, $c4, $c3
entry:
  %cmp = icmp ugt i8 addrspace(200)* %a, %b
  %conv = zext i1 %cmp to i32
  ret i32 %conv
}

define i32 @ge(i8 addrspace(200)* %a, i8 addrspace(200)* %b) nounwind {
; HYBRID-LABEL: ge:
; HYBRID:       # %bb.0: # %entry
; HYBRID-NEXT:    jr $ra
; HYBRID-NEXT:    cleu $2, $c4, $c3
;
; PURECAP-LABEL: ge:
; PURECAP:       # %bb.0: # %entry
; PURECAP-NEXT:    cjr $c17
; PURECAP-NEXT:    cleu $2, $c4, $c3
entry:
  %cmp = icmp uge i8 addrspace(200)* %a, %b
  %conv = zext i1 %cmp to i32
  ret i32 %conv
}

define i8 addrspace(200)* @select_lt(i8 addrspace(200)* %a, i8 addrspace(200)* %b) nounwind {
; HYBRID-LABEL: select_lt:
; HYBRID:       # %bb.0: # %entry
; HYBRID-NEXT:    cltu $1, $c3, $c4
; HYBRID-NEXT:    cmovn $c4, $c3, $1
; HYBRID-NEXT:    jr $ra
; HYBRID-NEXT:    cmove $c3, $c4
;
; PURECAP-LABEL: select_lt:
; PURECAP:       # %bb.0: # %entry
; PURECAP-NEXT:    cltu $1, $c3, $c4
; PURECAP-NEXT:    cmovn $c4, $c3, $1
; PURECAP-NEXT:    cjr $c17
; PURECAP-NEXT:    cmove $c3, $c4
entry:
  %cmp = icmp ult i8 addrspace(200)* %a, %b
  %cond = select i1 %cmp, i8 addrspace(200)* %a, i8 addrspace(200)* %b
  ret i8 addrspace(200)* %cond
}

define i8 addrspace(200)* @select_le(i8 addrspace(200)* %a, i8 addrspace(200)* %b) nounwind {
; HYBRID-LABEL: select_le:
; HYBRID:       # %bb.0: # %entry
; HYBRID-NEXT:    cleu $1, $c3, $c4
; HYBRID-NEXT:    cmovn $c4, $c3, $1
; HYBRID-NEXT:    jr $ra
; HYBRID-NEXT:    cmove $c3, $c4
;
; PURECAP-LABEL: select_le:
; PURECAP:       # %bb.0: # %entry
; PURECAP-NEXT:    cleu $1, $c3, $c4
; PURECAP-NEXT:    cmovn $c4, $c3, $1
; PURECAP-NEXT:    cjr $c17
; PURECAP-NEXT:    cmove $c3, $c4
entry:
  %cmp = icmp ule i8 addrspace(200)* %a, %b
  %cond = select i1 %cmp, i8 addrspace(200)* %a, i8 addrspace(200)* %b
  ret i8 addrspace(200)* %cond
}

define i8 addrspace(200)* @select_gt(i8 addrspace(200)* %a, i8 addrspace(200)* %b) nounwind {
; HYBRID-LABEL: select_gt:
; HYBRID:       # %bb.0: # %entry
; HYBRID-NEXT:    cltu $1, $c4, $c3
; HYBRID-NEXT:    cmovn $c4, $c3, $1
; HYBRID-NEXT:    jr $ra
; HYBRID-NEXT:    cmove $c3, $c4
;
; PURECAP-LABEL: select_gt:
; PURECAP:       # %bb.0: # %entry
; PURECAP-NEXT:    cltu $1, $c4, $c3
; PURECAP-NEXT:    cmovn $c4, $c3, $1
; PURECAP-NEXT:    cjr $c17
; PURECAP-NEXT:    cmove $c3, $c4
entry:
  %cmp = icmp ugt i8 addrspace(200)* %a, %b
  %cond = select i1 %cmp, i8 addrspace(200)* %a, i8 addrspace(200)* %b
  ret i8 addrspace(200)* %cond
}

define i8 addrspace(200)* @select_ge(i8 addrspace(200)* %a, i8 addrspace(200)* %b) nounwind {
; HYBRID-LABEL: select_ge:
; HYBRID:       # %bb.0: # %entry
; HYBRID-NEXT:    cleu $1, $c4, $c3
; HYBRID-NEXT:    cmovn $c4, $c3, $1
; HYBRID-NEXT:    jr $ra
; HYBRID-NEXT:    cmove $c3, $c4
;
; PURECAP-LABEL: select_ge:
; PURECAP:       # %bb.0: # %entry
; PURECAP-NEXT:    cleu $1, $c4, $c3
; PURECAP-NEXT:    cmovn $c4, $c3, $1
; PURECAP-NEXT:    cjr $c17
; PURECAP-NEXT:    cmove $c3, $c4
entry:
  %cmp = icmp uge i8 addrspace(200)* %a, %b
  %cond = select i1 %cmp, i8 addrspace(200)* %a, i8 addrspace(200)* %b
  ret i8 addrspace(200)* %cond
}

declare i32 @func1() nounwind noreturn
declare i32 @func2() nounwind noreturn

define i32 @branch_lt(i8 addrspace(200)* %a, i8 addrspace(200)* %b) nounwind noreturn {
; HYBRID-LABEL: branch_lt:
; HYBRID:       # %bb.0: # %entry
; HYBRID-NEXT:    daddiu $sp, $sp, -16
; HYBRID-NEXT:    sd $ra, 8($sp) # 8-byte Folded Spill
; HYBRID-NEXT:    sd $gp, 0($sp) # 8-byte Folded Spill
; HYBRID-NEXT:    lui $1, %hi(%neg(%gp_rel(branch_lt)))
; HYBRID-NEXT:    daddu $1, $1, $25
; HYBRID-NEXT:    cleu $2, $c4, $c3
; HYBRID-NEXT:    bnez $2, .LBB8_2
; HYBRID-NEXT:    daddiu $gp, $1, %lo(%neg(%gp_rel(branch_lt)))
; HYBRID-NEXT:  # %bb.1: # %if.then
; HYBRID-NEXT:    ld $25, %call16(func1)($gp)
; HYBRID-NEXT:    .reloc .Ltmp0, R_MIPS_JALR, func1
; HYBRID-NEXT:  .Ltmp0:
; HYBRID-NEXT:    jalr $25
; HYBRID-NEXT:    nop
; HYBRID-NEXT:    ld $gp, 0($sp) # 8-byte Folded Reload
; HYBRID-NEXT:    ld $ra, 8($sp) # 8-byte Folded Reload
; HYBRID-NEXT:    jr $ra
; HYBRID-NEXT:    daddiu $sp, $sp, 16
; HYBRID-NEXT:  .LBB8_2: # %if.end
; HYBRID-NEXT:    ld $25, %call16(func2)($gp)
; HYBRID-NEXT:    .reloc .Ltmp1, R_MIPS_JALR, func2
; HYBRID-NEXT:  .Ltmp1:
; HYBRID-NEXT:    jalr $25
; HYBRID-NEXT:    nop
; HYBRID-NEXT:    ld $gp, 0($sp) # 8-byte Folded Reload
; HYBRID-NEXT:    ld $ra, 8($sp) # 8-byte Folded Reload
; HYBRID-NEXT:    jr $ra
; HYBRID-NEXT:    daddiu $sp, $sp, 16
;
; PURECAP-LABEL: branch_lt:
; PURECAP:       # %bb.0: # %entry
; PURECAP-NEXT:    cincoffset $c11, $c11, -16
; PURECAP-NEXT:    csc $c17, $zero, 0($c11) # 16-byte Folded Spill
; PURECAP-NEXT:    cleu $1, $c4, $c3
; PURECAP-NEXT:    lui $2, %pcrel_hi(_CHERI_CAPABILITY_TABLE_-8)
; PURECAP-NEXT:    daddiu $2, $2, %pcrel_lo(_CHERI_CAPABILITY_TABLE_-4)
; PURECAP-NEXT:    cgetpccincoffset $c1, $2
; PURECAP-NEXT:    bnez $1, .LBB8_2
; PURECAP-NEXT:    nop
; PURECAP-NEXT:  # %bb.1: # %if.then
; PURECAP-NEXT:    clcbi $c12, %capcall20(func1)($c1)
; PURECAP-NEXT:    cjalr $c12, $c17
; PURECAP-NEXT:    nop
; PURECAP-NEXT:    clc $c17, $zero, 0($c11) # 16-byte Folded Reload
; PURECAP-NEXT:    cjr $c17
; PURECAP-NEXT:    cincoffset $c11, $c11, 16
; PURECAP-NEXT:  .LBB8_2: # %if.end
; PURECAP-NEXT:    clcbi $c12, %capcall20(func2)($c1)
; PURECAP-NEXT:    cjalr $c12, $c17
; PURECAP-NEXT:    nop
; PURECAP-NEXT:    clc $c17, $zero, 0($c11) # 16-byte Folded Reload
; PURECAP-NEXT:    cjr $c17
; PURECAP-NEXT:    cincoffset $c11, $c11, 16
entry:
  %cmp = icmp ult i8 addrspace(200)* %a, %b
  br i1 %cmp, label %if.then, label %if.end
if.then:
  %retval1 = tail call i32 @func1()
  ret i32 %retval1
if.end:
  %retval2 = tail call i32 @func2()
  ret i32 %retval2
}

define i32 @branch_le(i8 addrspace(200)* %a, i8 addrspace(200)* %b) nounwind noreturn {
; HYBRID-LABEL: branch_le:
; HYBRID:       # %bb.0: # %entry
; HYBRID-NEXT:    daddiu $sp, $sp, -16
; HYBRID-NEXT:    sd $ra, 8($sp) # 8-byte Folded Spill
; HYBRID-NEXT:    sd $gp, 0($sp) # 8-byte Folded Spill
; HYBRID-NEXT:    lui $1, %hi(%neg(%gp_rel(branch_le)))
; HYBRID-NEXT:    daddu $1, $1, $25
; HYBRID-NEXT:    cltu $2, $c4, $c3
; HYBRID-NEXT:    bnez $2, .LBB9_2
; HYBRID-NEXT:    daddiu $gp, $1, %lo(%neg(%gp_rel(branch_le)))
; HYBRID-NEXT:  # %bb.1: # %if.then
; HYBRID-NEXT:    ld $25, %call16(func1)($gp)
; HYBRID-NEXT:    .reloc .Ltmp2, R_MIPS_JALR, func1
; HYBRID-NEXT:  .Ltmp2:
; HYBRID-NEXT:    jalr $25
; HYBRID-NEXT:    nop
; HYBRID-NEXT:    ld $gp, 0($sp) # 8-byte Folded Reload
; HYBRID-NEXT:    ld $ra, 8($sp) # 8-byte Folded Reload
; HYBRID-NEXT:    jr $ra
; HYBRID-NEXT:    daddiu $sp, $sp, 16
; HYBRID-NEXT:  .LBB9_2: # %if.end
; HYBRID-NEXT:    ld $25, %call16(func2)($gp)
; HYBRID-NEXT:    .reloc .Ltmp3, R_MIPS_JALR, func2
; HYBRID-NEXT:  .Ltmp3:
; HYBRID-NEXT:    jalr $25
; HYBRID-NEXT:    nop
; HYBRID-NEXT:    ld $gp, 0($sp) # 8-byte Folded Reload
; HYBRID-NEXT:    ld $ra, 8($sp) # 8-byte Folded Reload
; HYBRID-NEXT:    jr $ra
; HYBRID-NEXT:    daddiu $sp, $sp, 16
;
; PURECAP-LABEL: branch_le:
; PURECAP:       # %bb.0: # %entry
; PURECAP-NEXT:    cincoffset $c11, $c11, -16
; PURECAP-NEXT:    csc $c17, $zero, 0($c11) # 16-byte Folded Spill
; PURECAP-NEXT:    cltu $1, $c4, $c3
; PURECAP-NEXT:    lui $2, %pcrel_hi(_CHERI_CAPABILITY_TABLE_-8)
; PURECAP-NEXT:    daddiu $2, $2, %pcrel_lo(_CHERI_CAPABILITY_TABLE_-4)
; PURECAP-NEXT:    cgetpccincoffset $c1, $2
; PURECAP-NEXT:    bnez $1, .LBB9_2
; PURECAP-NEXT:    nop
; PURECAP-NEXT:  # %bb.1: # %if.then
; PURECAP-NEXT:    clcbi $c12, %capcall20(func1)($c1)
; PURECAP-NEXT:    cjalr $c12, $c17
; PURECAP-NEXT:    nop
; PURECAP-NEXT:    clc $c17, $zero, 0($c11) # 16-byte Folded Reload
; PURECAP-NEXT:    cjr $c17
; PURECAP-NEXT:    cincoffset $c11, $c11, 16
; PURECAP-NEXT:  .LBB9_2: # %if.end
; PURECAP-NEXT:    clcbi $c12, %capcall20(func2)($c1)
; PURECAP-NEXT:    cjalr $c12, $c17
; PURECAP-NEXT:    nop
; PURECAP-NEXT:    clc $c17, $zero, 0($c11) # 16-byte Folded Reload
; PURECAP-NEXT:    cjr $c17
; PURECAP-NEXT:    cincoffset $c11, $c11, 16
entry:
  %cmp = icmp ule i8 addrspace(200)* %a, %b
  br i1 %cmp, label %if.then, label %if.end
if.then:
  %retval1 = tail call i32 @func1()
  ret i32 %retval1
if.end:
  %retval2 = tail call i32 @func2()
  ret i32 %retval2
}

define i32 @branch_gt(i8 addrspace(200)* %a, i8 addrspace(200)* %b) nounwind noreturn {
; HYBRID-LABEL: branch_gt:
; HYBRID:       # %bb.0: # %entry
; HYBRID-NEXT:    daddiu $sp, $sp, -16
; HYBRID-NEXT:    sd $ra, 8($sp) # 8-byte Folded Spill
; HYBRID-NEXT:    sd $gp, 0($sp) # 8-byte Folded Spill
; HYBRID-NEXT:    lui $1, %hi(%neg(%gp_rel(branch_gt)))
; HYBRID-NEXT:    daddu $1, $1, $25
; HYBRID-NEXT:    cleu $2, $c3, $c4
; HYBRID-NEXT:    bnez $2, .LBB10_2
; HYBRID-NEXT:    daddiu $gp, $1, %lo(%neg(%gp_rel(branch_gt)))
; HYBRID-NEXT:  # %bb.1: # %if.then
; HYBRID-NEXT:    ld $25, %call16(func1)($gp)
; HYBRID-NEXT:    .reloc .Ltmp4, R_MIPS_JALR, func1
; HYBRID-NEXT:  .Ltmp4:
; HYBRID-NEXT:    jalr $25
; HYBRID-NEXT:    nop
; HYBRID-NEXT:    ld $gp, 0($sp) # 8-byte Folded Reload
; HYBRID-NEXT:    ld $ra, 8($sp) # 8-byte Folded Reload
; HYBRID-NEXT:    jr $ra
; HYBRID-NEXT:    daddiu $sp, $sp, 16
; HYBRID-NEXT:  .LBB10_2: # %if.end
; HYBRID-NEXT:    ld $25, %call16(func2)($gp)
; HYBRID-NEXT:    .reloc .Ltmp5, R_MIPS_JALR, func2
; HYBRID-NEXT:  .Ltmp5:
; HYBRID-NEXT:    jalr $25
; HYBRID-NEXT:    nop
; HYBRID-NEXT:    ld $gp, 0($sp) # 8-byte Folded Reload
; HYBRID-NEXT:    ld $ra, 8($sp) # 8-byte Folded Reload
; HYBRID-NEXT:    jr $ra
; HYBRID-NEXT:    daddiu $sp, $sp, 16
;
; PURECAP-LABEL: branch_gt:
; PURECAP:       # %bb.0: # %entry
; PURECAP-NEXT:    cincoffset $c11, $c11, -16
; PURECAP-NEXT:    csc $c17, $zero, 0($c11) # 16-byte Folded Spill
; PURECAP-NEXT:    cleu $1, $c3, $c4
; PURECAP-NEXT:    lui $2, %pcrel_hi(_CHERI_CAPABILITY_TABLE_-8)
; PURECAP-NEXT:    daddiu $2, $2, %pcrel_lo(_CHERI_CAPABILITY_TABLE_-4)
; PURECAP-NEXT:    cgetpccincoffset $c1, $2
; PURECAP-NEXT:    bnez $1, .LBB10_2
; PURECAP-NEXT:    nop
; PURECAP-NEXT:  # %bb.1: # %if.then
; PURECAP-NEXT:    clcbi $c12, %capcall20(func1)($c1)
; PURECAP-NEXT:    cjalr $c12, $c17
; PURECAP-NEXT:    nop
; PURECAP-NEXT:    clc $c17, $zero, 0($c11) # 16-byte Folded Reload
; PURECAP-NEXT:    cjr $c17
; PURECAP-NEXT:    cincoffset $c11, $c11, 16
; PURECAP-NEXT:  .LBB10_2: # %if.end
; PURECAP-NEXT:    clcbi $c12, %capcall20(func2)($c1)
; PURECAP-NEXT:    cjalr $c12, $c17
; PURECAP-NEXT:    nop
; PURECAP-NEXT:    clc $c17, $zero, 0($c11) # 16-byte Folded Reload
; PURECAP-NEXT:    cjr $c17
; PURECAP-NEXT:    cincoffset $c11, $c11, 16
entry:
  %cmp = icmp ugt i8 addrspace(200)* %a, %b
  br i1 %cmp, label %if.then, label %if.end
if.then:
  %retval1 = tail call i32 @func1()
  ret i32 %retval1
if.end:
  %retval2 = tail call i32 @func2()
  ret i32 %retval2
}

define i32 @branch_ge(i8 addrspace(200)* %a, i8 addrspace(200)* %b) nounwind noreturn {
; HYBRID-LABEL: branch_ge:
; HYBRID:       # %bb.0: # %entry
; HYBRID-NEXT:    daddiu $sp, $sp, -16
; HYBRID-NEXT:    sd $ra, 8($sp) # 8-byte Folded Spill
; HYBRID-NEXT:    sd $gp, 0($sp) # 8-byte Folded Spill
; HYBRID-NEXT:    lui $1, %hi(%neg(%gp_rel(branch_ge)))
; HYBRID-NEXT:    daddu $1, $1, $25
; HYBRID-NEXT:    cltu $2, $c3, $c4
; HYBRID-NEXT:    bnez $2, .LBB11_2
; HYBRID-NEXT:    daddiu $gp, $1, %lo(%neg(%gp_rel(branch_ge)))
; HYBRID-NEXT:  # %bb.1: # %if.then
; HYBRID-NEXT:    ld $25, %call16(func1)($gp)
; HYBRID-NEXT:    .reloc .Ltmp6, R_MIPS_JALR, func1
; HYBRID-NEXT:  .Ltmp6:
; HYBRID-NEXT:    jalr $25
; HYBRID-NEXT:    nop
; HYBRID-NEXT:    ld $gp, 0($sp) # 8-byte Folded Reload
; HYBRID-NEXT:    ld $ra, 8($sp) # 8-byte Folded Reload
; HYBRID-NEXT:    jr $ra
; HYBRID-NEXT:    daddiu $sp, $sp, 16
; HYBRID-NEXT:  .LBB11_2: # %if.end
; HYBRID-NEXT:    ld $25, %call16(func2)($gp)
; HYBRID-NEXT:    .reloc .Ltmp7, R_MIPS_JALR, func2
; HYBRID-NEXT:  .Ltmp7:
; HYBRID-NEXT:    jalr $25
; HYBRID-NEXT:    nop
; HYBRID-NEXT:    ld $gp, 0($sp) # 8-byte Folded Reload
; HYBRID-NEXT:    ld $ra, 8($sp) # 8-byte Folded Reload
; HYBRID-NEXT:    jr $ra
; HYBRID-NEXT:    daddiu $sp, $sp, 16
;
; PURECAP-LABEL: branch_ge:
; PURECAP:       # %bb.0: # %entry
; PURECAP-NEXT:    cincoffset $c11, $c11, -16
; PURECAP-NEXT:    csc $c17, $zero, 0($c11) # 16-byte Folded Spill
; PURECAP-NEXT:    cltu $1, $c3, $c4
; PURECAP-NEXT:    lui $2, %pcrel_hi(_CHERI_CAPABILITY_TABLE_-8)
; PURECAP-NEXT:    daddiu $2, $2, %pcrel_lo(_CHERI_CAPABILITY_TABLE_-4)
; PURECAP-NEXT:    cgetpccincoffset $c1, $2
; PURECAP-NEXT:    bnez $1, .LBB11_2
; PURECAP-NEXT:    nop
; PURECAP-NEXT:  # %bb.1: # %if.then
; PURECAP-NEXT:    clcbi $c12, %capcall20(func1)($c1)
; PURECAP-NEXT:    cjalr $c12, $c17
; PURECAP-NEXT:    nop
; PURECAP-NEXT:    clc $c17, $zero, 0($c11) # 16-byte Folded Reload
; PURECAP-NEXT:    cjr $c17
; PURECAP-NEXT:    cincoffset $c11, $c11, 16
; PURECAP-NEXT:  .LBB11_2: # %if.end
; PURECAP-NEXT:    clcbi $c12, %capcall20(func2)($c1)
; PURECAP-NEXT:    cjalr $c12, $c17
; PURECAP-NEXT:    nop
; PURECAP-NEXT:    clc $c17, $zero, 0($c11) # 16-byte Folded Reload
; PURECAP-NEXT:    cjr $c17
; PURECAP-NEXT:    cincoffset $c11, $c11, 16
entry:
  %cmp = icmp uge i8 addrspace(200)* %a, %b
  br i1 %cmp, label %if.then, label %if.end
if.then:
  %retval1 = tail call i32 @func1()
  ret i32 %retval1
if.end:
  %retval2 = tail call i32 @func2()
  ret i32 %retval2
}
