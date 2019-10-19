import QtQuick 2.12
import QtQuick.Controls 2.12
import QtCharts 2.3
import BreweryControl 1.0

SwipeView {
    orientation: Qt.Vertical

    PIDControllersView {
        id: pidControllersView
    }

    PumpControllersView {
        id: grid
    }
}

/*##^##
Designer {
    D{i:0;autoSize:true;height:480;width:640}
}
##^##*/