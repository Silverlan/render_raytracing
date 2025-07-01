set(PCK "tbb")

if (${PCK}_FOUND)
  return()
endif()

find_path(${PCK}_INCLUDE_DIR
  NAMES tbb/tbb.h
  HINTS
    ${PRAGMA_DEPS_DIR}/tbb/include
)

find_library(${PCK}_LIBRARY
  NAMES tbb
  HINTS
    ${PRAGMA_DEPS_DIR}/tbb/lib
)

set(REQ_VARS ${PCK}_LIBRARY ${PCK}_INCLUDE_DIR)
if(WIN32)
  find_file(
    ${PCK}_TBB_RUNTIME
    NAMES tbb12.dll
    HINTS ${PRAGMA_DEPS_DIR}/tbb/bin
  )
  find_file(
    ${PCK}_TBB_MALLOC_RUNTIME
    NAMES tbbmalloc.dll
    HINTS ${PRAGMA_DEPS_DIR}/tbb/bin
  )
  find_file(
    ${PCK}_TBB_MALLOC_PROXY_RUNTIME
    NAMES tbbmalloc_proxy.dll
    HINTS ${PRAGMA_DEPS_DIR}/tbb/bin
  )
  set(REQ_VARS ${REQ_VARS} ${PCK}_TBB_RUNTIME ${PCK}_TBB_MALLOC_RUNTIME ${PCK}_TBB_MALLOC_PROXY_RUNTIME)
endif()

include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(${PCK}
  REQUIRED_VARS ${REQ_VARS}
)

if(${PCK}_FOUND)
  set(${PCK}_LIBRARIES   ${${PCK}_LIBRARY})
  set(${PCK}_INCLUDE_DIRS ${${PCK}_INCLUDE_DIR})
  if(WIN32)
    set(${PCK}_RUNTIME ${${PCK}_TBB_RUNTIME} ${${PCK}_TBB_MALLOC_RUNTIME} ${${PCK}_TBB_MALLOC_PROXY_RUNTIME})
  endif()
endif()
