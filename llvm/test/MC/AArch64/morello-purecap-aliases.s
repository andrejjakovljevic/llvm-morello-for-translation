// RUN: llvm-mc -triple=arm64 -mattr=+morello,+c64 -show-encoding < %s | FileCheck %s
// RUN: llvm-mc -triple=arm64 -mattr=+morello,+c64  -filetype=obj < %s -o - | \
// RUN:     llvm-objdump --mattr=+morello -d - |  FileCheck %s

    ret
// CHECK:       ret c30

// Load byte, alternate
    ldurb w13, [sp]
    ldrb w22, [x3]
    ldrb w13, [sp, #-5]
    ldursb x11, [x7]
    ldrsb x21, [x5]
    ldrsb x21, [x5, #4]
    ldursb w15, [x26]
    ldrsb w18, [x27]
    ldrsb w18, [x27, #4]
// CHECK:	ldurb	w13, [sp, #0]
// CHECK:	ldurb	w22, [x3, #0]
// CHECK:	ldurb	w13, [sp, #-5]
// CHECK:	ldursb	x11, [x7, #0]
// CHECK:	ldursb	x21, [x5, #0]
// CHECK:	ldursb	x21, [x5, #4]
// CHECK:	ldursb	w15, [x26, #0]
// CHECK:	ldursb	w18, [x27, #0]
// CHECK:	ldursb	w18, [x27, #4]

// Load half, alternate
    ldurh w13, [sp]
    ldrh w22, [x3]
    ldrh w22, [x3, #4]
    ldursh x11, [x7]
    ldrsh x21, [x5]
    ldrsh x21, [x5, #4]
    ldursh w15, [x26]
    ldrsh w18, [x27]
    ldrsh w18, [x27, #4]
// CHECK:	ldurh	w13, [sp, #0]
// CHECK:	ldurh	w22, [x3, #0]
// CHECK:	ldurh	w22, [x3, #4]
// CHECK:	ldursh	x11, [x7, #0]
// CHECK:	ldursh	x21, [x5, #0]
// CHECK:	ldursh	x21, [x5, #4]
// CHECK:	ldursh	w15, [x26, #0]
// CHECK:	ldursh	w18, [x27, #0]
// CHECK:	ldursh	w18, [x27, #4]

// Load word, alternate
    ldur w16, [sp]
    ldr  w15, [sp]
    ldr  w15, [sp, #5]
    ldursw x17, [x27]
    ldrsw x13, [x5]
    ldrsw x13, [x5, #8]
// CHECK:	ldur	w16, [sp, #0]
// CHECK:	ldur	w15, [sp, #0]
// CHECK:	ldur	w15, [sp, #5]
// CHECK:	ldursw	x17, [x27, #0]
// CHECK:	ldursw	x13, [x5, #0]
// CHECK:	ldursw	x13, [x5, #8]

// Load double-word, alternate
    ldur x13, [x0]
    ldr x25, [x7]
    ldr x25, [x7, #7]
// CHECK:	ldur	x13, [x0, #0]
// CHECK:	ldur	x25, [x7, #0]
// CHECK:	ldur	x25, [x7, #7]

// Load fp, alternate
    ldur b5, [sp]
    ldr  b7, [x5]
    ldr  b9, [x6, #8]
    ldur h7, [sp]
    ldr  h9, [x2]
    ldr  h9, [x2, #8]
    ldur s5, [sp]
    ldr  s5, [sp]
    ldr  s7, [sp, #8]
    ldur d5, [x29]
    ldr  d6, [x28]
    ldr  d7, [x27, #8]
    ldur q5, [x3]
    ldr  q6, [x2]
    ldr  q7, [x1, #8]
// CHECK:	ldur	b5, [sp]
// CHECK:	ldur	b7, [x5]
// CHECK:	ldur	b9, [x6, #8]
// CHECK:	ldur	h7, [sp, #0]
// CHECK:	ldur	h9, [x2, #0]
// CHECK:	ldur	h9, [x2, #8]
// CHECK:	ldur	s5, [sp, #0]
// CHECK:	ldur	s5, [sp, #0]
// CHECK:	ldur	s7, [sp, #8]
// CHECK:	ldur	d5, [x29, #0]
// CHECK:	ldur	d6, [x28, #0]
// CHECK:	ldur	d7, [x27, #8]
// CHECK:	ldur	q5, [x3, #0]
// CHECK:	ldur	q6, [x2, #0]
// CHECK:	ldur	q7, [x1, #8]

// Load capability, alternate
    ldur c7, [x2]
    ldr  c2, [x0]
    ldr  c3, [x4, #15]
// CHECK:	ldur	c7, [x2, #0]
// CHECK:	ldr	c2, [x0, #0]
// CHECK:	ldur	c3, [x4, #15]

// Load capability
    ldur c2, [c0]
    ldr  c2, [c0]
    ldr  c3, [c4, #16]
    ldr  c3, [c4, #-7]
// CHECK:	ldur	c2, [c0, #0]
// CHECK:	ldr	c2, [c0, #0]
// CHECK:	ldr	c3, [c4, #16]
// CHECK:	ldur	c3, [c4, #-7]

// Store byte, alternate
    sturb w13, [sp]
    strb w22, [x3]
    strb w13, [sp, #-5]
// CHECK:	sturb	w13, [sp, #0]
// CHECK:	sturb	w22, [x3, #0]
// CHECK:	sturb	w13, [sp, #-5]

// Store half, alternate
    sturh w13, [sp]
    strh w22, [x3]
    strh w22, [x3, #4]
// CHECK:	sturh	w13, [sp, #0]
// CHECK:	sturh	w22, [x3, #0]
// CHECK:	sturh	w22, [x3, #4]

// Store word, alternate
    stur w16, [sp]
    str  w15, [sp]
    str  w15, [sp, #5]
// CHECK:	stur	w16, [sp, #0]
// CHECK:	stur	w15, [sp, #0]
// CHECK:	stur	w15, [sp, #5]

// Store double word, alternate
    stur x13, [x0]
    str x25, [x7]
    str x25, [x7, #7]
// CHECK:	stur	x13, [x0, #0]
// CHECK:	stur	x25, [x7, #0]
// CHECK:	stur	x25, [x7, #7]

// Store FP, alternate
    stur b5, [sp]
    str  b7, [x5]
    str  b9, [x6, #8]
    stur h7, [sp]
    str  h9, [x2]
    str  h9, [x2, #8]
    stur s5, [sp]
    str  s5, [sp]
    str  s7, [sp, #8]
    stur d5, [x29]
    str  d6, [x28]
    str  d7, [x27, #8]
    stur q5, [x3]
    str  q6, [x2]
    str  q7, [x1, #8]
// CHECK:	stur	b5, [sp, #0]
// CHECK:	stur	b7, [x5, #0]
// CHECK:	stur	b9, [x6, #8]
// CHECK:	stur	h7, [sp, #0]
// CHECK:	stur	h9, [x2, #0]
// CHECK:	stur	h9, [x2, #8]
// CHECK:	stur	s5, [sp, #0]
// CHECK:	stur	s5, [sp, #0]
// CHECK:	stur	s7, [sp, #8]
// CHECK:	stur	d5, [x29, #0]
// CHECK:	stur	d6, [x28, #0]
// CHECK:	stur	d7, [x27, #8]
// CHECK:	stur	q5, [x3, #0]
// CHECK:	stur	q6, [x2, #0]
// CHECK:	stur	q7, [x1, #8]

// Store capability alternate
    stur c7, [x2]
    str  c2, [x0]
    str  c3, [x4, #15]
// CHECK:	stur	c7, [x2, #0]
// CHECK:	str	c2, [x0, #0]
// CHECK:	stur	c3, [x4, #15]

// Store capability
    stur  c2, [c0]
    str  c2, [c0]
    str  c3, [c4, #16]
    str  c3, [c4, #-7]
// CHECK:	stur	c2, [c0, #0]
// CHECK:	str	c2, [c0, #0]
// CHECK:	str	c3, [c4, #16]
// CHECK:	stur	c3, [c4, #-7]

// Various misc load/store aliases
   sttr c1, [c0]
   ldtr c1, [c0]
   stp c0, c1, [c2]
   ldp c0, c1, [c2]
// CHECK:   sttr c1, [c0, #0]
// CHECK:   ldtr c1, [c0, #0]
// CHECK:   stp c0, c1, [c2, #0]
// CHECK:   ldp c0, c1, [c2, #0]

  retr
  rets
// CHECK: retr c30
// CHECK: rets c30
