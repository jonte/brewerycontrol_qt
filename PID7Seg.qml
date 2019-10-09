import QtQuick 2.0
import QtQuick.Shapes 1.12

Rectangle {
    id: rectangle
    width: 230
    height: 85
    color: "#222121"
    property color segColor: "#d51919"
    property string label: "SV"
    property double value: 0
    
    Text {
        id: bg
        x: 0
        y: 0
        width: 200
        height: 84
        color: segColor
        text: "8888"
        horizontalAlignment: Text.AlignRight
        opacity: 0.1
        font.pixelSize: 72
        font.family: "Segment7"
    }
    
    Text {
        x: 206
        y: 0
        color: "#dbcfcf"
        text: label
        font.pixelSize: 12
    }
    
    Text {
        id: fg
        x: 0
        y: 0
        width: 200
        height: 84
        color: segColor
        text: value.toFixed(2)
        horizontalAlignment: Text.AlignRight
        font.pixelSize: 72
        font.family: "Segment7"
    }
}

/*##^##
Designer {
    D{i:0;height:85;width:230}
}
##^##*/
