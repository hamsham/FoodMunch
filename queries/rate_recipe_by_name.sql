
UPDATE
    recipes
SET
    rating=?
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
