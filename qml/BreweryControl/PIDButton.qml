import QtQuick 2.12
import QtQuick.Shapes 1.12

Rectangle {
    id: btnDown
    width: 60
    height: 60
    radius: 15
    border.width: 3
    color: Constants.darkDarkGray

    TapHandler {
        id: tapHandler
    }

    property string iconText: "?"
    property color iconColor: Constants.gray
    property string fontFamily: "Cantarell"

    Text {
        width: parent.width
        height: parent.height
        anchors.centerIn: parent
        color: tapHandler.pressed ? Qt.darker(iconColor) : iconColor
        text: iconText
        horizontalAlignment: Text.AlignHCenter
        verticalAlignment: Text.AlignVCenter
        fontSizeMode: Text.HorizontalFit
        font.pointSize: Constants.fontSize
    }
    border.color: Constants.gray
}



/*##^##
Designer {
    D{i:0;height:60;width:60}
}
##^##*/
