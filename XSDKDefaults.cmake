##################################################################################
#
#                    Set defaults for XSDK CMake projects
#
##################################################################################


FUNCTION(PRINT_VAR  VAR_NAME)
  MESSAGE("${VAR_NAME} = '${${VAR_NAME}}'")
ENDFUNCTION()


# A) Set options

SET(USE_XSDK_DEFAULTS  OFF  CACHE  BOOL
  "Use XSDK defaults and behavior.")

SET(XSDK_USE_COMPILER_ENV_VARS  OFF  CACHE  BOOL
  "When in XSDK mode, read defaults for compilers and flags from env.")

PRINT_VAR(USE_XSDK_DEFAULTS)
PRINT_VAR(XSDK_USE_COMPILER_ENV_VARS)


# B) Determine if to set compiler defaults from env var.

SET(GET_COMPILER_DEFAULTS_FROM_ENV  TRUE)
IF (USE_XSDK_DEFAULTS  AND  NOT  XSDK_USE_COMPILER_ENV_VARS)
  SET(GET_COMPILER_DEFAULTS_FROM_ENV  FALSE)
ENDIF()

# C) Set defaults from env vars if asked and otherwise ignore the env vars
# (which goes against default CMake behavior),

IF (GET_COMPILER_DEFAULTS_FROM_ENV)
  IF (NOT "$ENV{CXX}" STREQUAL "" AND "${CMAKE_CXX_COMPILER}" STREQUAL "")
    MESSAGE("Setting CMAKE_CXX_COMPILER from env var CXX='$ENV{CXX}'!")
    SET(CMAKE_CXX_COMPILER "$ENV{CXX}" CACHE FILEPATH "Set from env var CXX")
  ENDIF()
  # ToDo: Handle $ENV{CXXFLAGS} and CMAKE_CXX_FLAGS
ELSE()
  IF (NOT "$ENV{CXX}" STREQUAL "" AND "${CMAKE_CXX_COMPILER}" STREQUAL "")
    MESSAGE("NOT setting CMAKE_CXX_COMPILER from env var CXX='$ENV{CXX}'!")
    # Got to find the default C++ compiler so ENABLE_LANGAUGE(CXX) does not
    # pick up the CXX set in the env!  No way to avoid this that I can see.
    FIND_PROGRAM(DEFAULT_CXX_COMPILER  NAMES  c++  g++)
    SET(CMAKE_CXX_COMPILER "${DEFAULT_CXX_COMPILER}" CACHE FILEPATH
      "Ignoring default set by env var CXX")
  ENDIF()
  # ToDo: Handle $ENV{CXXFLAGS} and CMAKE_CXX_FLAGS
ENDIF()

# D) Set defaults for other variables

IF (USE_XSDK_DEFAULTS)

  IF ("${BUILD_SHARED_LIBS}"  STREQUAL  "")
    MESSAGE("Setting defalt for BUILD_SHARED_LIBS to TRUE!")
    SET(BUILD_SHARED_LIBS  TRUE  CACHE  BOOL
      "Set by default in XSDK mode")
  ENDIF()

  IF ("${CMAKE_BUILD_TYPE}"  STREQUAL  "")
    MESSAGE("Setting defalt for CMAKE_BUILD_TYPE to DEBUG!")
    SET(CMAKE_BUILD_TYPE  DEBUG  CACHE  STRING
      "Set by default in XSDK mode")
  ENDIF()

ENDIF()
