
SET(${PROJECT_NAME}_TRIBITS_DIR "${CMAKE_CURRENT_SOURCE_DIR}/cmake/tribits"
  CACHE PATH
  "The base directory pointing to the TriBITS system.  If provided as a relative path (formatted as STRING) then will be set to '${CMAKE_CURRENT_SOURCE_DIR}/'.  NOTE: If you leave off the STRING datatype, and it is a relative path, then it will be interpreted as relative to the build directory!"
  )
MARK_AS_ADVANCED(${PROJECT_NAME}_TRIBITS_DIR)

IF (NOT IS_ABSOLUTE "${${PROJECT_NAME}_TRIBITS_DIR}")
  IF (${PROJECT_NAME}_VERBOSE_CONFIGURE)
    MESSAGE("NOTE: ${PROJECT_NAME}_TRIBITS_DIR = '${${PROJECT_NAME}_TRIBITS_DIR}' provided as a relative directory so making this relative to '${CMAKE_CURRENT_SOURCE_DIR}'!")
  ENDIF()
  SET(${PROJECT_NAME}_TRIBITS_DIR
    "${CMAKE_CURRENT_SOURCE_DIR}/${${PROJECT_NAME}_TRIBITS_DIR}")
ENDIF()

IF (${PROJECT_NAME}_VERBOSE_CONFIGURE)
  MESSAGE("${PROJECT_NAME}_TRIBITS_DIR='${${PROJECT_NAME}_TRIBITS_DIR}'")
ENDIF()

SET(CMAKE_MODULE_PATH
   ${${PROJECT_NAME}_TRIBITS_DIR}/core/package_arch
   )

IF (${PROJECT_NAME}_VERBOSE_CONFIGURE)
  MESSAGE("CMAKE_MODULE_PATH='${CMAKE_MODULE_PATH}'")
ENDIF()

INCLUDE(TribitsCMakePolicies)
INCLUDE(TribitsProjectImpl)


MACRO(TRIBITS_PROJECT)
  TRIBITS_PROJECT_IMPL(${ARGN})
ENDMACRO()

