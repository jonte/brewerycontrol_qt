import QtQuick 2.12
import QtQuick.Controls 2.12
import QtCharts 2.3
import BreweryControl 1.0

Item {
    Connections {
        target: eventsource

        onUpdatePumps: function(pumps) {
            for (var pump in pumps) {
                var id = (pumps[pump].id)
                var name = (pumps[pump].name)

                var component = Qt.createComponent("qrc:/qml/BreweryControl/Views/Pumps/PumpController.qml")
                if (component.status === Component.Ready) {
                    component.createObject(grid, {pumpId: id, name: name});
                }
            }
        }
    }

    Grid {
        id: grid
        spacing: 5
        anchors.centerIn: parent
        scale: children.length > 3 ? 0.8 : 1.0

        rows: 2
        columns: 3
    }
}
