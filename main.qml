import QtQuick 2.4
import QtQuick.Controls 1.3
import QtQuick.Window 2.2
import QtQuick.Dialogs 1.2
import QtQuick.Layouts 1.0

ApplicationWindow {
    id: mainApp
    title: "Farmnivore DB"
    width: 640
    height: 480
    visible: true

    property var hideSearchBar: function() {}
    property var showSearchBar: function() {}

    UiDispatcher {
        id: uiDispatcher
    }

    DbInterface {
        id: dbInterface
    }

    TabView {
        id: mainTabs
        anchors.fill: parent

        Tab {
            title: "Recipes"

            ColumnLayout {
                id: detailsColumn

                RecipeTable {
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                }

                MainButtons {
                    id: mainButtons
                    Layout.fillWidth: true
                    Layout.fillHeight: false
                }

                SearchBar {
                    id: mainSearchBar
                    visible: false
                    Layout.fillWidth: true
                    Layout.fillHeight: false

                    onSearchRequested: {
                        mainApp.hideSearchBar();
                        uiDispatcher.foodSearchRequested(stringlist);
                    }

                    onSearchCancelled: {
                        mainApp.hideSearchBar();
                    }
                }

                Component.onCompleted: {
                    mainApp.hideSearchBar = function() {
                        mainSearchBar.visible = false;
                        mainSearchBar.focus = false;
                        mainButtons.visible = true;
                    }

                    mainApp.showSearchBar = function() {
                        mainSearchBar.visible = true;
                        mainSearchBar.focus = true;
                        mainButtons.visible = false;
                    }
                }

                Keys.onBackPressed: {
                    if (mainSearchBar.activeFocus) {
                        hideSearchBar();
                    }
                }

                Keys.onEscapePressed: {
                    if (mainSearchBar.activeFocus) {
                        hideSearchBar();
                    }
                }
            }
        }
        Tab {
            title: "Ingredients"

            IngredientGroupList {
                id: thisIngredientList
                Layout.fillHeight: true
                Layout.fillWidth: true
                clip: true
            }
        }
    }

    Component.onCompleted: {
        uiDispatcher.searchBarRequested.connect(mainApp.showSearchBar);

        // ensure all tab compnents have been completed
        for (var i = 0; i < mainTabs.count; ++i) {
            mainTabs.currentIndex = i;
        }
        mainTabs.currentIndex = 0;

        // complete the search bar
        showSearchBar();
        hideSearchBar();
    }
}
