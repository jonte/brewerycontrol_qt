import QtQuick 2.12
import QtQuick.Controls 2.12
import QtCharts 2.3
import BreweryControl 1.0
import BreweryControl.Views.PID 1.0

Item {
    property string name
    property string mode: "OFF"
    property string pumpId

    width: 200
    height: 200

    Connections {
        target: eventsource

        onUpdateMode: function(entityId, pumpMode) {
            if (entityId === pumpId) {
                mode = pumpMode.mode
            }
        }
    }

    Text {
        id: nameLabel
        width: parent.width
        anchors.top: parent.top
        color: Constants.darkDarkGray
        text: name
        font.pixelSize: 30
        horizontalAlignment: Text.AlignHCenter
        font.family: "Impact Label"
    }

    Rectangle {
        anchors.topMargin: nameLabel.height
        anchors.fill: parent
        color: Constants.darkDarkGray
        radius: 21
        border.width: 3
        border.color: Constants.gray

        PIDButton {
            id: btnGraph
            anchors.bottom: parent.bottom
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.bottomMargin: 7
            iconText: "\uf011"
            TapHandler {
                onTapped: eventsource.setPumpMode(pumpId, mode == "OFF" ? "ON" : "OFF");
            }
            iconColor: mode == "OFF" ?  Constants.gray : Constants.red
        }
    }

}
