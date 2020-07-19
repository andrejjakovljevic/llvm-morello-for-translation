; NOTE: Assertions have been autogenerated by utils/update_test_checks.py UTC_ARGS: --function-signature --scrub-attributes --check-attributes
; RUN: opt -attributor -attributor-manifest-internal  -attributor-max-iterations-verify -attributor-annotate-decl-cs -attributor-max-iterations=3 -S < %s | FileCheck %s --check-prefixes=CHECK,NOT_CGSCC_NPM,NOT_CGSCC_OPM,NOT_TUNIT_NPM,IS__TUNIT____,IS________OPM,IS__TUNIT_OPM
; RUN: opt -aa-pipeline=basic-aa -passes=attributor -attributor-manifest-internal  -attributor-max-iterations-verify -attributor-annotate-decl-cs -attributor-max-iterations=3 -S < %s | FileCheck %s --check-prefixes=CHECK,NOT_CGSCC_OPM,NOT_CGSCC_NPM,NOT_TUNIT_OPM,IS__TUNIT____,IS________NPM,IS__TUNIT_NPM
; RUN: opt -attributor-cgscc -attributor-manifest-internal  -attributor-annotate-decl-cs -S < %s | FileCheck %s --check-prefixes=CHECK,NOT_TUNIT_NPM,NOT_TUNIT_OPM,NOT_CGSCC_NPM,IS__CGSCC____,IS________OPM,IS__CGSCC_OPM
; RUN: opt -aa-pipeline=basic-aa -passes=attributor-cgscc -attributor-manifest-internal  -attributor-annotate-decl-cs -S < %s | FileCheck %s --check-prefixes=CHECK,NOT_TUNIT_NPM,NOT_TUNIT_OPM,NOT_CGSCC_OPM,IS__CGSCC____,IS________NPM,IS__CGSCC_NPM
; PR36485
; musttail call result can't be replaced with a constant, unless the call can be removed

declare i32 @external()

define i8* @start(i8 %v) {
; IS__TUNIT____-LABEL: define {{[^@]+}}@start
; IS__TUNIT____-SAME: (i8 [[V:%.*]])
; IS__TUNIT____-NEXT:    [[C1:%.*]] = icmp eq i8 [[V]], 0
; IS__TUNIT____-NEXT:    br i1 [[C1]], label [[TRUE:%.*]], label [[FALSE:%.*]]
; IS__TUNIT____:       true:
; IS__TUNIT____-NEXT:    [[CA:%.*]] = musttail call i8* @side_effects(i8 [[V]])
; IS__TUNIT____-NEXT:    ret i8* [[CA]]
; IS__TUNIT____:       false:
; IS__TUNIT____-NEXT:    [[C2:%.*]] = icmp eq i8 [[V]], 1
; IS__TUNIT____-NEXT:    br i1 [[C2]], label [[C2_TRUE:%.*]], label [[C2_FALSE:%.*]]
; IS__TUNIT____:       c2_true:
; IS__TUNIT____-NEXT:    ret i8* null
; IS__TUNIT____:       c2_false:
; IS__TUNIT____-NEXT:    [[CA2:%.*]] = musttail call i8* @dont_zap_me(i8 undef)
; IS__TUNIT____-NEXT:    ret i8* [[CA2]]
;
; IS__CGSCC____-LABEL: define {{[^@]+}}@start
; IS__CGSCC____-SAME: (i8 [[V:%.*]])
; IS__CGSCC____-NEXT:    [[C1:%.*]] = icmp eq i8 [[V]], 0
; IS__CGSCC____-NEXT:    br i1 [[C1]], label [[TRUE:%.*]], label [[FALSE:%.*]]
; IS__CGSCC____:       true:
; IS__CGSCC____-NEXT:    [[CA:%.*]] = musttail call noalias align 536870912 i8* @side_effects(i8 [[V]])
; IS__CGSCC____-NEXT:    ret i8* [[CA]]
; IS__CGSCC____:       false:
; IS__CGSCC____-NEXT:    [[C2:%.*]] = icmp eq i8 [[V]], 1
; IS__CGSCC____-NEXT:    br i1 [[C2]], label [[C2_TRUE:%.*]], label [[C2_FALSE:%.*]]
; IS__CGSCC____:       c2_true:
; IS__CGSCC____-NEXT:    [[CA1:%.*]] = musttail call noalias align 536870912 i8* @no_side_effects(i8 [[V]])
; IS__CGSCC____-NEXT:    ret i8* [[CA1]]
; IS__CGSCC____:       c2_false:
; IS__CGSCC____-NEXT:    [[CA2:%.*]] = musttail call noalias align 536870912 i8* @dont_zap_me(i8 [[V]])
; IS__CGSCC____-NEXT:    ret i8* [[CA2]]
;
  %c1 = icmp eq i8 %v, 0
  br i1 %c1, label %true, label %false
true:
  ; FIXME: propagate the value information for %v
  %ca = musttail call i8* @side_effects(i8 %v)
  ret i8* %ca
false:
  %c2 = icmp eq i8 %v, 1
  br i1 %c2, label %c2_true, label %c2_false
c2_true:
  %ca1 = musttail call i8* @no_side_effects(i8 %v)
  ; FIXME: zap this call
  ret i8* %ca1
c2_false:
  %ca2 = musttail call i8* @dont_zap_me(i8 %v)
  ret i8* %ca2
}

