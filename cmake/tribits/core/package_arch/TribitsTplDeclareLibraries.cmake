
INCLUDE(TribitsTplFindIncludeDirsAndLibraries)

FUNCTION(TRIBITS_TPL_DECLARE_LIBRARIES TPL_NAME)
  MESSAGE(WARNING
    "WARNING: TRIBITS_TPL_DECLARE_LIBRARIES() is deprecated, instead use"
    " TRIBITS_TPL_FIND_INCLUDE_DIRS_AND_LIBRARIES()!"
    "  Make this change in the file:\n"
    "  ${${TPL_NAME}_FINDMOD}\n"
    "which is pointed to by the file:\n"
    "  ${${TPL_NAME}_TPLS_LIST_FILE}\n"
    )
  TRIBITS_TPL_FIND_INCLUDE_DIRS_AND_LIBRARIES(${TPL_NAME} ${ARGN})
ENDFUNCTION()
