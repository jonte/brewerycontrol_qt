import QtQuick 2.12
import QtQuick.Controls 2.12
import QtCharts 2.3
import BreweryControl 1.0

ApplicationWindow {
    id: window
    visible: true
    width: 800
    height: 480
    color: Constants.black

    Rectangle {
        id: errorBorder
        anchors.fill: parent
        color: "#00000000"
        visible: true
        border.width: 5
        border.color: Constants.red
        z: 2000

        /* Always on top */
    }

    Connections {
        target: eventsource

        onUpdateVessels: function(vessels) {
            for (var vessel in vessels) {
                var id = (vessels[vessel].id)
                var name = (vessels[vessel].name)

                var component = Qt.createComponent("qrc:/qml/BreweryControl/GraphView.qml")
                if (component.status === Component.Ready) {
                    component.createObject(swipeView, {vesselId: id, vesselName: name});
                }

                component = Qt.createComponent("qrc:/qml/BreweryControl/PIDController.qml")
                if (component.status === Component.Ready) {
                    component.createObject(pidControllersView.children, {vesselId: id, vesselName: name});
                }
            }
        }
    }

    SwipeView {
        id: swipeView
        anchors.fill: parent

        PIDControllersView {
            id: pidControllersView
        }
    }



}

/*##^##
Designer {
    D{i:1;invisible:true}
}
##^##*/
