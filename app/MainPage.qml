import QtQuick 2.0
import Ubuntu.Components 1.3
import QtQuick.LocalStorage 2.0

import "js/Storage.js" as Storage
import "js/BMI.js" as BMI
Page {
    id:main_page
    property bool isEmpty;
    header: PageHeader {
        id: main_header
        title: i18n.tr("Weight Tracker")
        StyleHints {
            foregroundColor:Qt.darker( UbuntuColors.green)
            dividerColor: Qt.darker( UbuntuColors.green)
        }
        leadingActionBar.actions: []
        trailingActionBar.actions: [
            Action {
                iconName: "info"
                text: i18n.tr("Info")
                onTriggered: {
                    columnAdded = true
                    pageLayout.addPageToNextColumn(mainPage, aboutPage)
                }
            },
            Action {
                iconName: "settings"
                text: i18n.tr("Settings")
                onTriggered: {
                    columnAdded = false
                    pageLayout.primaryPage= settingsView
                }
            },
            Action {
                iconName: "history"
                text: i18n.tr("history")
                onTriggered: {
                    columnAdded = true
                    pageLayout.addPageToNextColumn(mainPage, listWeightPage)
                    listWeightPage.updateView()
                }
            }
        ]
    }
    function updateView (){
        mainView.updateView();
    }
    EmptyState {
        visible:isEmpty
    }
    Item{
        id: mainView
        visible:!isEmpty
        anchors {
            top: main_header.bottom
            left: parent.left
            right: parent.right
            bottom: parent.bottom
            margins: units.gu(2)
        }
        WeightComponent{
            id: weightComp
            anchors {
                top: mainView.top
                horizontalCenter: parent.horizontalCenter
            }
            height: mainView.height /2
            width: mainView.width            
        }
        GraphComponent{
            id: graphComp
            anchors {
                bottom: mainView.bottom
                horizontalCenter: mainView.horizontalCenter
            }
            height: (mainView.height /2)
            width: mainView.width
            MouseArea{
                anchors.fill:parent
                onClicked:{
                    columnAdded = true
                    pageLayout.addPageToNextColumn(mainPage, listWeightPage)
                    listWeightPage.updateView()
                }
            }
        }
        Component.onCompleted:{
            updateView();
        }
        function updateView(){
            if(!settings.isFirstUse){
                var userId = settings.userId;
                var unit = settings.unit;
                //var height = settings.height;
                //var age = settings.age;
                //var gender = settings.gender;
                var details = Storage.getUserDetails(userId);
                var age=details.age
                var height =details.height
                var gender=details.gender
                var userName =details.name
                var lastWeight = Storage.findLastWeigth(userId);
                var lastBMI =  BMI.getBmiNumber(unit,height,lastWeight);
                weightComp.lastWeight = lastWeight;
                weightComp.lastBMI =lastBMI;
                weightComp.tipBMI = BMI.getTipToNormalBmi(lastBMI,unit,height,lastWeight,
                                                          age,gender);
                weightComp.bmiClass = BMI.getBMIClass(lastBMI,age,gender);
                weightComp.weightDirection = Storage.getWeightDirectionFromLastTime(userId);
                weightComp.updateStatistics();
                weightComp.userName= userName;
                graphComp.dataForChart = Storage.getArrayWeightGenaral(userId);
                graphComp.update();
                isEmpty= !(Storage.findLastWeigth(settings.userId)>0);
                listWeightPage.updateView();
                listStatisticsPage.updateView();
                if(settings.showOnMetric){
                    metrics.update(lastWeight)
                }
            }
        }
    }
    BottomEdge {
        id: bottomEdge
        height: parent.height
        width: main_page.width
        hint{
            action: Action {
                id: addAction
                iconName: "add"
                onTriggered: bottomEdge.commit()
            }
        }
        contentComponent: bottomEdgeContent
        Component {
            id: bottomEdgeContent
            NewWeightComponent{}
        }
        onCollapseCompleted: {
            mainView.updateView();
        }
    }
    Component.onCompleted:{
        //TODO: this set to solve this bug
        //https://bugs.launchpad.net/ubuntu/+source/ubuntu-ui-toolkit/+bug/1536669
        //but it's ugly solution!
        QuickUtils.mouseAttached=true

        Storage.initialize();
        isEmpty = !(Storage.findLastWeigth(settings.userId)>0);
    }
}

