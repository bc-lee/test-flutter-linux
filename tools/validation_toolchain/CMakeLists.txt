cmake_minimum_required(VERSION 3.14)
project(test_compile)

set(CMAKE_CXX_STANDARD 14)

find_package(PkgConfig REQUIRED)

pkg_check_modules(GLIB REQUIRED glib-2.0)
message(STATUS "GLIB_INCLUDE_DIRS: ${GLIB_INCLUDE_DIRS}")
message(STATUS "GLIB_LIBRARIES: ${GLIB_LIBRARIES}")

pkg_check_modules(GTK REQUIRED gtk+-3.0)
message(STATUS "GTK_INCLUDE_DIRS: ${GTK_INCLUDE_DIRS}")
message(STATUS "GTK_LIBRARIES: ${GTK_LIBRARIES}")

add_executable(test_compile main.cpp)
target_include_directories(test_compile PUBLIC ${GLIB_INCLUDE_DIRS} ${GTK_INCLUDE_DIRS})
target_link_libraries(test_compile ${GLIB_LIBRARIES} ${GTK_LIBRARIES})
