include(${CMAKE_SOURCE_DIR}/cmake/pr_common.cmake)

set(PROJ_NAME render_raytracing)
pr_add_executable(${PROJ_NAME} CONSOLE)

pr_add_dependency(${PROJ_NAME} vfilesystem TARGET PUBLIC)

add_subdirectory(external_libs/render_raytracing_lib)
pr_add_dependency(${PROJ_NAME} render_raytracing_lib TARGET PUBLIC)

if(UNIX)
    pr_add_external_dependency(${PROJ_NAME} tbb LIBRARY PUBLIC)
    pr_add_external_dependency(${PROJ_NAME} boost_thread_shared LIBRARY PUBLIC)
    pr_add_external_dependency(${PROJ_NAME} openexr_imath LIBRARY PUBLIC)
    pr_add_external_dependency(${PROJ_NAME} openexr LIBRARY PUBLIC)
endif()

pr_add_headers(${PROJ_NAME} "include/")
pr_add_sources(${PROJ_NAME} "src/")

if(UNIX)
    target_link_libraries(${PROJ_NAME} PRIVATE "dl")
    target_link_libraries(${PROJ_NAME} PRIVATE "pthread")
else()
    set_target_properties(${PROJ_NAME} PROPERTIES VS_DEBUGGER_WORKING_DIRECTORY "${CMAKE_INSTALL_PREFIX}/${BINARY_OUTPUT_DIR}")
    set_target_properties(${PROJ_NAME} PROPERTIES VS_DEBUGGER_COMMAND "${CMAKE_INSTALL_PREFIX}/${BINARY_OUTPUT_DIR}/${PROJ_NAME}.exe")
endif()

pr_set_target_folder(render_raytracing_lib tools)

pr_finalize(${PROJ_NAME} FOLDER tools)
