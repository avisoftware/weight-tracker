import QtQuick 2.4
import Ubuntu.Components 1.3

/*
 Component which extends the SDK Expandable list item and provides a easy
 to use component where the title, subtitle and a listview can be displayed. It
 matches the design specification provided for clock.
*/

ListItem {
    id: expandableListItem

    // Public APIs
    property ListModel model
    property Component delegate
    property alias titleText: expandableHeader.title
    property alias subText: expandableHeader.subtitle
    property alias listViewHeight: expandableListLoader.height

    height: headerListItem.height
    expansion.height: headerListItem.height + expandableListLoader.height
    onClicked: expansion.expanded = !expansion.expanded

    ListItem {
        id: headerListItem
        height: expandableHeader.height + divider.height

        ListItemLayout {
            id: expandableHeader

            Icon {
                id: arrow

                width: units.gu(2)
                height: width
                SlotsLayout.position: SlotsLayout.Trailing
                name: "go-down"
                rotation: expandableListItem.expansion.expanded ? 180 : 0

                Behavior on rotation {
                    UbuntuNumberAnimation {}
                }
            }
        }
    }

    Loader {
        id: expandableListLoader
        width: parent.width
        asynchronous: true
        anchors.top: headerListItem.bottom
        sourceComponent: expandableListItem.expansion.expanded ? expandableListComponent : undefined
    }

    Component {
        id: expandableListComponent
        ListView {
            id: expandableList
            interactive: false
            model: expandableListItem.model
            delegate: expandableListItem.delegate
        }
    }
}
