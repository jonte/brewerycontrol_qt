import QtQuick 2.12
import QtQuick.Controls 2.12
import QtCharts 2.3
import BreweryControl 1.0
import BreweryControl.Views.Timers 1.0
import BreweryControl.Views.Graphs 1.0
import BreweryControl.Views.PID 1.0
import BreweryControl.Views.Pumps 1.0

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

                var component = Qt.createComponent("qrc:/qml/BreweryControl/Views/Graphs/GraphView.qml")
                if (component.status === Component.Ready) {
                    component.createObject(swipeView, {vesselId: id, vesselName: name});
                }

                component = Qt.createComponent("qrc:/qml/BreweryControl/Views/PID/PIDController.qml")
                if (component.status === Component.Ready) {
                    component.createObject(pidControllersView.children, {vesselId: id, vesselName: name});
                }
            }
        }
    }

    SwipeView {
        id: swipeView
        anchors.fill: parent
        currentIndex: 1

        PumpControllersView {}

        TimersView {}

        PIDControllersView {
            id: pidControllersView
        }
    }

    PageIndicator {
        count: swipeView.count
        currentIndex: swipeView.currentIndex

        anchors.bottom: swipeView.bottom
        anchors.horizontalCenter: parent.horizontalCenter
    }



}

/*##^##
Designer {
    D{i:1;invisible:true}
}
##^##*/
