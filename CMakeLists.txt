include(${CMAKE_SOURCE_DIR}/cmake/pr_common.cmake)

set(PROJ_NAME render_raytracing)
pr_add_executable(${PROJ_NAME} CONSOLE)

pr_add_dependency(${PROJ_NAME} vfilesystem TARGET PUBLIC)

add_subdirectory(external_libs/render_raytracing_lib)
pr_add_dependency(${PROJ_NAME} render_raytracing_lib TARGET PUBLIC)

pr_add_headers(${PROJ_NAME} "include/")
pr_add_sources(${PROJ_NAME} "src/")

if(UNIX)
    target_link_libraries(${PROJ_NAME} "dl")
    target_link_libraries(${PROJ_NAME} "pthread")
else()
    set_target_properties(${PROJ_NAME} PROPERTIES VS_DEBUGGER_WORKING_DIRECTORY "${CMAKE_INSTALL_PREFIX}/${BINARY_OUTPUT_DIR}")
    set_target_properties(${PROJ_NAME} PROPERTIES VS_DEBUGGER_COMMAND "${CMAKE_INSTALL_PREFIX}/${BINARY_OUTPUT_DIR}/${PROJ_NAME}.exe")
endif()

pr_finalize(${PROJ_NAME} FOLDER core)
