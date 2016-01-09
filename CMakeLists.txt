#
# Testing driver project for XSDK CMake specification
#
# See README.rst for details.
#

CMAKE_MINIMUM_REQUIRED(VERSION 2.8.11)

SET(PROJECT_NAME XSDKCMakeProj)

SET(CMAKE_DEFAULT_C_COMPILER_NAME  gcc  CACHE  STRING
  "Default name of the C compiler so that CMake does not find 'cc' by default!")
SET(CMAKE_C_COMPILER  gcc)

PROJECT(${PROJECT_NAME}  C  CXX  Fortran)

SET(C_COMPILER_1  "/usr/bin/cc"  CACHE FILEPATH
  "First valid C compiler to test with" )
SET(C_COMPILER_2  "/usr/bin/gcc"  CACHE FILEPATH
  "Second valid C compiler to test with" )
SET(C_DEFAULT_COMPILER  "${CMAKE_C_COMPILER}")

SET(CXX_COMPILER_1  "/usr/bin/c++"  CACHE FILEPATH
  "First valid C++ compiler to test with" )
SET(CXX_COMPILER_2  "/usr/bin/g++"  CACHE FILEPATH
  "Second valid C++ compiler to test with" )
SET(CXX_DEFAULT_COMPILER  "${CMAKE_CXX_COMPILER}")

SET(Fortran_COMPILER_1  "/usr/bin/f95"  CACHE FILEPATH
  "First valid Fortran compiler to test with" )
SET(Fortran_COMPILER_2  "/usr/bin/gfortran"  CACHE FILEPATH
  "Second valid Fortran compiler to test with" )
SET(Fortran_DEFAULT_COMPILER  "${CMAKE_Fortran_COMPILER}")

# Pull in TriBITS so we can use TRIBITS_ADD_ADVANCED_TEST() and some other
# functions (but this is *not* a TriBITS project).
SET(${PROJECT_NAME}_TRIBITS_DIR  "${CMAKE_CURRENT_SOURCE_DIR}/cmake/tribits"
 CACHE  PATH  "Set in CMakeLists.txt" )
INCLUDE("${${PROJECT_NAME}_TRIBITS_DIR}/TriBITS.cmake")

INCLUDE(CTest)
ENABLE_TESTING()


#
# Print compilers
#

PRINT_VAR(C_COMPILER_1)
PRINT_VAR(C_COMPILER_2)
PRINT_VAR(C_DEFAULT_COMPILER)

PRINT_VAR(CXX_COMPILER_1)
PRINT_VAR(CXX_COMPILER_2)
PRINT_VAR(CXX_DEFAULT_COMPILER)

PRINT_VAR(Fortran_COMPILER_1)
PRINT_VAR(Fortran_COMPILER_2)
PRINT_VAR(Fortran_DEFAULT_COMPILER)


#
# Check compiler vars
#

FUNCTION(CHECK_LANG_COMPILER_DEFAULTS  LANG)

  IF (${LANG}_COMPILER_1  STREQUAL  "")
    MESSAGE(FATAL_ERROR "ERROR: Must set ${LANG}_COMPILER_1!")
  ENDIF()
  
  IF (${LANG}_COMPILER_2  STREQUAL  "")
    MESSAGE(FATAL_ERROR "ERROR: Must set ${LANG}_COMPILER_2!")
  ENDIF()
  
  IF (${LANG}_DEFAULT_COMPILER  STREQUAL  "")
    MESSAGE(FATAL_ERROR "ERROR: A default compiler must be find!")
  ENDIF()
  
  IF (${LANG}_COMPILER_1  STREQUAL  ${LANG}_COMPILER_2)
    MESSAGE(FATAL_ERROR "ERROR: ${LANG}_COMPILER_1 and ${LANG}_COMPILER_2 must be different!")
  ENDIF()
  
  IF (${LANG}_COMPILER_1  STREQUAL  ${LANG}_DEFAULT_COMPILER)
    MESSAGE(FATAL_ERROR "ERROR: ${LANG}_COMPILER_1 and ${LANG}_DEFAULT_COMPILER must be different!")
  ENDIF()
  
  IF (${LANG}_COMPILER_2  STREQUAL  ${LANG}_DEFAULT_COMPILER)
    MESSAGE(FATAL_ERROR "ERROR: ${LANG}_COMPILER_2 and ${LANG}_DEFAULT_COMPILER must be different!")
  ENDIF()

