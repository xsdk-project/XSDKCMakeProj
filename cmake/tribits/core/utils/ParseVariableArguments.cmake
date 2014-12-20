


FUNCTION(PARSE_ARGUMENTS_DUMP_OUTPUT  OUTPUT_STR)
  IF (PARSE_ARGUMENTS_DUMP_OUTPUT_ENABLED)
    MESSAGE("${OUTPUT_STR}")
  ENDIF()
ENDFUNCTION()

MACRO(PARSE_ARGUMENTS prefix arg_names option_names)

  PARSE_ARGUMENTS_DUMP_OUTPUT("PARSE_ARGUMENTS: prefix='${prefix}'")
  PARSE_ARGUMENTS_DUMP_OUTPUT("PARSE_ARGUMENTS: arg_names='${arg_names}'")
  PARSE_ARGUMENTS_DUMP_OUTPUT("PARSE_ARGUMENTS: option_names='${option_names}'")
  PARSE_ARGUMENTS_DUMP_OUTPUT("PARSE_ARGUMENTS: ARGN='${ARGN}'")

  FOREACH(arg_name ${arg_names})
    SET(${prefix}_${arg_name})
  ENDFOREACH()

  FOREACH(option ${option_names})
    SET(${prefix}_${option} FALSE)
  ENDFOREACH()

  SET(DEFAULT_ARGS)
  SET(current_arg_name DEFAULT_ARGS)
  SET(current_arg_list)

  FOREACH(arg ${ARGN})
    SET(larg_names ${arg_names})
    LIST(FIND larg_names "${arg}" is_arg_name)
    IF (is_arg_name GREATER -1)
      SET(${prefix}_${current_arg_name} "${current_arg_list}")
      PARSE_ARGUMENTS_DUMP_OUTPUT("PARSE_ARGUMENTS: ${prefix}_${current_arg_name} = '${${prefix}_${current_arg_name}}'" )
      SET(current_arg_name "${arg}")
      SET(current_arg_list)
    ELSE()
      SET(loption_names "${option_names}")
      LIST(FIND loption_names "${arg}" is_option)
      IF (is_option GREATER -1)
        SET(${prefix}_${arg} TRUE)
        PARSE_ARGUMENTS_DUMP_OUTPUT( "PARSE_ARGUMENTS: ${prefix}_${arg} = '${${prefix}_${arg}}'" )
      ELSE()
        LIST(APPEND current_arg_list "${arg}")
      ENDIF()
    ENDIF()
  ENDFOREACH()

  SET(${prefix}_${current_arg_name} "${current_arg_list}")
  PARSE_ARGUMENTS_DUMP_OUTPUT( "PARSE_ARGUMENTS: ${prefix}_${current_arg_name} = '${${prefix}_${current_arg_name}}'" )

ENDMACRO()

