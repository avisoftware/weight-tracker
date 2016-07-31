import QtQuick 2.4
import Ubuntu.Components 1.3
import QtQuick.LocalStorage 2.0
import Ubuntu.Components.Popups 1.3
import "js/BMI.js" as BMI
import "js/Storage.js" as Storage
Item {
    id: rect
    property double lastWeight: 0.0
    property int lastBMI: 0
    property int tipBMI: 0
    property int bmiClass: 0
    property string weightDirection: ""
    Item{
        id:topSide
        height: (parent.height /3)*2
        width:  parent.width
        anchors{
            top:parent.top
            horizontalCenter:  parent.horizontalCenter
        }
        Item{
            id:titleItem
            height: weightTitelLabel.height
            width:  parent.width
            anchors{
                top:parent.top
                horizontalCenter:  parent.horizontalCenter
            }
            Label{
                id: weightTitelLabel
                anchors{
                    bottom:parent.bottom
                    horizontalCenter:  parent.horizontalCenter
                }
                text:lastWeight > 0 ? i18n.tr("Your last weight from ")+Storage.findLastDate(settings.userId) : ""
                fontSize: "small"
                color:Qt.darker( UbuntuColors.green)
            }
        }
        Item{
            id: weigthItem
            height: parent.height -titleItem.height
            width:rowLeft.implicitWidth
            anchors{
                top: titleItem.bottom
                horizontalCenter:  parent.horizontalCenter
            }
            Row{
                id: rowLeft
                anchors.centerIn:  parent
                Item{
                    id: weightDirectionItem
                     height: upIcon.height*2
                    width: upIcon.width
                    anchors.verticalCenter: parent.verticalCenter
                    Icon{
                        id: upIcon
                        anchors.bottom: downIcon.top
                        width: units.gu(3)
                        height: units.gu(3)
                        name: "up"
                        visible: !( weightDirection ==="d")
                        color:{
                            if(weightDirection == "u"){
                                UbuntuColors.red
                            }else{
                                UbuntuColors.green
                            }
                        }

                        source: "../../../graphics/up.svg"
                        MouseArea{
                            anchors.fill:parent
                            onClicked:{
                                var t = "up"
                                if(weightDirection === "s"||weightDirection === "-"){
                                    t="same"
                                }
                                PopupUtils.open(popover, upIcon, { 'typeS': t } )
                            }
                        }
                    }
                    Icon{
                        id: downIcon
                        anchors.bottom:  parent.bottom
                        width: units.gu(3)
                        height: units.gu(3)
                        name: "down"
                        visible: !(weightDirection === "u")
                        color: UbuntuColors.green
                        source: "../../../graphics/down.svg"
                        MouseArea{
                            anchors.fill:parent
                            onClicked:{
                                var t = "down"
                                if(weightDirection === "s"||weightDirection === "-"){
                                    t="same"
                                }
                                PopupUtils.open(popover, downIcon, { 'typeS': t } )
                            }
                        }
                    }
                }
                Item{
                    id: lastWeightItem
                    height: parent.height
                    width: weightLabel.implicitWidth
                    Label {
                        id: weightLabel
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.horizontalCenter: parent.horizontalCenter
                        text:lastWeight > 0 ? lastWeight.toString().replace(".", Qt.locale().decimalPoint) : "--"
                        font.pixelSize: lastWeight>99.9?units.dp(90): units.dp(110)
                        color:Qt.darker( UbuntuColors.green)
                    }
                }
                Rectangle{
                    id: kgTipItem
                    anchors.bottom: parent.bottom
                    height: t_metrics.tightBoundingRect.height
                    width: kgTipLabel.implicitWidth>kgLable.implicitWidth ? kgTipLabel.implicitWidth:kgLable.implicitWidth
                    Label {
                        id : kgTipLabel
                        height: parent.height/2
                        anchors.top: parent.top
                        anchors.horizontalCenter: parent.horizontalCenter
                        opacity: 0.5
                        text:{
                            if(lastBMI > 0){
                                if( tipBMI>0){
                                    return "+"+ tipBMI
                                }else if(tipBMI===0){
                                    ""
                                }else{
                                    return tipBMI
                                }
                            }else{
                                return ("-")
                            }
                        }
                        fontSize: "x-large"
                        color:{
                            if( tipBMI>0){
                                Qt.darker( UbuntuColors.red)
                            }else if(tipBMI<0){
                                Qt.darker( UbuntuColors.orange)
                            }else{
                                Qt.darker( UbuntuColors.green)
                            }
                        }
                        MouseArea{
                            anchors.fill:parent
                            onClicked:{
                                var t = ""
                                if(tipBMI!==0){
                                    if(tipBMI >0){
                                        t="plusWeight"
                                    }else{
                                        t="minusWeight"
                                    }
                                    PopupUtils.open(popover,kgTipLabel , { 'typeS': t } )
                                }
                            }
                        }
                    }
                    Label {
                        id: kgLable
                        anchors.left: parent.left
                        anchors.bottom: parent.bottom
                        anchors.horizontalCenter: parent.horizontalCenter
                        text:{
                            if (lastWeight > 0.0){
                                if(settings.unit ===0){
                                    return i18n.tr("KG");
                                }else{
                                    return i18n.tr("LB");
                                }
                            }else{
                                ""
                            }
                        }
                        fontSize: "large"
                        color: Qt.darker( UbuntuColors.green)
                    }
                }
                TextMetrics {
                        id:     t_metrics
                        font:   weightLabel.font
                        text:   weightLabel.text
                    }
            }
        }
    }
    Item{
        id: bottomSide
        height: parent.height /3
        width : parent.width /2
        anchors{
            bottom:parent.bottom
            horizontalCenter: parent.horizontalCenter

        }
        Item{
            id: bottomRect
            height: parent.height
            anchors{
                centerIn: parent
            }
            Label{
                id: bmiTitelLabel
                anchors.top:  parent.top
                anchors.horizontalCenter: parent.horizontalCenter
                text:lastWeight > 0 ? i18n.tr("Your BMI"):""
                fontSize: "small"
                color:Qt.darker( UbuntuColors.green)
            }
            Item{
                height: parent.height
                width: bmiLabel.implicitWidth > statusLabel.implicitWidth ? bmiLabel.implicitWidth:statusLabel.implicitWidth
                anchors{
                    top:parent.top
                    horizontalCenter: parent.horizontalCenter
                }
                Item{
                    id: bmiItem
                    height: (parent.height /3)*2
                    width: bmiLabel.implicitWidth
                    anchors{
                        top:parent.top
                        horizontalCenter: parent.horizontalCenter
                    }
                    Label {
                        id: bmiLabel
                        anchors.bottom: parent.bottom
                        anchors.horizontalCenter: parent.horizontalCenter
                        text:lastBMI > 0 ? lastBMI : "--"
                        font.pixelSize:  units.dp(40)
                        color:statusLabel.color
                    }
                }
                Item{
                    id: statusItem
                    height: parent.height /3
                    width: statusLabel.implicitWidth
                    anchors{
                        bottom:parent.bottom
                        horizontalCenter: parent.horizontalCenter
                    }
                    Label {
                        id:statusLabel
                        anchors.top: parent.top
                        anchors.horizontalCenter: parent.horizontalCenter
                        text:{
                            switch (bmiClass){
                            case BMI.BMIClass.VERY_SEVERELY_UNDERWEIGHT:
                                i18n.tr("Very Severely Underweight");
                                break;
                            case BMI.BMIClass.SEVERELY_UNDERWEIGHT:
                                i18n.tr("Severely Underweight")
                                break;
                            case BMI.BMIClass.UNDERWEIGHT:
                                i18n.tr("Underweight")
                                break;
                            case BMI.BMIClass.NORMAL:
                                i18n.tr("Normal")
                                break;
                            case BMI.BMIClass.OVERWEIGHT:
                                i18n.tr("Overweight")
                                break;
                            case BMI.BMIClass.OBESE:
                                i18n.tr("Obese")
                                break;
                            case BMI.BMIClass.OBESE_CLASS_I:
                                i18n.tr("Obese Class I")
                                break;
                            case BMI.BMIClass.OBESE_CLASS_II:
                                i18n.tr("Obese Class II")
                                break;
                            case BMI.BMIClass.OBESE_CLASS_III:
                                i18n.tr("Obese Class III")
                                break;
                            default:
                                ""
                            }
                        }
                        fontSize: "medium"
                        color: {
                            switch (bmiClass){
                            case BMI.BMIClass.VERY_SEVERELY_UNDERWEIGHT:
                            case BMI.BMIClass.SEVERELY_UNDERWEIGHT:
                            case BMI.BMIClass.UNDERWEIGHT:
                                Qt.darker( UbuntuColors.orange)
                                break;
                            case BMI.BMIClass.NORMAL:
                                Qt.darker( UbuntuColors.green)
                                break;
                            case BMI.BMIClass.OVERWEIGHT:
                            case BMI.BMIClass.OBESE:
                            case BMI.BMIClass.OBESE_CLASS_I:
                            case BMI.BMIClass.OBESE_CLASS_II:
                            case BMI.BMIClass.OBESE_CLASS_III:
                                Qt.darker( UbuntuColors.red)
                                break;
                            default:
                                Qt.darker( UbuntuColors.green)
                            }
                        }
                    }
                }
            }
        }
    }
    Component {
        id: popover
        Popover {
            id:pop
            property string typeS:"str";
            Item{
                width:l.contentWidth
                height: l.implicitHeight + units.gu(2)
                anchors.left: parent.left
                anchors.right: parent.right
                Label{
                    id: l
                    anchors.horizontalCenter: parent.horizontalCenter
                    horizontalAlignment:Text.AlignHCenter
                    color: Qt.darker(UbuntuColors.green)
                    text: {
                        if(typeS==="up"){
                            i18n.tr("Your weight increased from the last time")
                        }else if(typeS==="down"){
                            i18n.tr( "Your weight decreased from last time")
                        }else if(typeS==="same"){
                            i18n.tr("Your weight same as last time")
                        }else if(typeS==="plusWeight"){
                            i18n.tr("Your weight is higher than recommended")
                        }else if(typeS==="minusWeight"){
                            i18n.tr("Your weight is lower than recommended")
                        }
                    }

                }
            }
        }
    }


}