ENDFUNCTION()

CHECK_LANG_COMPILER_DEFAULTS(C)
CHECK_LANG_COMPILER_DEFAULTS(CXX)
CHECK_LANG_COMPILER_DEFAULTS(Fortran)


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
# Define a function to do a test using TRIBITS_ADD_ADVANCED_TEST()
#

INCLUDE(TribitsAddAdvancedTest)

FUNCTION( ADD_XSDK_TEST_CASE  TEST_NAME
  USE_XSDK_DEFAULTS
  ENV_C_TO_USE  ENV_C_FLAGS_TO_USE
  CMAKE_C_TO_USE  CMAKE_C_FLAGS_TO_USE
  ENV_CXX_TO_USE  ENV_CXX_FLAGS_TO_USE
  CMAKE_CXX_TO_USE  CMAKE_CXX_FLAGS_TO_USE
  ENV_Fortran_TO_USE  ENV_Fortran_FLAGS_TO_USE
  CMAKE_Fortran_TO_USE  CMAKE_Fortran_FLAGS_TO_USE
  )
 
  SET(EXAMPLE_DRIVER_PROJ_DIR  "${CMAKE_CURRENT_SOURCE_DIR}/example_driver")

  SET(PASS_REGEX_STR_ARRAY)  
  FOREACH(PASS_REGEX_STR  ${ARGN})
    REPLACE_REGEX_CHARS_WITH_BRACKET_CHARS("${PASS_REGEX_STR}"
      PASS_REGEX_STRING)
    LIST(APPEND PASS_REGEX_STR_ARRAY "${PASS_REGEX_STRING}")
  ENDFOREACH()

  SET(CMND_ARGS)

  IF (USE_XSDK_DEFAULTS)
    LIST(APPEND  CMND_ARGS  -DUSE_XSDK_DEFAULTS=${USE_XSDK_DEFAULTS})
  ENDIF()

  IF (CMAKE_C_TO_USE)
    LIST(APPEND  CMND_ARGS  -DCMAKE_C_COMPILER=${CMAKE_C_TO_USE})
  ENDIF()
  IF (CMAKE_C_FLAGS_TO_USE)
    LIST(APPEND  CMND_ARGS  -DCMAKE_C_FLAGS=${CMAKE_C_FLAGS_TO_USE})
  ENDIF()

  IF (CMAKE_CXX_TO_USE)
    LIST(APPEND  CMND_ARGS  -DCMAKE_CXX_COMPILER=${CMAKE_CXX_TO_USE})
  ENDIF()
  IF (CMAKE_CXX_FLAGS_TO_USE)
    LIST(APPEND  CMND_ARGS  -DCMAKE_CXX_FLAGS=${CMAKE_CXX_FLAGS_TO_USE})
  ENDIF()

  IF (CMAKE_Fortran_TO_USE)
    LIST(APPEND  CMND_ARGS  -DCMAKE_Fortran_COMPILER=${CMAKE_Fortran_TO_USE})
  ENDIF()
  IF (CMAKE_Fortran_FLAGS_TO_USE)
    LIST(APPEND  CMND_ARGS  -DCMAKE_Fortran_FLAGS=${CMAKE_Fortran_FLAGS_TO_USE})
  ENDIF()

