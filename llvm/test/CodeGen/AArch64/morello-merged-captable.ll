; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=aarch64-none-elf -mattr=+c64,+morello -target-abi=purecap | FileCheck %s

target datalayout = "e-m:e-pf200:128:128:128:64-i8:8:32-i16:16:32-i64:64-i128:128-n32:64-S128-A200-P200-G200"
target triple = "aarch64-none-unknown-elf"

@x0 = internal addrspace(200) global i32 0, align 4
@x1 = internal addrspace(200) global i32 0, align 4
@x2 = internal addrspace(200) global i32 0, align 4
@x3 = internal addrspace(200) global i32 0, align 4
@x4 = internal addrspace(200) global i32 0, align 4
@x5 = internal addrspace(200) global i32 0, align 4
@x6 = internal addrspace(200) global i32 0, align 4
@x7 = internal addrspace(200) global i32 0, align 4
@x8 = internal addrspace(200) global i32 0, align 4
@x9 = internal addrspace(200) global i32 0, align 4
@x10 = internal addrspace(200) global i32 0, align 4
@x11 = internal addrspace(200) global i32 0, align 4
@x12 = internal addrspace(200) global i32 0, align 4
@x13 = internal addrspace(200) global i32 0, align 4
@x14 = internal addrspace(200) global i32 0, align 4
@x15 = internal addrspace(200) global i32 0, align 4
@x16 = internal addrspace(200) global i32 0, align 4
@x17 = internal addrspace(200) global i32 0, align 4
@x18 = internal addrspace(200) global i32 0, align 4
@x19 = internal addrspace(200) global i32 0, align 4

