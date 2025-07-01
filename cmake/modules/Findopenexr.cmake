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

set(REQ_VARS ${PCK}_LIBRARY ${PCK}_CORE_LIBRARY ${PCK}_UTIL_LIBRARY ${PCK}_ILM_THREAD_LIBRARY ${PCK}_IEX_LIBRARY ${PCK}_INCLUDE_DIR)
if(WIN32)
  find_file(
    ${PCK}_OPENEXR_IEX_RUNTIME
    NAMES Iex.dll
    HINTS ${PRAGMA_DEPS_DIR}/openexr/bin
  )
  find_file(
    ${PCK}_OPENEXR_ILM_THREAD_RUNTIME
    NAMES IlmThread.dll
    HINTS ${PRAGMA_DEPS_DIR}/openexr/bin
  )
  find_file(
    ${PCK}_OPENEXR_RUNTIME
    NAMES OpenEXR.dll
    HINTS ${PRAGMA_DEPS_DIR}/openexr/bin
  )
  find_file(
    ${PCK}_OPENEXR_CORE_RUNTIME
    NAMES OpenEXRCore.dll
    HINTS ${PRAGMA_DEPS_DIR}/openexr/bin
  )
  find_file(
    ${PCK}_OPENEXR_UTIL_RUNTIME
    NAMES OpenEXRUtil.dll
    HINTS ${PRAGMA_DEPS_DIR}/openexr/bin
  )
  set(REQ_VARS ${REQ_VARS} ${PCK}_OPENEXR_IEX_RUNTIME ${PCK}_OPENEXR_ILM_THREAD_RUNTIME ${PCK}_OPENEXR_RUNTIME ${PCK}_OPENEXR_CORE_RUNTIME ${PCK}_OPENEXR_UTIL_RUNTIME)
endif()

include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(${PCK}
  REQUIRED_VARS ${REQ_VARS}
)

if(${PCK}_FOUND)
  set(${PCK}_LIBRARIES   ${${PCK}_LIBRARY} ${${PCK}_CORE_LIBRARY} ${${PCK}_UTIL_LIBRARY} ${${PCK}_ILM_THREAD_LIBRARY} ${${PCK}_IEX_LIBRARY})
  set(${PCK}_INCLUDE_DIRS ${${PCK}_INCLUDE_DIR})
  if(WIN32)
    set(${PCK}_RUNTIME ${${PCK}_OPENEXR_IEX_RUNTIME} ${${PCK}_OPENEXR_ILM_THREAD_RUNTIME} ${${PCK}_OPENEXR_RUNTIME} ${${PCK}_OPENEXR_CORE_RUNTIME} ${${PCK}_OPENEXR_UTIL_RUNTIME})
  endif()
endif()
