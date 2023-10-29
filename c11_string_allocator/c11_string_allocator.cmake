set(${PROJECT_NAME}_m_evacu ${m})
set(m ${PROJECT_NAME})
list(APPEND ${m}_unsetter )

set(${m}_kautil_cmake_heeder CMakeKautilHeader.v0.0.cmake)
if(DEFINED KAUTIL_THIRD_PARTY_DIR AND EXISTS "${KAUTIL_THIRD_PARTY_DIR}/${${m}_kautil_cmake_heeder}")
    include("${KAUTIL_THIRD_PARTY_DIR}/${${m}_kautil_cmake_heeder}")
else()
    if(NOT EXISTS ${CMAKE_BINARY_DIR}/${${m}_kautil_cmake_heeder})
        file(DOWNLOAD https://raw.githubusercontent.com/kautils/CMakeKautilHeader/v0.0/CMakeKautilHeader.cmake ${CMAKE_BINARY_DIR}/${${m}_kautil_cmake_heeder})
    endif()
    include(${CMAKE_BINARY_DIR}/${${m}_kautil_cmake_heeder})
endif()
git_clone(https://raw.githubusercontent.com/kautils/CMakeLibrarytemplate/v0.0.1/CMakeLibrarytemplate.cmake)

set(module_name c11_string_allocator)
unset(srcs)
file(GLOB srcs ${CMAKE_CURRENT_LIST_DIR}/*.cc)
set(${module_name}_common_pref
    MODULE_PREFIX kautil
    MODULE_NAME ${module_name}
    INCLUDES "${CMAKE_CURRENT_LIST_DIR}" $<BUILD_INTERFACE:${CMAKE_CURRENT_LIST_DIR}> $<INSTALL_INTERFACE:include> 
    SOURCES ${srcs}
    EXPORT_NAME_PREFIX ${PROJECT_NAME}
    EXPORT_VERSION ${PROJECT_VERSION}
    EXPORT_VERSION_COMPATIBILITY AnyNewerVersion
        
    DESTINATION_INCLUDE_DIR include/kautil
    DESTINATION_CMAKE_DIR cmake
    DESTINATION_LIB_DIR lib
)

CMakeLibraryTemplate(${module_name} EXPORT_LIB_TYPE static ${${module_name}_common_pref} )
#CMakeLibraryTemplate(${module_name} EXPORT_LIB_TYPE shared ${${module_name}_common_pref} )

set(__t ${${module_name}_static_tmain})
add_executable(${__t})
target_sources(${__t} PRIVATE ${CMAKE_CURRENT_LIST_DIR}/unit_test.cc)
target_link_libraries(${__t} PRIVATE ${${module_name}_static})
target_compile_definitions(${__t} PRIVATE ${${module_name}_static_tmain_ppcs})


foreach(__v ${${m}_unsetter})
    unset(${__v})
endforeach()
unset(${m}_unsetter)
set(m ${${PROJECT_NAME}_m_evacu})