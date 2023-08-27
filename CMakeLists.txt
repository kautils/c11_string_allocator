cmake_minimum_required(VERSION 3.20)
project(KautilC11StringAllocator
        LANGUAGES C CXX
        VERSION 0.0.0
)


set(VERSION_ID v0)
set(CMAKE_CXX_STANDARD 11)
include(${CMAKE_CURRENT_LIST_DIR}/c11_string_allocator/c11_string_allocator.cmake)