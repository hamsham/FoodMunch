SELECT
    recipes.id,
    recipe,
    servings,
    rating,
    bookmarked,
    prep_time
FROM
    recipes
LEFT JOIN
    ingredients
ON
    recipes.id=ingredients.recipe_id
WHERE
    ingredients.name
LIKE
    ?
INTERSECT /* WARNING: Sqlite3-specific */
SELECT
    recipes.id,
    recipe,
    servings,
    rating,
    bookmarked,
    prep_time
FROM
    recipes
LEFT JOIN
    ingredients
ON
    recipes.id=ingredients.recipe_id
WHERE
    ingredients.name
LIKE
    ?
