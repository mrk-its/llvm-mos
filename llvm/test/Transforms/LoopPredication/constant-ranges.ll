; NOTE: Assertions have been autogenerated by utils/update_test_checks.py
; RUN: opt -S -passes='loop-mssa(loop-predication)' -loop-predication-insert-assumes-of-predicated-guards-conditions=false < %s 2>&1 | FileCheck %s

define i32 @test_ult(ptr noundef %p, i32 noundef %n, ptr noundef %arr, ptr noundef %len_p, i32 noundef %c) {
; CHECK-LABEL: @test_ult(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[LEN:%.*]] = load i32, ptr [[LEN_P:%.*]], align 4, !range [[RNG0:![0-9]+]], !noundef !1
; CHECK-NEXT:    br label [[LOOP:%.*]]
; CHECK:       loop:
; CHECK-NEXT:    [[IV:%.*]] = phi i32 [ 0, [[ENTRY:%.*]] ], [ [[IV_NEXT:%.*]], [[BACKEDGE:%.*]] ]
; CHECK-NEXT:    [[EL_PTR:%.*]] = getelementptr i32, ptr [[P:%.*]], i32 [[IV]]
; CHECK-NEXT:    [[EL:%.*]] = load i32, ptr [[EL_PTR]], align 4
; CHECK-NEXT:    [[BOUND_CHECK:%.*]] = icmp ult i32 [[EL]], 128
; CHECK-NEXT:    br i1 [[BOUND_CHECK]], label [[DO_RANGE_CHECK:%.*]], label [[BOUND_CHECK_FAILED:%.*]]
; CHECK:       do_range_check:
; CHECK-NEXT:    [[RANGE_CHECK_ULT:%.*]] = icmp ult i32 [[EL]], [[LEN]]
; CHECK-NEXT:    [[WC:%.*]] = call i1 @llvm.experimental.widenable.condition()
; CHECK-NEXT:    [[EXPLICIT_GUARD_COND:%.*]] = and i1 [[RANGE_CHECK_ULT]], [[WC]]
; CHECK-NEXT:    br i1 [[EXPLICIT_GUARD_COND]], label [[BACKEDGE]], label [[DEOPT:%.*]]
; CHECK:       backedge:
; CHECK-NEXT:    [[ARR_PTR:%.*]] = getelementptr i32, ptr [[ARR:%.*]], i32 [[EL]]
; CHECK-NEXT:    store i32 [[IV]], ptr [[ARR_PTR]], align 4
; CHECK-NEXT:    [[IV_NEXT]] = add i32 [[IV]], 1
; CHECK-NEXT:    [[LOOP_COND:%.*]] = icmp slt i32 [[IV_NEXT]], [[N:%.*]]
; CHECK-NEXT:    br i1 [[LOOP_COND]], label [[LOOP]], label [[EXIT:%.*]]
; CHECK:       deopt:
; CHECK-NEXT:    [[DEOPT_RES:%.*]] = call i32 (...) @llvm.experimental.deoptimize.i32() [ "deopt"() ]
; CHECK-NEXT:    ret i32 [[DEOPT_RES]]
; CHECK:       exit:
; CHECK-NEXT:    ret i32 0
; CHECK:       bound_check_failed:
; CHECK-NEXT:    ret i32 -1
;
entry:
  %len = load i32, ptr %len_p, align 4, !noundef !0, !range !1
  br label %loop

loop:
  %iv = phi i32 [ 0, %entry ], [ %iv.next, %backedge ]
  %el.ptr = getelementptr i32, ptr %p, i32 %iv
  %el = load i32, ptr %el.ptr, align 4
  %bound_check = icmp ult i32 %el, 128
  br i1 %bound_check, label %do_range_check, label %bound_check_failed

do_range_check:
  %range_check.ult = icmp ult i32 %el, %len
  %wc = call i1 @llvm.experimental.widenable.condition()
  %explicit_guard_cond = and i1 %range_check.ult, %wc
  br i1 %explicit_guard_cond, label %backedge, label %deopt

backedge:
  %arr.ptr = getelementptr i32, ptr %arr, i32 %el
  store i32 %iv, ptr %arr.ptr, align 4
  %iv.next = add i32 %iv, 1
  %loop_cond = icmp slt i32 %iv.next, %n
  br i1 %loop_cond, label %loop, label %exit

deopt:
  %deopt_res = call i32 (...) @llvm.experimental.deoptimize.i32() [ "deopt"() ]
  ret i32 %deopt_res

exit:
  ret i32 0

bound_check_failed:
  ret i32 -1
}

