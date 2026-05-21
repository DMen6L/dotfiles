cmake_minimum_required(VERSION 3.16)

project(CIM VERSION 0.1)

set(CMAKE_CXX_STANDARD 20)

find_package(tomlplusplus REQUIRED)

add_executable(cim src/custom_icon_menu.cpp)

target_link_libraries(cim PRIVATE tomlplusplus::tomlplusplus)
