
INCLUDE(GlobalSet)

FUNCTION(FORTRAN_MANGLING)

  IF(NOT DEFINED FC_FN_CASE)

    IF (${PROJECT_NAME}_VERBOSE_CONFIGURE)
      MESSAGE("FORTRAN_MANGLING: Testing name Mangling Schemes!\n")
    ENDIF()

    FIND_FILE(_fcmakelists fmangle/ ${CMAKE_MODULE_PATH})
    IF (NOT _fcmakelists)
      MESSAGE(STATUS "Error, the directory fmangle could not be found so we can not determine Fortran name mangling!")
      RETURN()
    ENDIF()

    SET(_fcmangledir ${PROJECT_BINARY_DIR}/CMakeFiles/CMakeTmp/fmangle)
    FILE(MAKE_DIRECTORY ${_fcmangledir})

    FOREACH(cdef LOWER UPPER)

      FOREACH(udef UNDER NO_UNDER SECOND_UNDER)

        IF (${PROJECT_NAME}_VERBOSE_CONFIGURE)
          MESSAGE("FORTRAN_MANGLING: Testing ${cdef} ${udef}\n\n")
        ENDIF()

        SET(_fcmangledir_case "${_fcmangledir}/${cdef}/${udef}")
        FILE(MAKE_DIRECTORY "${_fcmangledir}/${cdef}")
        FILE(MAKE_DIRECTORY ${_fcmangledir_case})

        SET(COMMON_DEFS -DFC_FN_${cdef} -DFC_FN_${udef})
        SET(C_FLAGS "${CMAKE_C_FLAGS} ${${PROJECT_NAME}_EXTRA_LINK_FLAGS}")
        SET(F_FLAGS "${CMAKE_Fortran_FLAGS} ${${PROJECT_NAME}_EXTRA_LINK_FLAGS}")
        TRY_COMPILE(_fcmngl ${_fcmangledir_case} ${_fcmakelists} fmangle
          CMAKE_FLAGS
            "-DCMAKE_BUILD_TYPE:STRING=${CMAKE_BUILD_TYPE}"
            "-DCMAKE_C_FLAGS:STRING=${C_FLAGS}"
            "-DCMAKE_C_FLAGS_${CMAKE_BUILD_TYPE}:STRING=${CMAKE_C_FLAGS_${CMAKE_BUILD_TYPE}}"
            "-DCMAKE_Fortran_FLAGS:STRING=${F_FLAGS}"
            "-DCMAKE_Fortran_FLAGS_${CMAKE_BUILD_TYPE}:STRING=${CMAKE_Fortran_FLAGS_${CMAKE_BUILD_TYPE}}"
            "-DCOMMON_DEFS=${COMMON_DEFS}"
          OUTPUT_VARIABLE _fcmngl_output
          )
        IF (${PROJECT_NAME}_VERBOSE_CONFIGURE)
          MESSAGE("${_fcmngl_output}\n\n")
        ENDIF()

        IF(_fcmngl)
          IF (${PROJECT_NAME}_VERBOSE_CONFIGURE)
            MESSAGE("FORTRAN_MANGLING: Bingo!  ${cdef} ${udef} is the correct fortran name mangling!\n")
          ENDIF()
          GLOBAL_SET(FC_FN_CASE ${cdef})
          GLOBAL_SET(FC_FN_UNDERSCORE ${udef})
          BREAK()
        ENDIF()

      ENDFOREACH()

      IF(_fcmngl)
        BREAK()
      ENDIF()

    ENDFOREACH()

    IF(_fcmngl)
      MESSAGE(STATUS "Fortran name mangling: ${FC_FN_CASE} ${FC_FN_UNDERSCORE}")
    ELSE()
      MESSAGE(STATUS "Warning, cannot automatically determine Fortran mangling.")
    ENDIF()

  ENDIF()

  IF (FC_FN_CASE STREQUAL LOWER)
    SET(FC_NAME_NAME name)
  ELSEIF (FC_FN_CASE STREQUAL UPPER)
    SET(FC_NAME_NAME NAME)
  ENDIF()

  IF (FC_FN_UNDERSCORE)
    IF(FC_FN_UNDERSCORE STREQUAL "UNDER")
      SET(FC_FUNC_DEFAULT "(name,NAME) ${FC_NAME_NAME} ## _" CACHE INTERNAL "")
      SET(FC_FUNC__DEFAULT "(name,NAME) ${FC_NAME_NAME} ## _" CACHE INTERNAL "")
    ELSEIF(FC_FN_UNDERSCORE STREQUAL "SECOND_UNDER")
      SET(FC_FUNC_DEFAULT "(name,NAME) ${FC_NAME_NAME} ## _" CACHE INTERNAL "")
      SET(FC_FUNC__DEFAULT "(name,NAME) ${FC_NAME_NAME} ## __" CACHE INTERNAL "")
    ELSE()
      SET(FC_FUNC_DEFAULT "(name,NAME) ${FC_NAME_NAME}" CACHE INTERNAL "")
      SET(FC_FUNC__DEFAULT "(name,NAME) ${FC_NAME_NAME}" CACHE INTERNAL "")
    ENDIF()
  ENDIF()

ENDFUNCTION()



