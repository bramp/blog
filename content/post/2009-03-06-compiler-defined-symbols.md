---
title: Compiler defined symbols
author: bramp
layout: post
date: 2009-03-06
categories:
  - Blog
tags:
  - defines
  - FreeBSD
  - gcc
  - Linux
aliases:
  - /blog/2009/03/06/compiler-defined-symbols/
---
I found this neat little command to list all the GCC compiler defined symbols

```bash
gcc -dM -E - > /dev/null
```

This can help if you aren't quite sure which defines are used on your systems. For example my FreeBSD 7.1 machine outputs this:

```c
#define __DBL_MIN_EXP__ (-1021)
#define __FLT_MIN__ 1.17549435e-38F
#define __DEC64_DEN__ 0.000000000000001E-383DD
#define __CHAR_BIT__ 8
#define __WCHAR_MAX__ 2147483647
#define __DBL_DENORM_MIN__ 4.9406564584124654e-324
#define __FLT_EVAL_METHOD__ 0
#define __DBL_MIN_10_EXP__ (-307)
#define __FINITE_MATH_ONLY__ 0
#define __DEC64_MAX_EXP__ 384
#define __SHRT_MAX__ 32767
#define __LDBL_MAX__ 1.18973149535723176502e+4932L
#define __UINTMAX_TYPE__ long unsigned int
#define __DEC32_EPSILON__ 1E-6DF
#define __unix 1
#define __SCHAR_MAX__ 127
#define __USER_LABEL_PREFIX__
#define __STDC_HOSTED__ 1
#define __DEC64_MIN_EXP__ (-383)
#define __DBL_DIG__ 15
#define __FLT_EPSILON__ 1.19209290e-7F
#define __LDBL_MIN__ 3.36210314311209350626e-4932L
#define __DEC32_MAX__ 9.999999E96DF
#define __unix__ 1
#define __DECIMAL_DIG__ 21
#define __LDBL_HAS_QUIET_NAN__ 1
#define __GNUC__ 4
#define __MMX__ 1
#define __FLT_HAS_DENORM__ 1
#define __FreeBSD_cc_version 700003
#define __DBL_MAX__ 1.7976931348623157e+308
#define __DBL_HAS_INFINITY__ 1
#define __DEC32_MIN_EXP__ (-95)
#define __LDBL_HAS_DENORM__ 1
#define __DEC32_MIN__ 1E-95DF
#define __DBL_MAX_EXP__ 1024
#define __DEC128_EPSILON__ 1E-33DL
#define __SSE2_MATH__ 1
#define __amd64 1
#define __LONG_LONG_MAX__ 9223372036854775807LL
#define __GXX_ABI_VERSION 1002
#define __FLT_MIN_EXP__ (-125)
#define __x86_64 1
#define __DBL_MIN__ 2.2250738585072014e-308
#define __LP64__ 1
#define __DBL_HAS_QUIET_NAN__ 1
#define __DEC128_MIN__ 1E-6143DL
#define __REGISTER_PREFIX__
#define __DBL_HAS_DENORM__ 1
#define __NO_INLINE__ 1
#define __DEC_EVAL_METHOD__ 2
#define __DEC128_MAX__ 9.999999999999999999999999999999999E6144DL
#define __FLT_MANT_DIG__ 24
#define __VERSION__ "4.2.1 20070719  [FreeBSD]"
#define __DEC64_EPSILON__ 1E-15DD
#define __DEC128_MIN_EXP__ (-6143)
#define unix 1
#define __SIZE_TYPE__ long unsigned int
#define __DEC32_DEN__ 0.000001E-95DF
#define __ELF__ 1
#define __FLT_RADIX__ 2
#define __LDBL_EPSILON__ 1.08420217248550443401e-19L
#define __FreeBSD__ 7
#define __SSE_MATH__ 1
#define __k8 1
#define __LDBL_DIG__ 18
#define __KPRINTF_ATTRIBUTE__ 1
#define __x86_64__ 1
#define __FLT_HAS_QUIET_NAN__ 1
#define __FLT_MAX_10_EXP__ 38
#define __LONG_MAX__ 9223372036854775807L
#define __FLT_HAS_INFINITY__ 1
#define __DEC64_MAX__ 9.999999999999999E384DD
#define __DEC64_MANT_DIG__ 16
#define __DEC32_MAX_EXP__ 96
#define __DEC128_DEN__ 0.000000000000000000000000000000001E-6143DL
#define __LDBL_MANT_DIG__ 64
#define _LONGLONG 1
#define __DEC32_MANT_DIG__ 7
#define __k8__ 1
#define __WCHAR_TYPE__ int
#define __FLT_DIG__ 6
#define __INT_MAX__ 2147483647
#define __FLT_MAX_EXP__ 128
#define __DBL_MANT_DIG__ 53
#define __DEC64_MIN__ 1E-383DD
#define __WINT_TYPE__ unsigned int
#define __SSE__ 1
#define __LDBL_MIN_EXP__ (-16381)
#define __amd64__ 1
#define __LDBL_MAX_EXP__ 16384
#define __LDBL_MAX_10_EXP__ 4932
#define __DBL_EPSILON__ 2.2204460492503131e-16
#define _LP64 1
#define __GNUC_PATCHLEVEL__ 1
#define __LDBL_HAS_INFINITY__ 1
#define __INTMAX_MAX__ 9223372036854775807L
#define __FLT_DENORM_MIN__ 1.40129846e-45F
#define __FLT_MAX__ 3.40282347e+38F
#define __SSE2__ 1
#define __FLT_MIN_10_EXP__ (-37)
#define __INTMAX_TYPE__ long int
#define __DEC128_MAX_EXP__ 6144
#define __GNUC_MINOR__ 2
#define __DBL_MAX_10_EXP__ 308
#define __LDBL_DENORM_MIN__ 3.64519953188247460253e-4951L
#define __STDC__ 1
#define __PTRDIFF_TYPE__ long int
#define __DEC128_MANT_DIG__ 34
#define __LDBL_MIN_10_EXP__ (-4931)
#define __GNUC_GNU_INLINE__ 1
```

