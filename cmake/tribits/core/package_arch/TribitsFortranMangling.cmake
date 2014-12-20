

IF (${PROJECT_NAME}_ENABLE_Fortran)
  INCLUDE(FortranMangling)
  FORTRAN_MANGLING()

  IF(NOT ${PROJECT_NAME}_SKIP_FORTRANCINTERFACE_VERIFY_TEST)
    INCLUDE(FortranCInterface)
    FortranCInterface_VERIFY(CXX)
  ENDIF()
ENDIF()

IF (FC_FUNC_DEFAULT)

  SET(F77_FUNC_DEFAULT ${FC_FUNC_DEFAULT})
  SET(F77_FUNC__DEFAULT ${FC_FUNC__DEFAULT})

ELSE()

  IF(CYGWIN)
    SET(F77_FUNC_DEFAULT "(name,NAME) name ## _" )
    SET(F77_FUNC__DEFAULT "(name,NAME) name ## __" )
  ELSEIF(WIN32)
    SET(F77_FUNC_DEFAULT "(name,NAME) name ## _" )
    SET(F77_FUNC__DEFAULT "(name,NAME) NAME")
  ELSEIF(UNIX AND NOT APPLE)
    SET(F77_FUNC_DEFAULT "(name,NAME) name ## _" )
    SET(F77_FUNC__DEFAULT "(name,NAME) name ## _" )
  ELSEIF(APPLE)
    SET(F77_FUNC_DEFAULT "(name,NAME) name ## _" )
    SET(F77_FUNC__DEFAULT "(name,NAME) name ## __" )
  ELSE()
    MESSAGE(FATAL_ERROR "Error, could not determine fortran name mangling!")
  ENDIF()

ENDIF()


SET(F77_FUNC ${F77_FUNC_DEFAULT} CACHE STRING
  "Name mangling used to call Fortran 77 functions with no underscores in the name")
SET(F77_FUNC_ ${F77_FUNC__DEFAULT} CACHE STRING
  "Name mangling used to call Fortran 77 functions with at least one underscore in the name")

MARK_AS_ADVANCED(F77_FUNC)
MARK_AS_ADVANCED(F77_FUNC_)
