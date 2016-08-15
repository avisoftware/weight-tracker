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
                iconName:  "back"
                onTriggered: {
                    //                    if( parseFloat(ageTextField.text)>0&&parseFloat(heightTextField.text)>0 ){
                    pageLayout.primaryPage= mainPage
                    columnAdded = false
                    //                        if(settings.isFirstUse){
                    //                            settings.isFirstUse= false;
                    //                        }
                    //                    }else{
                    //                        //TODO: mark the filed that missing
                    //                    }
                }
            }
        ]
        trailingActionBar.actions: [
            Action {
                iconName:  "contact-new"
                onTriggered: {
                    columnAdded = true
                    pageLayout.addPageToNextColumn(settingsView, userComp,
                                                   {'id':-1,'age':0,'user_height':0,
                                                       'i_gender':0,'userName':''})
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
        id: usersModel
        Component.onCompleted: initialize()
        function initialize() {
            var  dataArr= Storage.getArrayUsers();
            if(dataArr.length <=0){
                usersModel.append({"name": 'user1' ,"userId":1})
            }

            for (var i=0; i<dataArr.length; i++){
                var name = dataArr[i][1];
                var id = dataArr[i][0];
                usersModel.append({"name": name ,"userId":id})
            }
            usersList.subText.text = usersModel.get(findUserIdIndex(settings.userId)).name
        }

    }
    function findUserIdIndex(userId){
        for (var i=0; i<=usersModel.count; i++){
            if( usersModel.get(i).userId===userId)
                return i;
        }
        return -1;
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
                id: userHeaderListItem
                height: units.gu(4)
                Label {
                    anchors { verticalCenter: parent.verticalCenter; left: parent.left; leftMargin: units.gu(2) }
                    text: i18n.tr("User Settings:")
                    font.bold: false
                    color:Qt.darker( UbuntuColors.green)

                }
            }
            ExpandableListItem {
                id: usersList
                listViewHeight: usersModel.count*units.gu(5)
                titleText.text: i18n.tr("User profile")
                titleText.color:Qt.darker( UbuntuColors.green)
                subText.color: Qt.darker( UbuntuColors.green)
                model: usersModel
                delegate: ListItem {
                    divider.visible: false
                    height: usersListItemLayout.height
                    leadingActions: ListItemActions {
                        actions: [
                            Action {
                                iconName: "delete"
                                onTriggered: {
                                    if(usersModel.count>1){
                                        PopupUtils.open(confirmDeleteUser,null,{ 'userId': model.userId })
                                    }else{
                                        PopupUtils.open(confirmDeleteUser,null,{ 'userId': -1 })

                                    }
                                }
                            }
                        ]
                    }
                    trailingActions: ListItemActions {
                        actions: [
                            Action {
                                iconName: "edit"
                                onTriggered: {
                                    if(model.userId>0){
                                        var details = Storage.getUserDetails(model.userId);
                                        var  age=details.age
                                        var user_height =details.height
                                        var i_gender=details.gender
                                        var userName =details.name
                                        pageLayout.addPageToNextColumn(settingsView, userComp,
                                                                       {'id':model.userId,'age':age,'user_height':user_height,
                                                                           'i_gender':i_gender,'userName':userName})
                                        columnAdded = true
                                    }
                                }

                            }
                        ]
                    }
                    ListItemLayout {
                        id: usersListItemLayout
                        title.text: model.name
                        title.color:Qt.darker( UbuntuColors.green)
                        height: units.gu(5)
                        padding { top: units.gu(1); bottom: units.gu(1) }
                        Icon {
                            SlotsLayout.position: SlotsLayout.Trailing
                            width: units.gu(2)
                            name: "tick"
                            visible: settings.userId === model.userId
                        }
                    }

                    onClicked: {
                        settings.userId = model.userId
                        usersList.subText.text = usersModel.get(findUserIdIndex(settings.userId)).name
                        usersList.expansion.expanded = false
                        mainPage.updateView()
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
                visible: !settings.isFirstUse
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
                id: confirmDeleteUser
                Dialog {
                    id: dialogueDeleteUser
                    property int userId;
                    title: i18n.tr("Delete user")
                    text:userId===-1?i18n.tr("You can't delete the last user!") :i18n.tr("You'll delete %1 account").arg(Storage.getUserName(userId))

                    Button {
                        text: i18n.tr("Delete")
                        color: UbuntuColors.red
                        visible: userId!==-1
                        onClicked: {
                            Storage.deleteUser(userId);
                            settings.userId=Storage.getMinUserId()
                            PopupUtils.close(dialogueDeleteUser);
                            updateUsersList();
                        }
                    }
                    Button {
                        text: i18n.tr("Cancel")
                        onClicked: PopupUtils.close(dialogueDeleteUser)
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
    function updateUsersList(){
        usersModel.clear();
        usersModel.initialize();
        mainPage.updateView()

    }
}