define i32 @test_slt(ptr noundef %p, i32 noundef %n, ptr noundef %arr, ptr noundef %len_p, i32 noundef %c) {
; CHECK-LABEL: @test_slt(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[LEN:%.*]] = load i32, ptr [[LEN_P:%.*]], align 4, !range [[RNG0]], !noundef !1
; CHECK-NEXT:    br label [[LOOP:%.*]]
; CHECK:       loop:
; CHECK-NEXT:    [[IV:%.*]] = phi i32 [ 0, [[ENTRY:%.*]] ], [ [[IV_NEXT:%.*]], [[BACKEDGE:%.*]] ]
; CHECK-NEXT:    [[EL_PTR:%.*]] = getelementptr i32, ptr [[P:%.*]], i32 [[IV]]
; CHECK-NEXT:    [[EL:%.*]] = load i32, ptr [[EL_PTR]], align 4
; CHECK-NEXT:    [[BOUND_CHECK:%.*]] = icmp slt i32 [[EL]], 128
; CHECK-NEXT:    br i1 [[BOUND_CHECK]], label [[DO_RANGE_CHECK:%.*]], label [[BOUND_CHECK_FAILED:%.*]]
; CHECK:       do_range_check:
; CHECK-NEXT:    [[RANGE_CHECK_SLT:%.*]] = icmp slt i32 [[EL]], [[LEN]]
; CHECK-NEXT:    [[WC:%.*]] = call i1 @llvm.experimental.widenable.condition()
; CHECK-NEXT:    [[EXPLICIT_GUARD_COND:%.*]] = and i1 [[RANGE_CHECK_SLT]], [[WC]]
; CHECK-NEXT:    br i1 [[EXPLICIT_GUARD_COND]], label [[BACKEDGE]], label [[DEOPT:%.*]]
; CHECK:       backedge:
; CHECK-NEXT:    [[ARR_PTR:%.*]] = getelementptr i32, ptr [[ARR:%.*]], i32 [[EL]]
; CHECK-NEXT:    store i32 [[IV]], ptr [[ARR_PTR]], align 4
; CHECK-NEXT:    [[IV_NEXT]] = add i32 [[IV]], 1
; CHECK-NEXT:    [[LOOP_COND:%.*]] = icmp ult i32 [[IV_NEXT]], [[N:%.*]]
; CHECK-NEXT:    br i1 [[LOOP_COND]], label [[LOOP]], label [[EXIT:%.*]]
; CHECK:       deopt:
; CHECK-NEXT:    [[DEOPT_RES:%.*]] = call i32 (...) @llvm.experimental.deoptimize.i32() [ "deopt"() ]
; CHECK-NEXT:    ret i32 [[DEOPT_RES]]
; CHECK:       exit:
; CHECK-NEXT:    ret i32 0
; CHECK:       bound_check_failed:
; CHECK-NEXT:    ret i32 -1
;
entry:
  %len = load i32, ptr %len_p, align 4, !noundef !0, !range !1
  br label %loop

loop:
  %iv = phi i32 [ 0, %entry ], [ %iv.next, %backedge ]
  %el.ptr = getelementptr i32, ptr %p, i32 %iv
  %el = load i32, ptr %el.ptr, align 4
  %bound_check = icmp slt i32 %el, 128
  br i1 %bound_check, label %do_range_check, label %bound_check_failed

do_range_check:
  %range_check.slt = icmp slt i32 %el, %len
  %wc = call i1 @llvm.experimental.widenable.condition()
  %explicit_guard_cond = and i1 %range_check.slt, %wc
  br i1 %explicit_guard_cond, label %backedge, label %deopt

backedge:
  %arr.ptr = getelementptr i32, ptr %arr, i32 %el
  store i32 %iv, ptr %arr.ptr, align 4
  %iv.next = add i32 %iv, 1
  %loop_cond = icmp ult i32 %iv.next, %n
  br i1 %loop_cond, label %loop, label %exit

deopt:
  %deopt_res = call i32 (...) @llvm.experimental.deoptimize.i32() [ "deopt"() ]
  ret i32 %deopt_res

exit:
  ret i32 0

bound_check_failed:
  ret i32 -1
}

