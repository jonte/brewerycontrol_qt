import QtQuick 2.0

pragma Singleton

QtObject {
    readonly property color gray: "#dbcfcf"
    readonly property color darkGray: Qt.darker(gray)
    readonly property color red: "#f04242"
    readonly property color darkDarkGray: Qt.darker(gray,3)
    readonly property color black:  "#222121"
    readonly property color green: "#29d519"
    readonly property color blue: Qt.lighter("#3066be")

    readonly property int fontSize: 40
}
