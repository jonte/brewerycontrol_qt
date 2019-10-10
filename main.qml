import QtQuick 2.12
import QtQuick.Controls 2.12
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

    Connections {
        target: eventsource

        onUpdateVessels: function(vessels) {
            for (var vessel in vessels) {
                var id = (vessels[vessel].id)
                var name = (vessels[vessel].name)

                var component = Qt.createComponent("qrc:/GraphView.qml")
                if (component.status === Component.Ready) {
                    component.createObject(stackView, {vesselId: id, vesselName: name});
                }

                component = Qt.createComponent("qrc:/PIDController.qml")
                if (component.status === Component.Ready) {
                    component.createObject(pidControllersView.children, {vesselId: id, vesselName: name});
                }
            }
        }
    }

    SwipeView {
        id: stackView
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
