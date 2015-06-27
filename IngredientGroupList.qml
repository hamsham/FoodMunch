import QtQuick 2.0

DefaultGroupList {
    width: 640
    height: 480
    id: thisIngredientList

    model: ListModel {
        id: thisIngredientModel
    }

    Connections {
        target: uiDispatcher

        onIngredientListLoaded: {
            var itemList = dbIf.ingredientList;
            var numItems = itemList.length;

            console.log("Adding " + numItems + " ingredients to the display.");

            for (var i = 0; i < numItems; ++i) {
                var item = itemList[i];
                thisIngredientModel.append({"name": item.name+'\n     '+item.amount+'\n'});
            }
        }

        onIngredientListCleared: {
            thisIngredientModel.clear();
            console.log("Cleared ingredient list from the display.");
        }
    }
}