define i32 @test_ule(ptr noundef %p, i32 noundef %n, ptr noundef %arr, ptr noundef %len_p, i32 noundef %c) {
; CHECK-LABEL: @test_ule(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[LEN:%.*]] = load i32, ptr [[LEN_P:%.*]], align 4, !range [[RNG0]], !noundef !1
; CHECK-NEXT:    br label [[LOOP:%.*]]
; CHECK:       loop:
; CHECK-NEXT:    [[IV:%.*]] = phi i32 [ 0, [[ENTRY:%.*]] ], [ [[IV_NEXT:%.*]], [[BACKEDGE:%.*]] ]
; CHECK-NEXT:    [[EL_PTR:%.*]] = getelementptr i32, ptr [[P:%.*]], i32 [[IV]]
; CHECK-NEXT:    [[EL:%.*]] = load i32, ptr [[EL_PTR]], align 4
; CHECK-NEXT:    [[BOUND_CHECK:%.*]] = icmp ult i32 [[EL]], 128
; CHECK-NEXT:    br i1 [[BOUND_CHECK]], label [[DO_RANGE_CHECK:%.*]], label [[BOUND_CHECK_FAILED:%.*]]
; CHECK:       do_range_check:
; CHECK-NEXT:    [[RANGE_CHECK_ULE:%.*]] = icmp ule i32 [[EL]], [[LEN]]
; CHECK-NEXT:    [[WC:%.*]] = call i1 @llvm.experimental.widenable.condition()
; CHECK-NEXT:    [[EXPLICIT_GUARD_COND:%.*]] = and i1 [[RANGE_CHECK_ULE]], [[WC]]
; CHECK-NEXT:    br i1 [[EXPLICIT_GUARD_COND]], label [[BACKEDGE]], label [[DEOPT:%.*]]
; CHECK:       backedge:
; CHECK-NEXT:    [[ARR_PTR:%.*]] = getelementptr i32, ptr [[ARR:%.*]], i32 [[EL]]
; CHECK-NEXT:    store i32 [[IV]], ptr [[ARR_PTR]], align 4
; CHECK-NEXT:    [[IV_NEXT]] = add i32 [[IV]], 1
; CHECK-NEXT:    [[LOOP_COND:%.*]] = icmp ult i32 [[IV_NEXT]], [[N:%.*]]
; CHECK-NEXT:    br i1 [[LOOP_COND]], label [[LOOP]], label [[EXIT:%.*]]
; CHECK:       deopt:
; CHECK-NEXT:    [[DEOPT_RES:%.*]] = call i32 (...) @llvm.experimental.deoptimize.i32() [ "deopt"() ]
; CHECK-NEXT:    ret i32 [[DEOPT_RES]]
; CHECK:       exit:
; CHECK-NEXT:    ret i32 0
; CHECK:       bound_check_failed:
; CHECK-NEXT:    ret i32 -1
;
entry:
  %len = load i32, ptr %len_p, align 4, !noundef !0, !range !1
  br label %loop

loop:
  %iv = phi i32 [ 0, %entry ], [ %iv.next, %backedge ]
  %el.ptr = getelementptr i32, ptr %p, i32 %iv
  %el = load i32, ptr %el.ptr, align 4
  %bound_check = icmp ult i32 %el, 128
  br i1 %bound_check, label %do_range_check, label %bound_check_failed

do_range_check:
  %range_check.ule = icmp ule i32 %el, %len
  %wc = call i1 @llvm.experimental.widenable.condition()
  %explicit_guard_cond = and i1 %range_check.ule, %wc
  br i1 %explicit_guard_cond, label %backedge, label %deopt

backedge:
  %arr.ptr = getelementptr i32, ptr %arr, i32 %el
  store i32 %iv, ptr %arr.ptr, align 4
  %iv.next = add i32 %iv, 1
  %loop_cond = icmp ult i32 %iv.next, %n
  br i1 %loop_cond, label %loop, label %exit

deopt:
  %deopt_res = call i32 (...) @llvm.experimental.deoptimize.i32() [ "deopt"() ]
  ret i32 %deopt_res

exit:
  ret i32 0

bound_check_failed:
  ret i32 -1
}

