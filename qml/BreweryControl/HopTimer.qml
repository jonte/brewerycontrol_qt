import QtGraphicalEffects 1.0
import QtQuick 2.12


Item {
    id: root
    width: 200
    height: 200
    property double value: Math.min(0.99999, 1 - (remainingTimeSec / initialtimeSec))
    property double initialtimeSec: 0
    property double remainingTimeSec: initialtimeSec
    property bool running: false
    property string hopName: "Unknown"

    function reset() {
        running = false
        remainingTimeSec = initialtimeSec
    }

    function remove() {
        root.destroy()
    }

    TapHandler {
        onTapped: running = !running
        onLongPressed: longPressMenu.visible = !longPressMenu.visible
    }

    Timer {
        interval: 1000
        repeat: true
        running: parent.running
        onTriggered:  remainingTimeSec -= 1
    }

    RemainingTime {
        id: remainingTime
        anchors.verticalCenter: parent.verticalCenter
        pixelSize: 60
        time: remainingTimeSec

        OpacityAnimator {
            target: remainingTime
            from: 0
            to: 1
            duration: 500
            running: remainingTimeSec < 0
        }
    }

    RemainingTime {
        anchors.bottom: innerRing.bottom
        anchors.verticalCenterOffset: 60
        anchors.horizontalCenterOffset: 0
        anchors.horizontalCenter: parent.horizontalCenter
        time: initialtimeSec
        opacity: 0.8
        pixelSize: 20
    }

    Rectangle
    {
        id: outerRing
        anchors.fill: parent
        radius: Math.max(width, height) / 2
        color: "transparent"
        border.color: Constants.darkGray
        border.width: 16

    }

    Rectangle
    {
        id: innerRing
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
    }

    LongPressMenu {
        id: longPressMenu
        visible: false
        width: innerRing.width - 20
        height: innerRing.height - 20
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter

        onResetTapped: {
            reset()
            visible = false
        }

        onRemoveTapped: remove()
        onGoBackTapped: visible = false
        onSetTimeTapped: {
            setTimeMenu.visible = true
            visible = false
        }
    }

    SetTimeMenu {
        id: setTimeMenu
        visible: false
        width: innerRing.width - 20
        height: innerRing.height - 20
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
        value: initialtimeSec

        onAddTapped: initialtimeSec += 60
        onAddLongTapped: initialtimeSec += 60 * 10
        onSubTapped: initialtimeSec -= 60
        onSubLongTapped: initialtimeSec -= 60 * 10
        onBackTapped: {
            visible = false
            reset()
        }
    }
}
