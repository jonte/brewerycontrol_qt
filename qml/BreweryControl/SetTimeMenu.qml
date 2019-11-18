import QtGraphicalEffects 1.0
import QtQuick 2.12


Item {
    id: root
    width: 200
    height: 200
    signal addTapped()
    signal addLongTapped()
    signal subTapped()
    signal subLongTapped()
    signal backTapped()
    property int value: 0

    Item {
        id: element
        width: parent.width
        height: parent.height /3
        clip: true
        
        Item {
            width: parent.width / 2
            height: parent.height
            clip: true


            Rectangle {
                width: root.width
                height: root.height
                color: Constants.blue
                radius: Math.max(width, height) / 2
                border.width: 0
            }

            Text {
                x: 44
                y: 22
                text: qsTr("ADD")
                anchors.verticalCenterOffset: 6
                anchors.horizontalCenterOffset: 13
                font.bold: true
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.verticalCenter: parent.verticalCenter
                font.pixelSize: 20
            }

            Rectangle {
                id: rectangle
                width: 3
                height: parent.height / 2
                color: "#ffffff"
                anchors.rightMargin: -2
                anchors.verticalCenter: parent.verticalCenter
                anchors.right: parent.right
            }

            TapHandler {
                gesturePolicy: TapHandler.WithinBounds
                onTapped: addTapped()
                onLongPressed: addLongTapped()
            }
        }

        Item {
            x: parent.width/2
            width: parent.width / 2
            height: parent.height
            clip: true
            Rectangle {
                x: -parent.width
                width: root.width
                height: root.height
                color: Constants.blue
                radius: Math.max(width, height) / 2
                border.width: 0
            }

            Text {
                x: 44
                y: 22
                text: qsTr("SUB")
                anchors.horizontalCenterOffset: -12
                anchors.verticalCenter: parent.verticalCenter
                font.pixelSize: 20
                anchors.verticalCenterOffset: 6
                anchors.horizontalCenter: parent.horizontalCenter
                font.bold: true
            }

            TapHandler {
                gesturePolicy: TapHandler.WithinBounds
                onTapped: subTapped()
                onLongPressed: subLongTapped()
            }
        }



    }

    Item {
        y: root.height / 3
        width: parent.width
        height: parent.height / 3
        clip: true
        Rectangle {
            y: -parent.y
            width: root.width
            height: root.height
            color: Constants.darkDarkGray
            radius: Math.max(width, height) / 2
            border.width: 0
        }

        RemainingTime {
            anchors.verticalCenterOffset: 3
            time: root.value
            anchors.verticalCenter: parent.verticalCenter
            anchors.horizontalCenter: parent.horizontalCenter
            pixelSize: 50
        }
    }

    Item {
        y: (parent.height / 3) * 2
        width: parent.width
        height: parent.height / 3
        anchors.bottom: parent.bottom
        clip: true
        Rectangle {
            y: -parent.y
            width: root.width
            height: root.height
            color: Constants.blue
            radius: Math.max(width, height) / 2
            border.width: 0
        }

        TapHandler {
            gesturePolicy: TapHandler.WithinBounds
            onTapped: backTapped()
        }

        Text {
            text: qsTr("GO BACK")
            anchors.verticalCenter: parent.verticalCenter
            font.pixelSize: 20
            anchors.verticalCenterOffset: -5
            anchors.horizontalCenter: parent.horizontalCenter
            font.bold: true
        }
    }

    
}

/*##^##
Designer {
    D{i:0;height:172;width:172}D{i:16;anchors_height:200;anchors_width:200;anchors_y:0}
D{i:17;anchors_height:200;anchors_width:200;anchors_y:0}
}
##^##*/