define i32 @test_sle(ptr noundef %p, i32 noundef %n, ptr noundef %arr, ptr noundef %len_p, i32 noundef %c) {
; CHECK-LABEL: @test_sle(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[LEN:%.*]] = load i32, ptr [[LEN_P:%.*]], align 4, !range [[RNG0]], !noundef !1
; CHECK-NEXT:    br label [[LOOP:%.*]]
; CHECK:       loop:
; CHECK-NEXT:    [[IV:%.*]] = phi i32 [ 0, [[ENTRY:%.*]] ], [ [[IV_NEXT:%.*]], [[BACKEDGE:%.*]] ]
; CHECK-NEXT:    [[EL_PTR:%.*]] = getelementptr i32, ptr [[P:%.*]], i32 [[IV]]
; CHECK-NEXT:    [[EL:%.*]] = load i32, ptr [[EL_PTR]], align 4
; CHECK-NEXT:    [[BOUND_CHECK:%.*]] = icmp slt i32 [[EL]], 128
; CHECK-NEXT:    br i1 [[BOUND_CHECK]], label [[DO_RANGE_CHECK:%.*]], label [[BOUND_CHECK_FAILED:%.*]]
; CHECK:       do_range_check:
; CHECK-NEXT:    [[RANGE_CHECK_SLE:%.*]] = icmp sle i32 [[EL]], [[LEN]]
; CHECK-NEXT:    [[WC:%.*]] = call i1 @llvm.experimental.widenable.condition()
; CHECK-NEXT:    [[EXPLICIT_GUARD_COND:%.*]] = and i1 [[RANGE_CHECK_SLE]], [[WC]]
; CHECK-NEXT:    br i1 [[EXPLICIT_GUARD_COND]], label [[BACKEDGE]], label [[DEOPT:%.*]]
; CHECK:       backedge:
; CHECK-NEXT:    [[ARR_PTR:%.*]] = getelementptr i32, ptr [[ARR:%.*]], i32 [[EL]]
; CHECK-NEXT:    store i32 [[IV]], ptr [[ARR_PTR]], align 4
; CHECK-NEXT:    [[IV_NEXT]] = add i32 [[IV]], 1
; CHECK-NEXT:    [[LOOP_COND:%.*]] = icmp ult i32 [[IV_NEXT]], [[N:%.*]]
; CHECK-NEXT:    br i1 [[LOOP_COND]], label [[LOOP]], label [[EXIT:%.*]]
; CHECK:       deopt:
; CHECK-NEXT:    [[DEOPT_RES:%.*]] = call i32 (...) @llvm.experimental.deoptimize.i32() [ "deopt"() ]
; CHECK-NEXT:    ret i32 [[DEOPT_RES]]
; CHECK:       exit:
; CHECK-NEXT:    ret i32 0
; CHECK:       bound_check_failed:
; CHECK-NEXT:    ret i32 -1
;
entry:
  %len = load i32, ptr %len_p, align 4, !noundef !0, !range !1
  br label %loop

loop:
  %iv = phi i32 [ 0, %entry ], [ %iv.next, %backedge ]
  %el.ptr = getelementptr i32, ptr %p, i32 %iv
  %el = load i32, ptr %el.ptr, align 4
  %bound_check = icmp slt i32 %el, 128
  br i1 %bound_check, label %do_range_check, label %bound_check_failed

do_range_check:
  %range_check.sle = icmp sle i32 %el, %len
  %wc = call i1 @llvm.experimental.widenable.condition()
  %explicit_guard_cond = and i1 %range_check.sle, %wc
  br i1 %explicit_guard_cond, label %backedge, label %deopt

backedge:
  %arr.ptr = getelementptr i32, ptr %arr, i32 %el
  store i32 %iv, ptr %arr.ptr, align 4
  %iv.next = add i32 %iv, 1
  %loop_cond = icmp ult i32 %iv.next, %n
  br i1 %loop_cond, label %loop, label %exit

deopt:
  %deopt_res = call i32 (...) @llvm.experimental.deoptimize.i32() [ "deopt"() ]
  ret i32 %deopt_res

exit:
  ret i32 0

bound_check_failed:
  ret i32 -1
}