#  MESSAGE("${TEST_NAME}: CMND_ARGS: ${CMND_ARGS}")

  TRIBITS_ADD_ADVANCED_TEST(${TEST_NAME}
    OVERALL_WORKING_DIRECTORY  TEST_NAME
    TEST_0
      CMND  ${CMAKE_COMMAND}
      ARGS  ${CMND_ARGS}
        ${EXAMPLE_DRIVER_PROJ_DIR}
      PASS_REGULAR_EXPRESSION_ALL
        ${PASS_REGEX_STR_ARRAY}
    ENVIRONMENT
      CC=${ENV_C_TO_USE}  CFLAGS=${ENV_C_FLAGS_TO_USE}
      CXX=${ENV_CXX_TO_USE}  CXXFLAGS=${ENV_CXX_FLAGS_TO_USE}
      FC=${ENV_Fortran_TO_USE}  FFLAGS=${ENV_Fortran_FLAGS_TO_USE}
    )

ENDFUNCTION()


#
# Test cases NoUseXsdkDefaults
# 

ADD_XSDK_TEST_CASE( NoUseXsdkDefaults_none_none
  FALSE
  ""  ""
  ""  ""
  ""  ""
  ""  ""
  ""  ""
  ""  ""
  "Before XSDK: CMAKE_C_COMPILER = ''"
  "Before XSDK: CMAKE_C_FLAGS = ''"
  "Before XSDK: CMAKE_CXX_COMPILER = ''"
  "Before XSDK: CMAKE_CXX_FLAGS = ''"
  "Before XSDK: CMAKE_Fortran_COMPILER = ''"
  "Before XSDK: CMAKE_Fortran_FLAGS = ''"
  "Before XSDK: BUILD_SHARED_LIBS = ''"
  "Before XSDK: CMAKE_BUILD_TYPE = ''"
  "Before XSDK: CMAKE_C_COMPILER = ''"
  "Before XSDK: CMAKE_CXX_COMPILER = ''"
  "Before XSDK: CMAKE_Fortran_COMPILER = ''"
  "USE_XSDK_DEFAULTS = 'FALSE'"
  "Before EL: CMAKE_C_COMPILER = ''"
  "Before EL: CMAKE_C_FLAGS = ''"
  "Before EL: CMAKE_CXX_COMPILER = ''"
  "Before EL: CMAKE_CXX_FLAGS = ''"
  "Before EL: CMAKE_Fortran_COMPILER = ''"
  "Before EL: CMAKE_Fortran_FLAGS = ''"
  "Before EL: BUILD_SHARED_LIBS = ''"
  "Before EL: CMAKE_BUILD_TYPE = ''"
  "Setting CMAKE_C_COMPILER=gcc so that CMake finds the default"
  "After EL: CMAKE_C_COMPILER = '${C_DEFAULT_COMPILER}'"
  "After EL: CMAKE_C_FLAGS = ''"
  "After EL: CMAKE_CXX_COMPILER = '${CXX_DEFAULT_COMPILER}'"
  "After EL: CMAKE_CXX_FLAGS = ''"
  "After EL: CMAKE_Fortran_COMPILER = '${Fortran_DEFAULT_COMPILER}'"
  "After EL: CMAKE_Fortran_FLAGS = ''"
  "After EL: BUILD_SHARED_LIBS = ''"
  "After EL: CMAKE_BUILD_TYPE = ''"
  )
  # Above just demonsgrates what the raw behavior of CMake when no CMake vars
  # and not env vars are passed in.

