



FIND_PROGRAM(PYTHON_EXECUTABLE
  NAMES python2.7 python2.6 python2.5 python2.4 python2.3 python2.2 python2.1 python2.0 python1.6 python1.5 python
  PATHS
  [HKEY_LOCAL_MACHINE\\SOFTWARE\\Python\\PythonCore\\2.7\\InstallPath]
  [HKEY_LOCAL_MACHINE\\SOFTWARE\\Python\\PythonCore\\2.6\\InstallPath]
  [HKEY_LOCAL_MACHINE\\SOFTWARE\\Python\\PythonCore\\2.5\\InstallPath]
  [HKEY_LOCAL_MACHINE\\SOFTWARE\\Python\\PythonCore\\2.4\\InstallPath]
  [HKEY_LOCAL_MACHINE\\SOFTWARE\\Python\\PythonCore\\2.3\\InstallPath]
  [HKEY_LOCAL_MACHINE\\SOFTWARE\\Python\\PythonCore\\2.2\\InstallPath]
  [HKEY_LOCAL_MACHINE\\SOFTWARE\\Python\\PythonCore\\2.1\\InstallPath]
  [HKEY_LOCAL_MACHINE\\SOFTWARE\\Python\\PythonCore\\2.0\\InstallPath]
  [HKEY_LOCAL_MACHINE\\SOFTWARE\\Python\\PythonCore\\1.6\\InstallPath]
  [HKEY_LOCAL_MACHINE\\SOFTWARE\\Python\\PythonCore\\1.5\\InstallPath]
  )

INCLUDE(FindPackageHandleStandardArgs)
FIND_PACKAGE_HANDLE_STANDARD_ARGS(PythonInterp DEFAULT_MSG PYTHON_EXECUTABLE)

MARK_AS_ADVANCED(PYTHON_EXECUTABLE)

IF (PYTHON_EXECUTABLE OR PythonInterp_MUST_BE_FOUND)
  IF (NOT PYTHON_EXECUTABLE)
    MESSAGE(FATAL_ERROR "Error, Python must be found!")
  ENDIF()
  IF (PythonInterp_FIND_VERSION)
    EXECUTE_PROCESS(COMMAND
      ${PYTHON_EXECUTABLE} -c "import sys; print sys.version.split()[0]"
      OUTPUT_VARIABLE PythonInterp_VERSION
      OUTPUT_STRIP_TRAILING_WHITESPACE
      )
    MESSAGE(STATUS "Python version ${PythonInterp_VERSION}")
    IF(${PythonInterp_VERSION} VERSION_LESS ${PythonInterp_FIND_VERSION})
      MESSAGE(WARNING
        "Python version ${PythonInterp_VERSION}"
        " is less than required version ${PythonInterp_FIND_VERSION}!"
        "  Disabling Python!"
        )
      SET(PYTHONINTERP_FOUND FALSE)
      UNSET(PYTHON_EXECUTABLE)
      UNSET(PYTHON_EXECUTABLE CACHE)
    ENDIF()
  ENDIF()
ENDIF()