define i32 @test_ugt(ptr noundef %p, i32 noundef %n, ptr noundef %arr, ptr noundef %len_p, i32 noundef %c) {
; CHECK-LABEL: @test_ugt(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[LEN:%.*]] = load i32, ptr [[LEN_P:%.*]], align 4, !range [[RNG0]], !noundef !1
; CHECK-NEXT:    br label [[LOOP:%.*]]
; CHECK:       loop:
; CHECK-NEXT:    [[IV:%.*]] = phi i32 [ 0, [[ENTRY:%.*]] ], [ [[IV_NEXT:%.*]], [[BACKEDGE:%.*]] ]
; CHECK-NEXT:    [[EL_PTR:%.*]] = getelementptr i32, ptr [[P:%.*]], i32 [[IV]]
; CHECK-NEXT:    [[EL:%.*]] = load i32, ptr [[EL_PTR]], align 4
; CHECK-NEXT:    [[BOUND_CHECK:%.*]] = icmp ult i32 [[EL]], 128
; CHECK-NEXT:    br i1 [[BOUND_CHECK]], label [[DO_RANGE_CHECK:%.*]], label [[BOUND_CHECK_FAILED:%.*]]
; CHECK:       do_range_check:
; CHECK-NEXT:    [[RANGE_CHECK_SLE:%.*]] = icmp ugt i32 [[LEN]], [[EL]]
; CHECK-NEXT:    [[WC:%.*]] = call i1 @llvm.experimental.widenable.condition()
; CHECK-NEXT:    [[EXPLICIT_GUARD_COND:%.*]] = and i1 [[RANGE_CHECK_SLE]], [[WC]]
; CHECK-NEXT:    br i1 [[EXPLICIT_GUARD_COND]], label [[BACKEDGE]], label [[DEOPT:%.*]]
; CHECK:       backedge:
; CHECK-NEXT:    [[ARR_PTR:%.*]] = getelementptr i32, ptr [[ARR:%.*]], i32 [[EL]]
; CHECK-NEXT:    store i32 [[IV]], ptr [[ARR_PTR]], align 4
; CHECK-NEXT:    [[IV_NEXT]] = add i32 [[IV]], 1
; CHECK-NEXT:    [[LOOP_COND:%.*]] = icmp ult i32 [[IV_NEXT]], [[N:%.*]]
; CHECK-NEXT:    br i1 [[LOOP_COND]], label [[LOOP]], label [[EXIT:%.*]]
; CHECK:       deopt:
; CHECK-NEXT:    [[DEOPT_RES:%.*]] = call i32 (...) @llvm.experimental.deoptimize.i32() [ "deopt"() ]
; CHECK-NEXT:    ret i32 [[DEOPT_RES]]
; CHECK:       exit:
; CHECK-NEXT:    ret i32 0
; CHECK:       bound_check_failed:
; CHECK-NEXT:    ret i32 -1
;
entry:
  %len = load i32, ptr %len_p, align 4, !noundef !0, !range !1
  br label %loop

loop:
  %iv = phi i32 [ 0, %entry ], [ %iv.next, %backedge ]
  %el.ptr = getelementptr i32, ptr %p, i32 %iv
  %el = load i32, ptr %el.ptr, align 4
  %bound_check = icmp ult i32 %el, 128
  br i1 %bound_check, label %do_range_check, label %bound_check_failed

do_range_check:
  %range_check.sle = icmp ugt i32 %len, %el
  %wc = call i1 @llvm.experimental.widenable.condition()
  %explicit_guard_cond = and i1 %range_check.sle, %wc
  br i1 %explicit_guard_cond, label %backedge, label %deopt

backedge:
  %arr.ptr = getelementptr i32, ptr %arr, i32 %el
  store i32 %iv, ptr %arr.ptr, align 4
  %iv.next = add i32 %iv, 1
  %loop_cond = icmp ult i32 %iv.next, %n
  br i1 %loop_cond, label %loop, label %exit

deopt:
  %deopt_res = call i32 (...) @llvm.experimental.deoptimize.i32() [ "deopt"() ]
  ret i32 %deopt_res

exit:
  ret i32 0

bound_check_failed:
  ret i32 -1
}

