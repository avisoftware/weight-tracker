import QtQuick 2.0
import Ubuntu.Components 1.3
import QtQuick.LocalStorage 2.0
import UserMetrics 0.1

MainView {
    objectName: "mainView"
    applicationName: "weight-tracker.avisoftware"

    property bool isWide: pageLayout.width > units.gu(80)
    property bool columnAdded: false

    //LayoutMirroring.enabled: Qt.locale().textDirection == Qt.RightToLeft
    //LayoutMirroring.childrenInherit: true

    width: units.gu(50)
    height: units.gu(75)
    Settings {
        id:settings
    }
    Metric {
            id: metrics
            name: "weight-tracker"
            format: i18n.tr("Your weight today is %1")
            emptyFormat: i18n.tr("No weight today.")
            domain: "weight-tracker.avisoftware"
        }

    backgroundColor: "#fff"
    AdaptivePageLayout {
        id: pageLayout
        anchors.fill: parent
        primaryPage:{
            if(settings.isFirstUse){
                userComp;
            }else{
                mainPage
            }
        }
        layouts: [
            // configure two columns
            PageColumnsLayout {
                when: isWide && columnAdded
                PageColumn {
                    fillWidth: true
                }
                PageColumn {
                    minimumWidth: units.gu(0)
                    maximumWidth: units.gu(50)
                    preferredWidth: units.gu(40)
                }

            },
            // configure minimum size for single column
            PageColumnsLayout {
                when: true
                PageColumn {
                    minimumWidth: units.gu(40)
                    fillWidth: true
                }
            }
        ]
        MainPage{
            id:mainPage
        }
        AboutPage{
            id: aboutPage
        }
        ListWeightPage{
            id: listWeightPage
        }
        SettingsView{
            id:settingsView
        }
        UserComponent{
            id: userComp
        }

    }
}
