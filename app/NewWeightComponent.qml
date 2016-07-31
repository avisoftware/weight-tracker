import QtQuick 2.0
import Ubuntu.Components 1.3
import Ubuntu.Components.Pickers 1.3
import QtQuick.LocalStorage 2.0
import Ubuntu.Components.Popups 1.3

import "js/Storage.js" as Storage
Page {
    property alias selectedDate : dateTextField.date
    height: bottomEdge.height
    header: PageHeader {
        title: i18n.tr("Insert new weigth")
        StyleHints {
                foregroundColor:Qt.darker( UbuntuColors.green)
                dividerColor: Qt.darker( UbuntuColors.green)
            }
    }
    Column {
        spacing: units.gu(1)
        anchors {
            topMargin: units.gu(8)
            fill: parent
        }

        ListItem {
            height: weightLayout.height + divider.height
            ListItemLayout {
                id: weightLayout
                title.text: i18n.tr("Your Weight:")
                title.color: Qt.darker( UbuntuColors.green)
                subtitle.text:i18n.tr("Leave empty to delete weight")
                subtitle.color: Qt.darker( UbuntuColors.green)
                TextField {
                    id: weightTextField
                    SlotsLayout.position: SlotsLayout.Last
                    width:units.gu(10)
                    validator:  DoubleValidator {decimals: 1}
                    inputMethodHints:Qt.ImhFormattedNumbersOnly
                }
            }
        }

        ListItem {
            height: dateLayout.height + divider.height
            ListItemLayout {
                id: dateLayout
                title.text: i18n.tr("Date:")
                title.color: Qt.darker( UbuntuColors.green)
                Button{
                    SlotsLayout.position: SlotsLayout.Last
                    id: dateTextField
                    text :Qt.formatDate(date,Qt.SystemLocaleShortDate)
                    color: UbuntuColors.darkGrey
                    anchors.left:   parent.left
                    anchors.rightMargin:  units.gu(2)
                    property date date: new Date()
                    onClicked: PickerPanel.openDatePicker(dateTextField, "date");
                }
            }
        }
        Button {
            id: saveButton
            text: i18n.tr("Save")
            anchors.horizontalCenter: parent.horizontalCenter
            color: UbuntuColors.green
            onClicked: {
                if(weightTextField.text>0){
                    if(!Storage.checkDateExist(Qt.formatDate(selectedDate,"yyyy-MM-dd"),settings.userId)){
                        var r= Storage.setWeight (weightTextField.text,Qt.formatDate(selectedDate,"yyyy-MM-dd"),settings.userId);
                        closePage();
                    }else{
                        PopupUtils.open(dialog, null,{"typeDialog":"update"});
                    }
                }else if (weightTextField.text===0||weightTextField.text===""){
                    if(!Storage.checkDateExist(Qt.formatDate(selectedDate,"yyyy-MM-dd"),settings.userId)){

                    }else{
                        PopupUtils.open(dialog, null,{"typeDialog":"delete"});
                    }
                }
            }
            function closePage(){
                bottomEdge.collapse();
            }
        }
    }
    Component {
        id: dialog
        Dialog {
            id: dialogue
            property string typeDialog: "update"

            title: {
                if(typeDialog==="update"){
                    i18n.tr("Date exist")
                }else if(typeDialog==="delete") {
                    i18n.tr("Date exist")
                }
            }
            text:{
                if(typeDialog==="update"){
                    i18n.tr("On this date you already have a weight,\n do you want to update to the new weigth?")
                }else if(typeDialog==="delete") {
                    i18n.tr("Are you sure you want to delete this entry?")
                }
            }
            Row {
                id: row
                width: parent.width
                spacing: units.gu(1)
                Button {
                    width: parent.width/2 - row.spacing/2
                    text:  i18n.tr("Cancel")
                    onClicked: PopupUtils.close(dialogue)
                }
                Button {
                    width: parent.width/2 - row.spacing/2
                    text:{
                        if(typeDialog==="update"){
                            i18n.tr("Update")
                        }else if(typeDialog==="delete") {
                            i18n.tr("Delete")
                        }
                    }
                    color: UbuntuColors.green
                    onClicked: {
                        var r;
                        if(typeDialog==="update"){
                             r= Storage.updateWeight (weightTextField.text,Qt.formatDate(selectedDate,"yyyy-MM-dd"),settings.userId);
                        }else if(typeDialog==="delete") {
                            r= Storage.deleteWeight (Qt.formatDate(selectedDate,"yyyy-MM-dd"),settings.userId);
                        }
                        PopupUtils.close(dialogue)
                        saveButton.closePage();
                    }
                }
            }
        }
    }
}