ADD_XSDK_TEST_CASE( NoUseXsdkDefaults_env1_none
  FALSE
  "${C_COMPILER_1}"  "-O0"
  ""  ""
  "${CXX_COMPILER_1}"  "-O1"
  ""  ""
  "${Fortran_COMPILER_1}"  "-O2"
  ""  ""
  "Before XSDK: CMAKE_C_COMPILER = ''"
  "Before XSDK: CMAKE_C_FLAGS = ''"
  "Before XSDK: CMAKE_CXX_COMPILER = ''"
  "Before XSDK: CMAKE_CXX_FLAGS = ''"
  "Before XSDK: CMAKE_Fortran_COMPILER = ''"
  "Before XSDK: CMAKE_Fortran_FLAGS = ''"
  "Before EL: CMAKE_C_COMPILER = ''"
  "Before EL: CMAKE_C_FLAGS = ''"
  "Before EL: CMAKE_CXX_COMPILER = ''"
  "Before EL: CMAKE_CXX_FLAGS = ''"
  "Before EL: CMAKE_Fortran_COMPILER = ''"
  "Before EL: CMAKE_Fortran_FLAGS = ''"
  "After EL: CMAKE_C_COMPILER = '${C_COMPILER_1}'"
  "After EL: CMAKE_C_FLAGS = '-O0 '"
  "After EL: CMAKE_CXX_COMPILER = '${CXX_COMPILER_1}'"
  "After EL: CMAKE_CXX_FLAGS = '-O1 '"
  "After EL: CMAKE_Fortran_COMPILER = '${Fortran_COMPILER_1}'"
  "After EL: CMAKE_Fortran_FLAGS = '-O2 '"
  )
  # Above shows the raw CMake does indeed read the env vars as one would hope.

ADD_XSDK_TEST_CASE( NoUseXsdkDefaults_none_cmake2
  FALSE
  ""  ""
  "${C_COMPILER_2}"  "-O0"
  ""  ""
  "${CXX_COMPILER_2}"  "-O1"
  ""  ""
  "${Fortran_COMPILER_2}"  "-O2"
  "Before XSDK: CMAKE_C_COMPILER = '${C_COMPILER_2}'"
  "Before XSDK: CMAKE_C_FLAGS = '-O0'"
  "Before XSDK: CMAKE_CXX_COMPILER = '${CXX_COMPILER_2}'"
  "Before XSDK: CMAKE_CXX_FLAGS = '-O1'"
  "Before XSDK: CMAKE_Fortran_COMPILER = '${Fortran_COMPILER_2}'"
  "Before XSDK: CMAKE_Fortran_FLAGS = '-O2'"
  "Before EL: CMAKE_C_COMPILER = '${C_COMPILER_2}'"
  "Before EL: CMAKE_C_FLAGS = '-O0'"
  "Before EL: CMAKE_CXX_COMPILER = '${CXX_COMPILER_2}'"
  "Before EL: CMAKE_CXX_FLAGS = '-O1'"
  "Before EL: CMAKE_Fortran_COMPILER = '${Fortran_COMPILER_2}'"
  "Before EL: CMAKE_Fortran_FLAGS = '-O2'"
  "After EL: CMAKE_C_COMPILER = '${C_COMPILER_2}'"
  "After EL: CMAKE_C_FLAGS = '-O0'"
  "After EL: CMAKE_CXX_COMPILER = '${CXX_COMPILER_2}'"
  "After EL: CMAKE_CXX_FLAGS = '-O1'"
  "After EL: CMAKE_Fortran_COMPILER = '${Fortran_COMPILER_2}'"
  "After EL: CMAKE_Fortran_FLAGS = '-O2'"
  )
  # Above shows that raw CMake handles its CMkae vars as you would expect.

