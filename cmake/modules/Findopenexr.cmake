set(PCK "openexr")

if (${PCK}_FOUND)
  return()
endif()

find_path(${PCK}_INCLUDE_DIR
  NAMES OpenEXR/openexr.h
  HINTS
    ${PRAGMA_DEPS_DIR}/openexr/include
)

find_library(${PCK}_LIBRARY
  NAMES OpenEXR
  HINTS
    ${PRAGMA_DEPS_DIR}/openexr/lib
)

find_library(${PCK}_CORE_LIBRARY
  NAMES OpenEXRCore
  HINTS
    ${PRAGMA_DEPS_DIR}/openexr/lib
)

find_library(${PCK}_UTIL_LIBRARY
  NAMES OpenEXRUtil
  HINTS
    ${PRAGMA_DEPS_DIR}/openexr/lib
)

find_library(${PCK}_ILM_THREAD_LIBRARY
  NAMES IlmThread
  HINTS
    ${PRAGMA_DEPS_DIR}/openexr/lib
)

find_library(${PCK}_IEX_LIBRARY
  NAMES Iex
  HINTS
    ${PRAGMA_DEPS_DIR}/openexr/lib
)

include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(${PCK}
  REQUIRED_VARS ${PCK}_LIBRARY ${PCK}_CORE_LIBRARY ${PCK}_UTIL_LIBRARY ${PCK}_ILM_THREAD_LIBRARY ${PCK}_IEX_LIBRARY ${PCK}_INCLUDE_DIR
)

if(${PCK}_FOUND)
  set(${PCK}_LIBRARIES   ${${PCK}_LIBRARY} ${${PCK}_CORE_LIBRARY} ${${PCK}_UTIL_LIBRARY} ${${PCK}_ILM_THREAD_LIBRARY} ${${PCK}_IEX_LIBRARY})
  set(${PCK}_INCLUDE_DIRS ${${PCK}_INCLUDE_DIR})
endif()
