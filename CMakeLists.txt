cmake_minimum_required(VERSION 3.20)
set(__version 0.0.1)
project(KautilC11StringAllocator.${__version}
    LANGUAGES C CXX
    VERSION ${__version}
)
unset(__version)


set(CMAKE_CXX_STANDARD 11)
include(${CMAKE_CURRENT_LIST_DIR}/c11_string_allocator/c11_string_allocator.cmake)



