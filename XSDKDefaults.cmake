##################################################################################
#
#                    Set defaults for XSDK CMake projects
#
##################################################################################

#
# This module implements standard behavior for XSDK CMake projects.  It
# changes the default behavior of CMake on a few fronts.  The main thing it
# does by default in XSDK mode is to ignore compiler vars in the env if they
# are set using CC, CXX, FC and compiler flags CFLAGS, CXXFLAGS, and FFLAGS.
#
# This module must be included after
#
#   PROJECT(${PROJECT_NAME}  NONE)
#
# is called but before the compilers are defined and processed using:
#
#   ENABLE_LANGAUGE(<LANG>)
#
# The major downside of this specification is that when USE_XSDK_DEFAULTS=TRUE
# but XSDK_USE_COMPILER_ENV_VARS=FALSE, then the default compilers must be
# searched for here instead of inside of ENABLE_LANGAUGE(<LANG>) .  This is
# because if you go into ENABLE_LANGAUGE(<LANG>) then CMake will set the
# default compilers by reading the env vars.  If you don't like the default
# compilers picked by this module, set XSDK_USE_COMPILER_ENV_VARS=TRUE (which
# is the CMake default anyway).
# 

#
# Helper functions
#

IF (NOT COMMAND PRINT_VAR)
  FUNCTION(PRINT_VAR  VAR_NAME)
    MESSAGE("${VAR_NAME} = '${${VAR_NAME}}'")
  ENDFUNCTION()
ENDIF()


MACRO(XSDK_HANDLE_LANG_DEFAULTS  CMAKE_LANG_NAME  ENV_LANG_NAME  LANG_DEFAULT_COMPILERS)
  
  IF (XSDK_USE_COMPILER_ENV_VARS)

    # Announce using env var ${ENV_LANG_NAME}
    IF (NOT "$ENV{${ENV_LANG_NAME}}" STREQUAL "" AND
      "${CMAKE_${CMAKE_LANG_NAME}_COMPILER}" STREQUAL ""
      )
      MESSAGE("XSDK: Setting CMAKE_${CMAKE_LANG_NAME}_COMPILER from env var"
        " ${ENV_LANG_NAME}='$ENV{${ENV_LANG_NAME}}'!")
      SET(CMAKE_${CMAKE_LANG_NAME}_COMPILER "$ENV{${ENV_LANG_NAME}}" CACHE FILEPATH
        "XSDK: Set by default from env var ${ENV_LANG_NAME}")
    ENDIF()

    # Announce using env var ${ENV_LANG_NAME}FLAGS
    IF (NOT "$ENV{${ENV_LANG_NAME}FLAGS}" STREQUAL "" AND
      "${CMAKE_${CMAKE_LANG_NAME}_FLAGS}" STREQUAL ""
      )
      MESSAGE("XSDK: Setting CMAKE_${CMAKE_LANG_NAME}_FLAGS from env var"
        " ${ENV_LANG_NAME}FLAGS='$ENV{${ENV_LANG_NAME}FLAGS}'!")
      SET(CMAKE_${CMAKE_LANG_NAME}_FLAGS "$ENV{${ENV_LANG_NAME}FLAGS} " CACHE  STRING
        "XSDK: Set by default from env var ${ENV_LANG_NAME}FLAGS")
      # NOTE: CMake adds the space after ${${ENV_LANG_NAME}FLAGS} so we duplicate that here!
    ENDIF()

  ELSE()

    # Ignore env var ${ENV_LANG_NAME}
    IF (NOT "$ENV{${ENV_LANG_NAME}}" STREQUAL "" AND
      "${CMAKE_${CMAKE_LANG_NAME}_COMPILER}" STREQUAL ""
      )
      MESSAGE("XSDK: NOT setting CMAKE_${CMAKE_LANG_NAME}_COMPILER from env var"
        " ${ENV_LANG_NAME}='$ENV{${ENV_LANG_NAME}}'!")
      # Got to find the default C++ compiler so
      # ENABLE_LANGAUGE(${CMAKE_LANG_NAME}) does not pick up the
      # ${ENV_LANG_NAME} set in the env!  No way to avoid this that I can see.
      FIND_PROGRAM(DEFAULT_${CMAKE_LANG_NAME}_COMPILER  NAMES  ${LANG_DEFAULT_COMPILERS})
      SET(CMAKE_${CMAKE_LANG_NAME}_COMPILER "${DEFAULT_${CMAKE_LANG_NAME}_COMPILER}"
        CACHE FILEPATH
        "XSDK: Ignoring default set by env var ${ENV_LANG_NAME}")
    ENDIF()

    # Ignore env var ${CMAKE_LANG_NAME}FLAGS
    IF (NOT "$ENV{${ENV_LANG_NAME}FLAGS}" STREQUAL "" AND
      "${CMAKE_${CMAKE_LANG_NAME}_FLAGS}" STREQUAL ""
      )
      MESSAGE("XSDK: NOT setting CMAKE_${CMAKE_LANG_NAME}_FLAGS from env var"
        " ${ENV_LANG_NAME}FLAGS='$ENV{${ENV_LANG_NAME}FLAGS}'!")
      SET(CMAKE_${CMAKE_LANG_NAME}_FLAGS "" CACHE  STRING
        "XSDK: Ignoring default set by env var ${ENV_LANG_NAME}FLAGS")
    ENDIF()

  ENDIF()


