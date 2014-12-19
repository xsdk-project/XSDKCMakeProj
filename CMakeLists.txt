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
# Print var
#
FUNCTION(PRINT_VAR  VAR_NAME)
  MESSAGE("${VAR_NAME} = '${${VAR_NAME}}'")
ENDFUNCTION()


#
# Print compilers
#

PRINT_VAR(CXX_COMPILER_1)
PRINT_VAR(CXX_COMPILER_2)
PRINT_VAR(CXX_DEFAUT_COMPILER)


#
# Check compiler vars
#

IF (CXX_COMPILER_1  STREQUAL  "")
  MESSAGE(FATAL_ERROR "ERROR: Must set CXX_COMPILER_1!")
ENDIF()

IF (CXX_COMPILER_2  STREQUAL  "")
  MESSAGE(FATAL_ERROR "ERROR: Must set CXX_COMPILER_2!")
ENDIF()

IF (CXX_DEFAUT_COMPILER  STREQUAL  "")
  MESSAGE(FATAL_ERROR "ERROR: A default compiler must be find!")
ENDIF()

IF (CXX_COMPILER_1  STREQUAL  CXX_COMPILER_2)
  MESSAGE(FATAL_ERROR "ERROR: CXX_COMPILER_1 and CXX_COMPILER_2 must be different!")
ENDIF()

IF (CXX_COMPILER_1  STREQUAL  CXX_DEFAUT_COMPILER)
  MESSAGE(FATAL_ERROR "ERROR: CXX_COMPILER_1 and CXX_DEFAUT_COMPILER must be different!")
ENDIF()

IF (CXX_COMPILER_2  STREQUAL  CXX_DEFAUT_COMPILER)
  MESSAGE(FATAL_ERROR "ERROR: CXX_COMPILER_2 and CXX_DEFAUT_COMPILER must be different!")
ENDIF()


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
  USE_XSDK_DEFAULTS  XSDK_USE_COMPILER_ENV_VARS
  ENV_CXX_TO_USE  CMAKE_CXX_TO_USE
  PASS_MATCH_STRING
  )
 
  SET(EXAMPLE_DRIVER_PROJ_DIR  "${CMAKE_CURRENT_SOURCE_DIR}/example_driver")

  SET(TEST_DIR  "${CMAKE_CURRENT_BINARY_DIR}/${TEST_NAME}")

  # Remove then create the test directroy
  IF (EXISTS ${TEST_DIR})
    FILE(REMOVE_RECURSE ${TEST_DIR})
  ENDIF()
  FILE(MAKE_DIRECTORY ${TEST_DIR})

  IF (CMAKE_CXX_TO_USE)
    SET(CMAKE_CXX_TO_USE_ARGS  -DCMAKE_CXX_COMPILER=${CMAKE_CXX_TO_USE})
  ENDIF()

  ADD_TEST (${TEST_NAME}
    ${CMAKE_COMMAND}
    -DUSE_XSDK_DEFAULTS=${USE_XSDK_DEFAULTS}
    -DXSDK_USE_COMPILER_ENV_VARS=${XSDK_USE_COMPILER_ENV_VARS}
    ${CMAKE_CXX_TO_USE_ARGS}
    ${EXAMPLE_DRIVER_PROJ_DIR}
    )

  REPLACE_REGEX_CHARS_WITH_BRACKET_CHARS("${PASS_MATCH_STRING}"
    PASS_REGEX_STRING)

  SET_TESTS_PROPERTIES(${TEST_NAME} PROPERTIES
    WORKING_DIRECTORY  "${TEST_DIR}"  
    PASS_REGULAR_EXPRESSION  "${PASS_REGEX_STRING}"  
    ENVIRONMENT CXX=${ENV_CXX_TO_USE}
    )

ENDFUNCTION()


#
# Test cases NoUseXsdkDefaults_NoUseCompilerEnvVars
# 

ADD_XSDK_TEST_CASE( NoUseXsdkDefaults_NoUseCompilerEnvVars_none_none
  FALSE  FALSE
  ""  ""
  "After: CMAKE_CXX_COMPILER = '${CXX_DEFAUT_COMPILER}'"
  )

ADD_XSDK_TEST_CASE( NoUseXsdkDefaults_NoUseCompilerEnvVars_cxx1_none
  FALSE  FALSE
  "${CXX_COMPILER_1}"  ""
  "After: CMAKE_CXX_COMPILER = '${CXX_COMPILER_1}'"
  )

ADD_XSDK_TEST_CASE( NoUseXsdkDefaults_NoUseCompilerEnvVars_none_cxx2
  FALSE  FALSE
  ""  "${CXX_COMPILER_2}"
  "After: CMAKE_CXX_COMPILER = '${CXX_COMPILER_2}'"
  )

ADD_XSDK_TEST_CASE( NoUseXsdkDefaults_NoUseCompilerEnvVars_cxx1_cxx2
  FALSE  FALSE
  "${CXX_COMPILER_1}"  "${CXX_COMPILER_2}"
  "After: CMAKE_CXX_COMPILER = '${CXX_COMPILER_2}'"
  )


#
# Test cases UseXsdkDefaults_NoUseCompilerEnvVars
# 

ADD_XSDK_TEST_CASE( UseXsdkDefaults_NoUseCompilerEnvVars_none_none
  TRUE  FALSE
  ""  ""
  "After: CMAKE_CXX_COMPILER = '${CXX_DEFAUT_COMPILER}'"
  )

ADD_XSDK_TEST_CASE( UseXsdkDefaults_NoUseCompilerEnvVars_cxx1_none
  TRUE  FALSE
  "${CXX_COMPILER_1}"  ""
  "After: CMAKE_CXX_COMPILER = '${CXX_DEFAUT_COMPILER}'"
  )

ADD_XSDK_TEST_CASE( UseXsdkDefaults_NoUseCompilerEnvVars_none_cxx2
  TRUE  FALSE
  ""  "${CXX_COMPILER_2}"
  "After: CMAKE_CXX_COMPILER = '${CXX_COMPILER_2}'"
  )

ADD_XSDK_TEST_CASE( UseXsdkDefaults_NoUseCompilerEnvVars_cxx1_cxx2
  TRUE  FALSE
  "${CXX_COMPILER_1}"  "${CXX_COMPILER_2}"
  "After: CMAKE_CXX_COMPILER = '${CXX_COMPILER_2}'"
  )


#
# Test cases UseXsdkDefaults_UseCompilerEnvVars
# 

ADD_XSDK_TEST_CASE( UseXsdkDefaults_UseCompilerEnvVars_none_none
  TRUE  TRUE
  ""  ""
  "After: CMAKE_CXX_COMPILER = '${CXX_DEFAUT_COMPILER}'"
  )

ADD_XSDK_TEST_CASE( UseXsdkDefaults_UseCompilerEnvVars_cxx1_none
  TRUE  TRUE
  "${CXX_COMPILER_1}"  ""
  "After: CMAKE_CXX_COMPILER = '${CXX_COMPILER_1}'"
  )

ADD_XSDK_TEST_CASE( UseXsdkDefaults_UseCompilerEnvVars_none_cxx2
  TRUE  TRUE
  ""  "${CXX_COMPILER_2}"
  "After: CMAKE_CXX_COMPILER = '${CXX_COMPILER_2}'"
  )

ADD_XSDK_TEST_CASE( UseXsdkDefaults_UseCompilerEnvVars_cxx1_cxx2
  TRUE  TRUE
  "${CXX_COMPILER_1}"  "${CXX_COMPILER_2}"
  "After: CMAKE_CXX_COMPILER = '${CXX_COMPILER_2}'"
  )
