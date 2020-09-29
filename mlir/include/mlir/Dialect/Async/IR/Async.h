//===- Async.h - MLIR Async dialect -----------------------------*- C++ -*-===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//
//
// This file defines the async dialect that is used for modeling asynchronous
// execution.
//
//===----------------------------------------------------------------------===//

#ifndef MLIR_DIALECT_ASYNC_IR_ASYNC_H
#define MLIR_DIALECT_ASYNC_IR_ASYNC_H

#include "mlir/IR/Dialect.h"
#include "mlir/IR/OpDefinition.h"
#include "mlir/IR/OpImplementation.h"
#include "mlir/Interfaces/SideEffectInterfaces.h"

namespace mlir {
namespace async {

/// The token type to represent asynchronous operation completion.
class TokenType : public Type::TypeBase<TokenType, Type, TypeStorage> {
public:
  using Base::Base;
};

} // namespace async
} // namespace mlir

#define GET_OP_CLASSES
#include "mlir/Dialect/Async/IR/AsyncOps.h.inc"

#include "mlir/Dialect/Async/IR/AsyncOpsDialect.h.inc"

#endif // MLIR_DIALECT_ASYNC_IR_ASYNC_H
