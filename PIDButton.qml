import QtQuick 2.0
import QtQuick.Shapes 1.12

Rectangle {
    id: btnDown
    width: 60
    height: 60
    color: "#3a3939"
    radius: 15
    border.width: 3

    property string iconText: "?"

    Text {
        width: parent.width
        height: parent.height
        anchors.centerIn: parent
        color: "#dbcfcf"
        text: iconText
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        fontSizeMode: Text.HorizontalFit
        font.pointSize: 40
    }
    border.color: "#dbcfcf"
}

/*##^##
Designer {
    D{i:0;height:60;width:60}
}
##^##*/
