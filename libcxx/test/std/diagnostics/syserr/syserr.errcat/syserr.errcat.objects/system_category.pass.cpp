//===----------------------------------------------------------------------===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

// <system_error>

// class error_category

// const error_category& system_category();

// XFAIL: suse-linux-enterprise-server-11
// XFAIL: centos-6.10
// XFAIL: with_system_cxx_lib=macosx10.12
// XFAIL: with_system_cxx_lib=macosx10.11
// XFAIL: with_system_cxx_lib=macosx10.10
// XFAIL: with_system_cxx_lib=macosx10.9
// XFAIL: with_system_cxx_lib=macosx10.7
// XFAIL: with_system_cxx_lib=macosx10.8

#include <system_error>
#include <cassert>
#include <string>
#include <cerrno>

#include "test_macros.h"

void test_message_for_bad_value() {
    errno = E2BIG; // something that message will never generate
    const std::error_category& e_cat1 = std::system_category();
    const std::string msg = e_cat1.message(-1);
    // Exact message format varies by platform.
    LIBCPP_ASSERT(msg.starts_with("Unknown error"));
    assert(errno == E2BIG);
}

int main(int, char**)
{
    const std::error_category& e_cat1 = std::system_category();
    std::error_condition e_cond = e_cat1.default_error_condition(5);
    assert(e_cond.value() == 5);
    assert(e_cond.category() == std::generic_category());
    e_cond = e_cat1.default_error_condition(5000);
    assert(e_cond.value() == 5000);
    assert(e_cond.category() == std::system_category());
    {
        test_message_for_bad_value();
    }

  return 0;
}