define i32 @getvals(i8 addrspace(200)* addrspace(200)* nocapture %a) local_unnamed_addr addrspace(200)  {
; CHECK-LABEL: getvals:
; CHECK:         .cfi_startproc purecap
; CHECK-NEXT:  // %bb.0: // %entry
; CHECK-NEXT:    adrp c1, .L__cap_merged_table
; CHECK-NEXT:    add c1, c1, :lo12:.L__cap_merged_table
; CHECK-NEXT:    ldp c2, c3, [c1, #0]
; CHECK-NEXT:    ldp c4, c5, [c1, #32]
; CHECK-NEXT:    stp c2, c3, [c0, #0]
; CHECK-NEXT:    ldp c2, c3, [c1, #64]
; CHECK-NEXT:    stp c4, c5, [c0, #32]
; CHECK-NEXT:    ldp c4, c5, [c1, #96]
; CHECK-NEXT:    stp c2, c3, [c0, #64]
; CHECK-NEXT:    ldp c2, c3, [c1, #128]
; CHECK-NEXT:    stp c4, c5, [c0, #96]
; CHECK-NEXT:    ldp c4, c5, [c1, #160]
; CHECK-NEXT:    stp c2, c3, [c0, #128]
; CHECK-NEXT:    ldp c2, c3, [c1, #192]
; CHECK-NEXT:    stp c4, c5, [c0, #160]
; CHECK-NEXT:    ldp c4, c5, [c1, #224]
; CHECK-NEXT:    stp c2, c3, [c0, #192]
; CHECK-NEXT:    ldp c2, c3, [c1, #256]
; CHECK-NEXT:    stp c4, c5, [c0, #224]
; CHECK-NEXT:    ldp c4, c1, [c1, #288]
; CHECK-NEXT:    stp c2, c3, [c0, #256]
; CHECK-NEXT:    stp c4, c1, [c0, #288]
; CHECK-NEXT:    ret c30
entry:
  store i8 addrspace(200)* bitcast (i32 addrspace(200)* @x0 to i8 addrspace(200)*), i8 addrspace(200)* addrspace(200)* %a, align 16
  %arrayidx1 = getelementptr inbounds i8 addrspace(200)*, i8 addrspace(200)* addrspace(200)* %a, i64 1
  store i8 addrspace(200)* bitcast (i32 addrspace(200)* @x1 to i8 addrspace(200)*), i8 addrspace(200)* addrspace(200)* %arrayidx1, align 16
  %arrayidx2 = getelementptr inbounds i8 addrspace(200)*, i8 addrspace(200)* addrspace(200)* %a, i64 2
  store i8 addrspace(200)* bitcast (i32 addrspace(200)* @x2 to i8 addrspace(200)*), i8 addrspace(200)* addrspace(200)* %arrayidx2, align 16
  %arrayidx3 = getelementptr inbounds i8 addrspace(200)*, i8 addrspace(200)* addrspace(200)* %a, i64 3
  store i8 addrspace(200)* bitcast (i32 addrspace(200)* @x3 to i8 addrspace(200)*), i8 addrspace(200)* addrspace(200)* %arrayidx3, align 16
  %arrayidx4 = getelementptr inbounds i8 addrspace(200)*, i8 addrspace(200)* addrspace(200)* %a, i64 4
  store i8 addrspace(200)* bitcast (i32 addrspace(200)* @x4 to i8 addrspace(200)*), i8 addrspace(200)* addrspace(200)* %arrayidx4, align 16
  %arrayidx5 = getelementptr inbounds i8 addrspace(200)*, i8 addrspace(200)* addrspace(200)* %a, i64 5
  store i8 addrspace(200)* bitcast (i32 addrspace(200)* @x5 to i8 addrspace(200)*), i8 addrspace(200)* addrspace(200)* %arrayidx5, align 16
  %arrayidx6 = getelementptr inbounds i8 addrspace(200)*, i8 addrspace(200)* addrspace(200)* %a, i64 6
  store i8 addrspace(200)* bitcast (i32 addrspace(200)* @x6 to i8 addrspace(200)*), i8 addrspace(200)* addrspace(200)* %arrayidx6, align 16
  %arrayidx7 = getelementptr inbounds i8 addrspace(200)*, i8 addrspace(200)* addrspace(200)* %a, i64 7
  store i8 addrspace(200)* bitcast (i32 addrspace(200)* @x7 to i8 addrspace(200)*), i8 addrspace(200)* addrspace(200)* %arrayidx7, align 16
  %arrayidx8 = getelementptr inbounds i8 addrspace(200)*, i8 addrspace(200)* addrspace(200)* %a, i64 8
  store i8 addrspace(200)* bitcast (i32 addrspace(200)* @x8 to i8 addrspace(200)*), i8 addrspace(200)* addrspace(200)* %arrayidx8, align 16
  %arrayidx9 = getelementptr inbounds i8 addrspace(200)*, i8 addrspace(200)* addrspace(200)* %a, i64 9
  store i8 addrspace(200)* bitcast (i32 addrspace(200)* @x9 to i8 addrspace(200)*), i8 addrspace(200)* addrspace(200)* %arrayidx9, align 16
  %arrayidx10 = getelementptr inbounds i8 addrspace(200)*, i8 addrspace(200)* addrspace(200)* %a, i64 10
  store i8 addrspace(200)* bitcast (i32 addrspace(200)* @x10 to i8 addrspace(200)*), i8 addrspace(200)* addrspace(200)* %arrayidx10, align 16
  %arrayidx11 = getelementptr inbounds i8 addrspace(200)*, i8 addrspace(200)* addrspace(200)* %a, i64 11
  store i8 addrspace(200)* bitcast (i32 addrspace(200)* @x11 to i8 addrspace(200)*), i8 addrspace(200)* addrspace(200)* %arrayidx11, align 16
  %arrayidx12 = getelementptr inbounds i8 addrspace(200)*, i8 addrspace(200)* addrspace(200)* %a, i64 12
  store i8 addrspace(200)* bitcast (i32 addrspace(200)* @x12 to i8 addrspace(200)*), i8 addrspace(200)* addrspace(200)* %arrayidx12, align 16
  %arrayidx13 = getelementptr inbounds i8 addrspace(200)*, i8 addrspace(200)* addrspace(200)* %a, i64 13
  store i8 addrspace(200)* bitcast (i32 addrspace(200)* @x13 to i8 addrspace(200)*), i8 addrspace(200)* addrspace(200)* %arrayidx13, align 16
  %arrayidx14 = getelementptr inbounds i8 addrspace(200)*, i8 addrspace(200)* addrspace(200)* %a, i64 14
  store i8 addrspace(200)* bitcast (i32 addrspace(200)* @x14 to i8 addrspace(200)*), i8 addrspace(200)* addrspace(200)* %arrayidx14, align 16
  %arrayidx15 = getelementptr inbounds i8 addrspace(200)*, i8 addrspace(200)* addrspace(200)* %a, i64 15
  store i8 addrspace(200)* bitcast (i32 addrspace(200)* @x15 to i8 addrspace(200)*), i8 addrspace(200)* addrspace(200)* %arrayidx15, align 16
  %arrayidx16 = getelementptr inbounds i8 addrspace(200)*, i8 addrspace(200)* addrspace(200)* %a, i64 16
  store i8 addrspace(200)* bitcast (i32 addrspace(200)* @x16 to i8 addrspace(200)*), i8 addrspace(200)* addrspace(200)* %arrayidx16, align 16
  %arrayidx17 = getelementptr inbounds i8 addrspace(200)*, i8 addrspace(200)* addrspace(200)* %a, i64 17
  store i8 addrspace(200)* bitcast (i32 addrspace(200)* @x17 to i8 addrspace(200)*), i8 addrspace(200)* addrspace(200)* %arrayidx17, align 16
  %arrayidx18 = getelementptr inbounds i8 addrspace(200)*, i8 addrspace(200)* addrspace(200)* %a, i64 18
  store i8 addrspace(200)* bitcast (i32 addrspace(200)* @x18 to i8 addrspace(200)*), i8 addrspace(200)* addrspace(200)* %arrayidx18, align 16
  %arrayidx19 = getelementptr inbounds i8 addrspace(200)*, i8 addrspace(200)* addrspace(200)* %a, i64 19
  store i8 addrspace(200)* bitcast (i32 addrspace(200)* @x19 to i8 addrspace(200)*), i8 addrspace(200)* addrspace(200)* %arrayidx19, align 16
  ret i32 undef
}

define i32 @bazz() local_unnamed_addr addrspace(200) {
; CHECK-LABEL: bazz:
; CHECK:         .cfi_startproc purecap
; CHECK-NEXT:  // %bb.0: // %entry
; CHECK-NEXT:    adrp c0, .L__cap_merged_table+16
; CHECK-NEXT:    adrp c1, .L__cap_merged_table+304
; CHECK-NEXT:    ldr c0, [c0, :lo12:.L__cap_merged_table+16]
; CHECK-NEXT:    ldr c1, [c1, :lo12:.L__cap_merged_table+304]
; CHECK-NEXT:    ldr w8, [c0]
; CHECK-NEXT:    ldr w9, [c1]
; CHECK-NEXT:    add w0, w9, w8
; CHECK-NEXT:    ret c30
entry:
  %0 = load i32, i32 addrspace(200)* @x1, align 4
  %1 = load i32, i32 addrspace(200)* @x19, align 4
  %add = add nsw i32 %1, %0
  ret i32 %add
}

define nonnull i32 addrspace(200)* @getx0() local_unnamed_addr addrspace(200) {
; CHECK-LABEL: getx0:
; CHECK:         .cfi_startproc purecap
; CHECK-NEXT:  // %bb.0: // %entry
; CHECK-NEXT:    adrp c0, .L__cap_merged_table
; CHECK-NEXT:    ldr c0, [c0, :lo12:.L__cap_merged_table]
; CHECK-NEXT:    ret c30
entry:
  ret i32 addrspace(200)* @x0
}

define nonnull i32 addrspace(200)* @getx1() local_unnamed_addr addrspace(200) {
; CHECK-LABEL: getx1:
; CHECK:         .cfi_startproc purecap
; CHECK-NEXT:  // %bb.0: // %entry
; CHECK-NEXT:    adrp c0, .L__cap_merged_table+16
; CHECK-NEXT:    ldr c0, [c0, :lo12:.L__cap_merged_table+16]
; CHECK-NEXT:    ret c30
entry:
  ret i32 addrspace(200)* @x1
}

define i32 @foo() local_unnamed_addr addrspace(200) {
; CHECK-LABEL: foo:
; CHECK:         .cfi_startproc purecap
; CHECK-NEXT:  // %bb.0: // %entry
; CHECK-NEXT:    adrp c0, .L__cap_merged_table+304
; CHECK-NEXT:    adrp c1, .L__cap_merged_table+16
; CHECK-NEXT:    ldr c0, [c0, :lo12:.L__cap_merged_table+304]
; CHECK-NEXT:    ldr c1, [c1, :lo12:.L__cap_merged_table+16]
; CHECK-NEXT:    ldr w8, [c0]
; CHECK-NEXT:    ldr w9, [c1]
; CHECK-NEXT:    add w0, w9, w8
; CHECK-NEXT:    ret c30
entry:
  %0 = load i32, i32 addrspace(200)* @x19, align 4
  %1 = load i32, i32 addrspace(200)* @x1, align 4
  %add = add nsw i32 %1, %0
  ret i32 %add
}

define i32 @foo1() local_unnamed_addr addrspace(200) {
; CHECK-LABEL: foo1:
; CHECK:         .cfi_startproc purecap
; CHECK-NEXT:  // %bb.0: // %entry
; CHECK-NEXT:    adrp c0, .L__cap_merged_table
; CHECK-NEXT:    adrp c1, .L__cap_merged_table+304
; CHECK-NEXT:    ldr c0, [c0, :lo12:.L__cap_merged_table]
; CHECK-NEXT:    ldr c1, [c1, :lo12:.L__cap_merged_table+304]
; CHECK-NEXT:    ldr w8, [c0]
; CHECK-NEXT:    ldr w9, [c1]
; CHECK-NEXT:    add w0, w9, w8
; CHECK-NEXT:    ret c30
entry:
  %0 = load i32, i32 addrspace(200)* @x0, align 4
  %1 = load i32, i32 addrspace(200)* @x19, align 4
  %add = add nsw i32 %1, %0
  ret i32 %add
}

define i32 @bat() local_unnamed_addr addrspace(200) {
; CHECK-LABEL: bat:
; CHECK:         .cfi_startproc purecap
; CHECK-NEXT:  // %bb.0: // %entry
; CHECK-NEXT:    adrp c0, .L__cap_merged_table
; CHECK-NEXT:    add c0, c0, :lo12:.L__cap_merged_table
; CHECK-NEXT:    ldr c1, [c0, #0]
; CHECK-NEXT:    ldr c2, [c0, #304]
; CHECK-NEXT:    ldr c0, [c0, #128]
; CHECK-NEXT:    ldr w8, [c1]
; CHECK-NEXT:    ldr w9, [c2]
; CHECK-NEXT:    ldr w10, [c0]
; CHECK-NEXT:    add w8, w9, w8
; CHECK-NEXT:    add w0, w8, w10
; CHECK-NEXT:    ret c30
entry:
  %0 = load i32, i32 addrspace(200)* @x0, align 4
  %1 = load i32, i32 addrspace(200)* @x19, align 4
  %add = add nsw i32 %1, %0
  %2 = load i32, i32 addrspace(200)* @x8, align 4
  %add1 = add nsw i32 %add, %2
  ret i32 %add1
}

define i32 @bif() local_unnamed_addr addrspace(200) {
; CHECK-LABEL: bif:
; CHECK:         .cfi_startproc purecap
; CHECK-NEXT:  // %bb.0: // %entry
; CHECK-NEXT:    adrp c0, .L__cap_merged_table
; CHECK-NEXT:    add c0, c0, :lo12:.L__cap_merged_table
; CHECK-NEXT:    ldr c1, [c0, #304]
; CHECK-NEXT:    ldr c2, [c0, #112]
; CHECK-NEXT:    ldr c0, [c0, #0]
; CHECK-NEXT:    ldr w8, [c1]
; CHECK-NEXT:    ldr w9, [c2]
; CHECK-NEXT:    ldr w10, [c0]
; CHECK-NEXT:    add w8, w9, w8
; CHECK-NEXT:    add w0, w8, w10
; CHECK-NEXT:    ret c30
entry:
  %0 = load i32, i32 addrspace(200)* @x19, align 4
  %1 = load i32, i32 addrspace(200)* @x7, align 4
  %add = add nsw i32 %1, %0
  %2 = load i32, i32 addrspace(200)* @x0, align 4
  %add1 = add nsw i32 %add, %2
  ret i32 %add1
}

; CHECK:	.type	.L__cap_merged_table,@object
; CHECK-NEXT:	.section	.data.rel.ro,"aw",@progbits
; CHECK-NEXT:	.p2align	4
; CHECK-LABEL: .L__cap_merged_table:
; CHECK-NEXT: .capinit x0
; CHECK-NEXT: .xword	0
; CHECK-NEXT: .xword	0
; CHECK-NEXT: .capinit x1
; CHECK-NEXT: .xword	0
; CHECK-NEXT: .xword	0
; CHECK-NEXT: .capinit x2
; CHECK-NEXT: .xword	0
; CHECK-NEXT: .xword	0
; CHECK-NEXT: .capinit x3
; CHECK-NEXT: .xword	0
; CHECK-NEXT: .xword	0
; CHECK-NEXT: .capinit x4
; CHECK-NEXT: .xword	0
; CHECK-NEXT: .xword	0
; CHECK-NEXT: .capinit x5
; CHECK-NEXT: .xword	0
; CHECK-NEXT: .xword	0
; CHECK-NEXT: .capinit x6
; CHECK-NEXT: .xword	0
; CHECK-NEXT: .xword	0
; CHECK-NEXT: .capinit x7
; CHECK-NEXT: .xword	0
; CHECK-NEXT: .xword	0
; CHECK-NEXT: .capinit x8
; CHECK-NEXT: .xword	0
; CHECK-NEXT: .xword	0
; CHECK-NEXT: .capinit x9
; CHECK-NEXT: .xword	0
; CHECK-NEXT: .xword	0
; CHECK-NEXT: .capinit x10
; CHECK-NEXT: .xword	0
; CHECK-NEXT: .xword	0
; CHECK-NEXT: .capinit x11
; CHECK-NEXT: .xword	0
; CHECK-NEXT: .xword	0
; CHECK-NEXT: .capinit x12
; CHECK-NEXT: .xword	0
; CHECK-NEXT: .xword	0
; CHECK-NEXT: .capinit x13
; CHECK-NEXT: .xword	0
; CHECK-NEXT: .xword	0
; CHECK-NEXT: .capinit x14
; CHECK-NEXT: .xword	0
; CHECK-NEXT: .xword	0
; CHECK-NEXT: .capinit x15
; CHECK-NEXT: .xword	0
; CHECK-NEXT: .xword	0
; CHECK-NEXT: .capinit x16
; CHECK-NEXT: .xword	0
; CHECK-NEXT: .xword	0
; CHECK-NEXT: .capinit x17
; CHECK-NEXT: .xword	0
; CHECK-NEXT: .xword	0
; CHECK-NEXT: .capinit x18
; CHECK-NEXT: .xword	0
; CHECK-NEXT: .xword	0
; CHECK-NEXT: .capinit x19
; CHECK-NEXT: .xword	0
; CHECK-NEXT: .xword	0
; CHECL-NEXT: .size	.L__cap_merged_table, 320
