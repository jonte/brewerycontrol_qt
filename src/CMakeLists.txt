set(SOURCES
    eventsource.cpp
    main.cpp
    settings.cpp
)

set(PRIVATE_HEADERS
    eventsource.h
    settings.h
)

add_executable(brewerycontrol_qt ${SOURCES} ${PRIVATE_HEADERS} qml.qrc)

target_compile_definitions(brewerycontrol_qt
  PRIVATE $<$<OR:$<CONFIG:Debug>,$<CONFIG:RelWithDebInfo>>:QT_QML_DEBUG>)
target_link_libraries(brewerycontrol_qt
  PRIVATE Qt5::Core Qt5::Quick Qt5::Widgets)

install(TARGETS brewerycontrol_qt
        RUNTIME DESTINATION bin)
