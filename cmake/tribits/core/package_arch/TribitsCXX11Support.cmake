
INCLUDE(CheckCXXSourceCompiles)


FUNCTION(TRIBITS_FIND_CXX11_FLAGS)


  IF(NOT ${PROJECT_NAME}_CXX11_FLAGS)

     MESSAGE("-- " "Search for C++11 compiler flag ...")
     INCLUDE(CheckCXXSourceCompiles)

     SET(CXX11_FLAG_OPTIONS
       "-std=c++11"    # intel/clang linux/mac
       "-std=c++0x"    # Older gcc
       "-std=gnu++11"  # gcc
       "/Qstd=c++11"   # intel windows
       )

     SET(TSOURCE
        "
        int main() {
          // check >> closing brackets
          std::vector<std::vector<float>> vecvecfloat(1);
          vecvecfloat[0].resize(1);
          vecvecfloat[0][0] = 0.0f;
          std::vector<int> vec(10);
          auto b        = vec.begin();
          decltype(b) e = vec.end();
          std::fill(b,e,1);
          // two examples, taken from the wikipedia article on C++0x :)
          std::vector<int> some_list;
          int total = 0;
          int value = 5;
          std::for_each(some_list.begin(), some_list.end(), [&total](int x) {
              total += x;
              });
          std::for_each(some_list.begin(), some_list.end(), [&, value](int x) {
              total += x * value;
              });
          return 0;
        }
        "
     )


     SET(TOPTION_IDX "0")
     FOREACH( TOPTION ${CXX11_FLAG_OPTIONS})

        IF(${PROJECT_NAME}_VERBOSE_CONFIGURE OR TRIBITS_ENABLE_CXX11_DEBUG_DUMP)
          MESSAGE("-- " "Testing C++11 flag: ${TOPTION}")
        ENDIF()

        SET(CMAKE_REQUIRED_FLAGS "${CMAKE_CXX_FLAGS} ${TOPTION}")

        SET(CXX11_FLAGS_COMPILE_RESULT_VAR CXX11_FLAGS_COMPILE_RESULT_${TOPTION_IDX})

        CHECK_CXX_SOURCE_COMPILES("${TSOURCE}" ${CXX11_FLAGS_COMPILE_RESULT_VAR}
           FAIL_REGEX "unrecognized .*option"                     # GNU
           FAIL_REGEX "unrecognized .*option"                     # GNU
           FAIL_REGEX "ignoring unknown option"                   # MSVC
           FAIL_REGEX "warning D9002"                             # MSVC, any lang
           FAIL_REGEX "[Uu]nknown option"                         # HP
           FAIL_REGEX "[Ww]arning: [Oo]ption"                     # SunPro
           FAIL_REGEX "command option .* is not recognized"       # XL
        )

        IF(${CXX11_FLAGS_COMPILE_RESULT_VAR})
          MESSAGE("-- " "Successful C++11 flag: '${TOPTION}'")
          ADVANCED_SET(${PROJECT_NAME}_CXX11_FLAGS ${TOPTION}
            CACHE STRING
            "Special C++ compiler flags to turn on C++11 support.  Determined automatically by default."
            )
          BREAK()
        ENDIF()

        MATH(EXPR TOPTION_IDX "${TOPTION_IDX}+1")

     ENDFOREACH()

  ELSE()

     MESSAGE("-- " "C++11 Flags already set: '${${PROJECT_NAME}_CXX11_FLAGS}'")

  ENDIF()

ENDFUNCTION()



FUNCTION(TRIBITS_CHECK_CXX11_SUPPORT VARNAME)

  INCLUDE(CheckCXXSourceCompiles)

  IF (${PROJECT_NAME}_CXX11_FLAGS)
    SET(CMAKE_REQUIRED_FLAGS "${CMAKE_REQUIRED_FLAGS} ${${PROJECT_NAME}_CXX11_FLAGS}")
  ENDIF()

  SET(SOURCE_CXX11_CONSECUTIVE_RIGHT_ANGLE_BRACKETS
  "
int main() {
  // check >> closing brackets
  std::vector<std::vector<float>> vecvecfloat(1);
  vecvecfloat[0].resize(1);
  vecvecfloat[0][0] = 0.0f;
  return 0;
}
  "
  )
  CHECK_CXX_SOURCE_COMPILES("${SOURCE_CXX11_CONSECUTIVE_RIGHT_ANGLE_BRACKETS}"
    CXX11_CONSECUTIVE_RIGHT_ANGLE_BRACKETS)

  SET(SOURCE_CXX11_AUTOTYPEDVARIABLES
  "
int main() {
  std::vector<int> vec(10);
  auto b        = vec.begin();
  decltype(b) e = vec.end();
  std::fill(b,e,1);
  return 0;
}
  "
  )
  CHECK_CXX_SOURCE_COMPILES("${SOURCE_CXX11_AUTOTYPEDVARIABLES}"
    CXX11_AUTOTYPEDVARIABLES)

  SET(SOURCE_CXX11_LAMBDAS
  "
int main() {
  // two examples, taken from the wikipedia article on C++0x :)
  std::vector<int> some_list;
  int total = 0;
  int value = 5;
  std::for_each(some_list.begin(), some_list.end(), [&total](int x) {
      total += x;
      });
  std::for_each(some_list.begin(), some_list.end(), [&, value](int x) {
      total += x * value;
      });
  //
  return 0;
}
  "
  )

  CHECK_CXX_SOURCE_COMPILES("${SOURCE_CXX11_LAMBDAS}" CXX11_LAMBDAS)

  IF (NOT CXX11_CONSECUTIVE_RIGHT_ANGLE_BRACKETS OR
    NOT CXX11_AUTOTYPEDVARIABLES OR
    NOT CXX11_LAMBDAS
    )
    SET(${VARNAME} FALSE PARENT_SCOPE)
  ELSE()
    SET(${VARNAME} TRUE PARENT_SCOPE)
  ENDIF()

ENDFUNCTION()
