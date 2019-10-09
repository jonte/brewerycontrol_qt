cmake_minimum_required(VERSION 3.5)

project(brewerycontrol_qt LANGUAGES CXX)

set(CMAKE_INCLUDE_CURRENT_DIR ON)

set(CMAKE_AUTOUIC ON)
set(CMAKE_AUTOMOC ON)
set(CMAKE_AUTORCC ON)

set(CMAKE_CXX_STANDARD 11)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(Qt5 COMPONENTS Core Quick Widgets REQUIRED)

set(SOURCES
    main.cpp
    eventsource.cpp
    eventsource.h)

add_executable(brewerycontrol_qt ${SOURCES} qml.qrc)

target_compile_definitions(brewerycontrol_qt
  PRIVATE $<$<OR:$<CONFIG:Debug>,$<CONFIG:RelWithDebInfo>>:QT_QML_DEBUG>)
target_link_libraries(brewerycontrol_qt
  PRIVATE Qt5::Core Qt5::Quick Qt5::Widgets)

install(TARGETS brewerycontrol_qt
        RUNTIME DESTINATION bin)