and my Debian Linux machine outputs this:

```c
#define __DBL_MIN_EXP__ (-1021)
#define __FLT_MIN__ 1.17549435e-38F
#define __DEC64_DEN__ 0.000000000000001E-383DD
#define __CHAR_BIT__ 8
#define __WCHAR_MAX__ 2147483647
#define __GCC_HAVE_SYNC_COMPARE_AND_SWAP_1 1
#define __GCC_HAVE_SYNC_COMPARE_AND_SWAP_2 1
#define __GCC_HAVE_SYNC_COMPARE_AND_SWAP_4 1
#define __DBL_DENORM_MIN__ 4.9406564584124654e-324
#define __GCC_HAVE_SYNC_COMPARE_AND_SWAP_8 1
#define __FLT_EVAL_METHOD__ 0
#define __unix__ 1
#define __x86_64 1
#define __DBL_MIN_10_EXP__ (-307)
#define __FINITE_MATH_ONLY__ 0
#define __GNUC_PATCHLEVEL__ 3
#define __DEC64_MAX_EXP__ 384
#define __SHRT_MAX__ 32767
#define __LDBL_MAX__ 1.18973149535723176502e+4932L
#define __UINTMAX_TYPE__ long unsigned int
#define __linux 1
#define __DEC32_EPSILON__ 1E-6DF
#define __unix 1
#define __LDBL_MAX_EXP__ 16384
#define __linux__ 1
#define __SCHAR_MAX__ 127
#define __DBL_DIG__ 15
#define __SIZEOF_INT__ 4
#define __SIZEOF_POINTER__ 8
#define __USER_LABEL_PREFIX__
#define __STDC_HOSTED__ 1
#define __LDBL_HAS_INFINITY__ 1
#define __FLT_EPSILON__ 1.19209290e-7F
#define __LDBL_MIN__ 3.36210314311209350626e-4932L
#define __DEC32_MAX__ 9.999999E96DF
#define __SIZEOF_LONG__ 8
#define __DECIMAL_DIG__ 21
#define __gnu_linux__ 1
#define __LDBL_HAS_QUIET_NAN__ 1
#define __GNUC__ 4
#define __MMX__ 1
#define __FLT_HAS_DENORM__ 1
#define __SIZEOF_LONG_DOUBLE__ 16
#define __DBL_MAX__ 1.7976931348623157e+308
#define __DBL_HAS_INFINITY__ 1
#define __DEC32_MIN_EXP__ (-95)
#define __LDBL_HAS_DENORM__ 1
#define __DEC128_MAX__ 9.999999999999999999999999999999999E6144DL
#define __DEC32_MIN__ 1E-95DF
#define __DBL_MAX_EXP__ 1024
#define __DEC128_EPSILON__ 1E-33DL
#define __SSE2_MATH__ 1
#define __amd64 1
#define __LONG_LONG_MAX__ 9223372036854775807LL
#define __SIZEOF_SIZE_T__ 8
#define __SIZEOF_WINT_T__ 4
#define __GXX_ABI_VERSION 1002
#define __FLT_MIN_EXP__ (-125)
#define __DBL_MIN__ 2.2250738585072014e-308
#define __LP64__ 1
#define __DECIMAL_BID_FORMAT__ 1
#define __DEC128_MIN__ 1E-6143DL
#define __REGISTER_PREFIX__
#define __DBL_HAS_DENORM__ 1
#define __NO_INLINE__ 1
#define __FLT_MANT_DIG__ 24
#define __VERSION__ "4.3.3"
#define __DEC64_EPSILON__ 1E-15DD
#define __DEC128_MIN_EXP__ (-6143)
#define unix 1
#define __SIZE_TYPE__ long unsigned int
#define __DEC32_DEN__ 0.000001E-95DF
#define __ELF__ 1
#define __FLT_RADIX__ 2
#define __LDBL_EPSILON__ 1.08420217248550443401e-19L
#define __SSE_MATH__ 1
#define __k8 1
#define __SIZEOF_PTRDIFF_T__ 8
#define __x86_64__ 1
#define __FLT_HAS_QUIET_NAN__ 1
#define __FLT_MAX_10_EXP__ 38
#define __LONG_MAX__ 9223372036854775807L
#define __FLT_HAS_INFINITY__ 1
#define __DEC64_MAX__ 9.999999999999999E384DD
#define __DEC64_MANT_DIG__ 16
#define __DEC32_MAX_EXP__ 96
#define linux 1
#define __DEC128_DEN__ 0.000000000000000000000000000000001E-6143DL
#define __SSE2__ 1
#define __LDBL_MANT_DIG__ 64
#define __DBL_HAS_QUIET_NAN__ 1
#define __k8__ 1
#define __WCHAR_TYPE__ int
#define __SIZEOF_FLOAT__ 4
#define __DEC64_MIN_EXP__ (-383)
#define __FLT_DIG__ 6
#define __INT_MAX__ 2147483647
#define __amd64__ 1
#define __FLT_MAX_EXP__ 128
#define __DBL_MANT_DIG__ 53
#define __DEC64_MIN__ 1E-383DD
#define __WINT_TYPE__ unsigned int
#define __SIZEOF_SHORT__ 2
#define __SSE__ 1
#define __LDBL_MIN_EXP__ (-16381)
#define __LDBL_MAX_10_EXP__ 4932
#define __DBL_EPSILON__ 2.2204460492503131e-16
#define _LP64 1
#define __SIZEOF_WCHAR_T__ 4
#define __DEC_EVAL_METHOD__ 2
#define __INTMAX_MAX__ 9223372036854775807L
#define __FLT_DENORM_MIN__ 1.40129846e-45F
#define __FLT_MAX__ 3.40282347e+38F
#define __SIZEOF_DOUBLE__ 8
#define __FLT_MIN_10_EXP__ (-37)
#define __INTMAX_TYPE__ long int
#define __DEC128_MAX_EXP__ 6144
#define __GNUC_MINOR__ 3
#define __DEC32_MANT_DIG__ 7
#define __DBL_MAX_10_EXP__ 308
#define __LDBL_DENORM_MIN__ 3.64519953188247460253e-4951L
#define __STDC__ 1
#define __PTRDIFF_TYPE__ long int
#define __DEC128_MANT_DIG__ 34
#define __LDBL_MIN_10_EXP__ (-4931)
#define __SIZEOF_LONG_LONG__ 8
#define __LDBL_DIG__ 18
#define __GNUC_GNU_INLINE__ 1
```