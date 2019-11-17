import QtQuick 2.0
import QtGraphicalEffects 1.0
import BreweryControl.Timers.HopTimer 1.0

Item {
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
}

/*##^##
Designer {
    D{i:0;height:600;width:800}
}
##^##*/
