import QtQuick 2.12
import QtQuick.Controls 2.12
import QtCharts 2.3

Item {
    id: graphView
    property string vesselName
    
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
    }
    
    function addChartData(vessel, chart) {
        if (vessel !== vesselName)
            return;
        var milliDate = chart.date * 1000;
        
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
