import QtQuick 2.0
import QtGraphicalEffects 1.0
import BreweryControl 1.0
import BreweryControl.Timers.HopTimer 1.0

Item {
    id: element

    Connections {
        target: eventsource

        onUpdateTimer: function(timerId, timer) {
            console.debug("Timer update: " + timerId + ", " + JSON.stringify(timer))
            for (var i = 0; i < grid.children.length; i++) {
                var child = grid.children[i]

                if (child.timerId === timer.id) {
                    child.hopName = timer.name
                    child.remainingTimeSec = timer.remainingTime
                    child.initialTimeSec = timer.initialTime
                    child.running = timer.running
                    return;
                }
            }

            var component = Qt.createComponent("qrc:/qml/BreweryControl/Timers/HopTimer/HopTimer.qml")
            component.createObject(grid, {
                               timerId: timer.id,
                               hopName: timer.name,
                               remainingTimeSec: timer.remainingTime,
                               initialTimeSec: timer.initialTime,
                               running: timer.running
                           });
        }
    }
    Grid {
        id: grid
        transformOrigin: Item.TopLeft
        spacing: 5
        anchors.fill: parent
        scale: children.length >= 8 ? 0.8 : 1.0

        rows: 2
        columns: 4

        onChildrenChanged: {
            if (children.length >= 8) {
                rows = 3
                columns = 5
                addTimerButton.scale = 0.5
            } else {
                rows = 2
                columns = 4
                addTimerButton.scale = 1.0
            }
        }
    }

    AddTimerButton {
        id: addTimerButton
        transformOrigin: Item.BottomRight

        onTapped: {
            var qml = "import BreweryControl.Timers.HopTimer 1.0; HopTimer {}"
            Qt.createQmlObject(qml, grid, "snippet")
        }

        active: grid.children.length < 15
        opacity: active ? 1.0 : 0.5
    }

    Text {
        id: helpText
        x: 300
        y: 293
        color: Constants.blue
        text: qsTr("Add a timer by pressing +")
        anchors.verticalCenter: parent.verticalCenter
        anchors.horizontalCenter: parent.horizontalCenter
        horizontalAlignment: Text.AlignHCenter
        font.pixelSize: 50
        visible: grid.children.length <= 0
    }
}

/*##^##
Designer {
    D{i:0;height:600;width:800}
}
##^##*/
