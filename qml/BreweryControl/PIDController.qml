import QtQuick 2.12
import QtQuick.Shapes 1.12

Item {
    id: controller
    width: 250
    height: 280

    property double sv: 0
    property double pv: 0
    property string vesselId
    property string vesselName
    property string mode: "OFF"

    Text {
        id: nameLabel
        width: parent.width
        height: 36
        color: Constants.darkDarkGray
        text: vesselName
        horizontalAlignment: Text.AlignHCenter
        font.family: "Impact Label"
        font.pixelSize: 30
    }

    Rectangle {
        id: root
        x: 0
        y: 40
        width: 250
        height: 235
        color: Constants.black
        radius: 21
        border.width: 3
        border.color: Constants.gray


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
                    controller.mode = heater.mode.mode
                }
            }
        }

        PIDButton {
            id: btnUp
            x: 182
            y: 168
            iconText: ""

            TapHandler {
                onTapped: eventsource.setSetpoint(vesselId, sv + 1);
                onLongPressed:  eventsource.setSetpoint(vesselId, sv + 10);
            }
        }

        PIDButton {
            id: btnDown
            x: 8
            y: 168
            iconText: ""
            TapHandler {
                id: tapHandler
                onTapped: eventsource.setSetpoint(vesselId, sv - 1);
                onLongPressed:  eventsource.setSetpoint(vesselId, sv - 10);
            }
        }

        PIDButton {
            id: btnGraph
            x: 95
            y: 168
            iconText: ""
            iconColor: mode == "OFF" ?  Constants.gray : Constants.red

            TapHandler {
                onTapped: eventsource.setMode(vesselId, mode == "OFF" ? "PID" : "OFF");
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
            segColor: Constants.green
        }
    }
}


/*##^##
Designer {
    D{i:0;height:260;width:250}
}
##^##*/
