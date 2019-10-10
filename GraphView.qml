import QtQuick 2.12
import QtQuick.Controls 2.12
import QtCharts 2.3

Item {
    id: graphView
    property string vesselName
    property int maxPoints: settings.value("maxChartPoints", 50)
    property int pointRemoveChunkSize: settings.value("pointRemoveChunkSize", 1)
    property int pointCount: 0

    Connections {
        target: eventsource
        onUpdateChart: graphView.addChartData(vessel, chart);
    }
    ValueAxis {
        id: yAxis
        min: 0
        max: 100
    }
    DateTimeAxis {
        id: dateAxis
        labelsFont.pointSize: 7
        format: "HH:mm"
    }
    
    function addChartData(vessel, chart) {
        if (vessel !== vesselName)
            return;
        var milliDate = chart.date * 1000;

        if (pointCount++ >= maxPoints) {
            tempSeries.removePoints(0, pointRemoveChunkSize)
            powerSeries.removePoints(0, pointRemoveChunkSize)
            setpointSeries.removePoints(0, pointRemoveChunkSize)

            pointCount -= pointRemoveChunkSize
        }

        tempSeries.append(milliDate, chart.temperature.temperature)
        powerSeries.append(milliDate, chart.heater_level.power)
        setpointSeries.append(milliDate, chart.setpoint.temperature)
    }
    
    ChartView {
        id: chartView
        title: vesselName + " temperature"
        anchors.fill: parent

        LineSeries {
            id: powerSeries
            name: "Power"
            axisX: dateAxis
            axisY: yAxis
        }
        
        LineSeries {
            id: setpointSeries
            name: "Setpoint"
            axisX: dateAxis
            axisY: yAxis
        }
        
        LineSeries {
            id: tempSeries
            name: "Temperature"
            axisX: dateAxis
            axisY: yAxis
            
            onPointAdded: function (index) {
                var xMax = tempSeries.at(index).x
                var xMin = tempSeries.at(0).x
                dateAxis.min = new Date(xMin)
                dateAxis.max = new Date(xMax)
            }
        }
    }
}
