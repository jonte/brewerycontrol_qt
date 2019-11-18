import QtQuick 2.0

Grid {
    id: grid
    spacing: 5
    scale: children.length > 3 ? 0.8 : 1.0

    rows: 2
    columns: 3

    HopTimer {
        initialtimeSec: 10
        hopName: "Cascade"
    }
}
