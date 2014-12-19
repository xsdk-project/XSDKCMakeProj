#
# Testing driver project for XSDK CMake specification
#
# This CMake project should be configured with:
#
#   cmake  -DCXX_COMPILER_1=<fullPathCxx1> \
#     -DCXX_COMPILER_2=<fullPathCxx2> \
#
# and a C++ compiler should be found by default which is different than these
# two compilers given above.  That way we can test the behavior of our mock
# XDSK CMake project.
#

CMAKE_MINIMUM_REQUIRED(VERSION 2.8.11)

PROJECT(XSDKCMakeProj CXX)

SET(CXX_COMPILER_1  ""  CACHE FILEPATH
  "One valid C++ compiler to test with" )

SET(CXX_COMPILER_2  ""  CACHE FILEPATH
  "Second valid C++ compiler to test with" )

# This is the compiler that CMake finds by default
SET(CXX_DEFAUT_COMPILER  "${CMAKE_CXX_COMPILER}")

INCLUDE(CTest)
ENABLE_TESTING()


#
# Replace regex chars with brachet chars
#
FUNCTION(REPLACE_REGEX_CHARS_WITH_BRACKET_CHARS  STR_IN  STR_OUT)

  STRING(LENGTH "${STR_IN}"  STR_IN_LEN)

  SET(IDX 0)
  SET(STR)
  WHILE(IDX  LESS  STR_IN_LEN)

    STRING(SUBSTRING "${STR_IN}" ${IDX}  1  CHAR)

    IF (CHAR  STREQUAL  ".")
      SET(STR  "${STR}[.]")
    ELSEIF (CHAR  STREQUAL  "+")
      SET(STR  "${STR}[+]")
    ELSE()
      SET(STR  "${STR}${CHAR}")
    ENDIF()

    MATH(EXPR  IDX  "${IDX} + 1")

  ENDWHILE()

  SET(${STR_OUT} ${STR} PARENT_SCOPE)

ENDFUNCTION()



#
# Define a function to do a test
#

FUNCTION( ADD_XSDK_TEST_CASE  TEST_NAME
  ENV_CXX_TO_USE  CMAKE_CXX_TO_USE
  USE_XSDK_DEFAULTS  GET_COMPILER_DEFAULTS_FROM_ENV
  PASS_MATCH_STRING
  )
 
  SET(EXAMPLE_DRIVER_PROJ_DIR  "${CMAKE_CURRENT_SOURCE_DIR}/example_driver")

  SET(TEST_DIR  "${CMAKE_CURRENT_BINARY_DIR}/${TEST_NAME}")

  # Remove then create the test directroy
  IF (EXISTS ${TEST_DIR})
    FILE(REMOVE_RECURSE ${TEST_DIR})
  ENDIF()
  FILE(MAKE_DIRECTORY ${TEST_DIR})

  ADD_TEST (${TEST_NAME}
    ${CMAKE_COMMAND}
    ${EXAMPLE_DRIVER_PROJ_DIR}
    )

  REPLACE_REGEX_CHARS_WITH_BRACKET_CHARS("${PASS_MATCH_STRING}"
    PASS_REGEX_STRING)
   MESSAGE("PASS_REGEX_STRING = '${PASS_REGEX_STRING}'")

  SET_TESTS_PROPERTIES(${TEST_NAME} PROPERTIES
    WORKING_DIRECTORY  "${TEST_DIR}"  
    PASS_REGULAR_EXPRESSION  "${PASS_REGEX_STRING}"  
    )

ENDFUNCTION()


#
# Define the test cases
# 

ADD_XSDK_TEST_CASE(RawDefaults  ""  ""  FALSE  FALSE
  "CMAKE_CXX_COMPILER = ${CXX_DEFAUT_COMPILER}"
#  "CMAKE_CXX_COMPILER = /projects/vera/gcc-4[.]6[.]1/toolset/gcc-4[.]6[.]1/bin/c[+][+]"
  )
