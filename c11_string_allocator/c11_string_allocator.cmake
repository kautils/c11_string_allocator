unset(__main) 
unset(__libs)
unset(__tmain)
unset(__tmain_libs)
unset(__alias )
unset(__module )
unset(__MODULE )

macro(KautilLibraryTemplate parse_prfx)
    
    cmake_parse_arguments( ${parse_prfx} "DEBUG_VERBOSE" "MODULE_NAME;EXPORT_NAME_PREFIX;EXPORT_VERSION;EXPORT_LIB_TYPE;DESTINATION_LIB_DIR" "MODULE_PREFIX;LINK_LIBS;DESTINATION_INCLUDE_DIR;DESTINATION_CMAKE_DIR" ${ARGV})
    
    set(__prfx_main)
    set(__prfx_alias)
    set(__PRFX_MAIN)
    foreach(prfx ${${parse_prfx}_MODULE_PREFIX})
        string(APPEND __prfx_main ${prfx}_)
        string(APPEND __prfx_alias ${prfx}::)
    endforeach()
    string(TOUPPER ${__prfx_main} __PRFX_MAIN)
    
    
    string(TOLOWER ${${parse_prfx}_EXPORT_LIB_TYPE} __lib_type)
    string(TOUPPER ${${parse_prfx}_EXPORT_LIB_TYPE} __LIB_TYPE)
    set(__exp_name  ${${parse_prfx}_EXPORT_NAME_PREFIX}.${__lib_type})
    set(__exp_ver ${${parse_prfx}_EXPORT_VERSION})
    set(__module ${${parse_prfx}_MODULE_NAME})
    string(TOUPPER ${__module} __MODULE)
    
    
    get_filename_component(__include_dir "${CMAKE_CURRENT_LIST_DIR}" DIRECTORY)
    set(__include_dir         $<BUILD_INTERFACE:${__include_dir}>)
    set(__install_include_dir $<INSTALL_INTERFACE:include>)
    set(__install_libdir lib)
    set(__libs ${${parse_prfx}_LINK_LIBS})
    
    set(__destination_include_dirs ${${parse_prfx}_DESTINATION_INCLUDE_DIR})
    set(__destination_cmake_dirs ${${parse_prfx}_DESTINATION_CMAKE_DIR})
    set(__destination_lib_dir ${${parse_prfx}_DESTINATION_LIBS_DIR})
    
    
    set(__main ${__prfx_main}${__module}_${__exp_ver}_${__lib_type})
    set(__alias ${__prfx_alias}${__module}::${__exp_ver}::${__lib_type})
    if( ${parse_prfx}_DEBUG_VERBOSE)
        include(CMakePrintHelpers)
        cmake_print_variables(__main)
        cmake_print_variables(__alias)
        cmake_print_variables(__exp_name)
        cmake_print_variables(__exp_ver)
        cmake_print_variables(__lib_type)
        cmake_print_variables(__LIB_TYPE)
        cmake_print_variables(__MODULE)
        cmake_print_variables(__include_dir)
        cmake_print_variables(__install_include_dir)
        cmake_print_variables(__install_libdir)
        cmake_print_variables(__libs)
        cmake_print_variables(__destination_include_dirs)
        cmake_print_variables(__destination_cmake_dirs)
        cmake_print_variables(__destination_lib_dir)
        message(WARNING ${parse_prfx}_DEBUG_VERBOSE)
    endif()
    
    
    set(__t ${__main})
    set(${parse_prfx}_${__lib_type} ${__t})
    set(${parse_prfx}_${__lib_type}_tmain_ppcs TMAIN_${__PRFX_MAIN}${__MODULE}_${__LIB_TYPE})
    set(${parse_prfx}_${__lib_type}_tmain tmain_${__prfx_main}${__module}_${__lib_type})
    
    add_library(${__t} ${__LIB_TYPE})
    add_library(${__alias} ALIAS ${__t})
    unset(srcs)
    file(GLOB srcs ${CMAKE_CURRENT_LIST_DIR}/*.cc)
    target_sources(${__t} PRIVATE ${srcs})
    target_link_libraries(${__t} PRIVATE ${__libs})
    target_include_directories(${__t} PUBLIC ${__include_dir} ${__install_include_dir})
    
    ##### INSTALL & EXPORT #####
    # install files
    file(GLOB headers ${CMAKE_CURRENT_LIST_DIR}/*.h)
    foreach(include_dest ${__destination_include_dirs})
        install(FILES ${headers} DESTINATION ${include_dest}/${__module}) 
    endforeach()
    
    foreach(include_dest ${__destination_cmake_dirs})
        install(FILES
            ${CMAKE_CURRENT_BINARY_DIR}/${__exp_name}.cmake
            ${CMAKE_CURRENT_BINARY_DIR}/${__exp_name}Config.cmake
            ${CMAKE_CURRENT_BINARY_DIR}/${__exp_name}ConfigVersion.cmake
            DESTINATION lib/${include_dest}/${__exp_name}
        )
    endforeach()
    
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
endmacro()


get_filename_component(__include_dir "${CMAKE_CURRENT_LIST_DIR}" DIRECTORY)
set(common_pref
    MODULE_PREFIX kautil
    MODULE_NAME c11_string_allocator
    EXPORT_NAME_PREFIX ${PROJECT_NAME}
    EXPORT_VERSION ${PROJECT_VERSION}
    INCLUDE $<BUILD_INTEREFACE:${__include_dir}> $<INSTALL_INTERFACE:include> 
    LINK_LIBS 
    DESTINATION_INCLUDE_DIR include
    DESTINATION_CMAKE_DIR cmake
    DESTINATION_LIB_DIR lib
)

KautilLibraryTemplate(c11_string_allocator ${common_pref} EXPORT_LIB_TYPE static)
KautilLibraryTemplate(c11_string_allocator ${common_pref} EXPORT_LIB_TYPE shared)

set(__t ${c11_string_allocator_static_tmain})
add_executable(${__t})
target_sources(${__t} PRIVATE ${CMAKE_CURRENT_LIST_DIR}/unit_test.cc)
target_link_libraries(${__t} PRIVATE ${c11_string_allocator_static})
target_compile_definitions(${__t} PRIVATE ${c11_string_allocator_static_tmain_ppcs})

