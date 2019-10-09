import QtQuick 2.13
import QtQuick.Controls 2.13
import QtCharts 2.3

ApplicationWindow {
    id: window
    visible: true
    width: 800
    height: 480
    color: "#222121"

    Rectangle {
        id: errorBorder
        anchors.fill: parent
        color: "#00000000"
        visible: true
        border.width: 5
        border.color: "#f04242"
        z: 2000

        /* Always on top */
    }

    SwipeView {
        id: stackView
        anchors.fill: parent

        PIDControllersView {
        }

        GraphView {
            vesselName: "mlt"
        }

        GraphView {
            vesselName: "hlt"
        }

        GraphView {
            vesselName: "bk"
        }
    }


}

/*##^##
Designer {
    D{i:1;invisible:true}
}
##^##*/