ENDMACRO()


#
# Set XSDK Defaults
#

# USE_XSDK_DEFAULTS
IF ("${USE_XSDK_DEFAULTS_DEFAULT}" STREQUAL "")
  SET(USE_XSDK_DEFAULTS_DEFAULT  FALSE)
ENDIF()
SET(USE_XSDK_DEFAULTS  ${USE_XSDK_DEFAULTS_DEFAULT}  CACHE  BOOL
  "Use XSDK defaults and behavior.")
PRINT_VAR(USE_XSDK_DEFAULTS)

# XSDK_ENABLE_C
SET(XSDK_ENABLE_C  TRUE  CACHE BOOL
  "Handle compiler and options for C")

# XSDK_ENABLE_CXX
SET(XSDK_ENABLE_CXX  TRUE  CACHE BOOL
  "Handle compiler and options for C++")

# XSDK_ENABLE_Fortran
SET(XSDK_ENABLE_Fortran  TRUE  CACHE BOOL
  "Handle compiler and options for Fortran")

# Set default compilers and flags
IF (USE_XSDK_DEFAULTS)

  SET(XSDK_USE_COMPILER_ENV_VARS  FALSE  CACHE  BOOL
    "When in XSDK mode, read defaults for compilers and flags from env.")
  PRINT_VAR(XSDK_USE_COMPILER_ENV_VARS)

  # Handle env vars for lanaguages C, C++, and Fortran

#  IF (XSDK_ENABLE_C)
#    XSDK_HANDLE_LANG_DEFAULTS(C  CC  "cc;gcc")
#  ENDIF()

  IF (XSDK_ENABLE_CXX)
    XSDK_HANDLE_LANG_DEFAULTS(CXX  CXX  "c++;g++")
  ENDIF()

#  IF (XSDK_ENABLE_Fotran)
#    XSDK_HANDLE_LANG_DEFAULTS(Fortran  FC  "gfortran;f90")
#  ENDIF()
  
  # Set XSDK defaults for other CMake variables
  
  IF ("${BUILD_SHARED_LIBS}"  STREQUAL  "")
    MESSAGE("XSDK: Setting default for BUILD_SHARED_LIBS to TRUE!")
    SET(BUILD_SHARED_LIBS  TRUE  CACHE  BOOL  "Set by default in XSDK mode")
  ENDIF()
  
  IF ("${CMAKE_BUILD_TYPE}"  STREQUAL  "")
    MESSAGE("XSDK: Setting default for CMAKE_BUILD_TYPE to DEBUG!")
    SET(CMAKE_BUILD_TYPE  DEBUG  CACHE  STRING  "Set by default in XSDK mode")
  ENDIF()

ENDIF()
