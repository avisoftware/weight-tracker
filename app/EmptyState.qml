import QtQuick 2.0
import Ubuntu.Components 1.3

Item {
    id: emptyStateScreen

    anchors {
        centerIn: parent
    }
    Icon {
        id: emptyStateIcon
        anchors.top: emptyStateScreen.top
        anchors.horizontalCenter: parent.horizontalCenter
        height: units.gu(9)
        width: height
        opacity: 0.5
        source: "../../../graphics/weighter.svg"
        color:Qt.darker(UbuntuColors.green)
    }
    Label {
        id: emptyStateLabel
        anchors.top: emptyStateIcon.bottom
        anchors.topMargin: units.gu(1)
        anchors.left: parent.left
        anchors.right: parent.right
        text: i18n.tr("Insert new Weight\nby swiping up from\nthe bottom of the screen.")
        color: Qt.darker(UbuntuColors.green)
        fontSize: "x-large"
        wrapMode: Text.WordWrap
        horizontalAlignment: Text.AlignHCenter
    }
}

