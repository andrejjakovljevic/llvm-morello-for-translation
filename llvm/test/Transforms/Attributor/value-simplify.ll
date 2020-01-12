; NOTE: Assertions have been autogenerated by utils/update_test_checks.py UTC_ARGS: --function-signature --scrub-attributes
; RUN: opt -attributor --attributor-disable=false -attributor-annotate-decl-cs -S < %s | FileCheck %s
; TODO: Add max-iteration check

; Disable update test checks and enable it where required.
; UTC_ARGS: --disable

; ModuleID = 'value-simplify.ll'
source_filename = "value-simplify.ll"
target datalayout = "e-m:o-i64:64-f80:128-n8:16:32:64-S128"
declare void @f(i32)

; Test1: Replace argument with constant
define internal void @test1(i32 %a) {
; CHECK: tail call void @f(i32 1)
  tail call void @f(i32 %a)
  ret void
}

define void @test1_helper() {
  tail call void @test1(i32 1)
  ret void
}

; TEST 2 : Simplify return value
define i32 @return0() {
  ret i32 0
}

define i32 @return1() {
  ret i32 1
}

; CHECK: define i32 @test2_1(i1 %c)
define i32 @test2_1(i1 %c) {
  br i1 %c, label %if.true, label %if.false
if.true:
  %call = tail call i32 @return0()
  %ret0 = add i32 %call, 1
  br label %end
if.false:
  %ret1 = tail call i32 @return1()
  br label %end
end:

; CHECK: %ret = phi i32 [ %ret0, %if.true ], [ 1, %if.false ]
  %ret = phi i32 [ %ret0, %if.true ], [ %ret1, %if.false ]

; CHECK: ret i32 1
  ret i32 1
}



; CHECK: define i32 @test2_2(i1 %c)
define i32 @test2_2(i1 %c) {
  %ret = tail call i32 @test2_1(i1 %c)
; CHECK: ret i32 1
  ret i32 %ret
}

declare void @use(i32)
; CHECK: define void @test3(i1 %c)
define void @test3(i1 %c) {
  br i1 %c, label %if.true, label %if.false
if.true:
  br label %end
if.false:
  %ret1 = tail call i32 @return1()
  br label %end
end:

; CHECK: %r = phi i32 [ 1, %if.true ], [ 1, %if.false ]
  %r = phi i32 [ 1, %if.true ], [ %ret1, %if.false ]

; CHECK: tail call void @use(i32 1)
  tail call void @use(i32 %r)
  ret void
}

define void @test-select-phi(i1 %c) {
  %select-same = select i1 %c, i32 1, i32 1
  ; CHECK: tail call void @use(i32 1)
  tail call void @use(i32 %select-same)

  %select-not-same = select i1 %c, i32 1, i32 0
  ; CHECK: tail call void @use(i32 %select-not-same)
  tail call void @use(i32 %select-not-same)
  br i1 %c, label %if-true, label %if-false
if-true:
  br label %end
if-false:
  br label %end
end:
  %phi-same = phi i32 [ 1, %if-true ], [ 1, %if-false ]
  %phi-not-same = phi i32 [ 0, %if-true ], [ 1, %if-false ]
  %phi-same-prop = phi i32 [ 1, %if-true ], [ %select-same, %if-false ]
  %phi-same-undef = phi i32 [ 1, %if-true ], [ undef, %if-false ]
  %select-not-same-undef = select i1 %c, i32 %phi-not-same, i32 undef


  ; CHECK: tail call void @use(i32 1)
  tail call void @use(i32 %phi-same)

  ; CHECK: tail call void @use(i32 %phi-not-same)
  tail call void @use(i32 %phi-not-same)

  ; CHECK: tail call void @use(i32 1)
  tail call void @use(i32 %phi-same-prop)

  ; CHECK: tail call void @use(i32 1)
  tail call void @use(i32 %phi-same-undef)

  ; CHECK: tail call void @use(i32 %select-not-same-undef)
  tail call void @use(i32 %select-not-same-undef)

  ret void

}

