-- In 10.sql, write SQL query to answer a question of your choice. This query should:
    -- Make use of AS to rename a column
    -- Involve at least condition, using WHERE
    -- Sort by at least one column using ORDER BY

SELECT "first_name" AS 'Name', "last_name" AS 'Surname'
FROM "players"
WHERE "final_game" LIKE '2023%'
ORDER BY "first_name", "last_name"
LIMIT 10;
