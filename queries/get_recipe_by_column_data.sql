
SELECT DISTINCT
    id,
    recipe,
    servings,
    rating,
    bookmarked,
    prep_time
FROM
    recipes
/*
ORDER BY
    recipe
*/
/*
ORDER BY
    prep_time
*/
/*
ORDER BY
    recipe
*/
/*
ORDER BY
    rating
*/
/*
ORDER BY
    servings
*/
/* random recipe */
WHERE
    _ROWID_ >= (
        abs(random()) % (
            SELECT
                max(_ROWID_)
            FROM
                recipes
        )
    )
LIMIT 1
/*
ASC
*/
