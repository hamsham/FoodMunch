
import QtQuick 2.4
import QtQuick.LocalStorage 2.0

import "RecipeSortOption.js" as RecipeSortOrder

QtObject {
    id: thisDbInterface
    property var recipeDB: null;
    property var recipeList: []
    property var ingredientList: []

    Component.onCompleted: {
        uiDispatcher.foodSearchRequested.connect(thisDbInterface.searchRecipesByFoods);
        uiDispatcher.reloadIngredients.connect(thisDbInterface.loadIngredientList);
        uiDispatcher.reloadRecipes.connect(function(sortorder, ascend) {
            if (thisDbInterface.recipeDB === null) {
                reloadDatabase();
            }
            console.log('' + sortorder + ' ' + ascend);
            thisDbInterface.reloadRecipeList(sortorder, ascend);
        });
        uiDispatcher.bookmarkRecipe.connect(thisDbInterface.bookmarkRecipe);
    }

    /*-------------------------------------
     * Reset all cached table data
    -------------------------------------*/
    function resetTables() {
        thisDbInterface.recipeList = [];
        uiDispatcher.recipeListCleared(thisDbInterface);
        thisDbInterface.ingredientList = [];
        uiDispatcher.ingredientListCleared(thisDbInterface);
    }

    /*-------------------------------------
     * Reload the database
    -------------------------------------*/
    function reloadDatabase() {
        thisDbInterface.recipeDB = LocalStorage.openDatabaseSync("FoodData", "1.0", "Everett's Food Database", 20480);
        return thisDbInterface.recipeDB;
    }

    /*-------------------------------------
     * Post recipes to the UI Dispatcher
    -------------------------------------*/
    function produceRecipes(rows) {
        var numRows = rows.length;
        var recipes = thisDbInterface.recipeList;

        for (var i = 0; i < numRows; ++i) {
            var item = rows.item(i);
            recipes.push({
                "recipeId":     item.id,
                "recipe":       item.recipe,
                "servings":     item.servings,
                "rating":       item.rating,
                "bookmarked":   item.bookmarked,
                "preptime":     item.prep_time
            });
        }

        console.log("Fetched " + recipes.length + " recipes from SQL.");

        uiDispatcher.recipeListReloaded(thisDbInterface);
    }

    /*-------------------------------------
     * Post ingredients to the Ui Dispatcher
    -------------------------------------*/
    function produceIngredients(recipe, rows) {
        var numRows = rows.length;
        var ingredients = thisDbInterface.ingredientList;

        for (var i = 0; i < numRows; ++i) {
            var item = rows.item(i);
            ingredients.push({"name": item.name, "amount": item.amount});
        }

        console.log("Fetched " + ingredients.length + " ingredients from SQL, using recipe " + recipe + ".");

        uiDispatcher.ingredientListLoaded(thisDbInterface);
    }

    /*-------------------------------------
     * Get the ID of a recipe based on its name
    -------------------------------------*/
    function getRecipeId(recipeName) {return recipeDB.transaction(function(tx) {
        var result = tx.executeSql('SELECT id FROM recipes WHERE recipe=?;', [recipeName]);
        var item = result.rows.item(0);
        if (item === undefined && !accessDbFile()) {
            console.log("Unable to locate SQL ID for Recipe \"" + recipeName + "\"");
            return -1;
        }

        var recipeId = item.id;
        console.log("Converted Recipe \"" + recipeName + "\" to the ID: " + recipeId);
        return recipeId;
    });}

    /*-------------------------------------
     * Reload all recipes based on a sorting order
    -------------------------------------*/
    function reloadRecipeList(sortorder, ascending) {recipeDB.transaction(function(tx) {
        thisDbInterface.resetTables();

        var query = 'SELECT DISTINCT id, recipe, servings, rating, bookmarked, prep_time FROM recipes';
        var sorter = '';

        if (sortorder !== 'undefined' && ascending !== 'undefined') {
            if (sortorder === RecipeSortOrder.SORT_BY_NAME) {
                sorter = ' ORDER BY recipe ' + (ascending ? 'ASC' : 'DESC');
            }
            else if (sortorder === RecipeSortOrder.SORT_BY_PREP_TIME) {
                sorter = ' ORDER BY prep_time ' + (ascending ? 'ASC' : 'DESC');
            }
            else if (sortorder === RecipeSortOrder.SORT_BY_RATING) {
                sorter = ' ORDER BY rating ' + (ascending ? 'ASC' : 'DESC');
            }
            else if (sortorder === RecipeSortOrder.SORT_BY_SERVINGS) {
                sorter = ' ORDER BY servings ' + (ascending ? 'ASC' : 'DESC');
            }
            else {
                sorter = ' WHERE _ROWID_ >= (abs(random()) % (SELECT max(_ROWID_) FROM recipes)) LIMIT 1';
            }
        }

        query = query + sorter + ';';
        console.log(query);

        var result = tx.executeSql(query);
        thisDbInterface.produceRecipes(result.rows);
    });}

    /*-------------------------------------
     * Load all ingredients based on a recipe ID
    -------------------------------------*/
    function loadIngredientList(recipeId) {recipeDB.transaction(function(tx) {
        thisDbInterface.ingredientList = [];
        uiDispatcher.ingredientListCleared(thisDbInterface);

        var result = tx.executeSql('SELECT name, amount FROM ingredients WHERE recipe_id=?;', [recipeId]);
        thisDbInterface.produceIngredients(recipeId, result.rows);
    });}

    /*-------------------------------------
     * Search for recipes containing specific foods
    -------------------------------------*/
    function searchRecipesByFoods(foods) {recipeDB.transaction(function(tx) {
        thisDbInterface.resetTables();

        if (foods.length === 0) {
            return;
        }

        var basicquery = "SELECT recipes.id, recipe, servings, rating, bookmarked, prep_time FROM recipes";
        basicquery += " LEFT JOIN ingredients ON recipes.id=ingredients.recipe_id WHERE ingredients.name LIKE ?";
        var query = basicquery;

        foods[0] = "%" + foods[0] + "%";

        for (var i = 1; i < foods.length; ++i) {
            foods[i] = "%" + foods[i] + "%";
            query = query.concat(" INTERSECT " + basicquery);
        }

        console.log("Searching for recipes matching a list of foods: " + foods);
        console.log(query);

        var result = tx.executeSql(query, foods);
        thisDbInterface.produceRecipes(result.rows);
    });}

    /*-------------------------------------
     * Bookmark a recipe by ID
    -------------------------------------*/
    function bookmarkRecipe(recipeId, isBookmarked) {recipeDB.transaction(function(tx) {
        console.log("Bookmarking recipe by ID: " + (recipeId));

        var result = tx.executeSql(
            "UPDATE recipes SET bookmarked=? WHERE id=?;",
            [isBookmarked, recipeId]
        );

        if (result.rowsAffected !== 1) {
            console.error("Failed to bookmark recipe by ID: " + recipeId);
        }
        else {
            uiDispatcher.recipeBookmarked(recipeId, isBookmarked);
        }
    });}
}

