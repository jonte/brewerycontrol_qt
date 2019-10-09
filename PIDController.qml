import QtQuick 2.13
import QtQuick.Shapes 1.12

Rectangle {
    id: root
    x: 0
    y: 0
    width: 250
    height: 235
    color: "#222121"
    radius: 21
    border.width: 3
    border.color: "#dbcfcf"
    property double sv: 0
    property double pv: 0
    property string vesselId


    Connections {
        target: eventsource
        onUpdateTemperature: function(vessel, temperature) {
            if (vessel === vesselId) {
                pv = temperature.temperature
            }
        }

        onUpdateHeater: function(vessel, heater) {
            if (vessel === vesselId) {
                sv = heater.pid.setpoint.temperature
            }
        }
    }

    PIDButton {
        id: btnUp
        x: 182
        y: 168
        iconText: "+"

        TapHandler {
            onTapped: eventsource.setSetpoint(vesselId, sv + 1);
            onLongPressed:  eventsource.setSetpoint(vesselId, sv + 10);
        }
    }

    PIDButton {
        id: btnDown
        x: 8
        y: 168
        iconText: "-"
        TapHandler {
            onTapped: eventsource.setSetpoint(vesselId, sv - 1);
            onLongPressed:  eventsource.setSetpoint(vesselId, sv - 10);
        }
    }

    PID7Seg {
        id: actualSeg
        x: 10
        y: 10
        value: pv
        label: "PV"
    }

    PID7Seg {
        id: setpointSeg
        x: 10
        y: 83
        value: sv
        label: "SV"
        segColor: "#29d519"
    }

    PIDButton {
        id: btnGraph
        x: 95
        y: 168
        iconText: " GRAPH "
    }
}



/*##^##
Designer {
    D{i:0;height:260;width:250}
}
##^##*/
