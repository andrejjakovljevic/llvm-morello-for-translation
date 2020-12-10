#!/usr/bin/env python

import glob
import os
import posixpath
import re


def get_libcxx_paths():
    utils_path = os.path.dirname(os.path.abspath(__file__))
    script_name = os.path.basename(__file__)
    assert os.path.exists(utils_path)
    src_root = os.path.dirname(utils_path)
    include_path = os.path.join(src_root, 'include')
    assert os.path.exists(include_path)
    libcxx_test_path = os.path.join(src_root, 'test', 'libcxx')
    assert os.path.exists(libcxx_test_path)
    return script_name, src_root, include_path, libcxx_test_path


script_name, source_root, include_path, libcxx_test_path = get_libcxx_paths()

header_markup = {
    "atomic": ["ifndef _LIBCPP_HAS_NO_THREADS"],
    "barrier": ["ifndef _LIBCPP_HAS_NO_THREADS"],
    "future": ["ifndef _LIBCPP_HAS_NO_THREADS"],
    "latch": ["ifndef _LIBCPP_HAS_NO_THREADS"],
    "mutex": ["ifndef _LIBCPP_HAS_NO_THREADS"],
    "shared_mutex": ["ifndef _LIBCPP_HAS_NO_THREADS"],
    "semaphore": ["ifndef _LIBCPP_HAS_NO_THREADS"],
    "thread": ["ifndef _LIBCPP_HAS_NO_THREADS"],

    "clocale": ["ifndef _LIBCPP_HAS_NO_LOCALIZATION"],
    "codecvt": ["ifndef _LIBCPP_HAS_NO_LOCALIZATION"],
    "fstream": ["ifndef _LIBCPP_HAS_NO_LOCALIZATION"],
    "iomanip": ["ifndef _LIBCPP_HAS_NO_LOCALIZATION"],
    "ios": ["ifndef _LIBCPP_HAS_NO_LOCALIZATION"],
    "iostream": ["ifndef _LIBCPP_HAS_NO_LOCALIZATION"],
    "istream": ["ifndef _LIBCPP_HAS_NO_LOCALIZATION"],
    "locale": ["ifndef _LIBCPP_HAS_NO_LOCALIZATION"],
    "locale.h": ["ifndef _LIBCPP_HAS_NO_LOCALIZATION"],
    "ostream": ["ifndef _LIBCPP_HAS_NO_LOCALIZATION"],
    "regex": ["ifndef _LIBCPP_HAS_NO_LOCALIZATION"],
    "sstream": ["ifndef _LIBCPP_HAS_NO_LOCALIZATION"],
    "streambuf": ["ifndef _LIBCPP_HAS_NO_LOCALIZATION"],
    "strstream": ["ifndef _LIBCPP_HAS_NO_LOCALIZATION"],

    "experimental/coroutine": ["if defined(__cpp_coroutines)"],
    "experimental/regex": ["ifndef _LIBCPP_HAS_NO_LOCALIZATION"],
}

allowed_extensions = ['', '.h']
indent_width = 4


begin_pattern = """\
////////////////////////////////////////////////////////////////////////////////
// BEGIN-GENERATED-HEADERS
////////////////////////////////////////////////////////////////////////////////
"""

warning_note = """\
// WARNING: This test was generated by {script_name}
// and should not be edited manually.

""".format(script_name=script_name)

end_pattern = """\
////////////////////////////////////////////////////////////////////////////////
// END-GENERATED-HEADERS
////////////////////////////////////////////////////////////////////////////////
"""

generated_part_pattern = re.compile(re.escape(begin_pattern) + ".*" + re.escape(end_pattern),
                                    re.MULTILINE | re.DOTALL)

headers_template = """\
// Top level headers
{top_level_headers}

// experimental headers
#if __cplusplus >= 201103L
{experimental_headers}
#endif // __cplusplus >= 201103L

// extended headers
{extended_headers}
"""


def should_keep_header(p, exclusions=None):
    if os.path.isdir(p):
        return False

    if exclusions:
        relpath = os.path.relpath(p, include_path)
        relpath = posixpath.join(*os.path.split(relpath))
        if relpath in exclusions:
            print('Excluded file:', relpath)
            return False

    return os.path.splitext(p)[1] in allowed_extensions


def produce_include(relpath, indent_level, post_include=None):
    relpath = posixpath.join(*os.path.split(relpath))
    template = "{preambule}#{indentation}include <{include}>{post_include}{postambule}"

    base_indentation = ' '*(indent_width * indent_level)
    next_indentation = base_indentation + ' '*(indent_width)
    post_include = "\n{}".format(post_include) if post_include else ''

    markup = header_markup.get(relpath, None)
    if markup:
        preambule = '#{indentation}{directive}\n'.format(
            directive=markup[0],
            indentation=base_indentation,
        )
        postambule = '\n#{indentation}endif'.format(
            indentation=base_indentation,
        )
        indentation = next_indentation
    else:
        preambule = ''
        postambule = ''
        indentation = base_indentation

    return template.format(
        include=relpath,
        post_include=post_include,
        preambule=preambule,
        postambule=postambule,
        indentation=indentation,
    )


def produce_headers(path_parts, indent_level, post_include=None, exclusions=None):
    pattern = os.path.join(*path_parts, '[a-z]*')

    include_headers = glob.glob(pattern, recursive=False)

    include_headers = [
        produce_include(os.path.relpath(p, include_path),
                        indent_level, post_include=post_include)
        for p in include_headers
        if should_keep_header(p, exclusions)]

    return '\n'.join(include_headers)


def produce_top_level_headers(post_include=None, exclusions=None):
    return produce_headers([include_path], 0, post_include=post_include, exclusions=exclusions)


def produce_experimental_headers(post_include=None, exclusions=None):
    return produce_headers([include_path, 'experimental'], 1, post_include=post_include, exclusions=exclusions)


def produce_extended_headers(post_include=None, exclusions=None):
    return produce_headers([include_path, 'ext'], 0, post_include=post_include, exclusions=exclusions)


def replace_generated_headers(test_path, test_str):
    with open(test_path, 'r') as f:
        content = f.read()

    preambule = begin_pattern + '\n// clang-format off\n\n' + warning_note
    postambule = '\n// clang-format on\n\n' + end_pattern
    content = generated_part_pattern.sub(
        preambule + test_str + postambule, content)

    with open(test_path, 'w') as f:
        f.write(content)


def produce_test(test_filename, exclusions=None, post_include=None):
    test_str = headers_template.format(
        top_level_headers=produce_top_level_headers(
            post_include=post_include,
            exclusions=exclusions,
        ),
        experimental_headers=produce_experimental_headers(
            post_include=post_include,
        ),
        extended_headers=produce_extended_headers(
            post_include=post_include,
        ),
    )

    replace_generated_headers(os.path.join(
        libcxx_test_path, test_filename), test_str)


def main():
    produce_test('double_include.sh.cpp')
    produce_test('min_max_macros.compile.pass.cpp',
                 post_include='TEST_MACROS();')
    produce_test('no_assert_include.compile.pass.cpp',
                 exclusions=['cassert'])


if __name__ == '__main__':
    main()
