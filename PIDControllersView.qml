import QtQuick 2.12
import QtQuick.Controls 2.12

Item {
    property alias children: grid

    Connections {
        target: eventsource
        onStreamConnected:  errorBorder.visible = false
        onStreamDisconnected:  errorBorder.visible = true
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

/*##^##
Designer {
    D{i:0;autoSize:true;height:480;width:640}
}
##^##*/
