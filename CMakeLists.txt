include(${CMAKE_SOURCE_DIR}/cmake/pr_common.cmake)

set(PROJ_NAME render_raytracing)
pr_add_executable(${PROJ_NAME})

pr_add_headers(${PROJ_NAME} "include/")
pr_add_sources(${PROJ_NAME} "src/")

add_subdirectory(external_libs/render_raytracing_lib)
pr_add_dependency(${PROJ_NAME} render_raytracing_lib TARGET PUBLIC)

pr_finalize(${PROJ_NAME} FOLDER core)
