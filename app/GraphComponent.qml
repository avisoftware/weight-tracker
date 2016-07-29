import QtQuick 2.0
import QtQuick.LocalStorage 2.0
import Ubuntu.Components 1.3
import "QChart/"
import "QChart/QChart.js" as Charts
import "js/Storage.js" as Storage
Item {
    id : chart
    property var  dataForChart;
    property alias loaderItem: loader.item
    Loader {
        id : loader
        anchors.fill: parent
        sourceComponent:{
            if (dataForChart ===""){
                noDataComp
            }else {
                chartComp
            }
        }
    }
    Component {
        id: noDataComp
        Item{
            Label{
                anchors.centerIn: parent
                text: i18n.tr("Not enough data to show a chart.")
                color: Qt.darker(UbuntuColors.green)
            }
        }
    }

    Component {
        id: chartComp
        QChart {
            id: chart_line;
            chartData: ""
            anchors.fill:parent
            anchors.margins: units.gu(2)
            chartType: Charts.ChartType.LINE;
            chartOptions: {"scaleFontColor":UbuntuColors.green,
                           "scaleGridLineColor":"rgba(62, 179, 79,.05)"}
            function paintData(){
                chartData=dataForChart;
            }
        }
    }
    function update(){
        if (dataForChart ===""){
        }else {
            loaderItem.paintData()
        }
    }
}
