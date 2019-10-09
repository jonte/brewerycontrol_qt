import QtQuick 2.12
import QtQuick.Controls 2.12

Item {
    Connections {
        target: eventsource
        onStreamConnected:  errorBorder.visible = false
        onStreamDisconnected:  errorBorder.visible = true
    }
    
    PIDController {
        id: mltPIDController
        x: 550
        y: 110
        vesselId: "mlt"
        
        Text {
            x: 0
            y: -40
            width: parent.width
            height: 36
            color: "#535353"
            text: qsTr("MLT")
            styleColor: "#222121"
            horizontalAlignment: Text.AlignHCenter
            font.pixelSize: 30
            font.family: "Impact Label"
        }
    }
    
    PIDController {
        id: hltPIDController
        x: 275
        y: 110
        vesselId: "hlt"
        
        Text {
            x: 0
            y: -40
            width: parent.width
            height: 36
            color: "#535353"
            text: qsTr("HLT")
            horizontalAlignment: Text.AlignHCenter
            font.pixelSize: 30
            font.family: "Impact Label"
        }
    }
    
    PIDController {
        id: bkPIDController
        x: 0
        y: 110
        vesselId: "bk"
        
        Text {
            x: 0
            y: -40
            width: parent.width
            height: 36
            color: "#535353"
            text: qsTr("Boil kettle")
            horizontalAlignment: Text.AlignHCenter
            font.family: "Impact Label"
            font.pixelSize: 30
        }
        
        
    }
}
