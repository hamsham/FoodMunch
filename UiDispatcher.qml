import QtQuick 2.4


QtObject {
    signal sortByPopularity(bool ascending);
    signal sortByPrepTime(bool ascending);

    signal randomizeRecipes();
    signal reloadRecipes(int sortorder, bool ascend);
    signal reloadIngredients(int recipId);

    signal bookmarkRecipe(int recipeId, bool isBookmarked);
    signal recipeBookmarked(int recipeId, bool isBookmarked);

    signal recipeListReloaded(var dbIf);
    signal recipeListCleared(var dbIf);

    signal ingredientListLoaded(var dbIf);
    signal ingredientListCleared(var dbIf);

    signal searchBarRequested();
    signal searchBarCancelled();
    signal foodSearchRequested(var foodlist);
}

