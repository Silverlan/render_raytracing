include(${CMAKE_SOURCE_DIR}/cmake/pr_common.cmake)

set(PROJ_NAME render_raytracing)
pr_add_executable(${PROJ_NAME} CONSOLE)

pr_add_dependency(${PROJ_NAME} vfilesystem TARGET PUBLIC)

add_subdirectory(external_libs/render_raytracing_lib)
pr_add_dependency(${PROJ_NAME} render_raytracing_lib TARGET PUBLIC)

find_package(imath REQUIRED)
pr_add_third_party_dependency(${PROJ_NAME} imath)

find_package(openexr REQUIRED)
pr_add_third_party_dependency(${PROJ_NAME} openexr)

find_package(tbb REQUIRED)
pr_add_third_party_dependency(${PROJ_NAME} tbb)

pr_add_headers(${PROJ_NAME} "include/")
pr_add_sources(${PROJ_NAME} "src/")

if(UNIX)
    target_link_libraries(${PROJ_NAME} PRIVATE "dl")
    target_link_libraries(${PROJ_NAME} PRIVATE "pthread")
else()
    set_target_properties(${PROJ_NAME} PROPERTIES VS_DEBUGGER_WORKING_DIRECTORY "${CMAKE_INSTALL_PREFIX}/${BINARY_OUTPUT_DIR}")
    set_target_properties(${PROJ_NAME} PROPERTIES VS_DEBUGGER_COMMAND "${CMAKE_INSTALL_PREFIX}/${BINARY_OUTPUT_DIR}/${PROJ_NAME}.exe")
endif()

if(UNIX)
    # HACK / FIX: The cycles library uses OpenImageDenoise with CUDA for denoising.
    # For some unknown reason, this causes a segfault when OpenImageDenoise calls cuInit().
    # If we call any OpenImageDenoise function that initializes the CUDA context
    # *before* loading the cycles module, this crash does not happen.
    # To do so, we create a dependency to OpenImageDenoise and call oidnIsCUDADeviceSupported.
    # (but any other oidn CUDA function would do as well.)
    # This problem only occurs on Linux.
    list(APPEND CMAKE_MODULE_PATH "${CMAKE_CURRENT_LIST_DIR}/cmake/modules")
    pr_add_third_party_dependency(${PROJ_NAME} openimagedenoise)
endif()

pr_set_target_folder(render_raytracing_lib tools)

pr_finalize(${PROJ_NAME} FOLDER tools)
