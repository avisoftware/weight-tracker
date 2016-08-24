import QtQuick 2.0
import Ubuntu.Components 1.3
import QtQuick.LocalStorage 2.0
import "js/Storage.js" as Storage
Item{
    id: statisticsItem
    height: statisticTitle.height+statisticLabel.height
    property int cardIndex:0;
    property var cardsArray :["avgLastWeek","avgLastMonth","avgLastYear",
        "maxWeight","minWeight","changeLastWeek","changeLastMonth","changeLastYear","changeFromStart"]
    property var dataArray :[]

    NumberAnimation {
        id: hide
        target: statItemScene
        properties: "opacity"
        from: 1
        to: 0
        duration: 1000
        onRunningChanged:{
            if (!hide.running) {
                setNextStatistic();
                show.start();
            }
        }
    }
    NumberAnimation {
        id: show
        target: statItemScene
        properties: "opacity"
        from: 0
        to: 1
        duration: 1000
    }
    Timer{
        id:timer
        interval: 4000;
        running: true;
        repeat: true;
        triggeredOnStart:false
        onTriggered:{
            if(statItemScene.opacity===0){
                show.start();
            }else if(statItemScene.opacity===1.0){
                hide.start();
            }
        }
    }
    Item {
        id: statItemScene
        opacity: 1
        Item{
            id: statisticTitle
            height: statisticTitelLabel.height
            anchors.top:parent.top
            Label{
                id: statisticTitelLabel
                anchors.top:  parent.top
                anchors.horizontalCenter: parent.horizontalCenter
                text:""
                fontSize: "small"
                horizontalAlignment: Text.AlignHCenter
                color:Qt.darker( UbuntuColors.green)
            }
        }
        Item{
            id:statisticItem
            height:statisticLabel.height
            width: statisticTitelLabel.width> statisticLabel.width ? statisticLabel.width:statisticTitelLabel.width
            anchors{
                top:statisticTitle.bottom
                horizontalCenter: parent.horizontalCenter
            }

            Label {
                id: statisticLabel
                anchors.centerIn:   parent
                text:""
                font.pixelSize:   isShort? units.dp(30):units.dp(40)
                color:Qt.darker(UbuntuColors.green)
            }
            Label {
                id:unitsLabel
                anchors.bottom: parent.bottom
                anchors.left: statisticLabel.right
                anchors.bottomMargin: (parent.height/2)-unitsLabel.height
                text:{
                    if (statisticLabel.text !==""){
                        if(settings.unit ===0){
                            return i18n.tr("KG");
                        }else{
                            return i18n.tr("LB");
                        }
                    }else{
                        ""
                    }
                }
                fontSize: "medium"
                color: Qt.darker(UbuntuColors.green)
            }
        }
    }

    function setFirstStatistic(){
        setStatistic(0);
    }

    function setNextStatistic(){
        cardIndex ++;
        if(cardIndex>=cardsArray.length){
            cardIndex=0;
        }
        setStatistic(cardIndex)
    }
    function setStatistic(index){
        var strTitle="";
        var periodStr="";
        var strStat =""
        var showUnits=true
        if(cardsArray[index]==="avgLastWeek"){
            periodStr=i18n.tr("last week")
            strTitle=isShort?i18n.tr("Average %1").arg(periodStr) :i18n.tr("Your average weight\nin the %1").arg(periodStr)
            var avgWeight =dataArray[0]
            strStat=avgWeight > 0.0 ? avgWeight.toFixed(2) : ""
        }else if(cardsArray[index]==="avgLastMonth"){
            periodStr=i18n.tr("last month")
            strTitle=isShort?i18n.tr("Average %1").arg(periodStr) :i18n.tr("Your average weight\nin the %1").arg(periodStr)
            var avgWeight =dataArray[1]
            strStat=avgWeight > 0.0 ? avgWeight.toFixed(2) : ""
        }else if(cardsArray[index]==="avgLastYear"){
            periodStr=i18n.tr("last year")
            strTitle=isShort?i18n.tr("Average %1").arg(periodStr) :i18n.tr("Your average weight\nin the %1").arg(periodStr)
            var avgWeight =dataArray[2]
            strStat=avgWeight > 0.0 ? avgWeight.toFixed(2) : ""
        }else if(cardsArray[index]==="maxWeight"){
            strTitle=i18n.tr("Your highest weight")
            var maxWeight =dataArray[3]
            strStat=maxWeight > 0.0 ? maxWeight.toFixed(1) : ""
        }else if(cardsArray[index]==="minWeight"){
            strTitle=i18n.tr("Your lowest weight")
            var minWeight =dataArray[4]
            strStat=minWeight > 0.0 ? minWeight.toFixed(1) : ""
        }else if(cardsArray[index]==="changeLastWeek"){
            var changeLastWeek =dataArray[5]
             periodStr=i18n.tr("last week")
            if(changeLastWeek<=0){
                strTitle=i18n.tr("You loss %1").arg(periodStr)
                strStat=(changeLastWeek*(-1)).toFixed(2)
            }else{
                strTitle=i18n.tr("You added %1").arg(periodStr)
                strStat=changeLastWeek.toFixed(2)
            }
        }else if(cardsArray[index]==="changeLastMonth"){
            var changeLastMonth =dataArray[6]
             periodStr=i18n.tr("last month")
            if(changeLastMonth<=0){
                strTitle=i18n.tr("You loss %1").arg(periodStr)
                strStat=(changeLastMonth*(-1)).toFixed(2)
            }else{
                strTitle=i18n.tr("You added %1").arg(periodStr)
                strStat=changeLastMonth.toFixed(2)
            }
        }else if(cardsArray[index]==="changeLastYear"){
            var changeLastYear =dataArray[7]
             periodStr=i18n.tr("last year")
            if(changeLastYear<=0){
                strTitle=i18n.tr("You loss %1").arg(periodStr)
                strStat=(changeLastYear*(-1)).toFixed(2)
            }else{
                strTitle=i18n.tr("You added %1").arg(periodStr)
                strStat=changeLastYear.toFixed(2)
            }
        }else if(cardsArray[index]==="changeFromStart"){
            var changeFromStart =dataArray[8]
             periodStr=i18n.tr("from start")
            if(changeFromStart<=0){
                strTitle=i18n.tr("You loss %1").arg(periodStr)
                strStat=(changeFromStart*(-1)).toFixed(2)
            }else{
                strTitle=i18n.tr("You added %1").arg(periodStr)
                strStat=changeFromStart.toFixed(2)
            }
        }
        statisticTitelLabel.text = strTitle
        statisticLabel.text =strStat
    }
    function initializeData(){
        dataArray[0]=Storage.getWeightAvgOnPeriod("lastWeek",settings.userId);
        dataArray[1]=Storage.getWeightAvgOnPeriod("lastMonth",settings.userId);
        dataArray[2]=Storage.getWeightAvgOnPeriod("lastYear",settings.userId);
        dataArray[3]=Storage.getMaxWeight(settings.userId);
        dataArray[4]=Storage.getMinWeight(settings.userId);
        dataArray[5]=Storage.getWeightChangesOnPeriod("lastWeek",settings.userId);
        dataArray[6]=Storage.getWeightChangesOnPeriod("lastMonth",settings.userId);
        dataArray[7]=Storage.getWeightChangesOnPeriod("lastYear",settings.userId);
        dataArray[8]=Storage.getWeightChangesOnPeriod("all",settings.userId);

        setFirstStatistic();
    }

    Component.onCompleted: {
        initializeData();
    }
}


