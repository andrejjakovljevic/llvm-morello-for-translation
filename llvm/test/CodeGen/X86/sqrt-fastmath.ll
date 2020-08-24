; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=x86_64-- -mcpu=x86-64 -mattr=+sse2 | FileCheck %s --check-prefix=CHECK --check-prefix=SSE
; RUN: llc < %s -mtriple=x86_64-- -mcpu=x86-64 -mattr=+avx  | FileCheck %s --check-prefix=CHECK --check-prefix=AVX --check-prefix=AVX1
; RUN: llc < %s -mtriple=x86_64-- -mcpu=x86-64 -mattr=+avx512f  | FileCheck %s --check-prefix=CHECK --check-prefix=AVX --check-prefix=AVX512

declare double @__sqrt_finite(double)
declare float @__sqrtf_finite(float)
declare x86_fp80 @__sqrtl_finite(x86_fp80)
declare float @llvm.sqrt.f32(float)
declare <4 x float> @llvm.sqrt.v4f32(<4 x float>)
declare <8 x float> @llvm.sqrt.v8f32(<8 x float>)
declare <16 x float> @llvm.sqrt.v16f32(<16 x float>)
declare double @llvm.sqrt.f64(double)
declare <2 x double> @llvm.sqrt.v2f64(<2 x double>)

declare float @llvm.fabs.f32(float)
declare <4 x float> @llvm.fabs.v4f32(<4 x float>)
declare double @llvm.fabs.f64(double)

define double @finite_f64_no_estimate(double %d) #0 {
; SSE-LABEL: finite_f64_no_estimate:
; SSE:       # %bb.0:
; SSE-NEXT:    sqrtsd %xmm0, %xmm0
; SSE-NEXT:    retq
;
; AVX-LABEL: finite_f64_no_estimate:
; AVX:       # %bb.0:
; AVX-NEXT:    vsqrtsd %xmm0, %xmm0, %xmm0
; AVX-NEXT:    retq
  %call = tail call double @__sqrt_finite(double %d) #2
  ret double %call
}

; No estimates for doubles.

define double @finite_f64_estimate(double %d) #1 {
; SSE-LABEL: finite_f64_estimate:
; SSE:       # %bb.0:
; SSE-NEXT:    sqrtsd %xmm0, %xmm0
; SSE-NEXT:    retq
;
; AVX-LABEL: finite_f64_estimate:
; AVX:       # %bb.0:
; AVX-NEXT:    vsqrtsd %xmm0, %xmm0, %xmm0
; AVX-NEXT:    retq
  %call = tail call double @__sqrt_finite(double %d) #2
  ret double %call
}

define float @finite_f32_no_estimate(float %f) #0 {
; SSE-LABEL: finite_f32_no_estimate:
; SSE:       # %bb.0:
; SSE-NEXT:    sqrtss %xmm0, %xmm0
; SSE-NEXT:    retq
;
; AVX-LABEL: finite_f32_no_estimate:
; AVX:       # %bb.0:
; AVX-NEXT:    vsqrtss %xmm0, %xmm0, %xmm0
; AVX-NEXT:    retq
  %call = tail call float @__sqrtf_finite(float %f) #2
  ret float %call
}

define float @finite_f32_estimate_ieee(float %f) #1 {
; SSE-LABEL: finite_f32_estimate_ieee:
; SSE:       # %bb.0:
; SSE-NEXT:    sqrtss %xmm0, %xmm0
; SSE-NEXT:    retq
;
; AVX-LABEL: finite_f32_estimate_ieee:
; AVX:       # %bb.0:
; AVX-NEXT:    vsqrtss %xmm0, %xmm0, %xmm0
; AVX-NEXT:    retq
  %call = tail call float @__sqrtf_finite(float %f) #2
  ret float %call
}