define i32 @test_uge(ptr noundef %p, i32 noundef %n, ptr noundef %arr, ptr noundef %len_p, i32 noundef %c) {
; CHECK-LABEL: @test_uge(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[LEN:%.*]] = load i32, ptr [[LEN_P:%.*]], align 4, !range [[RNG0]], !noundef !1
; CHECK-NEXT:    br label [[LOOP:%.*]]
; CHECK:       loop:
; CHECK-NEXT:    [[IV:%.*]] = phi i32 [ 0, [[ENTRY:%.*]] ], [ [[IV_NEXT:%.*]], [[BACKEDGE:%.*]] ]
; CHECK-NEXT:    [[EL_PTR:%.*]] = getelementptr i32, ptr [[P:%.*]], i32 [[IV]]
; CHECK-NEXT:    [[EL:%.*]] = load i32, ptr [[EL_PTR]], align 4
; CHECK-NEXT:    [[BOUND_CHECK:%.*]] = icmp ult i32 [[EL]], 128
; CHECK-NEXT:    br i1 [[BOUND_CHECK]], label [[DO_RANGE_CHECK:%.*]], label [[BOUND_CHECK_FAILED:%.*]]
; CHECK:       do_range_check:
; CHECK-NEXT:    [[RANGE_CHECK_SLE:%.*]] = icmp uge i32 [[LEN]], [[EL]]
; CHECK-NEXT:    [[WC:%.*]] = call i1 @llvm.experimental.widenable.condition()
; CHECK-NEXT:    [[EXPLICIT_GUARD_COND:%.*]] = and i1 [[RANGE_CHECK_SLE]], [[WC]]
; CHECK-NEXT:    br i1 [[EXPLICIT_GUARD_COND]], label [[BACKEDGE]], label [[DEOPT:%.*]]
; CHECK:       backedge:
; CHECK-NEXT:    [[ARR_PTR:%.*]] = getelementptr i32, ptr [[ARR:%.*]], i32 [[EL]]
; CHECK-NEXT:    store i32 [[IV]], ptr [[ARR_PTR]], align 4
; CHECK-NEXT:    [[IV_NEXT]] = add i32 [[IV]], 1
; CHECK-NEXT:    [[LOOP_COND:%.*]] = icmp ult i32 [[IV_NEXT]], [[N:%.*]]
; CHECK-NEXT:    br i1 [[LOOP_COND]], label [[LOOP]], label [[EXIT:%.*]]
; CHECK:       deopt:
; CHECK-NEXT:    [[DEOPT_RES:%.*]] = call i32 (...) @llvm.experimental.deoptimize.i32() [ "deopt"() ]
; CHECK-NEXT:    ret i32 [[DEOPT_RES]]
; CHECK:       exit:
; CHECK-NEXT:    ret i32 0
; CHECK:       bound_check_failed:
; CHECK-NEXT:    ret i32 -1
;
entry:
  %len = load i32, ptr %len_p, align 4, !noundef !0, !range !1
  br label %loop

loop:
  %iv = phi i32 [ 0, %entry ], [ %iv.next, %backedge ]
  %el.ptr = getelementptr i32, ptr %p, i32 %iv
  %el = load i32, ptr %el.ptr, align 4
  %bound_check = icmp ult i32 %el, 128
  br i1 %bound_check, label %do_range_check, label %bound_check_failed

do_range_check:
  %range_check.sle = icmp uge i32 %len, %el
  %wc = call i1 @llvm.experimental.widenable.condition()
  %explicit_guard_cond = and i1 %range_check.sle, %wc
  br i1 %explicit_guard_cond, label %backedge, label %deopt

backedge:
  %arr.ptr = getelementptr i32, ptr %arr, i32 %el
  store i32 %iv, ptr %arr.ptr, align 4
  %iv.next = add i32 %iv, 1
  %loop_cond = icmp ult i32 %iv.next, %n
  br i1 %loop_cond, label %loop, label %exit

deopt:
  %deopt_res = call i32 (...) @llvm.experimental.deoptimize.i32() [ "deopt"() ]
  ret i32 %deopt_res

exit:
  ret i32 0

bound_check_failed:
  ret i32 -1
}

