cmake_minimum_required(VERSION 3.5)

project(brewerycontrol_qt LANGUAGES CXX)

set(CMAKE_INCLUDE_CURRENT_DIR ON)

set(CMAKE_AUTOUIC ON)
set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTORCC ON)

set(CMAKE_CXX_STANDARD 11)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(Qt5 COMPONENTS Core Quick Widgets REQUIRED)

add_subdirectory(src)

set(QML_IMPORT_PATH "${CMAKE_SOURCE_DIR}/qml" CACHE STRING "Custom QML modules")
