

INCLUDE(TribitsTplFindIncludeDirsAndLibraries)
INCLUDE(TribitsGeneralMacros)

INCLUDE(AppendStringVar)


FUNCTION(TRIBITS_PROCESS_ENABLED_TPL  TPL_NAME)

  SET(PROCESSING_MSG_STRING "Processing enabled TPL: ${TPL_NAME} (")
  IF (TPL_${TPL_NAME}_ENABLING_PKG)
    APPEND_STRING_VAR(PROCESSING_MSG_STRING
      "enabled by ${TPL_${TPL_NAME}_ENABLING_PKG}," )
  ELSE()
    APPEND_STRING_VAR(PROCESSING_MSG_STRING
      "enabled explicitly," )
  ENDIF()
    APPEND_STRING_VAR(PROCESSING_MSG_STRING 
      " disable with -DTPL_ENABLE_${TPL_NAME}=OFF)" )

  MESSAGE("${PROCESSING_MSG_STRING}")

  IF (NOT ${PROJECT_NAME}_TRACE_DEPENDENCY_HANDLING_ONLY)

    IF (${PROJECT_NAME}_VERBOSE_CONFIGURE)
      PRINT_VAR(${TPL_NAME}_FINDMOD)
      PRINT_VAR(${TPL_NAME}_TPLS_LIST_FILE)
    ENDIF()
    IF (IS_ABSOLUTE ${${TPL_NAME}_FINDMOD})
      SET(CURRENT_TPL_PATH "${${TPL_NAME}_FINDMOD}")
    ELSE()
      SET(CURRENT_TPL_PATH "${PROJECT_SOURCE_DIR}/${${TPL_NAME}_FINDMOD}")
    ENDIF()

    TRIBITS_TRACE_FILE_PROCESSING(TPL  INCLUDE  "${CURRENT_TPL_PATH}")
    INCLUDE("${CURRENT_TPL_PATH}")

    IF (TPL_${TPL_NAME}_NOT_FOUND AND NOT TPL_TENTATIVE_ENABLE_${TPL_NAME})
      MESSAGE(
        "-- NOTE: The find module file for this failed TPL '${TPL_NAME}' is:\n"
        "     ${CURRENT_TPL_PATH}\n"
        "   which is pointed to in the file:\n"
        "     ${${TPL_NAME}_TPLS_LIST_FILE}\n"
        )
      IF (TPL_${TPL_NAME}_ENABLING_PKG)
        MESSAGE(
          "TIP: One way to get past the configure failure for the\n"
          "TPL '${TPL_NAME}' is to simply disable it with:\n"
          "  -DTPL_ENABLE_${TPL_NAME}=OFF\n"
          "which will disable it and will recursively disable all of the\n"
          "downstream packages that have required dependencies on it, including\n"
          "the package '${TPL_${TPL_NAME}_ENABLING_PKG}' which triggered its enable.\n"
          "When you reconfigure, just grep the cmake stdout for '${TPL_NAME}'\n"
          "and then follow the disables that occur as a result to see what impact\n"
          "this TPL disable has on the configuration of ${PROJECT_NAME}.\n"
          )
      ELSE()
        MESSAGE(
          "TIP: Even though the TPL '${TPL_NAME}' was explicitly enabled in input,\n"
          "it can be disabled with:\n"
          "  -DTPL_ENABLE_${TPL_NAME}=OFF\n"
          "which will disable it and will recursively disable all of the\n"
          "downstream packages that have required dependencies on it.\n"
          "When you reconfigure, just grep the cmake stdout for '${TPL_NAME}'\n"
          "and then follow the disables that occur as a result to see what impact\n"
          "this TPL disable has on the configuration of ${PROJECT_NAME}.\n"
          )
      ENDIF()
      MESSAGE(FATAL_ERROR
        "ERROR: TPL_${TPL_NAME}_NOT_FOUND=${TPL_${TPL_NAME}_NOT_FOUND}, aborting!")
    ENDIF()

    ASSERT_DEFINED(TPL_${TPL_NAME}_INCLUDE_DIRS)
    ASSERT_DEFINED(TPL_${TPL_NAME}_LIBRARIES)
    ASSERT_DEFINED(TPL_${TPL_NAME}_LIBRARY_DIRS)

  ENDIF()

ENDFUNCTION()
