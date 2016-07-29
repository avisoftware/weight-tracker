import QtQuick 2.0
import Ubuntu.Components 1.3
import QtQuick.LocalStorage 2.0

import "js/Storage.js" as Storage

Page {
     id: root
    header: PageHeader {
        id: main_header
        title: i18n.tr("Weight History")
        StyleHints {
                foregroundColor:Qt.darker( UbuntuColors.green)
                dividerColor: Qt.darker( UbuntuColors.green)
            }
        leadingActionBar.actions: [
            Action {
                iconName: "back"
                onTriggered: {
                    pageLayout.removePages(listWeightPage)
                    columnAdded = false
                }
            }
        ]
    }
        Flickable {
            id: page_flickable
            anchors {
                top: main_header.bottom
                left: parent.left
                right: parent.right
                bottom: parent.bottom
            }

            contentHeight:  view.height + units.gu(2)
            clip: true
            ListModel{
                id: model
            }

           ListView{
               id:view
               width: parent.width;
               height: model.count * units.gu(8)

               model:  model
               delegate: ListItem {
                   id: listItem
                   leadingActions: ListItemActions {
                                  actions: [
                                      Action {
                                          iconName: "delete"
                                          onTriggered: {
                                             if( Storage.deleteWeight(date,settings.userId)==="OK"){
                                                updateView();
                                                 mainPage.updateView()
                                             }

                                          }
                                      }
                                  ]
                              }
                   ListItemLayout {
                       title.text: date
                       title.color:Qt.darker( UbuntuColors.green)
                       Label {
                           text: {
                               var units =""
                               if(settings.unit ===0){
                                   units= i18n.tr("KG");
                               }else{
                                   units= i18n.tr("LB");
                               }
                               weight+" "+units}
                           color:Qt.darker( UbuntuColors.green)
                       }
                   }
               }
           }
           Component.onCompleted: {
              updateView();
           }

        }
        function updateView(){
            model.clear();
            var db = Storage.getDatabase();
            db.transaction(function(tx) {
                var rs = tx.executeSql('SELECT * FROM weight WHERE userId=?  ORDER BY date DESC',[settings.userId]);
                for(var i =0;i < rs.rows.length;i++){
                    model.append(rs.rows.item(i));
                }
            }
            );
        }
}


