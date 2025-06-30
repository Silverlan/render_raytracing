set(PCK "boost_rt")

if (${PCK}_FOUND)
  return()
endif()

find_path(${PCK}_INCLUDE_DIR
  NAMES boost/config.hpp
  HINTS
    ${PRAGMA_DEPS_DIR}/boost_cycles/include
)

set(boost_rt_libs
	boost_chrono
  boost_atomic
  boost_thread
)

set(boost_rt_lib_list)
foreach(LIB IN LISTS boost_rt_libs)
  find_library(boost_rt_${LIB}
    NAMES ${LIB}
    HINTS ${PRAGMA_DEPS_DIR}/boost_cycles/lib
  )
  list(APPEND boost_rt_lib_list boost_rt_${LIB})
endforeach()

include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(${PCK}
  REQUIRED_VARS ${boost_rt_lib_list} ${PCK}_INCLUDE_DIR
)

set(boost_rt_lib_paths)
foreach(LIB IN LISTS boost_rt_lib_list)
  list(APPEND boost_rt_lib_paths ${${LIB}})
endforeach()

if (boost_rt_FOUND)
  set(${PCK}_LIBRARIES   ${boost_rt_lib_paths})
  set(${PCK}_INCLUDE_DIRS ${${PCK}_INCLUDE_DIR})
endif()