define i32 @test_sgt(ptr noundef %p, i32 noundef %n, ptr noundef %arr, ptr noundef %len_p, i32 noundef %c) {
; CHECK-LABEL: @test_sgt(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[LEN:%.*]] = load i32, ptr [[LEN_P:%.*]], align 4, !range [[RNG0]], !noundef !1
; CHECK-NEXT:    br label [[LOOP:%.*]]
; CHECK:       loop:
; CHECK-NEXT:    [[IV:%.*]] = phi i32 [ 0, [[ENTRY:%.*]] ], [ [[IV_NEXT:%.*]], [[BACKEDGE:%.*]] ]
; CHECK-NEXT:    [[EL_PTR:%.*]] = getelementptr i32, ptr [[P:%.*]], i32 [[IV]]
; CHECK-NEXT:    [[EL:%.*]] = load i32, ptr [[EL_PTR]], align 4
; CHECK-NEXT:    [[BOUND_CHECK:%.*]] = icmp slt i32 [[EL]], 128
; CHECK-NEXT:    br i1 [[BOUND_CHECK]], label [[DO_RANGE_CHECK:%.*]], label [[BOUND_CHECK_FAILED:%.*]]
; CHECK:       do_range_check:
; CHECK-NEXT:    [[RANGE_CHECK_SLE:%.*]] = icmp sgt i32 [[LEN]], [[EL]]
; CHECK-NEXT:    [[WC:%.*]] = call i1 @llvm.experimental.widenable.condition()
; CHECK-NEXT:    [[EXPLICIT_GUARD_COND:%.*]] = and i1 [[RANGE_CHECK_SLE]], [[WC]]
; CHECK-NEXT:    br i1 [[EXPLICIT_GUARD_COND]], label [[BACKEDGE]], label [[DEOPT:%.*]]
; CHECK:       backedge:
; CHECK-NEXT:    [[ARR_PTR:%.*]] = getelementptr i32, ptr [[ARR:%.*]], i32 [[EL]]
; CHECK-NEXT:    store i32 [[IV]], ptr [[ARR_PTR]], align 4
; CHECK-NEXT:    [[IV_NEXT]] = add i32 [[IV]], 1
; CHECK-NEXT:    [[LOOP_COND:%.*]] = icmp ult i32 [[IV_NEXT]], [[N:%.*]]
; CHECK-NEXT:    br i1 [[LOOP_COND]], label [[LOOP]], label [[EXIT:%.*]]
; CHECK:       deopt:
; CHECK-NEXT:    [[DEOPT_RES:%.*]] = call i32 (...) @llvm.experimental.deoptimize.i32() [ "deopt"() ]
; CHECK-NEXT:    ret i32 [[DEOPT_RES]]
; CHECK:       exit:
; CHECK-NEXT:    ret i32 0
; CHECK:       bound_check_failed:
; CHECK-NEXT:    ret i32 -1
;
entry:
  %len = load i32, ptr %len_p, align 4, !noundef !0, !range !1
  br label %loop

loop:
  %iv = phi i32 [ 0, %entry ], [ %iv.next, %backedge ]
  %el.ptr = getelementptr i32, ptr %p, i32 %iv
  %el = load i32, ptr %el.ptr, align 4
  %bound_check = icmp slt i32 %el, 128
  br i1 %bound_check, label %do_range_check, label %bound_check_failed

do_range_check:
  %range_check.sle = icmp sgt i32 %len, %el
  %wc = call i1 @llvm.experimental.widenable.condition()
  %explicit_guard_cond = and i1 %range_check.sle, %wc
  br i1 %explicit_guard_cond, label %backedge, label %deopt

backedge:
  %arr.ptr = getelementptr i32, ptr %arr, i32 %el
  store i32 %iv, ptr %arr.ptr, align 4
  %iv.next = add i32 %iv, 1
  %loop_cond = icmp ult i32 %iv.next, %n
  br i1 %loop_cond, label %loop, label %exit

deopt:
  %deopt_res = call i32 (...) @llvm.experimental.deoptimize.i32() [ "deopt"() ]
  ret i32 %deopt_res

exit:
  ret i32 0

bound_check_failed:
  ret i32 -1
}