define i32 @ipccp1(i32 %a) {
; CHECK-LABEL: define {{[^@]+}}@ipccp1
; CHECK-SAME: (i32 returned [[A:%.*]])
; CHECK-NEXT:    br i1 true, label [[T:%.*]], label [[F:%.*]]
; CHECK:       t:
; CHECK-NEXT:    ret i32 [[A:%.*]]
; CHECK:       f:
; CHECK-NEXT:    unreachable
;
  br i1 true, label %t, label %f
t:
  ret i32 %a
f:
  %r = call i32 @ipccp1(i32 5)
  ret i32 %r
}

define internal i1 @ipccp2i(i1 %a) {
  br i1 %a, label %t, label %f
t:
  ret i1 %a
f:
  %r = call i1 @ipccp2i(i1 false)
  ret i1 %r
}

define i1 @ipccp2() {
; CHECK-LABEL: define {{[^@]+}}@ipccp2()
; CHECK-NEXT:    ret i1 true
;
  %r = call i1 @ipccp2i(i1 true)
  ret i1 %r
}

define internal i1 @ipccp2ib(i1 %a) {
  br i1 %a, label %t, label %f
t:
  ret i1 true
f:
  %r = call i1 @ipccp2ib(i1 false)
  ret i1 %r
}

define i1 @ipccp2b() {
; CHECK-LABEL: define {{[^@]+}}@ipccp2b()
; CHECK-NEXT:    ret i1 true
;
  %r = call i1 @ipccp2ib(i1 true)
  ret i1 %r
}

define internal i32 @ipccp3i(i32 %a) {
  %c = icmp eq i32 %a, 7
  br i1 %c, label %t, label %f
t:
  ret i32 %a
f:
  %r = call i32 @ipccp3i(i32 5)
  ret i32 %r
}

define i32 @ipccp3() {
; CHECK-LABEL: define {{[^@]+}}@ipccp3()
; CHECK-NEXT:    ret i32 7
  %r = call i32 @ipccp3i(i32 7)
  ret i32 %r
}

; UTC_ARGS: --enable

; Do not touch complicated arguments (for now)
%struct.X = type { i8* }
define internal i32* @test_inalloca(i32* inalloca %a) {
; CHECK-LABEL: define {{[^@]+}}@test_inalloca
; CHECK-SAME: (i32* inalloca noalias nofree returned writeonly align 536870912 [[A:%.*]])
; CHECK-NEXT:    ret i32* [[A]]
;
  ret i32* %a
}
define i32* @complicated_args_inalloca() {
; CHECK-LABEL: define {{[^@]+}}@complicated_args_inalloca()
; CHECK-NEXT:    [[CALL:%.*]] = call i32* @test_inalloca(i32* noalias nofree writeonly align 536870912 null)
; CHECK-NEXT:    ret i32* [[CALL]]
;
  %call = call i32* @test_inalloca(i32* null)
  ret i32* %call
}

define internal void @test_sret(%struct.X* sret %a, %struct.X** %b) {
; CHECK-LABEL: define {{[^@]+}}@test_sret
; CHECK-SAME: (%struct.X* noalias nofree sret writeonly align 536870912 [[A:%.*]], %struct.X** nocapture nofree nonnull writeonly dereferenceable(8) [[B:%.*]])
; CHECK-NEXT:    store %struct.X* [[A]], %struct.X** [[B]]
; CHECK-NEXT:    ret void
;
  store %struct.X* %a, %struct.X** %b
  ret void
}
define void @complicated_args_sret(%struct.X** %b) {
; CHECK-LABEL: define {{[^@]+}}@complicated_args_sret
; CHECK-SAME: (%struct.X** nocapture nofree writeonly [[B:%.*]])
; CHECK-NEXT:    call void @test_sret(%struct.X* noalias nofree writeonly align 536870912 null, %struct.X** nocapture nofree writeonly [[B]])
; CHECK-NEXT:    ret void
;
  call void @test_sret(%struct.X* null, %struct.X** %b)
  ret void
}