ADD_XSDK_TEST_CASE( NoUseXsdkDefaults_env1_cmake2
  FALSE
  "${C_COMPILER_1}"  "-bad-c" # Ignored
  "${C_COMPILER_2}"  "-O0"
  "${CXX_COMPILER_1}"  "-bad-c++"  # Ignored
  "${CXX_COMPILER_2}"  "-O1"
  "${Fortran_COMPILER_1}"  "-bad-fortran"  # Ignored
  "${Fortran_COMPILER_2}"  "-O2"
  "Before XSDK: CMAKE_C_COMPILER = '${C_COMPILER_2}'"
  "Before XSDK: CMAKE_C_FLAGS = '-O0'"
  "Before XSDK: CMAKE_CXX_COMPILER = '${CXX_COMPILER_2}'"
  "Before XSDK: CMAKE_CXX_FLAGS = '-O1'"
  "Before XSDK: CMAKE_Fortran_COMPILER = '${Fortran_COMPILER_2}'"
  "Before XSDK: CMAKE_Fortran_FLAGS = '-O2'"
  "Before EL: CMAKE_C_COMPILER = '${C_COMPILER_2}'"
  "Before EL: CMAKE_C_FLAGS = '-O0'"
  "Before EL: CMAKE_CXX_COMPILER = '${CXX_COMPILER_2}'"
  "Before EL: CMAKE_CXX_FLAGS = '-O1'"
  "Before EL: CMAKE_Fortran_COMPILER = '${Fortran_COMPILER_2}'"
  "Before EL: CMAKE_Fortran_FLAGS = '-O2'"
  "After EL: CMAKE_C_COMPILER = '${C_COMPILER_2}'"
  "After EL: CMAKE_C_FLAGS = '-O0'"
  "After EL: CMAKE_CXX_COMPILER = '${CXX_COMPILER_2}'"
  "After EL: CMAKE_CXX_FLAGS = '-O1'"
  "After EL: CMAKE_Fortran_COMPILER = '${Fortran_COMPILER_2}'"
  "After EL: CMAKE_Fortran_FLAGS = '-O2'"
  )
  # Above shows the with raw CMake, the CMake vars override the env vars, as
  # it should.

#
# Test cases UseXsdkDefaults
# 

ADD_XSDK_TEST_CASE( UseXsdkDefaults_none_none
  TRUE
  ""  ""
  ""  ""
  ""  ""
  ""  ""
  ""  ""
  ""  ""
  "Before XSDK: CMAKE_C_COMPILER = ''"
  "Before XSDK: CMAKE_C_FLAGS = ''"
  "Before XSDK: CMAKE_CXX_COMPILER = ''"
  "Before XSDK: CMAKE_CXX_FLAGS = ''"
  "Before XSDK: CMAKE_Fortran_COMPILER = ''"
  "Before XSDK: CMAKE_Fortran_FLAGS = ''"
  "Before XSDK: BUILD_SHARED_LIBS = ''"
  "Before XSDK: CMAKE_BUILD_TYPE = ''"
  "Before XSDK: CMAKE_C_COMPILER = ''"
  "Before XSDK: CMAKE_CXX_COMPILER = ''"
  "Before XSDK: CMAKE_Fortran_COMPILER = ''"
  "USE_XSDK_DEFAULTS = 'TRUE'"
  "XSDK: Setting default BUILD_SHARED_LIBS=TRUE"
  "XSDK: Setting default CMAKE_BUILD_TYPE=DEBUG"
  "Before EL: CMAKE_C_COMPILER = ''"
  "Before EL: CMAKE_C_FLAGS = ''"
  "Before EL: CMAKE_CXX_COMPILER = ''"
  "Before EL: CMAKE_CXX_FLAGS = ''"
  "Before EL: CMAKE_Fortran_COMPILER = ''"
  "Before EL: CMAKE_Fortran_FLAGS = ''"
  "Before EL: BUILD_SHARED_LIBS = 'TRUE'"
  "Before EL: CMAKE_BUILD_TYPE = 'DEBUG'"
  "Setting CMAKE_C_COMPILER=gcc so that CMake finds the default"
  "After EL: CMAKE_C_COMPILER = '${C_DEFAULT_COMPILER}'"
  "After EL: CMAKE_C_FLAGS = ''"
  "After EL: CMAKE_CXX_COMPILER = '${CXX_DEFAULT_COMPILER}'"
  "After EL: CMAKE_CXX_FLAGS = ''"
  "After EL: CMAKE_Fortran_COMPILER = '${Fortran_DEFAULT_COMPILER}'"
  "After EL: CMAKE_Fortran_FLAGS = ''"
  "After EL: BUILD_SHARED_LIBS = 'TRUE'"
  "After EL: CMAKE_BUILD_TYPE = 'DEBUG'"
  )
  # Above, by default XSDKDefaults.cmake just lets CMake pick the default
  # compilers but it does set BUILD_SHARED_LIBS=TRUE and
  # CMAKE_BUILD_TYPE=DEBUG.