define i32 @test_sge(ptr noundef %p, i32 noundef %n, ptr noundef %arr, ptr noundef %len_p, i32 noundef %c) {
; CHECK-LABEL: @test_sge(
; CHECK-NEXT:  entry:
; CHECK-NEXT:    [[LEN:%.*]] = load i32, ptr [[LEN_P:%.*]], align 4, !range [[RNG0]], !noundef !1
; CHECK-NEXT:    br label [[LOOP:%.*]]
; CHECK:       loop:
; CHECK-NEXT:    [[IV:%.*]] = phi i32 [ 0, [[ENTRY:%.*]] ], [ [[IV_NEXT:%.*]], [[BACKEDGE:%.*]] ]
; CHECK-NEXT:    [[EL_PTR:%.*]] = getelementptr i32, ptr [[P:%.*]], i32 [[IV]]
; CHECK-NEXT:    [[EL:%.*]] = load i32, ptr [[EL_PTR]], align 4
; CHECK-NEXT:    [[BOUND_CHECK:%.*]] = icmp slt i32 [[EL]], 128
; CHECK-NEXT:    br i1 [[BOUND_CHECK]], label [[DO_RANGE_CHECK:%.*]], label [[BOUND_CHECK_FAILED:%.*]]
; CHECK:       do_range_check:
; CHECK-NEXT:    [[RANGE_CHECK_SLE:%.*]] = icmp sge i32 [[LEN]], [[EL]]
; CHECK-NEXT:    [[WC:%.*]] = call i1 @llvm.experimental.widenable.condition()
; CHECK-NEXT:    [[EXPLICIT_GUARD_COND:%.*]] = and i1 [[RANGE_CHECK_SLE]], [[WC]]
; CHECK-NEXT:    br i1 [[EXPLICIT_GUARD_COND]], label [[BACKEDGE]], label [[DEOPT:%.*]]
; CHECK:       backedge:
; CHECK-NEXT:    [[ARR_PTR:%.*]] = getelementptr i32, ptr [[ARR:%.*]], i32 [[EL]]
; CHECK-NEXT:    store i32 [[IV]], ptr [[ARR_PTR]], align 4
; CHECK-NEXT:    [[IV_NEXT]] = add i32 [[IV]], 1
; CHECK-NEXT:    [[LOOP_COND:%.*]] = icmp ult i32 [[IV_NEXT]], [[N:%.*]]
; CHECK-NEXT:    br i1 [[LOOP_COND]], label [[LOOP]], label [[EXIT:%.*]]
; CHECK:       deopt:
; CHECK-NEXT:    [[DEOPT_RES:%.*]] = call i32 (...) @llvm.experimental.deoptimize.i32() [ "deopt"() ]
; CHECK-NEXT:    ret i32 [[DEOPT_RES]]
; CHECK:       exit:
; CHECK-NEXT:    ret i32 0
; CHECK:       bound_check_failed:
; CHECK-NEXT:    ret i32 -1
;
entry:
  %len = load i32, ptr %len_p, align 4, !noundef !0, !range !1
  br label %loop

loop:
  %iv = phi i32 [ 0, %entry ], [ %iv.next, %backedge ]
  %el.ptr = getelementptr i32, ptr %p, i32 %iv
  %el = load i32, ptr %el.ptr, align 4
  %bound_check = icmp slt i32 %el, 128
  br i1 %bound_check, label %do_range_check, label %bound_check_failed

do_range_check:
  %range_check.sle = icmp sge i32 %len, %el
  %wc = call i1 @llvm.experimental.widenable.condition()
  %explicit_guard_cond = and i1 %range_check.sle, %wc
  br i1 %explicit_guard_cond, label %backedge, label %deopt

backedge:
  %arr.ptr = getelementptr i32, ptr %arr, i32 %el
  store i32 %iv, ptr %arr.ptr, align 4
  %iv.next = add i32 %iv, 1
  %loop_cond = icmp ult i32 %iv.next, %n
  br i1 %loop_cond, label %loop, label %exit

deopt:
  %deopt_res = call i32 (...) @llvm.experimental.deoptimize.i32() [ "deopt"() ]
  ret i32 %deopt_res

exit:
  ret i32 0

bound_check_failed:
  ret i32 -1
}

; Function Attrs: inaccessiblememonly nocallback nofree nosync nounwind speculatable willreturn
declare i1 @llvm.experimental.widenable.condition() #1

declare i32 @llvm.experimental.deoptimize.i32(...)

attributes #1 = { inaccessiblememonly nocallback nofree nosync nounwind speculatable willreturn }

!0 = !{}
!1 = !{i32 0, i32 2147483646}