define float @finite_f32_estimate_ieee_ninf(float %f) #1 {
; SSE-LABEL: finite_f32_estimate_ieee_ninf:
; SSE:       # %bb.0:
; SSE-NEXT:    rsqrtss %xmm0, %xmm1
; SSE-NEXT:    movaps %xmm0, %xmm2
; SSE-NEXT:    mulss %xmm1, %xmm2
; SSE-NEXT:    movss {{.*#+}} xmm3 = mem[0],zero,zero,zero
; SSE-NEXT:    mulss %xmm2, %xmm3
; SSE-NEXT:    mulss %xmm1, %xmm2
; SSE-NEXT:    addss {{.*}}(%rip), %xmm2
; SSE-NEXT:    andps {{.*}}(%rip), %xmm0
; SSE-NEXT:    mulss %xmm3, %xmm2
; SSE-NEXT:    cmpltss {{.*}}(%rip), %xmm0
; SSE-NEXT:    andnps %xmm2, %xmm0
; SSE-NEXT:    retq
;
; AVX1-LABEL: finite_f32_estimate_ieee_ninf:
; AVX1:       # %bb.0:
; AVX1-NEXT:    vrsqrtss %xmm0, %xmm0, %xmm1
; AVX1-NEXT:    vmulss %xmm1, %xmm0, %xmm2
; AVX1-NEXT:    vmulss %xmm1, %xmm2, %xmm1
; AVX1-NEXT:    vaddss {{.*}}(%rip), %xmm1, %xmm1
; AVX1-NEXT:    vmulss {{.*}}(%rip), %xmm2, %xmm2
; AVX1-NEXT:    vandps {{.*}}(%rip), %xmm0, %xmm0
; AVX1-NEXT:    vmulss %xmm1, %xmm2, %xmm1
; AVX1-NEXT:    vcmpltss {{.*}}(%rip), %xmm0, %xmm0
; AVX1-NEXT:    vandnps %xmm1, %xmm0, %xmm0
; AVX1-NEXT:    retq
;
; AVX512-LABEL: finite_f32_estimate_ieee_ninf:
; AVX512:       # %bb.0:
; AVX512-NEXT:    vrsqrtss %xmm0, %xmm0, %xmm1
; AVX512-NEXT:    vmulss %xmm1, %xmm0, %xmm2
; AVX512-NEXT:    vfmadd213ss {{.*#+}} xmm1 = (xmm2 * xmm1) + mem
; AVX512-NEXT:    vmulss {{.*}}(%rip), %xmm2, %xmm2
; AVX512-NEXT:    vmulss %xmm1, %xmm2, %xmm1
; AVX512-NEXT:    vbroadcastss {{.*#+}} xmm2 = [NaN,NaN,NaN,NaN]
; AVX512-NEXT:    vandps %xmm2, %xmm0, %xmm0
; AVX512-NEXT:    vcmpltss {{.*}}(%rip), %xmm0, %k1
; AVX512-NEXT:    vxorps %xmm0, %xmm0, %xmm0
; AVX512-NEXT:    vmovss %xmm0, %xmm1, %xmm1 {%k1}
; AVX512-NEXT:    vmovaps %xmm1, %xmm0
; AVX512-NEXT:    retq
  %call = tail call ninf float @__sqrtf_finite(float %f) #2
  ret float %call
}

define float @finite_f32_estimate_daz(float %f) #4 {
; SSE-LABEL: finite_f32_estimate_daz:
; SSE:       # %bb.0:
; SSE-NEXT:    sqrtss %xmm0, %xmm0
; SSE-NEXT:    retq
;
; AVX-LABEL: finite_f32_estimate_daz:
; AVX:       # %bb.0:
; AVX-NEXT:    vsqrtss %xmm0, %xmm0, %xmm0
; AVX-NEXT:    retq
  %call = tail call float @__sqrtf_finite(float %f) #2
  ret float %call
}

define float @finite_f32_estimate_daz_ninf(float %f) #4 {
; SSE-LABEL: finite_f32_estimate_daz_ninf:
; SSE:       # %bb.0:
; SSE-NEXT:    rsqrtss %xmm0, %xmm1
; SSE-NEXT:    movaps %xmm0, %xmm2
; SSE-NEXT:    mulss %xmm1, %xmm2
; SSE-NEXT:    movss {{.*#+}} xmm3 = mem[0],zero,zero,zero
; SSE-NEXT:    mulss %xmm2, %xmm3
; SSE-NEXT:    mulss %xmm1, %xmm2
; SSE-NEXT:    addss {{.*}}(%rip), %xmm2
; SSE-NEXT:    mulss %xmm3, %xmm2
; SSE-NEXT:    xorps %xmm1, %xmm1
; SSE-NEXT:    cmpeqss %xmm1, %xmm0
; SSE-NEXT:    andnps %xmm2, %xmm0
; SSE-NEXT:    retq
;
; AVX1-LABEL: finite_f32_estimate_daz_ninf:
; AVX1:       # %bb.0:
; AVX1-NEXT:    vrsqrtss %xmm0, %xmm0, %xmm1
; AVX1-NEXT:    vmulss %xmm1, %xmm0, %xmm2
; AVX1-NEXT:    vmulss %xmm1, %xmm2, %xmm1
; AVX1-NEXT:    vaddss {{.*}}(%rip), %xmm1, %xmm1
; AVX1-NEXT:    vmulss {{.*}}(%rip), %xmm2, %xmm2
; AVX1-NEXT:    vmulss %xmm1, %xmm2, %xmm1
; AVX1-NEXT:    vxorps %xmm2, %xmm2, %xmm2
; AVX1-NEXT:    vcmpeqss %xmm2, %xmm0, %xmm0
; AVX1-NEXT:    vandnps %xmm1, %xmm0, %xmm0
; AVX1-NEXT:    retq
;
; AVX512-LABEL: finite_f32_estimate_daz_ninf:
; AVX512:       # %bb.0:
; AVX512-NEXT:    vrsqrtss %xmm0, %xmm0, %xmm1
; AVX512-NEXT:    vmulss %xmm1, %xmm0, %xmm2
; AVX512-NEXT:    vfmadd213ss {{.*#+}} xmm1 = (xmm2 * xmm1) + mem
; AVX512-NEXT:    vmulss {{.*}}(%rip), %xmm2, %xmm2
; AVX512-NEXT:    vmulss %xmm1, %xmm2, %xmm1
; AVX512-NEXT:    vxorps %xmm2, %xmm2, %xmm2
; AVX512-NEXT:    vcmpeqss %xmm2, %xmm0, %k1
; AVX512-NEXT:    vmovss %xmm2, %xmm1, %xmm1 {%k1}
; AVX512-NEXT:    vmovaps %xmm1, %xmm0
; AVX512-NEXT:    retq
  %call = tail call ninf float @__sqrtf_finite(float %f) #2
  ret float %call
}

define x86_fp80 @finite_f80_no_estimate(x86_fp80 %ld) #0 {
; CHECK-LABEL: finite_f80_no_estimate:
; CHECK:       # %bb.0:
; CHECK-NEXT:    fldt {{[0-9]+}}(%rsp)
; CHECK-NEXT:    fsqrt
; CHECK-NEXT:    retq
  %call = tail call x86_fp80 @__sqrtl_finite(x86_fp80 %ld) #2
  ret x86_fp80 %call
}

; Don't die on the impossible.

define x86_fp80 @finite_f80_estimate_but_no(x86_fp80 %ld) #1 {
; CHECK-LABEL: finite_f80_estimate_but_no:
; CHECK:       # %bb.0:
; CHECK-NEXT:    fldt {{[0-9]+}}(%rsp)
; CHECK-NEXT:    fsqrt
; CHECK-NEXT:    retq
  %call = tail call x86_fp80 @__sqrtl_finite(x86_fp80 %ld) #2
  ret x86_fp80 %call
}

; PR34994 - https://bugs.llvm.org/show_bug.cgi?id=34994

define float @sqrtf_check_denorms(float %x) #3 {
; SSE-LABEL: sqrtf_check_denorms:
; SSE:       # %bb.0:
; SSE-NEXT:    sqrtss %xmm0, %xmm0
; SSE-NEXT:    retq
;
; AVX-LABEL: sqrtf_check_denorms:
; AVX:       # %bb.0:
; AVX-NEXT:    vsqrtss %xmm0, %xmm0, %xmm0
; AVX-NEXT:    retq
  %call = tail call float @__sqrtf_finite(float %x) #2
  ret float %call
}

define float @sqrtf_check_denorms_ninf(float %x) #3 {
; SSE-LABEL: sqrtf_check_denorms_ninf:
; SSE:       # %bb.0:
; SSE-NEXT:    rsqrtss %xmm0, %xmm1
; SSE-NEXT:    movaps %xmm0, %xmm2
; SSE-NEXT:    mulss %xmm1, %xmm2
; SSE-NEXT:    movss {{.*#+}} xmm3 = mem[0],zero,zero,zero
; SSE-NEXT:    mulss %xmm2, %xmm3
; SSE-NEXT:    mulss %xmm1, %xmm2
; SSE-NEXT:    addss {{.*}}(%rip), %xmm2
; SSE-NEXT:    andps {{.*}}(%rip), %xmm0
; SSE-NEXT:    mulss %xmm3, %xmm2
; SSE-NEXT:    cmpltss {{.*}}(%rip), %xmm0
; SSE-NEXT:    andnps %xmm2, %xmm0
; SSE-NEXT:    retq
;
; AVX1-LABEL: sqrtf_check_denorms_ninf:
; AVX1:       # %bb.0:
; AVX1-NEXT:    vrsqrtss %xmm0, %xmm0, %xmm1
; AVX1-NEXT:    vmulss %xmm1, %xmm0, %xmm2
; AVX1-NEXT:    vmulss %xmm1, %xmm2, %xmm1
; AVX1-NEXT:    vaddss {{.*}}(%rip), %xmm1, %xmm1
; AVX1-NEXT:    vmulss {{.*}}(%rip), %xmm2, %xmm2
; AVX1-NEXT:    vandps {{.*}}(%rip), %xmm0, %xmm0
; AVX1-NEXT:    vmulss %xmm1, %xmm2, %xmm1
; AVX1-NEXT:    vcmpltss {{.*}}(%rip), %xmm0, %xmm0
; AVX1-NEXT:    vandnps %xmm1, %xmm0, %xmm0
; AVX1-NEXT:    retq
;
; AVX512-LABEL: sqrtf_check_denorms_ninf:
; AVX512:       # %bb.0:
; AVX512-NEXT:    vrsqrtss %xmm0, %xmm0, %xmm1
; AVX512-NEXT:    vmulss %xmm1, %xmm0, %xmm2
; AVX512-NEXT:    vfmadd213ss {{.*#+}} xmm1 = (xmm2 * xmm1) + mem
; AVX512-NEXT:    vmulss {{.*}}(%rip), %xmm2, %xmm2
; AVX512-NEXT:    vmulss %xmm1, %xmm2, %xmm1
; AVX512-NEXT:    vbroadcastss {{.*#+}} xmm2 = [NaN,NaN,NaN,NaN]
; AVX512-NEXT:    vandps %xmm2, %xmm0, %xmm0
; AVX512-NEXT:    vcmpltss {{.*}}(%rip), %xmm0, %k1
; AVX512-NEXT:    vxorps %xmm0, %xmm0, %xmm0
; AVX512-NEXT:    vmovss %xmm0, %xmm1, %xmm1 {%k1}
; AVX512-NEXT:    vmovaps %xmm1, %xmm0
; AVX512-NEXT:    retq
  %call = tail call ninf float @__sqrtf_finite(float %x) #2
  ret float %call
}

define <4 x float> @sqrt_v4f32_check_denorms(<4 x float> %x) #3 {
; SSE-LABEL: sqrt_v4f32_check_denorms:
; SSE:       # %bb.0:
; SSE-NEXT:    sqrtps %xmm0, %xmm0
; SSE-NEXT:    retq
;
; AVX-LABEL: sqrt_v4f32_check_denorms:
; AVX:       # %bb.0:
; AVX-NEXT:    vsqrtps %xmm0, %xmm0
; AVX-NEXT:    retq
  %call = tail call <4 x float> @llvm.sqrt.v4f32(<4 x float> %x) #2
  ret <4 x float> %call
}

define <4 x float> @sqrt_v4f32_check_denorms_ninf(<4 x float> %x) #3 {
; SSE-LABEL: sqrt_v4f32_check_denorms_ninf:
; SSE:       # %bb.0:
; SSE-NEXT:    rsqrtps %xmm0, %xmm2
; SSE-NEXT:    movaps %xmm0, %xmm1
; SSE-NEXT:    mulps %xmm2, %xmm1
; SSE-NEXT:    movaps {{.*#+}} xmm3 = [-5.0E-1,-5.0E-1,-5.0E-1,-5.0E-1]
; SSE-NEXT:    mulps %xmm1, %xmm3
; SSE-NEXT:    mulps %xmm2, %xmm1
; SSE-NEXT:    addps {{.*}}(%rip), %xmm1
; SSE-NEXT:    andps {{.*}}(%rip), %xmm0
; SSE-NEXT:    mulps %xmm3, %xmm1
; SSE-NEXT:    movaps {{.*#+}} xmm2 = [1.17549435E-38,1.17549435E-38,1.17549435E-38,1.17549435E-38]
; SSE-NEXT:    cmpleps %xmm0, %xmm2
; SSE-NEXT:    andps %xmm2, %xmm1
; SSE-NEXT:    movaps %xmm1, %xmm0
; SSE-NEXT:    retq
;
; AVX1-LABEL: sqrt_v4f32_check_denorms_ninf:
; AVX1:       # %bb.0:
; AVX1-NEXT:    vrsqrtps %xmm0, %xmm1
; AVX1-NEXT:    vmulps %xmm1, %xmm0, %xmm2
; AVX1-NEXT:    vmulps {{.*}}(%rip), %xmm2, %xmm3
; AVX1-NEXT:    vmulps %xmm1, %xmm2, %xmm1
; AVX1-NEXT:    vaddps {{.*}}(%rip), %xmm1, %xmm1
; AVX1-NEXT:    vandps {{.*}}(%rip), %xmm0, %xmm0
; AVX1-NEXT:    vmulps %xmm1, %xmm3, %xmm1
; AVX1-NEXT:    vmovaps {{.*#+}} xmm2 = [1.17549435E-38,1.17549435E-38,1.17549435E-38,1.17549435E-38]
; AVX1-NEXT:    vcmpleps %xmm0, %xmm2, %xmm0
; AVX1-NEXT:    vandps %xmm1, %xmm0, %xmm0
; AVX1-NEXT:    retq
;
; AVX512-LABEL: sqrt_v4f32_check_denorms_ninf:
; AVX512:       # %bb.0:
; AVX512-NEXT:    vrsqrtps %xmm0, %xmm1
; AVX512-NEXT:    vmulps %xmm1, %xmm0, %xmm2
; AVX512-NEXT:    vbroadcastss {{.*#+}} xmm3 = [-3.0E+0,-3.0E+0,-3.0E+0,-3.0E+0]
; AVX512-NEXT:    vfmadd231ps {{.*#+}} xmm3 = (xmm2 * xmm1) + xmm3
; AVX512-NEXT:    vbroadcastss {{.*#+}} xmm1 = [-5.0E-1,-5.0E-1,-5.0E-1,-5.0E-1]
; AVX512-NEXT:    vmulps %xmm1, %xmm2, %xmm1
; AVX512-NEXT:    vmulps %xmm3, %xmm1, %xmm1
; AVX512-NEXT:    vbroadcastss {{.*#+}} xmm2 = [NaN,NaN,NaN,NaN]
; AVX512-NEXT:    vandps %xmm2, %xmm0, %xmm0
; AVX512-NEXT:    vbroadcastss {{.*#+}} xmm2 = [1.17549435E-38,1.17549435E-38,1.17549435E-38,1.17549435E-38]
; AVX512-NEXT:    vcmpleps %xmm0, %xmm2, %xmm0
; AVX512-NEXT:    vandps %xmm1, %xmm0, %xmm0
; AVX512-NEXT:    retq
  %call = tail call ninf <4 x float> @llvm.sqrt.v4f32(<4 x float> %x) #2
  ret <4 x float> %call
}

define float @f32_no_estimate(float %x) #0 {
; SSE-LABEL: f32_no_estimate:
; SSE:       # %bb.0:
; SSE-NEXT:    sqrtss %xmm0, %xmm1
; SSE-NEXT:    movss {{.*#+}} xmm0 = mem[0],zero,zero,zero
; SSE-NEXT:    divss %xmm1, %xmm0
; SSE-NEXT:    retq
;
; AVX-LABEL: f32_no_estimate:
; AVX:       # %bb.0:
; AVX-NEXT:    vsqrtss %xmm0, %xmm0, %xmm0
; AVX-NEXT:    vmovss {{.*#+}} xmm1 = mem[0],zero,zero,zero
; AVX-NEXT:    vdivss %xmm0, %xmm1, %xmm0
; AVX-NEXT:    retq
  %sqrt = tail call float @llvm.sqrt.f32(float %x)
  %div = fdiv fast float 1.0, %sqrt
  ret float %div
}

define float @f32_estimate(float %x) #1 {
; SSE-LABEL: f32_estimate:
; SSE:       # %bb.0:
; SSE-NEXT:    rsqrtss %xmm0, %xmm1
; SSE-NEXT:    mulss %xmm1, %xmm0
; SSE-NEXT:    mulss %xmm1, %xmm0
; SSE-NEXT:    addss {{.*}}(%rip), %xmm0
; SSE-NEXT:    mulss {{.*}}(%rip), %xmm1
; SSE-NEXT:    mulss %xmm1, %xmm0
; SSE-NEXT:    retq
;
; AVX1-LABEL: f32_estimate:
; AVX1:       # %bb.0:
; AVX1-NEXT:    vrsqrtss %xmm0, %xmm0, %xmm1
; AVX1-NEXT:    vmulss %xmm1, %xmm0, %xmm0
; AVX1-NEXT:    vmulss %xmm1, %xmm0, %xmm0
; AVX1-NEXT:    vaddss {{.*}}(%rip), %xmm0, %xmm0
; AVX1-NEXT:    vmulss {{.*}}(%rip), %xmm1, %xmm1
; AVX1-NEXT:    vmulss %xmm0, %xmm1, %xmm0
; AVX1-NEXT:    retq
;
; AVX512-LABEL: f32_estimate:
; AVX512:       # %bb.0:
; AVX512-NEXT:    vrsqrtss %xmm0, %xmm0, %xmm1
; AVX512-NEXT:    vmulss %xmm1, %xmm0, %xmm0
; AVX512-NEXT:    vfmadd213ss {{.*#+}} xmm0 = (xmm1 * xmm0) + mem
; AVX512-NEXT:    vmulss {{.*}}(%rip), %xmm1, %xmm1
; AVX512-NEXT:    vmulss %xmm0, %xmm1, %xmm0
; AVX512-NEXT:    retq
  %sqrt = tail call float @llvm.sqrt.f32(float %x)
  %div = fdiv fast float 1.0, %sqrt
  ret float %div
}

define <4 x float> @v4f32_no_estimate(<4 x float> %x) #0 {
; SSE-LABEL: v4f32_no_estimate:
; SSE:       # %bb.0:
; SSE-NEXT:    sqrtps %xmm0, %xmm1
; SSE-NEXT:    movaps {{.*#+}} xmm0 = [1.0E+0,1.0E+0,1.0E+0,1.0E+0]
; SSE-NEXT:    divps %xmm1, %xmm0
; SSE-NEXT:    retq
;
; AVX1-LABEL: v4f32_no_estimate:
; AVX1:       # %bb.0:
; AVX1-NEXT:    vsqrtps %xmm0, %xmm0
; AVX1-NEXT:    vmovaps {{.*#+}} xmm1 = [1.0E+0,1.0E+0,1.0E+0,1.0E+0]
; AVX1-NEXT:    vdivps %xmm0, %xmm1, %xmm0
; AVX1-NEXT:    retq
;
; AVX512-LABEL: v4f32_no_estimate:
; AVX512:       # %bb.0:
; AVX512-NEXT:    vsqrtps %xmm0, %xmm0
; AVX512-NEXT:    vbroadcastss {{.*#+}} xmm1 = [1.0E+0,1.0E+0,1.0E+0,1.0E+0]
; AVX512-NEXT:    vdivps %xmm0, %xmm1, %xmm0
; AVX512-NEXT:    retq
  %sqrt = tail call <4 x float> @llvm.sqrt.v4f32(<4 x float> %x)
  %div = fdiv fast <4 x float> <float 1.0, float 1.0, float 1.0, float 1.0>, %sqrt
  ret <4 x float> %div
}

define <4 x float> @v4f32_estimate(<4 x float> %x) #1 {
; SSE-LABEL: v4f32_estimate:
; SSE:       # %bb.0:
; SSE-NEXT:    rsqrtps %xmm0, %xmm1
; SSE-NEXT:    mulps %xmm1, %xmm0
; SSE-NEXT:    mulps %xmm1, %xmm0
; SSE-NEXT:    addps {{.*}}(%rip), %xmm0
; SSE-NEXT:    mulps {{.*}}(%rip), %xmm1
; SSE-NEXT:    mulps %xmm1, %xmm0
; SSE-NEXT:    retq
;
; AVX1-LABEL: v4f32_estimate:
; AVX1:       # %bb.0:
; AVX1-NEXT:    vrsqrtps %xmm0, %xmm1
; AVX1-NEXT:    vmulps %xmm1, %xmm0, %xmm0
; AVX1-NEXT:    vmulps %xmm1, %xmm0, %xmm0
; AVX1-NEXT:    vaddps {{.*}}(%rip), %xmm0, %xmm0
; AVX1-NEXT:    vmulps {{.*}}(%rip), %xmm1, %xmm1
; AVX1-NEXT:    vmulps %xmm0, %xmm1, %xmm0
; AVX1-NEXT:    retq
;
; AVX512-LABEL: v4f32_estimate:
; AVX512:       # %bb.0:
; AVX512-NEXT:    vrsqrtps %xmm0, %xmm1
; AVX512-NEXT:    vmulps %xmm1, %xmm0, %xmm0
; AVX512-NEXT:    vbroadcastss {{.*#+}} xmm2 = [-3.0E+0,-3.0E+0,-3.0E+0,-3.0E+0]
; AVX512-NEXT:    vfmadd231ps {{.*#+}} xmm2 = (xmm1 * xmm0) + xmm2
; AVX512-NEXT:    vbroadcastss {{.*#+}} xmm0 = [-5.0E-1,-5.0E-1,-5.0E-1,-5.0E-1]
; AVX512-NEXT:    vmulps %xmm0, %xmm1, %xmm0
; AVX512-NEXT:    vmulps %xmm2, %xmm0, %xmm0
; AVX512-NEXT:    retq
  %sqrt = tail call <4 x float> @llvm.sqrt.v4f32(<4 x float> %x)
  %div = fdiv fast <4 x float> <float 1.0, float 1.0, float 1.0, float 1.0>, %sqrt
  ret <4 x float> %div
}

define <8 x float> @v8f32_no_estimate(<8 x float> %x) #0 {
; SSE-LABEL: v8f32_no_estimate:
; SSE:       # %bb.0:
; SSE-NEXT:    sqrtps %xmm1, %xmm2
; SSE-NEXT:    sqrtps %xmm0, %xmm3
; SSE-NEXT:    movaps {{.*#+}} xmm1 = [1.0E+0,1.0E+0,1.0E+0,1.0E+0]
; SSE-NEXT:    movaps %xmm1, %xmm0
; SSE-NEXT:    divps %xmm3, %xmm0
; SSE-NEXT:    divps %xmm2, %xmm1
; SSE-NEXT:    retq
;
; AVX1-LABEL: v8f32_no_estimate:
; AVX1:       # %bb.0:
; AVX1-NEXT:    vsqrtps %ymm0, %ymm0
; AVX1-NEXT:    vmovaps {{.*#+}} ymm1 = [1.0E+0,1.0E+0,1.0E+0,1.0E+0,1.0E+0,1.0E+0,1.0E+0,1.0E+0]
; AVX1-NEXT:    vdivps %ymm0, %ymm1, %ymm0
; AVX1-NEXT:    retq
;
; AVX512-LABEL: v8f32_no_estimate:
; AVX512:       # %bb.0:
; AVX512-NEXT:    vsqrtps %ymm0, %ymm0
; AVX512-NEXT:    vbroadcastss {{.*#+}} ymm1 = [1.0E+0,1.0E+0,1.0E+0,1.0E+0,1.0E+0,1.0E+0,1.0E+0,1.0E+0]
; AVX512-NEXT:    vdivps %ymm0, %ymm1, %ymm0
; AVX512-NEXT:    retq
  %sqrt = tail call <8 x float> @llvm.sqrt.v8f32(<8 x float> %x)
  %div = fdiv fast <8 x float> <float 1.0, float 1.0, float 1.0, float 1.0, float 1.0, float 1.0, float 1.0, float 1.0>, %sqrt
  ret <8 x float> %div
}

define <8 x float> @v8f32_estimate(<8 x float> %x) #1 {
; SSE-LABEL: v8f32_estimate:
; SSE:       # %bb.0:
; SSE-NEXT:    rsqrtps %xmm0, %xmm2
; SSE-NEXT:    movaps {{.*#+}} xmm3 = [-5.0E-1,-5.0E-1,-5.0E-1,-5.0E-1]
; SSE-NEXT:    mulps %xmm2, %xmm0
; SSE-NEXT:    mulps %xmm2, %xmm0
; SSE-NEXT:    mulps %xmm3, %xmm2
; SSE-NEXT:    movaps {{.*#+}} xmm4 = [-3.0E+0,-3.0E+0,-3.0E+0,-3.0E+0]
; SSE-NEXT:    addps %xmm4, %xmm0
; SSE-NEXT:    mulps %xmm2, %xmm0
; SSE-NEXT:    rsqrtps %xmm1, %xmm2
; SSE-NEXT:    mulps %xmm2, %xmm3
; SSE-NEXT:    mulps %xmm2, %xmm1
; SSE-NEXT:    mulps %xmm2, %xmm1
; SSE-NEXT:    addps %xmm4, %xmm1
; SSE-NEXT:    mulps %xmm3, %xmm1
; SSE-NEXT:    retq
;
; AVX1-LABEL: v8f32_estimate:
; AVX1:       # %bb.0:
; AVX1-NEXT:    vrsqrtps %ymm0, %ymm1
; AVX1-NEXT:    vmulps %ymm1, %ymm0, %ymm0
; AVX1-NEXT:    vmulps %ymm1, %ymm0, %ymm0
; AVX1-NEXT:    vaddps {{.*}}(%rip), %ymm0, %ymm0
; AVX1-NEXT:    vmulps {{.*}}(%rip), %ymm1, %ymm1
; AVX1-NEXT:    vmulps %ymm0, %ymm1, %ymm0
; AVX1-NEXT:    retq
;
; AVX512-LABEL: v8f32_estimate:
; AVX512:       # %bb.0:
; AVX512-NEXT:    vrsqrtps %ymm0, %ymm1
; AVX512-NEXT:    vmulps %ymm1, %ymm0, %ymm0
; AVX512-NEXT:    vbroadcastss {{.*#+}} ymm2 = [-3.0E+0,-3.0E+0,-3.0E+0,-3.0E+0,-3.0E+0,-3.0E+0,-3.0E+0,-3.0E+0]
; AVX512-NEXT:    vfmadd231ps {{.*#+}} ymm2 = (ymm1 * ymm0) + ymm2
; AVX512-NEXT:    vbroadcastss {{.*#+}} ymm0 = [-5.0E-1,-5.0E-1,-5.0E-1,-5.0E-1,-5.0E-1,-5.0E-1,-5.0E-1,-5.0E-1]
; AVX512-NEXT:    vmulps %ymm0, %ymm1, %ymm0
; AVX512-NEXT:    vmulps %ymm2, %ymm0, %ymm0
; AVX512-NEXT:    retq
  %sqrt = tail call <8 x float> @llvm.sqrt.v8f32(<8 x float> %x)
  %div = fdiv fast <8 x float> <float 1.0, float 1.0, float 1.0, float 1.0, float 1.0, float 1.0, float 1.0, float 1.0>, %sqrt
  ret <8 x float> %div
}

define <16 x float> @v16f32_no_estimate(<16 x float> %x) #0 {
; SSE-LABEL: v16f32_no_estimate:
; SSE:       # %bb.0:
; SSE-NEXT:    sqrtps %xmm3, %xmm4
; SSE-NEXT:    sqrtps %xmm2, %xmm5
; SSE-NEXT:    sqrtps %xmm1, %xmm2
; SSE-NEXT:    sqrtps %xmm0, %xmm1
; SSE-NEXT:    movaps {{.*#+}} xmm3 = [1.0E+0,1.0E+0,1.0E+0,1.0E+0]
; SSE-NEXT:    movaps %xmm3, %xmm0
; SSE-NEXT:    divps %xmm1, %xmm0
; SSE-NEXT:    movaps %xmm3, %xmm1
; SSE-NEXT:    divps %xmm2, %xmm1
; SSE-NEXT:    movaps %xmm3, %xmm2
; SSE-NEXT:    divps %xmm5, %xmm2
; SSE-NEXT:    divps %xmm4, %xmm3
; SSE-NEXT:    retq
;
; AVX1-LABEL: v16f32_no_estimate:
; AVX1:       # %bb.0:
; AVX1-NEXT:    vsqrtps %ymm1, %ymm1
; AVX1-NEXT:    vsqrtps %ymm0, %ymm0
; AVX1-NEXT:    vmovaps {{.*#+}} ymm2 = [1.0E+0,1.0E+0,1.0E+0,1.0E+0,1.0E+0,1.0E+0,1.0E+0,1.0E+0]
; AVX1-NEXT:    vdivps %ymm0, %ymm2, %ymm0
; AVX1-NEXT:    vdivps %ymm1, %ymm2, %ymm1
; AVX1-NEXT:    retq
;
; AVX512-LABEL: v16f32_no_estimate:
; AVX512:       # %bb.0:
; AVX512-NEXT:    vsqrtps %zmm0, %zmm0
; AVX512-NEXT:    vbroadcastss {{.*#+}} zmm1 = [1.0E+0,1.0E+0,1.0E+0,1.0E+0,1.0E+0,1.0E+0,1.0E+0,1.0E+0,1.0E+0,1.0E+0,1.0E+0,1.0E+0,1.0E+0,1.0E+0,1.0E+0,1.0E+0]
; AVX512-NEXT:    vdivps %zmm0, %zmm1, %zmm0
; AVX512-NEXT:    retq
  %sqrt = tail call <16 x float> @llvm.sqrt.v16f32(<16 x float> %x)
  %div = fdiv fast <16 x float> <float 1.0, float 1.0, float 1.0, float 1.0, float 1.0, float 1.0, float 1.0, float 1.0, float 1.0, float 1.0, float 1.0, float 1.0, float 1.0, float 1.0, float 1.0, float 1.0>, %sqrt
  ret <16 x float> %div
}

define <16 x float> @v16f32_estimate(<16 x float> %x) #1 {
; SSE-LABEL: v16f32_estimate:
; SSE:       # %bb.0:
; SSE-NEXT:    rsqrtps %xmm0, %xmm5
; SSE-NEXT:    movaps {{.*#+}} xmm4 = [-5.0E-1,-5.0E-1,-5.0E-1,-5.0E-1]
; SSE-NEXT:    mulps %xmm5, %xmm0
; SSE-NEXT:    mulps %xmm5, %xmm0
; SSE-NEXT:    movaps %xmm5, %xmm6
; SSE-NEXT:    mulps %xmm4, %xmm6
; SSE-NEXT:    movaps {{.*#+}} xmm5 = [-3.0E+0,-3.0E+0,-3.0E+0,-3.0E+0]
; SSE-NEXT:    addps %xmm5, %xmm0
; SSE-NEXT:    mulps %xmm6, %xmm0
; SSE-NEXT:    rsqrtps %xmm1, %xmm6
; SSE-NEXT:    mulps %xmm6, %xmm1
; SSE-NEXT:    mulps %xmm6, %xmm1
; SSE-NEXT:    mulps %xmm4, %xmm6
; SSE-NEXT:    addps %xmm5, %xmm1
; SSE-NEXT:    mulps %xmm6, %xmm1
; SSE-NEXT:    rsqrtps %xmm2, %xmm6
; SSE-NEXT:    mulps %xmm6, %xmm2
; SSE-NEXT:    mulps %xmm6, %xmm2
; SSE-NEXT:    mulps %xmm4, %xmm6
; SSE-NEXT:    addps %xmm5, %xmm2
; SSE-NEXT:    mulps %xmm6, %xmm2
; SSE-NEXT:    rsqrtps %xmm3, %xmm6
; SSE-NEXT:    mulps %xmm6, %xmm4
; SSE-NEXT:    mulps %xmm6, %xmm3
; SSE-NEXT:    mulps %xmm6, %xmm3
; SSE-NEXT:    addps %xmm5, %xmm3
; SSE-NEXT:    mulps %xmm4, %xmm3
; SSE-NEXT:    retq
;
; AVX1-LABEL: v16f32_estimate:
; AVX1:       # %bb.0:
; AVX1-NEXT:    vrsqrtps %ymm0, %ymm2
; AVX1-NEXT:    vmovaps {{.*#+}} ymm3 = [-5.0E-1,-5.0E-1,-5.0E-1,-5.0E-1,-5.0E-1,-5.0E-1,-5.0E-1,-5.0E-1]
; AVX1-NEXT:    vmulps %ymm3, %ymm2, %ymm4
; AVX1-NEXT:    vmulps %ymm2, %ymm0, %ymm0
; AVX1-NEXT:    vmulps %ymm2, %ymm0, %ymm0
; AVX1-NEXT:    vmovaps {{.*#+}} ymm2 = [-3.0E+0,-3.0E+0,-3.0E+0,-3.0E+0,-3.0E+0,-3.0E+0,-3.0E+0,-3.0E+0]
; AVX1-NEXT:    vaddps %ymm2, %ymm0, %ymm0
; AVX1-NEXT:    vmulps %ymm0, %ymm4, %ymm0
; AVX1-NEXT:    vrsqrtps %ymm1, %ymm4
; AVX1-NEXT:    vmulps %ymm3, %ymm4, %ymm3
; AVX1-NEXT:    vmulps %ymm4, %ymm1, %ymm1
; AVX1-NEXT:    vmulps %ymm4, %ymm1, %ymm1
; AVX1-NEXT:    vaddps %ymm2, %ymm1, %ymm1
; AVX1-NEXT:    vmulps %ymm1, %ymm3, %ymm1
; AVX1-NEXT:    retq
;
; AVX512-LABEL: v16f32_estimate:
; AVX512:       # %bb.0:
; AVX512-NEXT:    vrsqrt14ps %zmm0, %zmm1
; AVX512-NEXT:    vmulps %zmm1, %zmm0, %zmm0
; AVX512-NEXT:    vfmadd213ps {{.*#+}} zmm0 = (zmm1 * zmm0) + mem
; AVX512-NEXT:    vmulps {{.*}}(%rip){1to16}, %zmm1, %zmm1
; AVX512-NEXT:    vmulps %zmm0, %zmm1, %zmm0
; AVX512-NEXT:    retq
  %sqrt = tail call <16 x float> @llvm.sqrt.v16f32(<16 x float> %x)
  %div = fdiv fast <16 x float> <float 1.0, float 1.0, float 1.0, float 1.0, float 1.0, float 1.0, float 1.0, float 1.0, float 1.0, float 1.0, float 1.0, float 1.0, float 1.0, float 1.0, float 1.0, float 1.0>, %sqrt
  ret <16 x float> %div
}

; x / (fabs(y) * sqrt(z)) --> x * rsqrt(y*y*z)

define float @div_sqrt_fabs_f32(float %x, float %y, float %z) {
; SSE-LABEL: div_sqrt_fabs_f32:
; SSE:       # %bb.0:
; SSE-NEXT:    mulss %xmm1, %xmm1
; SSE-NEXT:    mulss %xmm2, %xmm1
; SSE-NEXT:    xorps %xmm2, %xmm2
; SSE-NEXT:    rsqrtss %xmm1, %xmm2
; SSE-NEXT:    mulss %xmm2, %xmm1
; SSE-NEXT:    mulss %xmm2, %xmm1
; SSE-NEXT:    addss {{.*}}(%rip), %xmm1
; SSE-NEXT:    mulss {{.*}}(%rip), %xmm2
; SSE-NEXT:    mulss %xmm0, %xmm2
; SSE-NEXT:    mulss %xmm1, %xmm2
; SSE-NEXT:    movaps %xmm2, %xmm0
; SSE-NEXT:    retq
;
; AVX1-LABEL: div_sqrt_fabs_f32:
; AVX1:       # %bb.0:
; AVX1-NEXT:    vmulss %xmm1, %xmm1, %xmm1
; AVX1-NEXT:    vmulss %xmm2, %xmm1, %xmm1
; AVX1-NEXT:    vrsqrtss %xmm1, %xmm1, %xmm2
; AVX1-NEXT:    vmulss %xmm2, %xmm1, %xmm1
; AVX1-NEXT:    vmulss %xmm2, %xmm1, %xmm1
; AVX1-NEXT:    vaddss {{.*}}(%rip), %xmm1, %xmm1
; AVX1-NEXT:    vmulss {{.*}}(%rip), %xmm2, %xmm2
; AVX1-NEXT:    vmulss %xmm0, %xmm2, %xmm0
; AVX1-NEXT:    vmulss %xmm0, %xmm1, %xmm0
; AVX1-NEXT:    retq
;
; AVX512-LABEL: div_sqrt_fabs_f32:
; AVX512:       # %bb.0:
; AVX512-NEXT:    vmulss %xmm1, %xmm1, %xmm1
; AVX512-NEXT:    vmulss %xmm2, %xmm1, %xmm1
; AVX512-NEXT:    vrsqrtss %xmm1, %xmm1, %xmm2
; AVX512-NEXT:    vmulss %xmm2, %xmm1, %xmm1
; AVX512-NEXT:    vfmadd213ss {{.*#+}} xmm1 = (xmm2 * xmm1) + mem
; AVX512-NEXT:    vmulss {{.*}}(%rip), %xmm2, %xmm2
; AVX512-NEXT:    vmulss %xmm0, %xmm2, %xmm0
; AVX512-NEXT:    vmulss %xmm0, %xmm1, %xmm0
; AVX512-NEXT:    retq
  %s = call fast float @llvm.sqrt.f32(float %z)
  %a = call fast float @llvm.fabs.f32(float %y)
  %m = fmul fast float %s, %a
  %d = fdiv fast float %x, %m
  ret float %d
}

; x / (fabs(y) * sqrt(z)) --> x * rsqrt(y*y*z)

define <4 x float> @div_sqrt_fabs_v4f32(<4 x float> %x, <4 x float> %y, <4 x float> %z) {
; SSE-LABEL: div_sqrt_fabs_v4f32:
; SSE:       # %bb.0:
; SSE-NEXT:    mulps %xmm1, %xmm1
; SSE-NEXT:    mulps %xmm2, %xmm1
; SSE-NEXT:    rsqrtps %xmm1, %xmm2
; SSE-NEXT:    mulps %xmm2, %xmm1
; SSE-NEXT:    mulps %xmm2, %xmm1
; SSE-NEXT:    addps {{.*}}(%rip), %xmm1
; SSE-NEXT:    mulps {{.*}}(%rip), %xmm2
; SSE-NEXT:    mulps %xmm1, %xmm2
; SSE-NEXT:    mulps %xmm2, %xmm0
; SSE-NEXT:    retq
;
; AVX1-LABEL: div_sqrt_fabs_v4f32:
; AVX1:       # %bb.0:
; AVX1-NEXT:    vmulps %xmm1, %xmm1, %xmm1
; AVX1-NEXT:    vmulps %xmm2, %xmm1, %xmm1
; AVX1-NEXT:    vrsqrtps %xmm1, %xmm2
; AVX1-NEXT:    vmulps %xmm2, %xmm1, %xmm1
; AVX1-NEXT:    vmulps %xmm2, %xmm1, %xmm1
; AVX1-NEXT:    vaddps {{.*}}(%rip), %xmm1, %xmm1
; AVX1-NEXT:    vmulps {{.*}}(%rip), %xmm2, %xmm2
; AVX1-NEXT:    vmulps %xmm1, %xmm2, %xmm1
; AVX1-NEXT:    vmulps %xmm1, %xmm0, %xmm0
; AVX1-NEXT:    retq
;
; AVX512-LABEL: div_sqrt_fabs_v4f32:
; AVX512:       # %bb.0:
; AVX512-NEXT:    vmulps %xmm1, %xmm1, %xmm1
; AVX512-NEXT:    vmulps %xmm2, %xmm1, %xmm1
; AVX512-NEXT:    vrsqrtps %xmm1, %xmm2
; AVX512-NEXT:    vmulps %xmm2, %xmm1, %xmm1
; AVX512-NEXT:    vbroadcastss {{.*#+}} xmm3 = [-3.0E+0,-3.0E+0,-3.0E+0,-3.0E+0]
; AVX512-NEXT:    vfmadd231ps {{.*#+}} xmm3 = (xmm2 * xmm1) + xmm3
; AVX512-NEXT:    vbroadcastss {{.*#+}} xmm1 = [-5.0E-1,-5.0E-1,-5.0E-1,-5.0E-1]
; AVX512-NEXT:    vmulps %xmm1, %xmm2, %xmm1
; AVX512-NEXT:    vmulps %xmm3, %xmm1, %xmm1
; AVX512-NEXT:    vmulps %xmm1, %xmm0, %xmm0
; AVX512-NEXT:    retq
  %s = call <4 x float> @llvm.sqrt.v4f32(<4 x float> %z)
  %a = call <4 x float> @llvm.fabs.v4f32(<4 x float> %y)
  %m = fmul reassoc <4 x float> %a, %s
  %d = fdiv reassoc arcp <4 x float> %x, %m
  ret <4 x float> %d
}

; This has 'arcp' but does not have 'reassoc' FMF.
; We allow converting the sqrt to an estimate, but
; do not pull the divisor into the estimate.
; x / (fabs(y) * sqrt(z)) --> x * rsqrt(z) / fabs(y)

define <4 x float> @div_sqrt_fabs_v4f32_fmf(<4 x float> %x, <4 x float> %y, <4 x float> %z) {
; SSE-LABEL: div_sqrt_fabs_v4f32_fmf:
; SSE:       # %bb.0:
; SSE-NEXT:    rsqrtps %xmm2, %xmm3
; SSE-NEXT:    mulps %xmm3, %xmm2
; SSE-NEXT:    mulps %xmm3, %xmm2
; SSE-NEXT:    addps {{.*}}(%rip), %xmm2
; SSE-NEXT:    mulps {{.*}}(%rip), %xmm3
; SSE-NEXT:    mulps %xmm2, %xmm3
; SSE-NEXT:    andps {{.*}}(%rip), %xmm1
; SSE-NEXT:    divps %xmm1, %xmm3
; SSE-NEXT:    mulps %xmm3, %xmm0
; SSE-NEXT:    retq
;
; AVX1-LABEL: div_sqrt_fabs_v4f32_fmf:
; AVX1:       # %bb.0:
; AVX1-NEXT:    vrsqrtps %xmm2, %xmm3
; AVX1-NEXT:    vmulps %xmm3, %xmm2, %xmm2
; AVX1-NEXT:    vmulps %xmm3, %xmm2, %xmm2
; AVX1-NEXT:    vaddps {{.*}}(%rip), %xmm2, %xmm2
; AVX1-NEXT:    vmulps {{.*}}(%rip), %xmm3, %xmm3
; AVX1-NEXT:    vmulps %xmm2, %xmm3, %xmm2
; AVX1-NEXT:    vandps {{.*}}(%rip), %xmm1, %xmm1
; AVX1-NEXT:    vdivps %xmm1, %xmm2, %xmm1
; AVX1-NEXT:    vmulps %xmm1, %xmm0, %xmm0
; AVX1-NEXT:    retq
;
; AVX512-LABEL: div_sqrt_fabs_v4f32_fmf:
; AVX512:       # %bb.0:
; AVX512-NEXT:    vrsqrtps %xmm2, %xmm3
; AVX512-NEXT:    vbroadcastss {{.*#+}} xmm4 = [-5.0E-1,-5.0E-1,-5.0E-1,-5.0E-1]
; AVX512-NEXT:    vmulps %xmm4, %xmm3, %xmm4
; AVX512-NEXT:    vmulps %xmm3, %xmm2, %xmm2
; AVX512-NEXT:    vmulps %xmm3, %xmm2, %xmm2
; AVX512-NEXT:    vbroadcastss {{.*#+}} xmm3 = [-3.0E+0,-3.0E+0,-3.0E+0,-3.0E+0]
; AVX512-NEXT:    vaddps %xmm3, %xmm2, %xmm2
; AVX512-NEXT:    vbroadcastss {{.*#+}} xmm3 = [NaN,NaN,NaN,NaN]
; AVX512-NEXT:    vmulps %xmm2, %xmm4, %xmm2
; AVX512-NEXT:    vandps %xmm3, %xmm1, %xmm1
; AVX512-NEXT:    vdivps %xmm1, %xmm2, %xmm1
; AVX512-NEXT:    vmulps %xmm1, %xmm0, %xmm0
; AVX512-NEXT:    retq
  %s = call <4 x float> @llvm.sqrt.v4f32(<4 x float> %z)
  %a = call <4 x float> @llvm.fabs.v4f32(<4 x float> %y)
  %m = fmul <4 x float> %a, %s
  %d = fdiv arcp <4 x float> %x, %m
  ret <4 x float> %d
}

; No estimates for f64, so do not convert fabs into an fmul.

define double @div_sqrt_fabs_f64(double %x, double %y, double %z) {
; SSE-LABEL: div_sqrt_fabs_f64:
; SSE:       # %bb.0:
; SSE-NEXT:    sqrtsd %xmm2, %xmm2
; SSE-NEXT:    andpd {{.*}}(%rip), %xmm1
; SSE-NEXT:    mulsd %xmm2, %xmm1
; SSE-NEXT:    divsd %xmm1, %xmm0
; SSE-NEXT:    retq
;
; AVX-LABEL: div_sqrt_fabs_f64:
; AVX:       # %bb.0:
; AVX-NEXT:    vsqrtsd %xmm2, %xmm2, %xmm2
; AVX-NEXT:    vandpd {{.*}}(%rip), %xmm1, %xmm1
; AVX-NEXT:    vmulsd %xmm1, %xmm2, %xmm1
; AVX-NEXT:    vdivsd %xmm1, %xmm0, %xmm0
; AVX-NEXT:    retq
  %s = call fast double @llvm.sqrt.f64(double %z)
  %a = call fast double @llvm.fabs.f64(double %y)
  %m = fmul fast double %s, %a
  %d = fdiv fast double %x, %m
  ret double %d
}

; This is a special case for the general pattern above -
; if the sqrt operand is the same as the other mul op,
; then fabs may be omitted.
; x / (y * sqrt(y)) --> x * rsqrt(y*y*y)

define float @div_sqrt_f32(float %x, float %y) {
; SSE-LABEL: div_sqrt_f32:
; SSE:       # %bb.0:
; SSE-NEXT:    movaps %xmm1, %xmm2
; SSE-NEXT:    mulss %xmm1, %xmm2
; SSE-NEXT:    mulss %xmm1, %xmm2
; SSE-NEXT:    xorps %xmm1, %xmm1
; SSE-NEXT:    rsqrtss %xmm2, %xmm1
; SSE-NEXT:    mulss %xmm1, %xmm2
; SSE-NEXT:    mulss %xmm1, %xmm2
; SSE-NEXT:    addss {{.*}}(%rip), %xmm2
; SSE-NEXT:    mulss {{.*}}(%rip), %xmm1
; SSE-NEXT:    mulss %xmm0, %xmm1
; SSE-NEXT:    mulss %xmm2, %xmm1
; SSE-NEXT:    movaps %xmm1, %xmm0
; SSE-NEXT:    retq
;
; AVX1-LABEL: div_sqrt_f32:
; AVX1:       # %bb.0:
; AVX1-NEXT:    vmulss %xmm1, %xmm1, %xmm2
; AVX1-NEXT:    vmulss %xmm1, %xmm2, %xmm1
; AVX1-NEXT:    vrsqrtss %xmm1, %xmm1, %xmm2
; AVX1-NEXT:    vmulss %xmm2, %xmm1, %xmm1
; AVX1-NEXT:    vmulss %xmm2, %xmm1, %xmm1
; AVX1-NEXT:    vaddss {{.*}}(%rip), %xmm1, %xmm1
; AVX1-NEXT:    vmulss {{.*}}(%rip), %xmm2, %xmm2
; AVX1-NEXT:    vmulss %xmm0, %xmm2, %xmm0
; AVX1-NEXT:    vmulss %xmm0, %xmm1, %xmm0
; AVX1-NEXT:    retq
;
; AVX512-LABEL: div_sqrt_f32:
; AVX512:       # %bb.0:
; AVX512-NEXT:    vmulss %xmm1, %xmm1, %xmm2
; AVX512-NEXT:    vmulss %xmm1, %xmm2, %xmm1
; AVX512-NEXT:    vrsqrtss %xmm1, %xmm1, %xmm2
; AVX512-NEXT:    vmulss %xmm2, %xmm1, %xmm1
; AVX512-NEXT:    vfmadd213ss {{.*#+}} xmm1 = (xmm2 * xmm1) + mem
; AVX512-NEXT:    vmulss {{.*}}(%rip), %xmm2, %xmm2
; AVX512-NEXT:    vmulss %xmm0, %xmm2, %xmm0
; AVX512-NEXT:    vmulss %xmm0, %xmm1, %xmm0
; AVX512-NEXT:    retq
  %s = call fast float @llvm.sqrt.f32(float %y)
  %m = fmul fast float %s, %y
  %d = fdiv fast float %x, %m
  ret float %d
}

; This is a special case for the general pattern above -
; if the sqrt operand is the same as the other mul op,
; then fabs may be omitted.
; x / (y * sqrt(y)) --> x * rsqrt(y*y*y)

define <4 x float> @div_sqrt_v4f32(<4 x float> %x, <4 x float> %y) {
; SSE-LABEL: div_sqrt_v4f32:
; SSE:       # %bb.0:
; SSE-NEXT:    movaps %xmm1, %xmm2
; SSE-NEXT:    mulps %xmm1, %xmm2
; SSE-NEXT:    mulps %xmm1, %xmm2
; SSE-NEXT:    rsqrtps %xmm2, %xmm1
; SSE-NEXT:    mulps %xmm1, %xmm2
; SSE-NEXT:    mulps %xmm1, %xmm2
; SSE-NEXT:    addps {{.*}}(%rip), %xmm2
; SSE-NEXT:    mulps {{.*}}(%rip), %xmm1
; SSE-NEXT:    mulps %xmm2, %xmm1
; SSE-NEXT:    mulps %xmm1, %xmm0
; SSE-NEXT:    retq
;
; AVX1-LABEL: div_sqrt_v4f32:
; AVX1:       # %bb.0:
; AVX1-NEXT:    vmulps %xmm1, %xmm1, %xmm2
; AVX1-NEXT:    vmulps %xmm1, %xmm2, %xmm1
; AVX1-NEXT:    vrsqrtps %xmm1, %xmm2
; AVX1-NEXT:    vmulps %xmm2, %xmm1, %xmm1
; AVX1-NEXT:    vmulps %xmm2, %xmm1, %xmm1
; AVX1-NEXT:    vaddps {{.*}}(%rip), %xmm1, %xmm1
; AVX1-NEXT:    vmulps {{.*}}(%rip), %xmm2, %xmm2
; AVX1-NEXT:    vmulps %xmm1, %xmm2, %xmm1
; AVX1-NEXT:    vmulps %xmm1, %xmm0, %xmm0
; AVX1-NEXT:    retq
;
; AVX512-LABEL: div_sqrt_v4f32:
; AVX512:       # %bb.0:
; AVX512-NEXT:    vmulps %xmm1, %xmm1, %xmm2
; AVX512-NEXT:    vmulps %xmm1, %xmm2, %xmm1
; AVX512-NEXT:    vrsqrtps %xmm1, %xmm2
; AVX512-NEXT:    vmulps %xmm2, %xmm1, %xmm1
; AVX512-NEXT:    vbroadcastss {{.*#+}} xmm3 = [-3.0E+0,-3.0E+0,-3.0E+0,-3.0E+0]
; AVX512-NEXT:    vfmadd231ps {{.*#+}} xmm3 = (xmm2 * xmm1) + xmm3
; AVX512-NEXT:    vbroadcastss {{.*#+}} xmm1 = [-5.0E-1,-5.0E-1,-5.0E-1,-5.0E-1]
; AVX512-NEXT:    vmulps %xmm1, %xmm2, %xmm1
; AVX512-NEXT:    vmulps %xmm3, %xmm1, %xmm1
; AVX512-NEXT:    vmulps %xmm1, %xmm0, %xmm0
; AVX512-NEXT:    retq
  %s = call <4 x float> @llvm.sqrt.v4f32(<4 x float> %y)
  %m = fmul reassoc <4 x float> %y, %s
  %d = fdiv reassoc arcp <4 x float> %x, %m
  ret <4 x float> %d
}

define double @sqrt_fdiv_common_operand(double %x) nounwind {
; SSE-LABEL: sqrt_fdiv_common_operand:
; SSE:       # %bb.0:
; SSE-NEXT:    sqrtsd %xmm0, %xmm1
; SSE-NEXT:    divsd %xmm1, %xmm0
; SSE-NEXT:    retq
;
; AVX-LABEL: sqrt_fdiv_common_operand:
; AVX:       # %bb.0:
; AVX-NEXT:    vsqrtsd %xmm0, %xmm0, %xmm1
; AVX-NEXT:    vdivsd %xmm1, %xmm0, %xmm0
; AVX-NEXT:    retq
  %sqrt = call fast double @llvm.sqrt.f64(double %x)
  %r = fdiv fast double %x, %sqrt
  ret double %r
}

define <2 x double> @sqrt_fdiv_common_operand_vec(<2 x double> %x) nounwind {
; SSE-LABEL: sqrt_fdiv_common_operand_vec:
; SSE:       # %bb.0:
; SSE-NEXT:    sqrtpd %xmm0, %xmm1
; SSE-NEXT:    divpd %xmm1, %xmm0
; SSE-NEXT:    retq
;
; AVX-LABEL: sqrt_fdiv_common_operand_vec:
; AVX:       # %bb.0:
; AVX-NEXT:    vsqrtpd %xmm0, %xmm1
; AVX-NEXT:    vdivpd %xmm1, %xmm0, %xmm0
; AVX-NEXT:    retq
  %sqrt = call <2 x double> @llvm.sqrt.v2f64(<2 x double> %x)
  %r = fdiv nsz arcp reassoc <2 x double> %x, %sqrt
  ret <2 x double> %r
}

define double @sqrt_fdiv_common_operand_extra_use(double %x, double* %p) nounwind {
; SSE-LABEL: sqrt_fdiv_common_operand_extra_use:
; SSE:       # %bb.0:
; SSE-NEXT:    sqrtsd %xmm0, %xmm1
; SSE-NEXT:    movsd %xmm1, (%rdi)
; SSE-NEXT:    divsd %xmm1, %xmm0
; SSE-NEXT:    retq
;
; AVX-LABEL: sqrt_fdiv_common_operand_extra_use:
; AVX:       # %bb.0:
; AVX-NEXT:    vsqrtsd %xmm0, %xmm0, %xmm1
; AVX-NEXT:    vmovsd %xmm1, (%rdi)
; AVX-NEXT:    vdivsd %xmm1, %xmm0, %xmm0
; AVX-NEXT:    retq
  %sqrt = call fast double @llvm.sqrt.f64(double %x)
  store double %sqrt, double* %p
  %r = fdiv fast double %x, %sqrt
  ret double %r
}

attributes #0 = { "unsafe-fp-math"="true" "reciprocal-estimates"="!sqrtf,!vec-sqrtf,!divf,!vec-divf" }
attributes #1 = { "unsafe-fp-math"="true" "reciprocal-estimates"="sqrt,vec-sqrt" }
attributes #2 = { nounwind readnone }
attributes #3 = { "unsafe-fp-math"="true" "reciprocal-estimates"="sqrt,vec-sqrt" "denormal-fp-math"="ieee" }
attributes #4 = { "unsafe-fp-math"="true" "reciprocal-estimates"="sqrt,vec-sqrt" "denormal-fp-math"="ieee,preserve-sign" }
