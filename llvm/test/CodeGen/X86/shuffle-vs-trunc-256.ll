; NOTE: Assertions have been autogenerated by utils/update_llc_test_checks.py
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=+avx | FileCheck %s --check-prefix=AVX --check-prefix=AVX1
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=+avx2 | FileCheck %s --check-prefix=AVX --check-prefix=AVX2
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=+avx512f | FileCheck %s --check-prefix=AVX512 --check-prefix=AVX512F
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=+avx512vl | FileCheck %s --check-prefix=AVX512 --check-prefix=AVX512VL
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=+avx512bw | FileCheck %s --check-prefix=AVX512 --check-prefix=AVX512BW
; RUN: llc < %s -mtriple=x86_64-unknown-unknown -mattr=+avx512bw,+avx512vl | FileCheck %s --check-prefix=AVX512 --check-prefix=AVX512BWVL

; PR31551
; Pairs of shufflevector:trunc functions with functional equivalence.
; Ideally, the shuffles should be lowered to code with the same quality as the truncates.

define void @shuffle_v32i8_to_v16i8(<32 x i8>* %L, <16 x i8>* %S) nounwind {
; AVX1-LABEL: shuffle_v32i8_to_v16i8:
; AVX1:       # BB#0:
; AVX1-NEXT:    vmovdqa (%rdi), %ymm0
; AVX1-NEXT:    vextractf128 $1, %ymm0, %xmm1
; AVX1-NEXT:    vmovdqa {{.*#+}} xmm2 = <0,2,4,6,8,10,12,14,u,u,u,u,u,u,u,u>
; AVX1-NEXT:    vpshufb %xmm2, %xmm1, %xmm1
; AVX1-NEXT:    vpshufb %xmm2, %xmm0, %xmm0
; AVX1-NEXT:    vpunpcklqdq {{.*#+}} xmm0 = xmm0[0],xmm1[0]
; AVX1-NEXT:    vmovdqa %xmm0, (%rsi)
; AVX1-NEXT:    vzeroupper
; AVX1-NEXT:    retq
;
; AVX2-LABEL: shuffle_v32i8_to_v16i8:
; AVX2:       # BB#0:
; AVX2-NEXT:    vmovdqa (%rdi), %ymm0
; AVX2-NEXT:    vextracti128 $1, %ymm0, %xmm1
; AVX2-NEXT:    vmovdqa {{.*#+}} xmm2 = <0,2,4,6,8,10,12,14,u,u,u,u,u,u,u,u>
; AVX2-NEXT:    vpshufb %xmm2, %xmm1, %xmm1
; AVX2-NEXT:    vpshufb %xmm2, %xmm0, %xmm0
; AVX2-NEXT:    vpunpcklqdq {{.*#+}} xmm0 = xmm0[0],xmm1[0]
; AVX2-NEXT:    vmovdqa %xmm0, (%rsi)
; AVX2-NEXT:    vzeroupper
; AVX2-NEXT:    retq
;
; AVX512F-LABEL: shuffle_v32i8_to_v16i8:
; AVX512F:       # BB#0:
; AVX512F-NEXT:    vpmovsxwd (%rdi), %zmm0
; AVX512F-NEXT:    vpmovdb %zmm0, %xmm0
; AVX512F-NEXT:    vmovdqa %xmm0, (%rsi)
; AVX512F-NEXT:    vzeroupper
; AVX512F-NEXT:    retq
;
; AVX512VL-LABEL: shuffle_v32i8_to_v16i8:
; AVX512VL:       # BB#0:
; AVX512VL-NEXT:    vpmovsxwd (%rdi), %zmm0
; AVX512VL-NEXT:    vpmovdb %zmm0, %xmm0
; AVX512VL-NEXT:    vmovdqa %xmm0, (%rsi)
; AVX512VL-NEXT:    vzeroupper
; AVX512VL-NEXT:    retq
;
; AVX512BW-LABEL: shuffle_v32i8_to_v16i8:
; AVX512BW:       # BB#0:
; AVX512BW-NEXT:    vmovdqa (%rdi), %ymm0
; AVX512BW-NEXT:    vpmovwb %zmm0, %ymm0
; AVX512BW-NEXT:    vmovdqa %xmm0, (%rsi)
; AVX512BW-NEXT:    vzeroupper
; AVX512BW-NEXT:    retq
;
; AVX512BWVL-LABEL: shuffle_v32i8_to_v16i8:
; AVX512BWVL:       # BB#0:
; AVX512BWVL-NEXT:    vmovdqa (%rdi), %ymm0
; AVX512BWVL-NEXT:    vpmovwb %ymm0, (%rsi)
; AVX512BWVL-NEXT:    vzeroupper
; AVX512BWVL-NEXT:    retq
  %vec = load <32 x i8>, <32 x i8>* %L
  %strided.vec = shufflevector <32 x i8> %vec, <32 x i8> undef, <16 x i32> <i32 0, i32 2, i32 4, i32 6, i32 8, i32 10, i32 12, i32 14, i32 16, i32 18, i32 20, i32 22, i32 24, i32 26, i32 28, i32 30>
  store <16 x i8> %strided.vec, <16 x i8>* %S
  ret void
}

define void @trunc_v16i16_to_v16i8(<32 x i8>* %L, <16 x i8>* %S) nounwind {
; AVX1-LABEL: trunc_v16i16_to_v16i8:
; AVX1:       # BB#0:
; AVX1-NEXT:    vmovdqa (%rdi), %ymm0
; AVX1-NEXT:    vextractf128 $1, %ymm0, %xmm1
; AVX1-NEXT:    vmovdqa {{.*#+}} xmm2 = <0,2,4,6,8,10,12,14,u,u,u,u,u,u,u,u>
; AVX1-NEXT:    vpshufb %xmm2, %xmm1, %xmm1
; AVX1-NEXT:    vpshufb %xmm2, %xmm0, %xmm0
; AVX1-NEXT:    vpunpcklqdq {{.*#+}} xmm0 = xmm0[0],xmm1[0]
; AVX1-NEXT:    vmovdqa %xmm0, (%rsi)
; AVX1-NEXT:    vzeroupper
; AVX1-NEXT:    retq
;
; AVX2-LABEL: trunc_v16i16_to_v16i8:
; AVX2:       # BB#0:
; AVX2-NEXT:    vmovdqa (%rdi), %ymm0
; AVX2-NEXT:    vextracti128 $1, %ymm0, %xmm1
; AVX2-NEXT:    vmovdqa {{.*#+}} xmm2 = <0,2,4,6,8,10,12,14,u,u,u,u,u,u,u,u>
; AVX2-NEXT:    vpshufb %xmm2, %xmm1, %xmm1
; AVX2-NEXT:    vpshufb %xmm2, %xmm0, %xmm0
; AVX2-NEXT:    vpunpcklqdq {{.*#+}} xmm0 = xmm0[0],xmm1[0]
; AVX2-NEXT:    vmovdqa %xmm0, (%rsi)
; AVX2-NEXT:    vzeroupper
; AVX2-NEXT:    retq
;
; AVX512F-LABEL: trunc_v16i16_to_v16i8:
; AVX512F:       # BB#0:
; AVX512F-NEXT:    vpmovsxwd (%rdi), %zmm0
; AVX512F-NEXT:    vpmovdb %zmm0, %xmm0
; AVX512F-NEXT:    vmovdqa %xmm0, (%rsi)
; AVX512F-NEXT:    vzeroupper
; AVX512F-NEXT:    retq
;
; AVX512VL-LABEL: trunc_v16i16_to_v16i8:
; AVX512VL:       # BB#0:
; AVX512VL-NEXT:    vpmovsxwd (%rdi), %zmm0
; AVX512VL-NEXT:    vpmovdb %zmm0, %xmm0
; AVX512VL-NEXT:    vmovdqa %xmm0, (%rsi)
; AVX512VL-NEXT:    vzeroupper
; AVX512VL-NEXT:    retq
;
; AVX512BW-LABEL: trunc_v16i16_to_v16i8:
; AVX512BW:       # BB#0:
; AVX512BW-NEXT:    vmovdqa (%rdi), %ymm0
; AVX512BW-NEXT:    vpmovwb %zmm0, %ymm0
; AVX512BW-NEXT:    vmovdqa %xmm0, (%rsi)
; AVX512BW-NEXT:    vzeroupper
; AVX512BW-NEXT:    retq
;
; AVX512BWVL-LABEL: trunc_v16i16_to_v16i8:
; AVX512BWVL:       # BB#0:
; AVX512BWVL-NEXT:    vmovdqa (%rdi), %ymm0
; AVX512BWVL-NEXT:    vpmovwb %ymm0, (%rsi)
; AVX512BWVL-NEXT:    vzeroupper
; AVX512BWVL-NEXT:    retq
  %vec = load <32 x i8>, <32 x i8>* %L
  %bc = bitcast <32 x i8> %vec to <16 x i16>
  %strided.vec = trunc <16 x i16> %bc to <16 x i8>
  store <16 x i8> %strided.vec, <16 x i8>* %S
  ret void
}

define void @shuffle_v16i16_to_v8i16(<16 x i16>* %L, <8 x i16>* %S) nounwind {
; AVX1-LABEL: shuffle_v16i16_to_v8i16:
; AVX1:       # BB#0:
; AVX1-NEXT:    vmovdqa (%rdi), %ymm0
; AVX1-NEXT:    vextractf128 $1, %ymm0, %xmm1
; AVX1-NEXT:    vmovdqa {{.*#+}} xmm2 = [0,1,4,5,8,9,12,13,8,9,12,13,12,13,14,15]
; AVX1-NEXT:    vpshufb %xmm2, %xmm1, %xmm1
; AVX1-NEXT:    vpshufb %xmm2, %xmm0, %xmm0
; AVX1-NEXT:    vpunpcklqdq {{.*#+}} xmm0 = xmm0[0],xmm1[0]
; AVX1-NEXT:    vmovdqa %xmm0, (%rsi)
; AVX1-NEXT:    vzeroupper
; AVX1-NEXT:    retq
;
; AVX2-LABEL: shuffle_v16i16_to_v8i16:
; AVX2:       # BB#0:
; AVX2-NEXT:    vmovdqa (%rdi), %ymm0
; AVX2-NEXT:    vpshufb {{.*#+}} ymm0 = ymm0[0,1,4,5,8,9,12,13,8,9,12,13,12,13,14,15,16,17,20,21,24,25,28,29,24,25,28,29,28,29,30,31]
; AVX2-NEXT:    vpermq {{.*#+}} ymm0 = ymm0[0,2,2,3]
; AVX2-NEXT:    vmovdqa %xmm0, (%rsi)
; AVX2-NEXT:    vzeroupper
; AVX2-NEXT:    retq
;
; AVX512F-LABEL: shuffle_v16i16_to_v8i16:
; AVX512F:       # BB#0:
; AVX512F-NEXT:    vmovdqa (%rdi), %ymm0
; AVX512F-NEXT:    vpmovdw %zmm0, %ymm0
; AVX512F-NEXT:    vmovdqa %xmm0, (%rsi)
; AVX512F-NEXT:    vzeroupper
; AVX512F-NEXT:    retq
;
; AVX512VL-LABEL: shuffle_v16i16_to_v8i16:
; AVX512VL:       # BB#0:
; AVX512VL-NEXT:    vmovdqa (%rdi), %ymm0
; AVX512VL-NEXT:    vpmovdw %ymm0, (%rsi)
; AVX512VL-NEXT:    vzeroupper
; AVX512VL-NEXT:    retq
;
; AVX512BW-LABEL: shuffle_v16i16_to_v8i16:
; AVX512BW:       # BB#0:
; AVX512BW-NEXT:    vmovdqa (%rdi), %ymm0
; AVX512BW-NEXT:    vpmovdw %zmm0, %ymm0
; AVX512BW-NEXT:    vmovdqa %xmm0, (%rsi)
; AVX512BW-NEXT:    vzeroupper
; AVX512BW-NEXT:    retq
;
; AVX512BWVL-LABEL: shuffle_v16i16_to_v8i16:
; AVX512BWVL:       # BB#0:
; AVX512BWVL-NEXT:    vmovdqa (%rdi), %ymm0
; AVX512BWVL-NEXT:    vpmovdw %ymm0, (%rsi)
; AVX512BWVL-NEXT:    vzeroupper
; AVX512BWVL-NEXT:    retq
  %vec = load <16 x i16>, <16 x i16>* %L
  %strided.vec = shufflevector <16 x i16> %vec, <16 x i16> undef, <8 x i32> <i32 0, i32 2, i32 4, i32 6, i32 8, i32 10, i32 12, i32 14>
  store <8 x i16> %strided.vec, <8 x i16>* %S
  ret void
}

define void @trunc_v8i32_to_v8i16(<16 x i16>* %L, <8 x i16>* %S) nounwind {
; AVX1-LABEL: trunc_v8i32_to_v8i16:
; AVX1:       # BB#0:
; AVX1-NEXT:    vmovdqa (%rdi), %ymm0
; AVX1-NEXT:    vextractf128 $1, %ymm0, %xmm1
; AVX1-NEXT:    vmovdqa {{.*#+}} xmm2 = [0,1,4,5,8,9,12,13,8,9,12,13,12,13,14,15]
; AVX1-NEXT:    vpshufb %xmm2, %xmm1, %xmm1
; AVX1-NEXT:    vpshufb %xmm2, %xmm0, %xmm0
; AVX1-NEXT:    vpunpcklqdq {{.*#+}} xmm0 = xmm0[0],xmm1[0]
; AVX1-NEXT:    vmovdqa %xmm0, (%rsi)
; AVX1-NEXT:    vzeroupper
; AVX1-NEXT:    retq
;
; AVX2-LABEL: trunc_v8i32_to_v8i16:
; AVX2:       # BB#0:
; AVX2-NEXT:    vmovdqa (%rdi), %ymm0
; AVX2-NEXT:    vpshufb {{.*#+}} ymm0 = ymm0[0,1,4,5,8,9,12,13,8,9,12,13,12,13,14,15,16,17,20,21,24,25,28,29,24,25,28,29,28,29,30,31]
; AVX2-NEXT:    vpermq {{.*#+}} ymm0 = ymm0[0,2,2,3]
; AVX2-NEXT:    vmovdqa %xmm0, (%rsi)
; AVX2-NEXT:    vzeroupper
; AVX2-NEXT:    retq
;
; AVX512F-LABEL: trunc_v8i32_to_v8i16:
; AVX512F:       # BB#0:
; AVX512F-NEXT:    vmovdqa (%rdi), %ymm0
; AVX512F-NEXT:    vpmovdw %zmm0, %ymm0
; AVX512F-NEXT:    vmovdqa %xmm0, (%rsi)
; AVX512F-NEXT:    vzeroupper
; AVX512F-NEXT:    retq
;
; AVX512VL-LABEL: trunc_v8i32_to_v8i16:
; AVX512VL:       # BB#0:
; AVX512VL-NEXT:    vmovdqa (%rdi), %ymm0
; AVX512VL-NEXT:    vpmovdw %ymm0, (%rsi)
; AVX512VL-NEXT:    vzeroupper
; AVX512VL-NEXT:    retq
;
; AVX512BW-LABEL: trunc_v8i32_to_v8i16:
; AVX512BW:       # BB#0:
; AVX512BW-NEXT:    vmovdqa (%rdi), %ymm0
; AVX512BW-NEXT:    vpmovdw %zmm0, %ymm0
; AVX512BW-NEXT:    vmovdqa %xmm0, (%rsi)
; AVX512BW-NEXT:    vzeroupper
; AVX512BW-NEXT:    retq
;
; AVX512BWVL-LABEL: trunc_v8i32_to_v8i16:
; AVX512BWVL:       # BB#0:
; AVX512BWVL-NEXT:    vmovdqa (%rdi), %ymm0
; AVX512BWVL-NEXT:    vpmovdw %ymm0, (%rsi)
; AVX512BWVL-NEXT:    vzeroupper
; AVX512BWVL-NEXT:    retq
  %vec = load <16 x i16>, <16 x i16>* %L
  %bc = bitcast <16 x i16> %vec to <8 x i32>
  %strided.vec = trunc <8 x i32> %bc to <8 x i16>
  store <8 x i16> %strided.vec, <8 x i16>* %S
  ret void
}

define void @shuffle_v8i32_to_v4i32(<8 x i32>* %L, <4 x i32>* %S) nounwind {
; AVX1-LABEL: shuffle_v8i32_to_v4i32:
; AVX1:       # BB#0:
; AVX1-NEXT:    vmovaps (%rdi), %ymm0
; AVX1-NEXT:    vextractf128 $1, %ymm0, %xmm1
; AVX1-NEXT:    vshufps {{.*#+}} xmm0 = xmm0[0,2],xmm1[0,2]
; AVX1-NEXT:    vmovaps %xmm0, (%rsi)
; AVX1-NEXT:    vzeroupper
; AVX1-NEXT:    retq
;
; AVX2-LABEL: shuffle_v8i32_to_v4i32:
; AVX2:       # BB#0:
; AVX2-NEXT:    vpermilps {{.*#+}} ymm0 = mem[0,2,2,3,4,6,6,7]
; AVX2-NEXT:    vpermpd {{.*#+}} ymm0 = ymm0[0,2,2,3]
; AVX2-NEXT:    vmovaps %xmm0, (%rsi)
; AVX2-NEXT:    vzeroupper
; AVX2-NEXT:    retq
;
; AVX512F-LABEL: shuffle_v8i32_to_v4i32:
; AVX512F:       # BB#0:
; AVX512F-NEXT:    vmovdqa (%rdi), %ymm0
; AVX512F-NEXT:    vpmovqd %zmm0, %ymm0
; AVX512F-NEXT:    vmovdqa %xmm0, (%rsi)
; AVX512F-NEXT:    vzeroupper
; AVX512F-NEXT:    retq
;
; AVX512VL-LABEL: shuffle_v8i32_to_v4i32:
; AVX512VL:       # BB#0:
; AVX512VL-NEXT:    vmovdqa (%rdi), %ymm0
; AVX512VL-NEXT:    vpmovqd %ymm0, (%rsi)
; AVX512VL-NEXT:    vzeroupper
; AVX512VL-NEXT:    retq
;
; AVX512BW-LABEL: shuffle_v8i32_to_v4i32:
; AVX512BW:       # BB#0:
; AVX512BW-NEXT:    vmovdqa (%rdi), %ymm0
; AVX512BW-NEXT:    vpmovqd %zmm0, %ymm0
; AVX512BW-NEXT:    vmovdqa %xmm0, (%rsi)
; AVX512BW-NEXT:    vzeroupper
; AVX512BW-NEXT:    retq
;
; AVX512BWVL-LABEL: shuffle_v8i32_to_v4i32:
; AVX512BWVL:       # BB#0:
; AVX512BWVL-NEXT:    vmovdqa (%rdi), %ymm0
; AVX512BWVL-NEXT:    vpmovqd %ymm0, (%rsi)
; AVX512BWVL-NEXT:    vzeroupper
; AVX512BWVL-NEXT:    retq
  %vec = load <8 x i32>, <8 x i32>* %L
  %strided.vec = shufflevector <8 x i32> %vec, <8 x i32> undef, <4 x i32> <i32 0, i32 2, i32 4, i32 6>
  store <4 x i32> %strided.vec, <4 x i32>* %S
  ret void
}

define void @trunc_v4i64_to_v4i32(<8 x i32>* %L, <4 x i32>* %S) nounwind {
; AVX1-LABEL: trunc_v4i64_to_v4i32:
; AVX1:       # BB#0:
; AVX1-NEXT:    vmovaps (%rdi), %ymm0
; AVX1-NEXT:    vextractf128 $1, %ymm0, %xmm1
; AVX1-NEXT:    vshufps {{.*#+}} xmm0 = xmm0[0,2],xmm1[0,2]
; AVX1-NEXT:    vmovaps %xmm0, (%rsi)
; AVX1-NEXT:    vzeroupper
; AVX1-NEXT:    retq
;
; AVX2-LABEL: trunc_v4i64_to_v4i32:
; AVX2:       # BB#0:
; AVX2-NEXT:    vpermilps {{.*#+}} ymm0 = mem[0,2,2,3,4,6,6,7]
; AVX2-NEXT:    vpermpd {{.*#+}} ymm0 = ymm0[0,2,2,3]
; AVX2-NEXT:    vmovaps %xmm0, (%rsi)
; AVX2-NEXT:    vzeroupper
; AVX2-NEXT:    retq
;
; AVX512F-LABEL: trunc_v4i64_to_v4i32:
; AVX512F:       # BB#0:
; AVX512F-NEXT:    vmovdqa (%rdi), %ymm0
; AVX512F-NEXT:    vpmovqd %zmm0, %ymm0
; AVX512F-NEXT:    vmovdqa %xmm0, (%rsi)
; AVX512F-NEXT:    vzeroupper
; AVX512F-NEXT:    retq
;
; AVX512VL-LABEL: trunc_v4i64_to_v4i32:
; AVX512VL:       # BB#0:
; AVX512VL-NEXT:    vmovdqa (%rdi), %ymm0
; AVX512VL-NEXT:    vpmovqd %ymm0, (%rsi)
; AVX512VL-NEXT:    vzeroupper
; AVX512VL-NEXT:    retq
;
; AVX512BW-LABEL: trunc_v4i64_to_v4i32:
; AVX512BW:       # BB#0:
; AVX512BW-NEXT:    vmovdqa (%rdi), %ymm0
; AVX512BW-NEXT:    vpmovqd %zmm0, %ymm0
; AVX512BW-NEXT:    vmovdqa %xmm0, (%rsi)
; AVX512BW-NEXT:    vzeroupper
; AVX512BW-NEXT:    retq
;
; AVX512BWVL-LABEL: trunc_v4i64_to_v4i32:
; AVX512BWVL:       # BB#0:
; AVX512BWVL-NEXT:    vmovdqa (%rdi), %ymm0
; AVX512BWVL-NEXT:    vpmovqd %ymm0, (%rsi)
; AVX512BWVL-NEXT:    vzeroupper
; AVX512BWVL-NEXT:    retq
  %vec = load <8 x i32>, <8 x i32>* %L
  %bc = bitcast <8 x i32> %vec to <4 x i64>
  %strided.vec = trunc <4 x i64> %bc to <4 x i32>
  store <4 x i32> %strided.vec, <4 x i32>* %S
  ret void
}

define void @shuffle_v32i8_to_v8i8(<32 x i8>* %L, <8 x i8>* %S) nounwind {
; AVX1-LABEL: shuffle_v32i8_to_v8i8:
; AVX1:       # BB#0:
; AVX1-NEXT:    vmovdqa (%rdi), %ymm0
; AVX1-NEXT:    vextractf128 $1, %ymm0, %xmm1
; AVX1-NEXT:    vmovdqa {{.*#+}} xmm2 = <0,4,8,12,u,u,u,u,u,u,u,u,u,u,u,u>
; AVX1-NEXT:    vpshufb %xmm2, %xmm1, %xmm1
; AVX1-NEXT:    vpshufb %xmm2, %xmm0, %xmm0
; AVX1-NEXT:    vpunpckldq {{.*#+}} xmm0 = xmm0[0],xmm1[0],xmm0[1],xmm1[1]
; AVX1-NEXT:    vmovq %xmm0, (%rsi)
; AVX1-NEXT:    vzeroupper
; AVX1-NEXT:    retq
;
; AVX2-LABEL: shuffle_v32i8_to_v8i8:
; AVX2:       # BB#0:
; AVX2-NEXT:    vmovdqa (%rdi), %ymm0
; AVX2-NEXT:    vpshufb {{.*#+}} ymm0 = ymm0[0,1,4,5,8,9,12,13,8,9,12,13,12,13,14,15,16,17,20,21,24,25,28,29,24,25,28,29,28,29,30,31]
; AVX2-NEXT:    vpermq {{.*#+}} ymm0 = ymm0[0,2,2,3]
; AVX2-NEXT:    vpshufb {{.*#+}} xmm0 = xmm0[0,2,4,6,8,10,12,14,u,u,u,u,u,u,u,u]
; AVX2-NEXT:    vmovq %xmm0, (%rsi)
; AVX2-NEXT:    vzeroupper
; AVX2-NEXT:    retq
;
; AVX512F-LABEL: shuffle_v32i8_to_v8i8:
; AVX512F:       # BB#0:
; AVX512F-NEXT:    vmovdqa (%rdi), %ymm0
; AVX512F-NEXT:    vpmovdw %zmm0, %ymm0
; AVX512F-NEXT:    vpshufb {{.*#+}} xmm0 = xmm0[0,2,4,6,8,10,12,14,u,u,u,u,u,u,u,u]
; AVX512F-NEXT:    vmovq %xmm0, (%rsi)
; AVX512F-NEXT:    vzeroupper
; AVX512F-NEXT:    retq
;
; AVX512VL-LABEL: shuffle_v32i8_to_v8i8:
; AVX512VL:       # BB#0:
; AVX512VL-NEXT:    vmovdqa (%rdi), %ymm0
; AVX512VL-NEXT:    vpmovdb %ymm0, (%rsi)
; AVX512VL-NEXT:    vzeroupper
; AVX512VL-NEXT:    retq
;
; AVX512BW-LABEL: shuffle_v32i8_to_v8i8:
; AVX512BW:       # BB#0:
; AVX512BW-NEXT:    vmovdqa (%rdi), %ymm0
; AVX512BW-NEXT:    vpmovdw %zmm0, %ymm0
; AVX512BW-NEXT:    vpshufb {{.*#+}} xmm0 = xmm0[0,2,4,6,8,10,12,14,u,u,u,u,u,u,u,u]
; AVX512BW-NEXT:    vmovq %xmm0, (%rsi)
; AVX512BW-NEXT:    vzeroupper
; AVX512BW-NEXT:    retq
;
; AVX512BWVL-LABEL: shuffle_v32i8_to_v8i8:
; AVX512BWVL:       # BB#0:
; AVX512BWVL-NEXT:    vmovdqa (%rdi), %ymm0
; AVX512BWVL-NEXT:    vpmovdb %ymm0, (%rsi)
; AVX512BWVL-NEXT:    vzeroupper
; AVX512BWVL-NEXT:    retq
  %vec = load <32 x i8>, <32 x i8>* %L
  %strided.vec = shufflevector <32 x i8> %vec, <32 x i8> undef, <8 x i32> <i32 0, i32 4, i32 8, i32 12, i32 16, i32 20, i32 24, i32 28>
  store <8 x i8> %strided.vec, <8 x i8>* %S
  ret void
}

define void @trunc_v8i32_to_v8i8(<32 x i8>* %L, <8 x i8>* %S) nounwind {
; AVX1-LABEL: trunc_v8i32_to_v8i8:
; AVX1:       # BB#0:
; AVX1-NEXT:    vmovdqa (%rdi), %ymm0
; AVX1-NEXT:    vextractf128 $1, %ymm0, %xmm1
; AVX1-NEXT:    vmovdqa {{.*#+}} xmm2 = <0,4,8,12,u,u,u,u,u,u,u,u,u,u,u,u>
; AVX1-NEXT:    vpshufb %xmm2, %xmm1, %xmm1
; AVX1-NEXT:    vpshufb %xmm2, %xmm0, %xmm0
; AVX1-NEXT:    vpunpckldq {{.*#+}} xmm0 = xmm0[0],xmm1[0],xmm0[1],xmm1[1]
; AVX1-NEXT:    vmovq %xmm0, (%rsi)
; AVX1-NEXT:    vzeroupper
; AVX1-NEXT:    retq
;
; AVX2-LABEL: trunc_v8i32_to_v8i8:
; AVX2:       # BB#0:
; AVX2-NEXT:    vmovdqa (%rdi), %ymm0
; AVX2-NEXT:    vpshufb {{.*#+}} ymm0 = ymm0[0,1,4,5,8,9,12,13,8,9,12,13,12,13,14,15,16,17,20,21,24,25,28,29,24,25,28,29,28,29,30,31]
; AVX2-NEXT:    vpermq {{.*#+}} ymm0 = ymm0[0,2,2,3]
; AVX2-NEXT:    vpshufb {{.*#+}} xmm0 = xmm0[0,2,4,6,8,10,12,14,u,u,u,u,u,u,u,u]
; AVX2-NEXT:    vmovq %xmm0, (%rsi)
; AVX2-NEXT:    vzeroupper
; AVX2-NEXT:    retq
;
; AVX512F-LABEL: trunc_v8i32_to_v8i8:
; AVX512F:       # BB#0:
; AVX512F-NEXT:    vmovdqa (%rdi), %ymm0
; AVX512F-NEXT:    vpmovdw %zmm0, %ymm0
; AVX512F-NEXT:    vpshufb {{.*#+}} xmm0 = xmm0[0,2,4,6,8,10,12,14,u,u,u,u,u,u,u,u]
; AVX512F-NEXT:    vmovq %xmm0, (%rsi)
; AVX512F-NEXT:    vzeroupper
; AVX512F-NEXT:    retq
;
; AVX512VL-LABEL: trunc_v8i32_to_v8i8:
; AVX512VL:       # BB#0:
; AVX512VL-NEXT:    vmovdqa (%rdi), %ymm0
; AVX512VL-NEXT:    vpmovdb %ymm0, (%rsi)
; AVX512VL-NEXT:    vzeroupper
; AVX512VL-NEXT:    retq
;
; AVX512BW-LABEL: trunc_v8i32_to_v8i8:
; AVX512BW:       # BB#0:
; AVX512BW-NEXT:    vmovdqa (%rdi), %ymm0
; AVX512BW-NEXT:    vpmovdw %zmm0, %ymm0
; AVX512BW-NEXT:    vpshufb {{.*#+}} xmm0 = xmm0[0,2,4,6,8,10,12,14,u,u,u,u,u,u,u,u]
; AVX512BW-NEXT:    vmovq %xmm0, (%rsi)
; AVX512BW-NEXT:    vzeroupper
; AVX512BW-NEXT:    retq
;
; AVX512BWVL-LABEL: trunc_v8i32_to_v8i8:
; AVX512BWVL:       # BB#0:
; AVX512BWVL-NEXT:    vmovdqa (%rdi), %ymm0
; AVX512BWVL-NEXT:    vpmovdb %ymm0, (%rsi)
; AVX512BWVL-NEXT:    vzeroupper
; AVX512BWVL-NEXT:    retq
  %vec = load <32 x i8>, <32 x i8>* %L
  %bc = bitcast <32 x i8> %vec to <8 x i32>
  %strided.vec = trunc <8 x i32> %bc to <8 x i8>
  store <8 x i8> %strided.vec, <8 x i8>* %S
  ret void
}

define void @shuffle_v16i16_to_v4i16(<16 x i16>* %L, <4 x i16>* %S) nounwind {
; AVX1-LABEL: shuffle_v16i16_to_v4i16:
; AVX1:       # BB#0:
; AVX1-NEXT:    vmovaps (%rdi), %ymm0
; AVX1-NEXT:    vextractf128 $1, %ymm0, %xmm1
; AVX1-NEXT:    vshufps {{.*#+}} xmm0 = xmm0[0,2],xmm1[0,2]
; AVX1-NEXT:    vpshufb {{.*#+}} xmm0 = xmm0[0,1,4,5,8,9,12,13,8,9,12,13,12,13,14,15]
; AVX1-NEXT:    vmovq %xmm0, (%rsi)
; AVX1-NEXT:    vzeroupper
; AVX1-NEXT:    retq
;
; AVX2-LABEL: shuffle_v16i16_to_v4i16:
; AVX2:       # BB#0:
; AVX2-NEXT:    vpshufd {{.*#+}} ymm0 = mem[0,2,2,3,4,6,6,7]
; AVX2-NEXT:    vpermq {{.*#+}} ymm0 = ymm0[0,2,2,3]
; AVX2-NEXT:    vpshufb {{.*#+}} xmm0 = xmm0[0,1,4,5,8,9,12,13,8,9,12,13,12,13,14,15]
; AVX2-NEXT:    vmovq %xmm0, (%rsi)
; AVX2-NEXT:    vzeroupper
; AVX2-NEXT:    retq
;
; AVX512F-LABEL: shuffle_v16i16_to_v4i16:
; AVX512F:       # BB#0:
; AVX512F-NEXT:    vmovdqa (%rdi), %ymm0
; AVX512F-NEXT:    vpmovqd %zmm0, %ymm0
; AVX512F-NEXT:    vpshufb {{.*#+}} xmm0 = xmm0[0,1,4,5,8,9,12,13,8,9,12,13,12,13,14,15]
; AVX512F-NEXT:    vmovq %xmm0, (%rsi)
; AVX512F-NEXT:    vzeroupper
; AVX512F-NEXT:    retq
;
; AVX512VL-LABEL: shuffle_v16i16_to_v4i16:
; AVX512VL:       # BB#0:
; AVX512VL-NEXT:    vmovdqa (%rdi), %ymm0
; AVX512VL-NEXT:    vpmovqw %ymm0, (%rsi)
; AVX512VL-NEXT:    vzeroupper
; AVX512VL-NEXT:    retq
;
; AVX512BW-LABEL: shuffle_v16i16_to_v4i16:
; AVX512BW:       # BB#0:
; AVX512BW-NEXT:    vmovdqa (%rdi), %ymm0
; AVX512BW-NEXT:    vpmovqd %zmm0, %ymm0
; AVX512BW-NEXT:    vpshufb {{.*#+}} xmm0 = xmm0[0,1,4,5,8,9,12,13,8,9,12,13,12,13,14,15]
; AVX512BW-NEXT:    vmovq %xmm0, (%rsi)
; AVX512BW-NEXT:    vzeroupper
; AVX512BW-NEXT:    retq
;
; AVX512BWVL-LABEL: shuffle_v16i16_to_v4i16:
; AVX512BWVL:       # BB#0:
; AVX512BWVL-NEXT:    vmovdqa (%rdi), %ymm0
; AVX512BWVL-NEXT:    vpmovqw %ymm0, (%rsi)
; AVX512BWVL-NEXT:    vzeroupper
; AVX512BWVL-NEXT:    retq
  %vec = load <16 x i16>, <16 x i16>* %L
  %strided.vec = shufflevector <16 x i16> %vec, <16 x i16> undef, <4 x i32> <i32 0, i32 4, i32 8, i32 12>
  store <4 x i16> %strided.vec, <4 x i16>* %S
  ret void
}

define void @trunc_v4i64_to_v4i16(<16 x i16>* %L, <4 x i16>* %S) nounwind {
; AVX1-LABEL: trunc_v4i64_to_v4i16:
; AVX1:       # BB#0:
; AVX1-NEXT:    vmovaps (%rdi), %ymm0
; AVX1-NEXT:    vextractf128 $1, %ymm0, %xmm1
; AVX1-NEXT:    vshufps {{.*#+}} xmm0 = xmm0[0,2],xmm1[0,2]
; AVX1-NEXT:    vpshufb {{.*#+}} xmm0 = xmm0[0,1,4,5,8,9,12,13,8,9,12,13,12,13,14,15]
; AVX1-NEXT:    vmovq %xmm0, (%rsi)
; AVX1-NEXT:    vzeroupper
; AVX1-NEXT:    retq
;
; AVX2-LABEL: trunc_v4i64_to_v4i16:
; AVX2:       # BB#0:
; AVX2-NEXT:    vpshufd {{.*#+}} ymm0 = mem[0,2,2,3,4,6,6,7]
; AVX2-NEXT:    vpermq {{.*#+}} ymm0 = ymm0[0,2,2,3]
; AVX2-NEXT:    vpshufb {{.*#+}} xmm0 = xmm0[0,1,4,5,8,9,12,13,8,9,12,13,12,13,14,15]
; AVX2-NEXT:    vmovq %xmm0, (%rsi)
; AVX2-NEXT:    vzeroupper
; AVX2-NEXT:    retq
;
; AVX512F-LABEL: trunc_v4i64_to_v4i16:
; AVX512F:       # BB#0:
; AVX512F-NEXT:    vmovdqa (%rdi), %ymm0
; AVX512F-NEXT:    vpmovqd %zmm0, %ymm0
; AVX512F-NEXT:    vpshufb {{.*#+}} xmm0 = xmm0[0,1,4,5,8,9,12,13,8,9,12,13,12,13,14,15]
; AVX512F-NEXT:    vmovq %xmm0, (%rsi)
; AVX512F-NEXT:    vzeroupper
; AVX512F-NEXT:    retq
;
; AVX512VL-LABEL: trunc_v4i64_to_v4i16:
; AVX512VL:       # BB#0:
; AVX512VL-NEXT:    vmovdqa (%rdi), %ymm0
; AVX512VL-NEXT:    vpmovqw %ymm0, (%rsi)
; AVX512VL-NEXT:    vzeroupper
; AVX512VL-NEXT:    retq
;
; AVX512BW-LABEL: trunc_v4i64_to_v4i16:
; AVX512BW:       # BB#0:
; AVX512BW-NEXT:    vmovdqa (%rdi), %ymm0
; AVX512BW-NEXT:    vpmovqd %zmm0, %ymm0
; AVX512BW-NEXT:    vpshufb {{.*#+}} xmm0 = xmm0[0,1,4,5,8,9,12,13,8,9,12,13,12,13,14,15]
; AVX512BW-NEXT:    vmovq %xmm0, (%rsi)
; AVX512BW-NEXT:    vzeroupper
; AVX512BW-NEXT:    retq
;
; AVX512BWVL-LABEL: trunc_v4i64_to_v4i16:
; AVX512BWVL:       # BB#0:
; AVX512BWVL-NEXT:    vmovdqa (%rdi), %ymm0
; AVX512BWVL-NEXT:    vpmovqw %ymm0, (%rsi)
; AVX512BWVL-NEXT:    vzeroupper
; AVX512BWVL-NEXT:    retq
  %vec = load <16 x i16>, <16 x i16>* %L
  %bc = bitcast <16 x i16> %vec to <4 x i64>
  %strided.vec = trunc <4 x i64> %bc to <4 x i16>
  store <4 x i16> %strided.vec, <4 x i16>* %S
  ret void
}

define void @shuffle_v32i8_to_v4i8(<32 x i8>* %L, <4 x i8>* %S) nounwind {
; AVX1-LABEL: shuffle_v32i8_to_v4i8:
; AVX1:       # BB#0:
; AVX1-NEXT:    vmovaps (%rdi), %ymm0
; AVX1-NEXT:    vextractf128 $1, %ymm0, %xmm1
; AVX1-NEXT:    vshufps {{.*#+}} xmm0 = xmm0[0,2],xmm1[0,2]
; AVX1-NEXT:    vpshufb {{.*#+}} xmm0 = xmm0[0,4,8,12,u,u,u,u,u,u,u,u,u,u,u,u]
; AVX1-NEXT:    vmovd %xmm0, (%rsi)
; AVX1-NEXT:    vzeroupper
; AVX1-NEXT:    retq
;
; AVX2-LABEL: shuffle_v32i8_to_v4i8:
; AVX2:       # BB#0:
; AVX2-NEXT:    vpshufd {{.*#+}} ymm0 = mem[0,2,2,3,4,6,6,7]
; AVX2-NEXT:    vpermq {{.*#+}} ymm0 = ymm0[0,2,2,3]
; AVX2-NEXT:    vpshufb {{.*#+}} xmm0 = xmm0[0,4,8,12,u,u,u,u,u,u,u,u,u,u,u,u]
; AVX2-NEXT:    vmovd %xmm0, (%rsi)
; AVX2-NEXT:    vzeroupper
; AVX2-NEXT:    retq
;
; AVX512F-LABEL: shuffle_v32i8_to_v4i8:
; AVX512F:       # BB#0:
; AVX512F-NEXT:    vmovdqa (%rdi), %ymm0
; AVX512F-NEXT:    vpmovqd %zmm0, %ymm0
; AVX512F-NEXT:    vpshufb {{.*#+}} xmm0 = xmm0[0,4,8,12,u,u,u,u,u,u,u,u,u,u,u,u]
; AVX512F-NEXT:    vmovd %xmm0, (%rsi)
; AVX512F-NEXT:    vzeroupper
; AVX512F-NEXT:    retq
;
; AVX512VL-LABEL: shuffle_v32i8_to_v4i8:
; AVX512VL:       # BB#0:
; AVX512VL-NEXT:    vmovdqa (%rdi), %ymm0
; AVX512VL-NEXT:    vpmovqb %ymm0, (%rsi)
; AVX512VL-NEXT:    vzeroupper
; AVX512VL-NEXT:    retq
;
; AVX512BW-LABEL: shuffle_v32i8_to_v4i8:
; AVX512BW:       # BB#0:
; AVX512BW-NEXT:    vmovdqa (%rdi), %ymm0
; AVX512BW-NEXT:    vpmovqd %zmm0, %ymm0
; AVX512BW-NEXT:    vpshufb {{.*#+}} xmm0 = xmm0[0,4,8,12,u,u,u,u,u,u,u,u,u,u,u,u]
; AVX512BW-NEXT:    vmovd %xmm0, (%rsi)
; AVX512BW-NEXT:    vzeroupper
; AVX512BW-NEXT:    retq
;
; AVX512BWVL-LABEL: shuffle_v32i8_to_v4i8:
; AVX512BWVL:       # BB#0:
; AVX512BWVL-NEXT:    vmovdqa (%rdi), %ymm0
; AVX512BWVL-NEXT:    vpmovqb %ymm0, (%rsi)
; AVX512BWVL-NEXT:    vzeroupper
; AVX512BWVL-NEXT:    retq
  %vec = load <32 x i8>, <32 x i8>* %L
  %strided.vec = shufflevector <32 x i8> %vec, <32 x i8> undef, <4 x i32> <i32 0, i32 8, i32 16, i32 24>
  store <4 x i8> %strided.vec, <4 x i8>* %S
  ret void
}

define void @trunc_v4i64_to_v4i8(<32 x i8>* %L, <4 x i8>* %S) nounwind {
; AVX1-LABEL: trunc_v4i64_to_v4i8:
; AVX1:       # BB#0:
; AVX1-NEXT:    vmovaps (%rdi), %ymm0
; AVX1-NEXT:    vextractf128 $1, %ymm0, %xmm1
; AVX1-NEXT:    vshufps {{.*#+}} xmm0 = xmm0[0,2],xmm1[0,2]
; AVX1-NEXT:    vpshufb {{.*#+}} xmm0 = xmm0[0,4,8,12,u,u,u,u,u,u,u,u,u,u,u,u]
; AVX1-NEXT:    vmovd %xmm0, (%rsi)
; AVX1-NEXT:    vzeroupper
; AVX1-NEXT:    retq
;
; AVX2-LABEL: trunc_v4i64_to_v4i8:
; AVX2:       # BB#0:
; AVX2-NEXT:    vpshufd {{.*#+}} ymm0 = mem[0,2,2,3,4,6,6,7]
; AVX2-NEXT:    vpermq {{.*#+}} ymm0 = ymm0[0,2,2,3]
; AVX2-NEXT:    vpshufb {{.*#+}} xmm0 = xmm0[0,4,8,12,u,u,u,u,u,u,u,u,u,u,u,u]
; AVX2-NEXT:    vmovd %xmm0, (%rsi)
; AVX2-NEXT:    vzeroupper
; AVX2-NEXT:    retq
;
; AVX512F-LABEL: trunc_v4i64_to_v4i8:
; AVX512F:       # BB#0:
; AVX512F-NEXT:    vmovdqa (%rdi), %ymm0
; AVX512F-NEXT:    vpmovqd %zmm0, %ymm0
; AVX512F-NEXT:    vpshufb {{.*#+}} xmm0 = xmm0[0,4,8,12,u,u,u,u,u,u,u,u,u,u,u,u]
; AVX512F-NEXT:    vmovd %xmm0, (%rsi)
; AVX512F-NEXT:    vzeroupper
; AVX512F-NEXT:    retq
;
; AVX512VL-LABEL: trunc_v4i64_to_v4i8:
; AVX512VL:       # BB#0:
; AVX512VL-NEXT:    vmovdqa (%rdi), %ymm0
; AVX512VL-NEXT:    vpmovqb %ymm0, (%rsi)
; AVX512VL-NEXT:    vzeroupper
; AVX512VL-NEXT:    retq
;
; AVX512BW-LABEL: trunc_v4i64_to_v4i8:
; AVX512BW:       # BB#0:
; AVX512BW-NEXT:    vmovdqa (%rdi), %ymm0
; AVX512BW-NEXT:    vpmovqd %zmm0, %ymm0
; AVX512BW-NEXT:    vpshufb {{.*#+}} xmm0 = xmm0[0,4,8,12,u,u,u,u,u,u,u,u,u,u,u,u]
; AVX512BW-NEXT:    vmovd %xmm0, (%rsi)
; AVX512BW-NEXT:    vzeroupper
; AVX512BW-NEXT:    retq
;
; AVX512BWVL-LABEL: trunc_v4i64_to_v4i8:
; AVX512BWVL:       # BB#0:
; AVX512BWVL-NEXT:    vmovdqa (%rdi), %ymm0
; AVX512BWVL-NEXT:    vpmovqb %ymm0, (%rsi)
; AVX512BWVL-NEXT:    vzeroupper
; AVX512BWVL-NEXT:    retq
  %vec = load <32 x i8>, <32 x i8>* %L
  %bc = bitcast <32 x i8> %vec to <4 x i64>
  %strided.vec = trunc <4 x i64> %bc to <4 x i8>
  store <4 x i8> %strided.vec, <4 x i8>* %S
  ret void
}

; In this case not all elements are collected from the same source vector, so
; the resulting BUILD_VECTOR should not be combined to a truncate.
define <16 x i8> @negative(<32 x i8> %v, <32 x i8> %w) nounwind {
; AVX1-LABEL: negative:
; AVX1:       # BB#0:
; AVX1-NEXT:    vpshufb {{.*#+}} xmm2 = xmm0[u,2,4,6,8,10,12,14],zero,zero,zero,zero,zero,zero,zero,zero
; AVX1-NEXT:    vextractf128 $1, %ymm0, %xmm0
; AVX1-NEXT:    vpshufb {{.*#+}} xmm0 = xmm0[u],zero,zero,zero,zero,zero,zero,zero,xmm0[0,2,4,6,8,10,12,14]
; AVX1-NEXT:    vpor %xmm2, %xmm0, %xmm0
; AVX1-NEXT:    vmovdqa {{.*#+}} xmm2 = [0,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255]
; AVX1-NEXT:    vpblendvb %xmm2, %xmm0, %xmm1, %xmm0
; AVX1-NEXT:    vzeroupper
; AVX1-NEXT:    retq
;
; AVX2-LABEL: negative:
; AVX2:       # BB#0:
; AVX2-NEXT:    vpshufb {{.*#+}} ymm0 = ymm0[u,2,4,6,8,10,12,14,0,2,4,6,8,10,12,14,u,18,20,22,24,26,28,30,16,18,20,22,24,26,28,30]
; AVX2-NEXT:    vmovdqa {{.*#+}} ymm2 = [0,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,0,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255]
; AVX2-NEXT:    vpblendvb %ymm2, %ymm0, %ymm1, %ymm0
; AVX2-NEXT:    vpermq {{.*#+}} ymm0 = ymm0[0,3,2,3]
; AVX2-NEXT:    # kill: %XMM0<def> %XMM0<kill> %YMM0<kill>
; AVX2-NEXT:    vzeroupper
; AVX2-NEXT:    retq
;
; AVX512F-LABEL: negative:
; AVX512F:       # BB#0:
; AVX512F-NEXT:    vpshufb {{.*#+}} ymm0 = ymm0[u,2,4,6,8,10,12,14,0,2,4,6,8,10,12,14,u,18,20,22,24,26,28,30,16,18,20,22,24,26,28,30]
; AVX512F-NEXT:    vmovdqa {{.*#+}} ymm2 = [0,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,0,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255]
; AVX512F-NEXT:    vpblendvb %ymm2, %ymm0, %ymm1, %ymm0
; AVX512F-NEXT:    vpermq {{.*#+}} ymm0 = ymm0[0,3,2,3]
; AVX512F-NEXT:    # kill: %XMM0<def> %XMM0<kill> %YMM0<kill>
; AVX512F-NEXT:    vzeroupper
; AVX512F-NEXT:    retq
;
; AVX512VL-LABEL: negative:
; AVX512VL:       # BB#0:
; AVX512VL-NEXT:    vpshufb {{.*#+}} ymm0 = ymm0[u,2,4,6,8,10,12,14,0,2,4,6,8,10,12,14,u,18,20,22,24,26,28,30,16,18,20,22,24,26,28,30]
; AVX512VL-NEXT:    vmovdqa {{.*#+}} ymm2 = [0,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,0,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255]
; AVX512VL-NEXT:    vpblendvb %ymm2, %ymm0, %ymm1, %ymm0
; AVX512VL-NEXT:    vpermq {{.*#+}} ymm0 = ymm0[0,3,2,3]
; AVX512VL-NEXT:    # kill: %XMM0<def> %XMM0<kill> %YMM0<kill>
; AVX512VL-NEXT:    vzeroupper
; AVX512VL-NEXT:    retq
;
; AVX512BW-LABEL: negative:
; AVX512BW:       # BB#0:
; AVX512BW-NEXT:    vpshufb {{.*#+}} ymm0 = ymm0[u,2,4,6,8,10,12,14,0,2,4,6,8,10,12,14,u,18,20,22,24,26,28,30,16,18,20,22,24,26,28,30]
; AVX512BW-NEXT:    vmovdqa {{.*#+}} ymm2 = [0,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255,0,255,255,255,255,255,255,255,255,255,255,255,255,255,255,255]
; AVX512BW-NEXT:    vpblendvb %ymm2, %ymm0, %ymm1, %ymm0
; AVX512BW-NEXT:    vpermq {{.*#+}} ymm0 = ymm0[0,3,2,3]
; AVX512BW-NEXT:    # kill: %XMM0<def> %XMM0<kill> %YMM0<kill>
; AVX512BW-NEXT:    vzeroupper
; AVX512BW-NEXT:    retq
;
; AVX512BWVL-LABEL: negative:
; AVX512BWVL:       # BB#0:
; AVX512BWVL-NEXT:    vpshufb {{.*#+}} ymm0 = ymm0[u,2,4,6,8,10,12,14,0,2,4,6,8,10,12,14,u,18,20,22,24,26,28,30,16,18,20,22,24,26,28,30]
; AVX512BWVL-NEXT:    movl $65537, %eax # imm = 0x10001
; AVX512BWVL-NEXT:    kmovd %eax, %k1
; AVX512BWVL-NEXT:    vmovdqu8 %ymm1, %ymm0 {%k1}
; AVX512BWVL-NEXT:    vpermq {{.*#+}} ymm0 = ymm0[0,3,2,3]
; AVX512BWVL-NEXT:    # kill: %XMM0<def> %XMM0<kill> %YMM0<kill>
; AVX512BWVL-NEXT:    vzeroupper
; AVX512BWVL-NEXT:    retq
  %strided.vec = shufflevector <32 x i8> %v, <32 x i8> undef, <16 x i32> <i32 0, i32 2, i32 4, i32 6, i32 8, i32 10, i32 12, i32 14, i32 16, i32 18, i32 20, i32 22, i32 24, i32 26, i32 28, i32 30>
  %w0 = extractelement <32 x i8> %w, i32 0
  %merged = insertelement <16 x i8> %strided.vec, i8 %w0, i32 0
  ret <16 x i8> %merged
}
