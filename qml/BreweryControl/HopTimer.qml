import QtGraphicalEffects 1.0
import QtQuick 2.12


Item {
    width: 200
    height: 200
    property double value: Math.min(0.99999, 1 - (remainingTimeSec / initialtimeSec))
    property double initialtimeSec: 0
    property double remainingTimeSec: initialtimeSec
    property bool running: false
    property string hopName: "Unknown"

    MouseArea {
        id: tapHandler
        anchors.fill: parent
        onPressed: running = !running
        onPressAndHold: remainingTimeSec = initialtimeSec
    }

    Timer {
        interval: 1000
        repeat: true
        running: parent.running
        onTriggered:  remainingTimeSec -= 1
    }

    Text {
        id: remainingTime
        font.family: "Segment7"
        anchors.centerIn: parent
        text: Math.abs(remainingTimeSec)
        color: remainingTimeSec < 0 ? Constants.red : Constants.green
        font.pixelSize: 72

        OpacityAnimator {
            target: parent
            from: 0
            to: 1
            duration: 500
            running: remainingTimeSec < 0
        }
    }

    Text {
        font.family: "Segment7"
        anchors.top: remainingTime.bottom
        anchors.horizontalCenter: remainingTime.horizontalCenter
        text: initialtimeSec
        color: Constants.red
        opacity: 0.8
        font.pixelSize: 20
    }

    Rectangle
    {
        id: outerRing
        z: 0
        anchors.fill: parent
        radius: Math.max(width, height) / 2
        color: "transparent"
        border.color: Constants.darkGray
        border.width: 16
    }

    Rectangle
    {
        id: innerRing
        z: 1
        anchors.fill: parent
        anchors.margins: (outerRing.border.width - border.width) / 2
        radius: outerRing.radius
        color: "transparent"
        border.color: Constants.black
        border.width: 8

        ConicalGradient
        {
            source: innerRing
            anchors.fill: parent
            gradient: Gradient
            {
                GradientStop { position: 0.00; color: Constants.green }
                GradientStop { position: value; color: Constants.green }
                GradientStop { position: value + 0.001; color: "transparent" }
                GradientStop { position: 1.00; color: "transparent" }
            }
        }
    }

    Text {
        font.family: "Cantarell"
        anchors.top: outerRing.bottom
        anchors.horizontalCenter: outerRing.horizontalCenter
        text: hopName
        color: Constants.green
        opacity: 0.8
        font.pixelSize: 40
        elide: Text.ElideRight
        width: parent.width
    }
}