ADD_XSDK_TEST_CASE( UseXsdkDefaults_env1_none
  TRUE
  "${C_COMPILER_1}"  "-O0"
  ""  ""
  "${CXX_COMPILER_1}"  "-O1"
  ""  ""
  "${Fortran_COMPILER_1}"  "-O2"
  ""  ""
  "Before XSDK: CMAKE_C_COMPILER = ''"
  "Before XSDK: CMAKE_C_FLAGS = ''"
  "Before XSDK: CMAKE_CXX_COMPILER = ''"
  "Before XSDK: CMAKE_CXX_FLAGS = ''"
  "Before XSDK: CMAKE_Fortran_COMPILER = ''"
  "Before XSDK: CMAKE_Fortran_FLAGS = ''"
  "XSDK: Setting CMAKE_C_COMPILER from env var CC='${C_COMPILER_1}'!"
  "XSDK: Setting CMAKE_C_FLAGS from env var CFLAGS='-O0'!"
  "XSDK: Setting CMAKE_CXX_COMPILER from env var CXX='${CXX_COMPILER_1}'!"
  "XSDK: Setting CMAKE_CXX_FLAGS from env var CXXFLAGS='-O1'!"
  "XSDK: Setting CMAKE_Fortran_COMPILER from env var FC='${Fortran_COMPILER_1}'!"
  "XSDK: Setting CMAKE_Fortran_FLAGS from env var FFLAGS='-O2'!"
  "Before EL: CMAKE_C_COMPILER = '${C_COMPILER_1}'"
  "Before EL: CMAKE_C_FLAGS = '-O0 '"
  "Before EL: CMAKE_CXX_COMPILER = '${CXX_COMPILER_1}'"
  "Before EL: CMAKE_CXX_FLAGS = '-O1 '"
  "Before EL: CMAKE_Fortran_COMPILER = '${Fortran_COMPILER_1}'"
  "Before EL: CMAKE_Fortran_FLAGS = '-O2 '"
  "After EL: CMAKE_C_COMPILER = '${C_COMPILER_1}'"
  "After EL: CMAKE_C_FLAGS = '-O0 '"
  "After EL: CMAKE_CXX_COMPILER = '${CXX_COMPILER_1}'"
  "After EL: CMAKE_CXX_FLAGS = '-O1 '"
  "After EL: CMAKE_Fortran_COMPILER = '${Fortran_COMPILER_1}'"
  "After EL: CMAKE_Fortran_FLAGS = '-O2 '"
  "After EL: BUILD_SHARED_LIBS = 'TRUE'"
  "After EL: CMAKE_BUILD_TYPE = 'DEBUG'"
  )
  # Above, XSDKDefaults.cmake print out that the env vars are being used and
  # sets the CMake vars before CMake does its default thing.

