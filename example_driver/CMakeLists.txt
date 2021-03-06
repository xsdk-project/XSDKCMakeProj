#
# This is a dummy CMake project for testing XSDKDefaults.cmake
#
# But this is also simple enough that it can be a concrete example on how to
# and where to include XSDKDefaults.cmake.
#

CMAKE_MINIMUM_REQUIRED(VERSION 2.8.11)

#
# Helper functions
#

FUNCTION(PRINT_VAR_W_PREFIX  PREFIX_STR  VAR_NAME)
  MESSAGE("${PREFIX_STR}: ${VAR_NAME} = '${${VAR_NAME}}'")
ENDFUNCTION()

FUNCTION(PRINT_XSDK_RELATED_VARS  PREFIX_STR)
  PRINT_VAR_W_PREFIX("${PREFIX_STR}"  CMAKE_C_COMPILER)
  PRINT_VAR_W_PREFIX("${PREFIX_STR}"  CMAKE_C_FLAGS)
  PRINT_VAR_W_PREFIX("${PREFIX_STR}"  CMAKE_C_FLAGS_DEBUG)
  PRINT_VAR_W_PREFIX("${PREFIX_STR}"  CMAKE_C_FLAGS_RELEASE)
  PRINT_VAR_W_PREFIX("${PREFIX_STR}"  CMAKE_CXX_COMPILER)
  PRINT_VAR_W_PREFIX("${PREFIX_STR}"  CMAKE_CXX_FLAGS)
  PRINT_VAR_W_PREFIX("${PREFIX_STR}"  CMAKE_CXX_FLAGS_DEBUG)
  PRINT_VAR_W_PREFIX("${PREFIX_STR}"  CMAKE_CXX_FLAGS_RELEASE)
  PRINT_VAR_W_PREFIX("${PREFIX_STR}"  CMAKE_Fortran_COMPILER)
  PRINT_VAR_W_PREFIX("${PREFIX_STR}"  CMAKE_Fortran_FLAGS)
  PRINT_VAR_W_PREFIX("${PREFIX_STR}"  CMAKE_Fortran_FLAGS_DEBUG)
  PRINT_VAR_W_PREFIX("${PREFIX_STR}"  CMAKE_Fortran_FLAGS_RELEASE)
  PRINT_VAR_W_PREFIX("${PREFIX_STR}"  BUILD_SHARED_LIBS)
  PRINT_VAR_W_PREFIX("${PREFIX_STR}"  CMAKE_BUILD_TYPE)
ENDFUNCTION()

#
# Example/test driver project
#

# Define the project but don't allow the compilers to be enabled yet
PROJECT(XSDKExampleProj  NONE)

MESSAGE("\nPrint variables before applying XSDK defaults:")
PRINT_XSDK_RELATED_VARS("Before XSDK")

MESSAGE("\nProcess XSDK defaults ...")
INCLUDE("${CMAKE_CURRENT_LIST_DIR}/../xsdk/XSDKDefaults.cmake")

MESSAGE("\nPrint variables after applying XSDK defaults but before enable lang:")
PRINT_XSDK_RELATED_VARS("Before EL")

IF ("${CMAKE_C_COMPILER}" STREQUAL "" AND "$ENV{CC}" STREQUAL "")
  MESSAGE("Setting CMAKE_C_COMPILER=gcc so that CMake finds the default"
    " gcc compiler in the default path before finding the standard C compiler"
    " /usr/bin/cc")
  SET(CMAKE_C_COMPILER gcc)
ENDIF()

MESSAGE("\n*** Call ENABLE_LANGUAGE(C) ...\n")
ENABLE_LANGUAGE(C)

MESSAGE("\n*** Call ENABLE_LANGUAGE(CXX) ...\n")
ENABLE_LANGUAGE(CXX)

MESSAGE("\n*** Call ENABLE_LANGUAGE(Fortran) ...\n")
ENABLE_LANGUAGE(Fortran)

MESSAGE("\nPrint variables after enable lang:")
PRINT_XSDK_RELATED_VARS("After EL")
