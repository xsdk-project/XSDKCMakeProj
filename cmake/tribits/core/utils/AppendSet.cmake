
MACRO(APPEND_SET VARNAME)
  LIST(APPEND ${VARNAME} ${ARGN})
ENDMACRO()