ADD_XSDK_TEST_CASE( UseXsdkDefaults_none_cmake2
  TRUE
  ""  ""
  "${C_COMPILER_2}"  "-O0"
  ""  ""
  "${CXX_COMPILER_2}"  "-O1"
  ""  ""
  "${Fortran_COMPILER_2}"  "-O2"
  "Before XSDK: CMAKE_C_COMPILER = '${C_COMPILER_2}'"
  "Before XSDK: CMAKE_C_FLAGS = '-O0'"
  "Before XSDK: CMAKE_CXX_COMPILER = '${CXX_COMPILER_2}'"
  "Before XSDK: CMAKE_CXX_FLAGS = '-O1'"
  "Before XSDK: CMAKE_Fortran_COMPILER = '${Fortran_COMPILER_2}'"
  "Before XSDK: CMAKE_Fortran_FLAGS = '-O2'"
  "Before EL: CMAKE_C_COMPILER = '${C_COMPILER_2}'"
  "Before EL: CMAKE_C_FLAGS = '-O0'"
  "Before EL: CMAKE_CXX_COMPILER = '${CXX_COMPILER_2}'"
  "Before EL: CMAKE_CXX_FLAGS = '-O1'"
  "Before EL: CMAKE_Fortran_COMPILER = '${Fortran_COMPILER_2}'"
  "Before EL: CMAKE_Fortran_FLAGS = '-O2'"
  "After EL: CMAKE_C_COMPILER = '${C_COMPILER_2}'"
  "After EL: CMAKE_C_FLAGS = '-O0'"
  "After EL: CMAKE_CXX_COMPILER = '${CXX_COMPILER_2}'"
  "After EL: CMAKE_CXX_FLAGS = '-O1'"
  "After EL: CMAKE_Fortran_COMPILER = '${Fortran_COMPILER_2}'"
  "After EL: CMAKE_Fortran_FLAGS = '-O2'"
  "After EL: BUILD_SHARED_LIBS = 'TRUE'"
  "After EL: CMAKE_BUILD_TYPE = 'DEBUG'"
  )
  # Above, the CMake vars just pass through unaffected by XSDKDefaults.cmake

ADD_XSDK_TEST_CASE( UseXsdkDefaults_env1_cmake2
  TRUE
  "${C_COMPILER_1}"  "-bad-c" # Ignored
  "${C_COMPILER_2}"  "-O0"
  "${CXX_COMPILER_1}"  "-bad-c++"  # Ignored
  "${CXX_COMPILER_2}"  "-O1"
  "${Fortran_COMPILER_1}"  "-bad-fortran"  # Ignored
  "${Fortran_COMPILER_2}"  "-O2"
  "Before XSDK: CMAKE_C_COMPILER = '${C_COMPILER_2}'"
  "Before XSDK: CMAKE_C_FLAGS = '-O0'"
  "Before XSDK: CMAKE_CXX_COMPILER = '${CXX_COMPILER_2}'"
  "Before XSDK: CMAKE_CXX_FLAGS = '-O1'"
  "Before XSDK: CMAKE_Fortran_COMPILER = '${Fortran_COMPILER_2}'"
  "Before XSDK: CMAKE_Fortran_FLAGS = '-O2'"
  "Before EL: CMAKE_C_COMPILER = '${C_COMPILER_2}'"
  "Before EL: CMAKE_C_FLAGS = '-O0'"
  "Before EL: CMAKE_CXX_COMPILER = '${CXX_COMPILER_2}'"
  "Before EL: CMAKE_CXX_FLAGS = '-O1'"
  "Before EL: CMAKE_Fortran_COMPILER = '${Fortran_COMPILER_2}'"
  "Before EL: CMAKE_Fortran_FLAGS = '-O2'"
  "After EL: CMAKE_C_COMPILER = '${C_COMPILER_2}'"
  "After EL: CMAKE_C_FLAGS = '-O0'"
  "After EL: CMAKE_CXX_COMPILER = '${CXX_COMPILER_2}'"
  "After EL: CMAKE_CXX_FLAGS = '-O1'"
  "After EL: CMAKE_Fortran_COMPILER = '${Fortran_COMPILER_2}'"
  "After EL: CMAKE_Fortran_FLAGS = '-O2'"
  "After EL: BUILD_SHARED_LIBS = 'TRUE'"
  "After EL: CMAKE_BUILD_TYPE = 'DEBUG'"
  )
  # Above, the CMake vars override what is in the env with XSDK behavior too