define internal %struct.X* @test_nest(%struct.X* nest %a) {
; CHECK-LABEL: define {{[^@]+}}@test_nest
; CHECK-SAME: (%struct.X* nest noalias nofree readnone returned align 536870912 [[A:%.*]])
; CHECK-NEXT:    ret %struct.X* [[A]]
;
  ret %struct.X* %a
}
define %struct.X* @complicated_args_nest() {
; CHECK-LABEL: define {{[^@]+}}@complicated_args_nest()
; CHECK-NEXT:    [[CALL:%.*]] = call %struct.X* @test_nest(%struct.X* noalias nofree readnone align 536870912 null)
; CHECK-NEXT:    ret %struct.X* [[CALL]]
;
  %call = call %struct.X* @test_nest(%struct.X* null)
  ret %struct.X* %call
}

@S = external global %struct.X
define internal void @test_byval(%struct.X* byval %a) {
; CHECK-LABEL: define {{[^@]+}}@test_byval
; CHECK-SAME: (%struct.X* noalias nocapture nofree nonnull writeonly byval align 8 dereferenceable(8) [[A:%.*]])
; CHECK-NEXT:    [[G0:%.*]] = getelementptr [[STRUCT_X:%.*]], %struct.X* [[A]], i32 0, i32 0
; CHECK-NEXT:    store i8* null, i8** [[G0]], align 8
; CHECK-NEXT:    ret void
;
  %g0 = getelementptr %struct.X, %struct.X* %a, i32 0, i32 0
  store i8* null, i8** %g0
  ret void
}
define void @complicated_args_byval() {
; CHECK-LABEL: define {{[^@]+}}@complicated_args_byval()
; CHECK-NEXT:    call void @test_byval(%struct.X* nofree nonnull readonly align 8 dereferenceable(8) @S)
; CHECK-NEXT:    ret void
;
  call void @test_byval(%struct.X* @S)
  ret void
}

define void @fixpoint_changed(i32* %p) {
; CHECK-LABEL: define {{[^@]+}}@fixpoint_changed
; CHECK-SAME: (i32* nocapture nofree writeonly [[P:%.*]])
; CHECK-NEXT:  entry:
; CHECK-NEXT:    br label [[FOR_COND:%.*]]
; CHECK:       for.cond:
; CHECK-NEXT:    [[J_0:%.*]] = phi i32 [ 0, [[ENTRY:%.*]] ], [ [[INC:%.*]], [[SW_EPILOG:%.*]] ]
; CHECK-NEXT:    [[CMP:%.*]] = icmp slt i32 [[J_0]], 30
; CHECK-NEXT:    br i1 [[CMP]], label [[FOR_BODY:%.*]], label [[FOR_END:%.*]]
; CHECK:       for.body:
; CHECK-NEXT:    switch i32 [[J_0]], label [[SW_EPILOG]] [
; CHECK-NEXT:    i32 1, label [[SW_BB:%.*]]
; CHECK-NEXT:    ]
; CHECK:       sw.bb:
; CHECK-NEXT:    br label [[SW_EPILOG]]
; CHECK:       sw.epilog:
; CHECK-NEXT:    [[X_0:%.*]] = phi i32 [ 255, [[FOR_BODY]] ], [ 253, [[SW_BB]] ]
; CHECK-NEXT:    store i32 [[X_0]], i32* [[P]]
; CHECK-NEXT:    [[INC]] = add nsw i32 [[J_0]], 1
; CHECK-NEXT:    br label [[FOR_COND]]
; CHECK:       for.end:
; CHECK-NEXT:    ret void
;
entry:
  br label %for.cond

for.cond:
  %j.0 = phi i32 [ 0, %entry ], [ %inc, %sw.epilog ]
  %cmp = icmp slt i32 %j.0, 30
  br i1 %cmp, label %for.body, label %for.end

for.body:
  switch i32 %j.0, label %sw.epilog [
  i32 1, label %sw.bb
  ]

sw.bb:
  br label %sw.epilog

sw.epilog:
  %x.0 = phi i32 [ 255, %for.body ], [ 253, %sw.bb ]
  store i32 %x.0, i32* %p
  %inc = add nsw i32 %j.0, 1
  br label %for.cond

for.end:
  ret void
}

; UTC_ARGS: --disable
