pr_install_targets(render_raytracing INSTALL_DIR "./${EXECUTABLE_OUTPUT_DIR}/")

pr_install_binaries(imath)
pr_install_binaries(openexr)
pr_install_binaries(tbb)

if(UNIX)
    pr_install_directory("${CMAKE_CURRENT_LIST_DIR}/assets/lin64/" INSTALL_DIR ".")
else()
    pr_install_directory("${CMAKE_CURRENT_LIST_DIR}/assets/win64/" INSTALL_DIR ".")
endif()
