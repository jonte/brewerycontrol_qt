import QtGraphicalEffects 1.0
import QtQuick 2.12
import BreweryControl 1.0


Text {
    property int time: 0
    property int pixelSize: 24

    id: remainingTime
    anchors.centerIn: parent

    color: time < 0 ? Constants.red : Constants.green
    text: prettyTime(time)
    font.pixelSize: pixelSize
    font.family: "Segment7"

    function prettyTime(time) {
        var minutes = Math.floor(time / 60)
        time -= minutes * 60;
        var seconds = parseInt(time % 60, 10);
        return  ('0' + minutes).slice(-2) + "." +
                ('0' + seconds).slice(-2)
    }
}
