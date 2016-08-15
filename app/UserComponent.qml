import QtQuick 2.4
import Ubuntu.Components 1.3
import QtQuick.LocalStorage 2.0
import Ubuntu.Components.Popups 1.3

import "js/Storage.js" as Storage

Page {
    property int id:-1
    property int age:0
    property int user_height :0
    property int i_gender:0
    property string userName :""


    header: PageHeader {
        id: main_header
        title: i18n.tr("User profile")
        flickable: flickable
        StyleHints {
            foregroundColor:Qt.darker( UbuntuColors.green)
            dividerColor: Qt.darker( UbuntuColors.green)
        }
       leadingActionBar.actions: [
            Action {
                visible: ! settings.isFirstUse
                iconName: "back"
                onTriggered: {
                    pageLayout.removePages(settingsView)
                    columnAdded = false
                }

            }
        ]
        trailingActionBar.actions: [
            Action {
                iconName: "ok"
                enabled: ( parseFloat(ageTextField.text)>0&&parseFloat(heightTextField.text)>0 &&nameTextField.text!=="")
                onTriggered: {
                    if( parseFloat(ageTextField.text)>0&&parseFloat(heightTextField.text)>0 &&nameTextField.text!==""){                       
                        if(settings.isFirstUse||id===-1){
                            Storage.insertUser(userName,age,user_height,i_gender);
                            if(settings.isFirstUse){
                                 pageLayout.primaryPage= mainPage
                            }else{
                                pageLayout.removePages(settingsView)
                            }
                            settings.isFirstUse= false;
                            columnAdded = false
                        }else{
                            Storage.updateUser(id,userName,age,user_height,i_gender)
                            columnAdded = false
                            pageLayout.removePages(settingsView)
                        }
                        //reload the list of users
                        settingsView.updateUsersList();
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
            genderList.subText.text = genderModel.get(i_gender).gender
        }
    }
    onI_genderChanged:{
        genderModel.initialize()
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
                height: nameLayout.height + divider.height
                ListItemLayout {
                    id: nameLayout
                    title.text: i18n.tr("Your Name:")
                    title.color:Qt.darker( UbuntuColors.green)
                    TextField {
                        id: nameTextField
                        SlotsLayout.position: SlotsLayout.Last
                        width:units.gu(20)
                        text:userName
                        onTextChanged: {
                            if (text!==""){
                                userName = text;
                            }
                        }                      
                    }
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
                        text: age !=0 ? age:"";
                        onTextChanged: {
                            age= parseFloat(text);
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
                        width:units.gu(15)
                        validator:  IntValidator {}
                        inputMethodHints:Qt.ImhFormattedNumbersOnly
                        text:user_height !=0 ? user_height:""
                        onTextChanged: {
                            user_height= parseFloat(text);
                        }
                    }
                    Label{
                        fontSize: "mediun"
                        color: Qt.darker( UbuntuColors.green)
                        SlotsLayout.position: SlotsLayout.Last
                        text:{
                            if(settings.unit ===0){
                                return i18n.tr("CM");
                            }else{
                                return i18n.tr("IN");
                            }
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
                subText.text: genderModel.get(i_gender).gender
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
                            visible: i_gender === model.index
                        }
                    }

                    onClicked: {
                        i_gender = model.index
                        genderList.subText.text = genderModel.get(i_gender).gender
                        genderList.expansion.expanded = false
                    }
                }
            }

            ExpandableListItem {
                id: unitList
                visible: settings.isFirstUse
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
       }        
    }
}



