import QtGraphicalEffects 1.0
import QtQuick 2.12


Item {
    id: longPressMenu
    width: 200
    height: 200
    signal resetTapped()
    signal removeTapped()
    signal setTimeTapped()
    signal goBackTapped()

    Item {
        id: element
        width: parent.width
        height: parent.height / parent.children.length
        clip: true
        
        Rectangle {
            width: longPressMenu.width
            height: longPressMenu.height
            color: Constants.blue
            radius: Math.max(width, height) / 2
            border.width: 0
        }
        
        TapHandler {
            gesturePolicy: TapHandler.WithinBounds
            onTapped: removeTapped()
        }

        Rectangle {
            width: parent.width/3
            height: 3
            color: Constants.darkGray
            anchors.bottomMargin: -2
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.bottom: parent.bottom
        }

        Text {
            text: qsTr("REMOVE")
            anchors.verticalCenterOffset: 6
            anchors.horizontalCenterOffset: 0
            font.bold: true
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
            font.pixelSize: 20
        }

    }
    
    Item {
        y: parent.height / parent.children.length
        width: parent.width
        height: parent.height / parent.children.length
        clip: true
        Rectangle {
            y: -parent.y
            width: longPressMenu.width
            height: longPressMenu.height
            color: Constants.blue
            radius: Math.max(width, height) / 2
            border.width: 0
            
            TapHandler {
                gesturePolicy: TapHandler.WithinBounds
                onTapped: resetTapped()
            }
        }
        
        Rectangle {
            x: 0
            y: -2
            width: parent.width/3
            height: 3
            color: Constants.darkGray
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.bottomMargin: -2
            anchors.bottom: parent.bottom
        }

        Text {
            text: qsTr("RESET")
            font.bold: true
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
            font.pixelSize: 20
        }

    }
    
    Item {
        y: (parent.height/parent.children.length) * 2
        width: parent.width
        height: parent.height/parent.children.length
        clip: true
        
        Rectangle {
            y: -parent.y
            width: longPressMenu.width
            height: longPressMenu.height
            color: Constants.blue
            radius: Math.max(width, height) / 2
            border.width: 0
        }

        Rectangle {
            x: -4
            y: 4
            width: parent.width/3
            height: 3
            color: Constants.darkGray
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.bottomMargin: -2
            anchors.bottom: parent.bottom
        }

        TapHandler {
            gesturePolicy: TapHandler.WithinBounds
            onTapped: setTimeTapped()
        }

        Text {
            text: qsTr("SET TIME")
            anchors.verticalCenterOffset: 0
            font.bold: true
            anchors.verticalCenter: parent.verticalCenter
            anchors.horizontalCenter: parent.horizontalCenter
            font.pixelSize: 20
        }

    }

    Item {
        y: (parent.height/parent.children.length) * 3
        width: parent.width
        height: parent.height / parent.children.length
        clip: true
        Rectangle {
            y: -parent.y
            width: longPressMenu.width
            height: longPressMenu.height
            color: Constants.blue
            radius: Math.max(width, height) / 2
            border.width: 0
        }

        TapHandler {
            gesturePolicy: TapHandler.WithinBounds
            onTapped: goBackTapped()
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
    D{i:0;height:172;width:172}D{i:12;anchors_height:200;anchors_width:200;anchors_y:0}
}
##^##*/
