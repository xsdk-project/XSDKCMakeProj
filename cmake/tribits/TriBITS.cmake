
IF (${PROJECT_NAME}_TRIBITS_DIR)
  SET(TRIBITS_BASE_DIR_LOCAL "${${PROJECT_NAME}_TRIBITS_DIR}")
ELSEIF(CMAKE_CURRENT_LIST_DIR)
  SET(TRIBITS_BASE_DIR_LOCAL "${CMAKE_CURRENT_LIST_DIR}")
ELSE()
  MESSAGE(FATAL_ERROR "Please set ${PROJECT_NAME}_TRIBITS_DIR"
    " or use a CMake version older than 2.8.5!")
ENDIF()

INCLUDE("${TRIBITS_BASE_DIR_LOCAL}/core/package_arch/TribitsProject.cmake")
INCLUDE("${TRIBITS_BASE_DIR_LOCAL}/Version.cmake")