define internal i8* @side_effects(i8 %v) {
; IS__TUNIT____-LABEL: define {{[^@]+}}@side_effects
; IS__TUNIT____-SAME: (i8 [[V:%.*]])
; IS__TUNIT____-NEXT:    [[I1:%.*]] = call i32 @external()
; IS__TUNIT____-NEXT:    [[CA:%.*]] = musttail call i8* @start(i8 [[V]])
; IS__TUNIT____-NEXT:    ret i8* [[CA]]
;
; IS__CGSCC____-LABEL: define {{[^@]+}}@side_effects
; IS__CGSCC____-SAME: (i8 [[V:%.*]])
; IS__CGSCC____-NEXT:    [[I1:%.*]] = call i32 @external()
; IS__CGSCC____-NEXT:    [[CA:%.*]] = musttail call noalias align 536870912 i8* @start(i8 [[V]])
; IS__CGSCC____-NEXT:    ret i8* [[CA]]
;
  %i1 = call i32 @external()

  ; since this goes back to `start` the SCPP should be see that the return value
  ; is always `null`.
  ; The call can't be removed due to `external` call above, though.

  %ca = musttail call i8* @start(i8 %v)

  ; Thus the result must be returned anyway
  ret i8* %ca
}

define internal i8* @no_side_effects(i8 %v) readonly nounwind {
; IS__CGSCC____: Function Attrs: nofree norecurse nosync nounwind readnone willreturn
; IS__CGSCC____-LABEL: define {{[^@]+}}@no_side_effects
; IS__CGSCC____-SAME: (i8 [[V:%.*]])
; IS__CGSCC____-NEXT:    ret i8* null
;
  ret i8* null
}

define internal i8* @dont_zap_me(i8 %v) {
; IS__TUNIT____-LABEL: define {{[^@]+}}@dont_zap_me
; IS__TUNIT____-SAME: (i8 [[V:%.*]])
; IS__TUNIT____-NEXT:    [[I1:%.*]] = call i32 @external()
; IS__TUNIT____-NEXT:    ret i8* undef
;
; IS__CGSCC____-LABEL: define {{[^@]+}}@dont_zap_me
; IS__CGSCC____-SAME: (i8 [[V:%.*]])
; IS__CGSCC____-NEXT:    [[I1:%.*]] = call i32 @external()
; IS__CGSCC____-NEXT:    ret i8* null
;
  %i1 = call i32 @external()
  ret i8* null
}
