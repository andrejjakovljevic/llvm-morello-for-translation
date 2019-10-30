# NOTE: Assertions have been autogenerated by utils/update_mca_test_checks.py
# RUN: llvm-mca -march=aarch64 -mcpu=exynos-m3 -resource-pressure=false < %s | FileCheck %s -check-prefixes=ALL,M3
# RUN: llvm-mca -march=aarch64 -mcpu=exynos-m4 -resource-pressure=false < %s | FileCheck %s -check-prefixes=ALL,M4

  mov	x0, x1
  mov	sp, x0

  mov	w0, #0x3210
  add	w0, w1, #0

  adr	x0, 1f
  ldr	x0, [x0]

  adrp	x0, 1f
  add	x0, x0, :lo12:1f

  fmov	s0, s1

  movi	d0, #0

1:

# ALL:      Iterations:        100
# ALL-NEXT: Instructions:      1000

# M3-NEXT:  Total Cycles:      172
# M4-NEXT:  Total Cycles:      172

# ALL-NEXT: Total uOps:        1000

# M3:       Dispatch Width:    6
# M3-NEXT:  uOps Per Cycle:    5.81
# M3-NEXT:  IPC:               5.81
# M3-NEXT:  Block RThroughput: 1.7

# M4:       Dispatch Width:    6
# M4-NEXT:  uOps Per Cycle:    5.81
# M4-NEXT:  IPC:               5.81
# M4-NEXT:  Block RThroughput: 1.7

# ALL:      Instruction Info:
# ALL-NEXT: [1]: #uOps
# ALL-NEXT: [2]: Latency
# ALL-NEXT: [3]: RThroughput
# ALL-NEXT: [4]: MayLoad
# ALL-NEXT: [5]: MayStore
# ALL-NEXT: [6]: HasSideEffects (U)

# ALL:      [1]    [2]    [3]    [4]    [5]    [6]    Instructions:

# M3-NEXT:   1      0     0.17                        mov	x0, x1
# M3-NEXT:   1      0     0.17                        mov	sp, x0
# M3-NEXT:   1      0     0.17                        mov	w0, #12816
# M3-NEXT:   1      1     0.25                        add	w0, w1, #0
# M3-NEXT:   1      0     0.17                        adr	x0, .Ltmp0
# M3-NEXT:   1      4     0.50    *                   ldr	x0, [x0]
# M3-NEXT:   1      0     0.17                        adrp	x0, .Ltmp0
# M3-NEXT:   1      1     0.25                        add	x0, x0, :lo12:.Ltmp0
# M3-NEXT:   1      1     0.33                        fmov	s0, s1
# M3-NEXT:   1      0     0.17                        movi	d0, #0000000000000000

# M4-NEXT:   1      0     0.17                        mov	x0, x1
# M4-NEXT:   1      0     0.17                        mov	sp, x0
# M4-NEXT:   1      0     0.17                        mov	w0, #12816
# M4-NEXT:   1      1     0.25                        add	w0, w1, #0
# M4-NEXT:   1      0     0.17                        adr	x0, .Ltmp0
# M4-NEXT:   1      4     0.50    *                   ldr	x0, [x0]
# M4-NEXT:   1      0     0.17                        adrp	x0, .Ltmp0
# M4-NEXT:   1      1     0.25                        add	x0, x0, :lo12:.Ltmp0
# M4-NEXT:   1      1     0.33                        fmov	s0, s1
# M4-NEXT:   1      0     0.17                        movi	d0, #0000000000000000
