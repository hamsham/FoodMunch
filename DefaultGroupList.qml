
import QtQuick 2.4
import QtQuick.Controls 1.3
import QtQuick.Layouts 1.1


GroupBox {
    id: thisGroupBox
    width: 640
    height: 480

    property alias model: thisListView.model
    property alias delegate: thisListView.delegate
    property alias header: thisListView.header
    property alias footer: thisListView.footer
    property alias orientation: thisListView.orientation

    ScrollView {
        id: thisScrollView
        anchors.fill: parent

        ListView {
            id: thisListView
            anchors.fill: parent

            model: ListModel {
                id: thisListModel
            }

            delegate: Label {
                id: thisListDelegate
                width: thisScrollView.width
                clip: true
                text: name

                wrapMode: Text.Wrap
            }
        }
    }
}

