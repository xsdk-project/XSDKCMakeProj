

MACRO(ADVANCED_SET VARNAME)
  SET(${VARNAME} ${ARGN})
  MARK_AS_ADVANCED(${VARNAME})
ENDMACRO()