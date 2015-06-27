
import QtQuick 2.4
import QtQuick.Controls 1.3
import QtQuick.Layouts 1.1

GroupBox {
    id: thisSearchBar
    width: 480
    signal searchRequested(var stringlist)
    signal searchCancelled()

    onActiveFocusChanged: {
        thisTextField.focus = thisSearchBar.focus;
    }

    onVisibleChanged: {
        thisTextField.focus = thisSearchBar.visible;
    }

    RowLayout {
        id: thisLayout
        anchors.fill: parent

        TextField {
            id: thisTextField
            Layout.fillWidth: true
            Layout.fillHeight: true

            onAccepted: {
                thisSearchBar.searchRequested(thisTextField.text.split(" "));
            }
        }

        Button {
            id: thisSearchButton
            text: "Search"
            Layout.fillWidth: false
            Layout.fillHeight: true

            onClicked: {
                thisSearchBar.searchRequested(thisTextField.text.split(" "));
            }
        }

        Button {
            id: thisCancelButton
            text: "Cancel"
            Layout.fillWidth: false
            Layout.fillHeight: true

            onClicked: {
                thisSearchBar.searchCancelled();
            }
        }
    }
}
