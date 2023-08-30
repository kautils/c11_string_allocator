unset(__main) 
unset(__libs)
unset(__tmain)
unset(__tmain_libs)
unset(__alias )
unset(__module )
unset(__MODULE )


set(__exp_name  ${PROJECT_NAME})
set(__exp_ver ${PROJECT_VERSION})
set(__module c11_string_allocator)
set(__lib_type SHARED)
string(TOLOWER ${__lib_type} __lib_suffix)


string(TOUPPER ${__module} __MODULE)
set(__main kautil_${__module}_${__exp_ver}_${__lib_suffix})
set(__alias kautil::${__module}::${__exp_ver}::${__lib_suffix})
set(__tmain tmain_${__module}_${__exp_ver}_${__lib_suffix})
set(__tmain_mc TMAIN_KAUTIL_${__MODULE}_${__lib_type})
get_filename_component(__include_dir "${CMAKE_CURRENT_LIST_DIR}" DIRECTORY)
set(__include_dir         $<BUILD_INTERFACE:${__include_dir}>)
set(__install_include_dir $<INSTALL_INTERFACE:include>)
set(__install_libdir lib)
set(__libs )

set(__t ${__main})
add_library(${__t} ${__lib_type})
add_library(${__alias} ALIAS ${__t})
unset(srcs)
file(GLOB srcs ${CMAKE_CURRENT_LIST_DIR}/*.cc)
target_sources(${__t} PRIVATE ${srcs})
target_link_libraries(${__t} PRIVATE ${__libs})
target_include_directories(${__t} PUBLIC ${__include_dir} ${__install_include_dir})

##### INSTALL & EXPORT #####
# install files
file(GLOB headers ${CMAKE_CURRENT_LIST_DIR}/*.h)
install(FILES ${headers} DESTINATION include/${__module}) 
install(FILES
    ${CMAKE_CURRENT_BINARY_DIR}/${__exp_name}.cmake
    ${CMAKE_CURRENT_BINARY_DIR}/${__exp_name}Config.cmake
    ${CMAKE_CURRENT_BINARY_DIR}/${__exp_name}ConfigVersion.cmake
    DESTINATION lib/cmake/${__exp_name}
)

# cmake for find package
install(TARGETS ${__t} EXPORT ${__t} DESTINATION ${__install_libdir}) 
set_target_properties(${__t} PROPERTIES EXPORT_NAME ${__alias} ) 
install(EXPORT ${__t} FILE ${__exp_name}.cmake DESTINATION ${__install_libdir}/cmake/${__exp_name})
export(EXPORT ${__t} FILE "${CMAKE_CURRENT_BINARY_DIR}/${__exp_name}.cmake")

include(CMakePackageConfigHelpers)
# Config.cmake
configure_package_config_file( 
  "${CMAKE_CURRENT_LIST_DIR}/Config.cmake.in"
  "${CMAKE_CURRENT_BINARY_DIR}/${__exp_name}Config.cmake"
  INSTALL_DESTINATION "lib/cmake/${__exp_name}"
)
# ConfigVersion.cmake
write_basic_package_version_file( 
  "${CMAKE_CURRENT_BINARY_DIR}/${__exp_name}ConfigVersion.cmake"
  VERSION "${__exp_ver}" 
  COMPATIBILITY AnyNewerVersion
)



set(__t ${__tmain})
add_executable(${__t})
target_sources(${__t} PRIVATE ${CMAKE_CURRENT_LIST_DIR}/unit_test.cc)
target_link_libraries(${__t} PRIVATE ${__alias})
target_compile_definitions(${__t} PRIVATE ${__tmain_mc})

