import QtQuick 2.4
import QtQuick.Controls 1.3
import QtQuick.Layouts 1.1


GroupBox {
    id: thisTable
    width: 640
    height: 480

    property string idColumn: 'recipeId'
    property string recipeColumn: 'recipe'
    property string servingsColumn: 'servings'
    property string ratingColumn: 'rating'
    property string bookmarkColumn: 'bookmarked'
    property string prepColumn: 'preptime'

    Component.onCompleted: {
        uiDispatcher.recipeListReloaded.connect(function(dbIf) {
            thisRecipeModel.clear();
            var recipeList = dbIf.recipeList;
            var numRecipes = recipeList.length;

            console.log("Adding " + numRecipes + " recipes to the display.");

            for (var i = 0; i < numRecipes; ++i) {
                var item = recipeList[i];
                thisRecipeModel.append({
                    "recipeId":     item.recipeId,
                    "recipe":       item.recipe,
                    "servings":     item.servings,
                    "rating":       '' + item.rating + '/5',
                    "bookmarked":   item.bookmarked,
                    "preptime":     '' + item.preptime + " minutes"
                });
            }
        });
    }

    ListModel {
        id: thisRecipeModel
    }

    TableView {
        id: thisRecipeTable
        clip: false
        highlightOnFocus: false
        headerVisible: true
        model: thisRecipeModel
        selectionMode: SelectionMode.SingleSelection
        anchors.fill: parent
        sortIndicatorVisible: false
        readonly property int avilableColumns: 5

        onClicked: {
            var recipeName = getRecipe(row).recipe;
            var recipeId = getRecipe(row).recipeId;
            console.log("Selected Recipe: " + recipeId + " - " + recipeName);
            uiDispatcher.reloadIngredients(recipeId);
        }

        TableViewColumn {
            title: "ID"
            role: idColumn
            movable: true
            width: 0
            visible: false
        }

        TableViewColumn {
            title: "Recipe"
            role: recipeColumn
            movable: true
            width: thisRecipeTable.viewport.width / thisRecipeTable.avilableColumns
        }
        TableViewColumn {
            title: "Servings"
            role: servingsColumn
            movable: true
            width: thisRecipeTable.viewport.width / thisRecipeTable.avilableColumns
        }
        TableViewColumn {
            title: "Rating"
            role: ratingColumn
            movable: true
            width: thisRecipeTable.viewport.width / thisRecipeTable.avilableColumns
        }
        TableViewColumn {
            title: "Bookmared ?"
            role: bookmarkColumn
            horizontalAlignment: Qt.AlignHCenter
            movable: true
            width: thisRecipeTable.viewport.width / thisRecipeTable.avilableColumns
            delegate: Component {
                CheckBox {
                    id: bookmarkCheck
                    checked: styleData.value
                    anchors.fill: parent
                    anchors.centerIn: parent
                    onClicked: {
                        var row = styleData.row;

                        if (row < 0) {
                            return;
                        }

                        var recipe = getRecipe(row).recipe;
                        var recipeId = getRecipe(row).recipeId;

                        if (bookmarkCheck.checked) {
                            console.log("Attempting to bookmark recipe: " + recipeId + "-" + recipe);
                        }
                        else {
                            console.log("Attempting to unbookmark recipe: " + recipeId + "-" + recipe);
                        }

                        uiDispatcher.bookmarkRecipe(recipeId, bookmarkCheck.checked);
                    }

                    Component.onCompleted: {
                        uiDispatcher.onRecipeBookmarked.connect(function(recipeId, isBookmarked) {
                            var cachedId = getRecipe(styleData.row).recipeId;

                            if (cachedId !== recipeId) {
                                // The table attempts to check 10 other rows when a check has been made.
                                // This may be intended behavior for Qt.
                                return;
                            }

                            bookmarkCheck.checked = isBookmarked ? true : false;
                            console.log("Recipe Bookmark Status: " + recipeId + "-" + isBookmarked);
                        });
                    }
                }
            }
        }
        TableViewColumn {
            title: "Prep Time"
            role: prepColumn
            movable: true
            width: thisRecipeTable.viewport.width / thisRecipeTable.avilableColumns
        }
    }

    function getRecipe(index) {
        return thisRecipeTable.model.get(index);
    }
}

