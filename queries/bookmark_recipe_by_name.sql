
UPDATE
    recipes
SET
    bookmarked=?
WHERE
    id=
    (
        SELECT DISTINCT
            id
        FROM
            recipes
        WHERE
            recipe=?
        LIMIT 1
    )
