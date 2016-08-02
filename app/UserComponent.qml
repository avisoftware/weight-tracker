import QtQuick 2.4
import Ubuntu.Components 1.3
import QtQuick.LocalStorage 2.0
import Ubuntu.Components.Popups 1.3

import "js/Storage.js" as Storage

Page {
    header: PageHeader {
        id: main_header
        title: i18n.tr("Settings")
        flickable: flickable
        StyleHints {
            foregroundColor:Qt.darker( UbuntuColors.green)
            dividerColor: Qt.darker( UbuntuColors.green)
        }
        leadingActionBar.actions: [
            Action {
                iconName: settings.isFirstUse ?"ok": "back"
                onTriggered: {
                    if( parseFloat(ageTextField.text)>0&&parseFloat(heightTextField.text)>0 ){
                        pageLayout.primaryPage= mainPage
                        columnAdded = false
                        if(settings.isFirstUse){
                            settings.isFirstUse= false;
                        }
                    }else{
                        //TODO: mark the filed that missing
                    }
                }
            }
        ]
    }
    ListModel {
        id: unitModel
        Component.onCompleted: initialize()
        function initialize() {
            unitModel.append({ "unit": i18n.tr("KG/CM"), "index": 0 })
            unitModel.append({ "unit": i18n.tr("LB/IN"), "index": 1 })
            unitList.subText.text = unitModel.get(settings.unit).unit
        }
    }
    ListModel {
        id: genderModel
        Component.onCompleted: initialize()
        function initialize() {
            genderModel.append({ "gender": i18n.tr("Male"), "index": 0 })
            genderModel.append({ "gender": i18n.tr("Female"), "index": 1 })
            genderList.subText.text = genderModel.get(settings.gender).gender
        }
    }
    ListModel {
        id: deleteHistoryModel
        Component.onCompleted: initialize()
        function initialize() {
            deleteHistoryModel.append({ "period": i18n.tr("Older then month"), "index": 0 })
            deleteHistoryModel.append({ "period": i18n.tr("Older then 6 month"), "index": 1 })
            deleteHistoryModel.append({ "period": i18n.tr("Older then year"), "index": 2 })
            deleteHistoryModel.append({ "period": i18n.tr("All history"), "index": 3 })

        }
    }
    Flickable {
        id: flickable
        anchors.fill: parent
        contentHeight: settingsColumn.height + units.gu(5)

        Column {
            id: settingsColumn
            anchors {
                top: parent.top
                left: parent.left
                right: parent.right
            }
            ListItem {
                id: firstUseListItem
                height: units.gu(6)
                visible: settings.isFirstUse
                Label {
                    anchors { verticalCenter: parent.verticalCenter; left: parent.left; leftMargin: units.gu(2) }
                    text: i18n.tr("It is your first use, insert your details to proceed")
                    color:Qt.darker( UbuntuColors.green)
                    font.bold: true
                }
            }
            ListItem {
                id: userHeaderListItem
                height: units.gu(4)
                Label {
                    anchors { verticalCenter: parent.verticalCenter; left: parent.left; leftMargin: units.gu(2) }
                    text: i18n.tr("User Settings:")
                    font.bold: false
                    color:Qt.darker( UbuntuColors.green)

                }
            }

            ListItem {
                height: ageLayout.height + divider.height
                ListItemLayout {
                    id: ageLayout
                    title.text: i18n.tr("Your Age:")
                    title.color:Qt.darker( UbuntuColors.green)
                    TextField {
                        id: ageTextField
                        SlotsLayout.position: SlotsLayout.Last
                        width:units.gu(20)
                        validator:  IntValidator {}
                        inputMethodHints:Qt.ImhFormattedNumbersOnly
                        onTextChanged: {
                            settings.age= parseFloat(text);
                        }
                        Component.onCompleted: {
                            text= settings.age !=0 ? settings.age:"";
                        }
                    }
                }
            }
            ListItem {
                height: heightLayout.height + divider.height
                ListItemLayout {
                    id: heightLayout
                    title.text: i18n.tr("Your Height:")
                    title.color:Qt.darker( UbuntuColors.green)
                    TextField {
                        id: heightTextField
                        SlotsLayout.position: SlotsLayout.Last
                        width:units.gu(20)
                        validator:  IntValidator {}
                        inputMethodHints:Qt.ImhFormattedNumbersOnly
                        onTextChanged: {
                            settings.height= parseFloat(text);
                        }
                        Component.onCompleted: {
                            text= settings.height !=0 ? settings.height:""
                        }
                    }
                }
            }
            ExpandableListItem {
                id: genderList
                listViewHeight: units.gu(9)
                titleText.text: i18n.tr("Gender")
                titleText.color:Qt.darker( UbuntuColors.green)
                subText.color: Qt.darker( UbuntuColors.green)
                model: genderModel

                delegate: ListItem {
                    divider.visible: false
                    height: genderListItemLayout.height
                    ListItemLayout {
                        id: genderListItemLayout
                        title.text: model.gender
                        title.color:Qt.darker( UbuntuColors.green)
                        padding { top: units.gu(1); bottom: units.gu(1) }
                        Icon {
                            SlotsLayout.position: SlotsLayout.Trailing
                            width: units.gu(2)
                            name: "tick"
                            visible: settings.gender === model.index
                        }
                    }

                    onClicked: {
                        settings.gender = model.index
                        genderList.subText.text = genderModel.get(settings.gender).gender
                        genderList.expansion.expanded = false
                    }
                }
            }
            ListItem {
                id: generalHeaderListItem
                height: units.gu(4)
                Label {
                    anchors { verticalCenter: parent.verticalCenter; left: parent.left; leftMargin: units.gu(2) }
                    text: i18n.tr("General Settings:")
                    font.bold: false
                    color:Qt.darker( UbuntuColors.green)

                }
            }
            ExpandableListItem {
                id: unitList
                listViewHeight: units.gu(9)
                titleText.text: i18n.tr("Units")
                titleText.color:Qt.darker( UbuntuColors.green)
                 subText.color: Qt.darker( UbuntuColors.green)
                model: unitModel
                delegate: ListItem {
                    divider.visible: false
                    height: unitListItemLayout.height
                    ListItemLayout {
                        id: unitListItemLayout
                        title.text: model.unit
                        title.color:Qt.darker( UbuntuColors.green)
                        padding { top: units.gu(1); bottom: units.gu(1) }
                        Icon {
                            SlotsLayout.position: SlotsLayout.Trailing
                            width: units.gu(2)
                            name: "tick"
                            visible: settings.unit === model.index
                        }
                    }
                    onClicked: {
                        settings.unit = model.index
                        unitList.subText.text = unitModel.get(settings.unit).unit
                        unitList.expansion.expanded = false
                    }
                }
            }
            ListItem {
                height: metricLayout.height + divider.height
                ListItemLayout {
                    id: metricLayout
                    title.text: i18n.tr("Show on the Metric")
                    title.color:Qt.darker( UbuntuColors.green)
                    Switch {
                        id: metricSwitch
                        checked: settings.showOnMetric
                        onClicked: {
                            settings.showOnMetric = checked;
                        }
                        SlotsLayout.position: SlotsLayout.Last
                    }
                }
            }
            ExpandableListItem {
                id: clearHistoryList
                listViewHeight: units.gu(18)
                titleText.text: i18n.tr("Clear History")
                titleText.color:Qt.darker( UbuntuColors.green)
                subText.color: Qt.darker( UbuntuColors.green)
                model: deleteHistoryModel
                delegate: ListItem {
                    divider.visible: false
                    height: clearHistoryListItemLayout.height
                    ListItemLayout {
                        id: clearHistoryListItemLayout
                        title.text: model.period
                        title.color:Qt.darker( UbuntuColors.green)
                        padding { top: units.gu(1); bottom: units.gu(1) }
                        Icon {
                            SlotsLayout.position: SlotsLayout.Trailing
                            width: units.gu(2)
                            name: "tick"
                            visible: false
                        }
                    }

                    onClicked: {
                        onClicked: PopupUtils.open(confirmEraseHistory,null,{ 'period': model.index })
                        clearHistoryList.expansion.expanded = false
                    }
                }
            }
            Component {
                id: confirmEraseHistory
                Dialog {
                    id: dialogueErase
                    property int period;
                    property string periodStr: {
                         switch (period){
                         case 0:
                             "older then month"
                             break;
                         case 1:
                             "older then 6 month"
                             break;
                         case 2:
                             "older then year"
                             break;
                         case 3:
                             "all"
                             break;
                         }
                    }

                    title: i18n.tr("Clear History")
                    text: i18n.tr("You'll delete %1 history").arg(periodStr)

                    Button {
                        text: i18n.tr("Delete")
                        color: UbuntuColors.red
                        onClicked: {
                            Storage.deleteHistoryOnPeriod(period,settings.userId);
                            PopupUtils.close(dialogueErase);
                            mainPage.updateView();
                        }
                    }
                    Button {
                        text: i18n.tr("Cancel")
                        onClicked: PopupUtils.close(dialogueErase)
                    }
                }
            }
        }
    }
}



