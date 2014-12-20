
IF (TribitsTplFindIncludeDirsAndLibraries_INCLUDED)
  RETURN()
ELSE()
  SET(TribitsTplFindIncludeDirsAndLibraries_INCLUDED TRUE)
ENDIF()

INCLUDE(AdvancedSet)
INCLUDE(AppendSet)
INCLUDE(AssertDefined)
INCLUDE(DualScopeSet)
INCLUDE(GlobalNullSet)
INCLUDE(GlobalSet)
INCLUDE(MultilineSet)
INCLUDE(ParseVariableArguments)
INCLUDE(SetNotFound)


FUNCTION(TRIBITS_TPL_FIND_INCLUDE_DIRS_AND_LIBRARIES TPL_NAME)

  ASSERT_DEFINED(TPL_ENABLE_${TPL_NAME})

  PARSE_ARGUMENTS(
     PARSE
     "REQUIRED_HEADERS;REQUIRED_LIBS_NAMES"
     "MUST_FIND_ALL_LIBS;MUST_FIND_ALL_HEADERS;NO_PRINT_ENABLE_SUCCESS_FAIL"
     ${ARGN}
     )

  IF (${PROJECT_NAME}_VERBOSE_CONFIGURE)
    SET(TRIBITS_TPL_FIND_INCLUDE_DIRS_AND_LIBRARIES_VERBOSE TRUE)
  ENDIF()

  IF (TRIBITS_TPL_FIND_INCLUDE_DIRS_AND_LIBRARIES_VERBOSE)
    MESSAGE("TRIBITS_TPL_FIND_INCLUDE_DIRS_AND_LIBRARIES: ${TPL_NAME}")
    PRINT_VAR(PARSE_REQUIRED_HEADERS)
    PRINT_VAR(PARSE_REQUIRED_LIBS_NAMES)
    PRINT_VAR(TPL_${TPL_NAME}_INCLUDE_DIRS)
    PRINT_VAR(TPL_${TPL_NAME}_LIBRARIES)
  ENDIF()

  IF (TPL_TENTATIVE_ENABLE_${TPL_NAME})
    MESSAGE("-- Attempting to tentatively enable TPL '${TPL_NAME}' ...")
    SET(ERROR_MSG_MODE)
  ELSE()
    SET(ERROR_MSG_MODE SEND_ERROR)
  ENDIF()


  IF (PARSE_REQUIRED_LIBS_NAMES)


    MULTILINE_SET(DOCSTR
      "List of semi-colon separated paths to look for the TPL ${TPL_NAME}"
      " libraries.  This list of paths will be passed into a FIND_LIBRARY(...)"
      " command to find the libraries listed in ${TPL_NAME}_LIBRARY_NAMES."
      "  Note that this set of paths is also the default value used for"
      " ${TPL_NAME}_LIBRARY_DIRS.  Therefore, if the headers exist in the"
      " same directories as the library, you do not need to set"
      " ${TPL_NAME}_LIBRARY_DIRS."
      )

    ADVANCED_SET(${TPL_NAME}_LIBRARY_DIRS "" CACHE PATH ${DOCSTR})
    IF (TRIBITS_TPL_FIND_INCLUDE_DIRS_AND_LIBRARIES_VERBOSE)
      PRINT_VAR(${TPL_NAME}_LIBRARY_DIRS)
    ENDIF()


    MULTILINE_SET(DOCSTR
      "List of semi-colon separated names of libraries needed to link to for"
      " the TPL ${TPL_NAME}.  This list of libraries will be search for in"
      " FIND_LIBRARY(...) calls along with the directories specified with"
      " ${TPL_NAME}_LIBRARY_DIRS.  NOTE: This is not the final list of libraries"
      " used for linking.  That is specified by TPL_${TPL_NAME}_LIBRARIES!"
      )
    ADVANCED_SET(${TPL_NAME}_LIBRARY_NAMES ${PARSE_REQUIRED_LIBS_NAMES}
      CACHE STRING ${DOCSTR})

    SET(PARSE_REQUIRED_LIBS_NAMES ${${TPL_NAME}_LIBRARY_NAMES})

    IF (TRIBITS_TPL_FIND_INCLUDE_DIRS_AND_LIBRARIES_VERBOSE)
      PRINT_VAR(${TPL_NAME}_LIBRARY_NAMES)
      PRINT_VAR(PARSE_REQUIRED_LIBS_NAMES)
    ENDIF()

  ELSE()

    SET(${TPL_NAME}_LIBRARY_DIRS) # Just to ignore below!

  ENDIF()


  IF (PARSE_REQUIRED_HEADERS)

    MULTILINE_SET(DOCSTR
      "List of semi-colon separated paths to look for the TPL ${TPL_NAME}"
      " headers.  This list of paths will be passed into a FIND_PATH(...)"
      " command to find the headers for ${TPL_NAME} (which are known in advance)."
      )
    ADVANCED_SET(${TPL_NAME}_INCLUDE_DIRS ${${TPL_NAME}_LIBRARY_DIRS}
      CACHE PATH ${DOCSTR})

    IF (TRIBITS_TPL_FIND_INCLUDE_DIRS_AND_LIBRARIES_VERBOSE)
      PRINT_VAR(${TPL_NAME}_LIBRARY_DIRS)
      PRINT_VAR(${TPL_NAME}_INCLUDE_DIRS)
      PRINT_VAR(PARSE_REQUIRED_HEADERS)
    ENDIF()

  ENDIF()


  IF (NOT CMAKE_FIND_LIBRARY_SUFFIXES_DEFAULT)
   SET(TPL_CMAKE_FIND_LIBRARY_SUFFIXES_DEFAULT ${CMAKE_FIND_LIBRARY_SUFFIXES})
  ENDIF()

  IF (TPL_FIND_SHARED_LIBS)
    SET(TPL_CMAKE_FIND_LIBRARY_SUFFIXES ${TPL_CMAKE_FIND_LIBRARY_SUFFIXES_DEFAULT})
  ELSE()
    IF (WIN32)
      SET(CMAKE_FIND_LIBRARY_SUFFIXES .lib .a)
    ELSE()
      SET(CMAKE_FIND_LIBRARY_SUFFIXES .a )
    ENDIF()
  ENDIF()


  SET(_${TPL_NAME}_ENABLE_SUCCESS TRUE)

  IF (PARSE_REQUIRED_LIBS_NAMES)


    IF (NOT TPL_${TPL_NAME}_LIBRARIES)

      IF (PARSE_MUST_FIND_ALL_LIBS)
        MESSAGE("-- Must find at least one lib in each of the"
          " lib sets \"${PARSE_REQUIRED_LIBS_NAMES}\"")
      ENDIF()

      MESSAGE( "-- Searching for libs in ${TPL_NAME}_LIBRARY_DIRS='${${TPL_NAME}_LIBRARY_DIRS}'")

      SET(LIBRARIES_FOUND)

      FOREACH(LIBNAME_SET ${${TPL_NAME}_LIBRARY_NAMES})

        MESSAGE("-- Searching for a lib in the set \"${LIBNAME_SET}\":")

        IF (TRIBITS_TPL_FIND_INCLUDE_DIRS_AND_LIBRARIES_VERBOSE)
          PRINT_VAR(LIBNAME_SET)
        ENDIF()

        SET(LIBNAME_LIST ${LIBNAME_SET})
        SEPARATE_ARGUMENTS(LIBNAME_LIST)

        SET(LIBNAME_SET_LIB)

        FOREACH(LIBNAME ${LIBNAME_LIST})

          MESSAGE("--   Searching for lib '${LIBNAME}' ...")

          IF (${TPL_NAME}_LIBRARY_DIRS)
            SET(PATHS_ARG PATHS ${${TPL_NAME}_LIBRARY_DIRS})
          ELSE()
            SET(PATHS_ARG PATHS)
          ENDIF()

          SET_NOTFOUND(_${TPL_NAME}_${LIBNAME}_LIBRARY)
          FIND_LIBRARY( _${TPL_NAME}_${LIBNAME}_LIBRARY
            NAMES ${LIBNAME}
            ${PATHS_ARG} NO_DEFAULT_PATH )
          FIND_LIBRARY( _${TPL_NAME}_${LIBNAME}_LIBRARY
            NAMES ${LIBNAME} )
          MARK_AS_ADVANCED(_${TPL_NAME}_${LIBNAME}_LIBRARY)

          IF (TRIBITS_TPL_FIND_INCLUDE_DIRS_AND_LIBRARIES_VERBOSE)
            PRINT_VAR(_${TPL_NAME}_${LIBNAME}_LIBRARY)
          ENDIF()

          IF (_${TPL_NAME}_${LIBNAME}_LIBRARY)
            MESSAGE("--     Found lib '${_${TPL_NAME}_${LIBNAME}_LIBRARY}'")
            SET(LIBNAME_SET_LIB ${_${TPL_NAME}_${LIBNAME}_LIBRARY})
            BREAK()
          ENDIF()

        ENDFOREACH()

        IF (NOT LIBNAME_SET_LIB)
          MESSAGE(
            "-- ERROR: Did not find a lib in the lib set \"${LIBNAME_SET}\""
             " for the TPL '${TPL_NAME}'!")
          IF (PARSE_MUST_FIND_ALL_LIBS)
	    SET(_${TPL_NAME}_ENABLE_SUCCESS FALSE)
          ELSE()
            BREAK()
          ENDIF()
        ENDIF()

        APPEND_SET(LIBRARIES_FOUND ${LIBNAME_SET_LIB})

      ENDFOREACH()

      MULTILINE_SET(DOCSTR
        "List of semi-colon separated full paths to the libraries for the TPL"
        " ${TPL_NAME}.  This is the final variable that is used in the link"
        " commands.  The user variable ${TPL_NAME}_LIBRARY_DIRS is used to look"
        " for the know library names but but is just a suggestion."
        " This variable, however, is the final value and will not be touched."
        )
      ADVANCED_SET( TPL_${TPL_NAME}_LIBRARIES ${LIBRARIES_FOUND}
        CACHE FILEPATH ${DOCSTR} )

      IF (NOT TPL_${TPL_NAME}_LIBRARIES OR NOT _${TPL_NAME}_ENABLE_SUCCESS)
        MESSAGE(
          "-- ERROR: Could not find the libraries for the TPL '${TPL_NAME}'!")
        MESSAGE(
          "-- TIP: If the TPL '${TPL_NAME}' is on your system then you can set:\n"
          "     -D${TPL_NAME}_LIBRARY_DIRS='<dir0>;<dir1>;...'\n"
          "   to point to the directories where these libraries may be found.\n"
          "   Or, just set:\n"
          "     -DTPL_${TPL_NAME}_LIBRARIES='<path-to-libs0>;<path-to-libs1>;...'\n"
          "   to point to the full paths for the libraries which will\n"
          "   bypass any search for libraries and these libraries will be used without\n"
          "   question in the build.  (But this will result in a build-time error\n"
          "   obviously if all all of the necssary symbols are not found.)")
        TRIBITS_TPL_FIND_INCLUDE_DIRS_AND_LIBRARIES_HANDLE_FAIL()
      ENDIF()

    ENDIF()

    MESSAGE("-- TPL_${TPL_NAME}_LIBRARIES='${TPL_${TPL_NAME}_LIBRARIES}'")

  ELSE()

    GLOBAL_NULL_SET(TPL_${TPL_NAME}_LIBRARIES)

  ENDIF()


  IF (PARSE_REQUIRED_HEADERS)

    IF (NOT TPL_${TPL_NAME}_INCLUDE_DIRS)

      IF (PARSE_MUST_FIND_ALL_HEADERS)
        MESSAGE("-- Must find at least one header in each of the"
          " header sets \"${PARSE_REQUIRED_HEADERS}\"")
      ENDIF()

      MESSAGE( "-- Searching for headers in ${TPL_NAME}_INCLUDE_DIRS='${${TPL_NAME}_INCLUDE_DIRS}'")

      FOREACH(INCLUDE_FILE_SET ${PARSE_REQUIRED_HEADERS})

        MESSAGE("-- Searching for a header file in the set \"${INCLUDE_FILE_SET}\":")

        SET(INCLUDE_FILE_LIST ${INCLUDE_FILE_SET})
        SEPARATE_ARGUMENTS(INCLUDE_FILE_LIST)
        SET(INCLUDE_FILE_SET_PATH) # Start out as empty list

        FOREACH(INCLUDE_FILE ${INCLUDE_FILE_LIST})

          MESSAGE("--   Searching for header '${INCLUDE_FILE}' ...")

          IF (TRIBITS_TPL_FIND_INCLUDE_DIRS_AND_LIBRARIES_VERBOSE)
            PRINT_VAR(INCLUDE_FILE)
          ENDIF()

          SET_NOTFOUND(_${TPL_NAME}_${INCLUDE_FILE}_PATH)
          FIND_PATH( _${TPL_NAME}_${INCLUDE_FILE}_PATH
            NAMES ${INCLUDE_FILE}
            PATHS ${${TPL_NAME}_INCLUDE_DIRS}
            NO_DEFAULT_PATH)
          FIND_PATH( _${TPL_NAME}_${INCLUDE_FILE}_PATH
            NAMES ${INCLUDE_FILE} )
          MARK_AS_ADVANCED(_${TPL_NAME}_${INCLUDE_FILE}_PATH)

          IF (TRIBITS_TPL_FIND_INCLUDE_DIRS_AND_LIBRARIES_VERBOSE)
            PRINT_VAR(_${TPL_NAME}_${INCLUDE_FILE}_PATH)
          ENDIF()

          IF(_${TPL_NAME}_${INCLUDE_FILE}_PATH)
            MESSAGE( "--     Found header '${_${TPL_NAME}_${INCLUDE_FILE}_PATH}/${INCLUDE_FILE}'")
            APPEND_SET(INCLUDE_FILE_SET_PATH ${_${TPL_NAME}_${INCLUDE_FILE}_PATH})
            BREAK()
          ENDIF()

        ENDFOREACH()

        IF(NOT INCLUDE_FILE_SET_PATH)
          MESSAGE("-- ERROR: Could not find a header file in"
            " the set \"${INCLUDE_FILE_SET}\"")
          IF(PARSE_MUST_FIND_ALL_HEADERS)
            SET(_${TPL_NAME}_ENABLE_SUCCESS FALSE)
          ENDIF()
        ENDIF()

        APPEND_SET(INCLUDES_FOUND ${INCLUDE_FILE_SET_PATH})

      ENDFOREACH(INCLUDE_FILE_SET ${PARSE_REQUIRED_HEADERS})

      IF (INCLUDES_FOUND)
        LIST(REMOVE_DUPLICATES INCLUDES_FOUND)
      ENDIF()

      MULTILINE_SET(DOCSTR
        "List of semi-colon separated paths to append to the compile invocations"
        " to find the headers for the TPL ${TPL_NAME}.  This is the final variable"
        " that is used in the build commands.  The user variable ${TPL_NAME}_INCLUDE_DIRS"
        " is used to look for the given headers first but is just a suggestion."
        " This variable, however, is the final value and will not be touched."
        )

      ADVANCED_SET(TPL_${TPL_NAME}_INCLUDE_DIRS ${INCLUDES_FOUND}
        CACHE PATH ${DOCSTR})

      IF (NOT TPL_${TPL_NAME}_INCLUDE_DIRS OR NOT _${TPL_NAME}_ENABLE_SUCCESS)
        MESSAGE(
          "-- ERROR: Could not find the include directories for TPL '${TPL_NAME}'!")
        MESSAGE(
          "-- TIP: If the TPL '${TPL_NAME}' is on your system then you can set:\n"
          "     -D${TPL_NAME}_INCLUDE_DIRS='<dir0>;<dir1>;...'\n"
          "   to point to directories where these header files may be found.\n"
          "   Or, just set:\n"
          "     -DTPL_${TPL_NAME}_INCLUDE_DIRS='<dir0>;<dir1>;...'\n"
          "   to point to the include directories which will bypass any search for\n"
          "   header files and these include directories will be used without\n"
          "   question in the build.  (But this will result in a build-time error\n"
          "   obviously if the necessary header files are not found in these\n"
          "   include directories.)")
        TRIBITS_TPL_FIND_INCLUDE_DIRS_AND_LIBRARIES_HANDLE_FAIL()
      ENDIF()

      IF (TPL_${TPL_NAME}_INCLUDE_DIRS)
        MESSAGE("-- Found TPL '${TPL_NAME}' include dirs '${TPL_${TPL_NAME}_INCLUDE_DIRS}'")
      ENDIF()
    ELSE()


    ENDIF()

    MESSAGE("-- TPL_${TPL_NAME}_INCLUDE_DIRS='${TPL_${TPL_NAME}_INCLUDE_DIRS}'")

  ELSE()

    IF (${TPL_NAME}_INCLUDE_DIRS)
      ADVANCED_SET(TPL_${TPL_NAME}_INCLUDE_DIRS ${${TPL_NAME}_INCLUDE_DIRS}
        CACHE PATH "User provided include dirs in the absence of include files.")
    ELSE()
      GLOBAL_NULL_SET(TPL_${TPL_NAME}_INCLUDE_DIRS)
    ENDIF()

  ENDIF()

  GLOBAL_NULL_SET(TPL_${TPL_NAME}_LIBRARY_DIRS)

  IF (TRIBITS_TPL_FIND_INCLUDE_DIRS_AND_LIBRARIES_VERBOSE)
    PRINT_VAR(TPL_${TPL_NAME}_LIBRARY_DIRS)
  ENDIF()

  IF (TPL_TENTATIVE_ENABLE_${TPL_NAME})
    IF (_${TPL_NAME}_ENABLE_SUCCESS)
      IF (NOT PARSE_NO_PRINT_ENABLE_SUCCESS_FAIL)
        MESSAGE("-- Attempt to tentatively enable TPL '${TPL_NAME}' passed!")
      ENDIF()
    ELSE()
      IF (NOT PARSE_NO_PRINT_ENABLE_SUCCESS_FAIL)
        MESSAGE("-- Attempt to tentatively enable TPL '${TPL_NAME}' failed!"
          "  Setting TPL_ENABLE_${TPL_NAME}=OFF")
      ENDIF()
      SET(TPL_ENABLE_${TPL_NAME} OFF CACHE STRING
        "Forced off since tentative enable failed!"  FORCE)
    ENDIF()
  ENDIF()

ENDFUNCTION()


FUNCTION(TRIBITS_TPL_TENTATIVELY_ENABLE  TPL_NAME)

  IF ("${TPL_ENABLE_${TPL_NAME}}" STREQUAL "")
    SET(TPL_ENABLE_${TPL_NAME} ON CACHE STRING "autoset" FORCE)
    ADVANCED_SET(TPL_TENTATIVE_ENABLE_${TPL_NAME} ON CACHE STRING "autoset" FORCE)
  ELSE()
  ENDIF()

ENDFUNCTION()



MACRO(TRIBITS_TPL_FIND_INCLUDE_DIRS_AND_LIBRARIES_HANDLE_FAIL) 
  SET(_${TPL_NAME}_ENABLE_SUCCESS FALSE)
  GLOBAL_SET(TPL_${TPL_NAME}_NOT_FOUND TRUE)
  MESSAGE(
    "-- ERROR: Failed finding all of the parts of TPL '${TPL_NAME}' (see above), Aborting!\n" )
  IF ("${ERROR_MSG_MODE}" STREQUAL "SEND_ERROR")
    RETURN()
  ENDIF()
ENDMACRO()
