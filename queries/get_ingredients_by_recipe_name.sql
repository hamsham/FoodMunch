
SELECT
    name,
    amount
FROM
    ingredients
WHERE
    recipe_id=
    (
        SELECT DISTINCT
            id
        FROM
            recipes
        WHERE
            recipe=?
        LIMIT 1
    )
