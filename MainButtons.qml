import QtQuick 2.0
import QtQuick.Layouts 1.0
import QtQuick.Controls 1.2

import "RecipeSortOption.js" as RecipeSortOption


GroupBox {
    height: thisToolButtonLayout.height

    Flickable {
        clip: true
        height: thisToolButtonLayout.height
        width: parent.width
        contentWidth: thisToolButtonLayout.width
        contentHeight: thisToolButtonLayout.height

        RowLayout {
            id: thisToolButtonLayout
            height: Layout.implicitHeight
            Layout.fillWidth: true
            property bool ascend: false

            ToolButton {
                text: "Refresh"
                onClicked: {
                    thisToolButtonLayout.ascend = !thisToolButtonLayout.ascend;
                    uiDispatcher.reloadRecipes(RecipeSortOption.SORT_BY_NAME, thisToolButtonLayout.ascend);
                }
            }

            ToolButton {
                text: "Search"
                onClicked: {
                    uiDispatcher.searchBarRequested();
                }
            }

            ToolButton {
                text: "Sort By Popularity"
                onClicked: {
                    thisToolButtonLayout.ascend = !thisToolButtonLayout.ascend;
                    uiDispatcher.reloadRecipes(RecipeSortOption.SORT_BY_RATING, thisToolButtonLayout.ascend);
                }
            }

            ToolButton {
                text: "Sort By Servings"
                onClicked: {
                    thisToolButtonLayout.ascend = !thisToolButtonLayout.ascend;
                    uiDispatcher.reloadRecipes(RecipeSortOption.SORT_BY_SERVINGS, thisToolButtonLayout.ascend);
                }
            }

            ToolButton {
                text: "Sort By Prep Time"
                onClicked: {
                    thisToolButtonLayout.ascend = !thisToolButtonLayout.ascend;
                    uiDispatcher.reloadRecipes(RecipeSortOption.SORT_BY_PREP_TIME, thisToolButtonLayout.ascend);
                }
            }

            ToolButton {
                text: "Randomize"
                onClicked: {
                    thisToolButtonLayout.ascend = !thisToolButtonLayout.ascend;
                    uiDispatcher.reloadRecipes(RecipeSortOption.SORT_BY_RANDOM, thisToolButtonLayout.ascend);
                }
            }
            Item {
                Layout.fillWidth: true
            }
        }
    }
}
