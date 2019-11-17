import QtQuick 2.12
import QtGraphicalEffects 1.0
import BreweryControl 1.0

Rectangle {
    signal tapped()
    property bool active: true

    id: root
    width: 75
    height: width
    color: active ? Constants.blue : Constants.gray
    radius: width
    border.color: Constants.darkGray
    anchors.bottomMargin: 10
    anchors.rightMargin: 10
    anchors.bottom: parent.bottom
    anchors.right: parent.right
    
    Text {
        text: qsTr("")
        anchors.verticalCenter: parent.verticalCenter
        anchors.horizontalCenter: parent.horizontalCenter
        font.pixelSize: 42
    }

    TapHandler {
        enabled: root.active
        onTapped: root.tapped()
    }
}
