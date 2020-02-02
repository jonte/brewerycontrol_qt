import QtQuick 2.12
import QtQuick.Controls 2.12
import QtCharts 2.3
import BreweryControl 1.0

Item {
    Grid {
        id: grid
        spacing: 5
        anchors.centerIn: parent
        scale: children.length > 3 ? 0.8 : 1.0

        rows: 2
        columns: 3

        PumpController {
            name: "Pump 1"
        }
        PumpController {
            name: "Pump 2"
        }
        PumpController {
            name: "Pump 3"
        }
    }
}
