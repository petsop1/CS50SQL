/*
Hits are great, but so are RBIs! In 12.sql, write a SQL query to find the players among the 10 least expensive players per hit and among the 10 least expensive players per RBI in 2001.
    Your query should return a table with two columns, one for the players’ first names and one of their last names.
    You can calculate a player’s salary per RBI by dividing their 2001 salary by their number of RBIs in 2001.
    You may assume, for simplicity, that a player will only have one salary and one performance in 2001.
    Order your results by player ID, least to greatest (or alphabetically by last name, as both are the same in this case!).
    Keep in mind the lessons you’ve learned in 10.sql and 11.sql!
*/


-- result, simplest one
SELECT "first_name", "last_name"
FROM (
    SELECT "players"."first_name", "players"."last_name"
    FROM "salaries"
    JOIN "players"
        ON "players"."id" = "salaries"."player_id"
    JOIN "performances"
        ON "performances"."player_id" = "salaries"."player_id"
        AND "performances"."year" = "salaries"."year"
    WHERE "salaries"."year" = 2001
        AND "performances"."H" > 0
    ORDER BY ("salaries"."salary" * 1.0 / "performances"."H"), "players"."id"
    LIMIT 10
)

INTERSECT

SELECT "first_name", "last_name"
FROM (
    SELECT "players"."first_name", "players"."last_name"
    FROM "salaries"
    JOIN "players"
        ON "players"."id" = "salaries"."player_id"
    JOIN "performances"
        ON "performances"."player_id" = "salaries"."player_id"
        AND "performances"."year" = "salaries"."year"
    WHERE "salaries"."year" = 2001
        AND "performances"."RBI" > 0
    ORDER BY ("salaries"."salary" * 1.0 / "performances"."RBI"), "players"."id"
    LIMIT 10
)
ORDER BY "last_name", "first_name";



------------------------- result v2, more robust, using players.id, nested query with intersect
/*
SELECT "players"."first_name", "players"."last_name"
FROM "players"
WHERE "players"."id" IN (
    SELECT "id"
    FROM (
        SELECT "players"."id"
        FROM "salaries"
        JOIN "players"
            ON "players"."id" = "salaries"."player_id"
        JOIN "performances"
            ON "performances"."player_id" = "salaries"."player_id"
            AND "performances"."year" = "salaries"."year"
        WHERE "salaries"."year" = 2001
            AND "performances"."H" > 0
        ORDER BY ("salaries"."salary" * 1.0 / "performances"."H"), "players"."id"
        LIMIT 10
    )

    INTERSECT

    SELECT "id"
    FROM (
        SELECT "players"."id"
        FROM "salaries"
        JOIN "players"
            ON "players"."id" = "salaries"."player_id"
        JOIN "performances"
            ON "performances"."player_id" = "salaries"."player_id"
            AND "performances"."year" = "salaries"."year"
        WHERE "salaries"."year" = 2001
            AND "performances"."RBI" > 0
        ORDER BY ("salaries"."salary" * 1.0 / "performances"."RBI"), "players"."id"
        LIMIT 10
    )
)
ORDER BY "players"."id";
*/


-- Result ver. 3 – Using WITH clause (most reccomended in general, even if not covered in the lesson)
/*
WITH "cheapest_per_hit" AS (
    SELECT "players"."id"
    FROM "salaries"
    JOIN "players"
        ON "players"."id" = "salaries"."player_id"
    JOIN "performances"
        ON "performances"."player_id" = "salaries"."player_id"
       AND "performances"."year" = "salaries"."year"
    WHERE "salaries"."year" = 2001
      AND "performances"."H" > 0
    ORDER BY ("salaries"."salary" * 1.0 / "performances"."H"), "players"."id"
    LIMIT 10
),
"cheapest_per_rbi" AS (
    SELECT "players"."id"
    FROM "salaries"
    JOIN "players"
        ON "players"."id" = "salaries"."player_id"
    JOIN "performances"
        ON "performances"."player_id" = "salaries"."player_id"
       AND "performances"."year" = "salaries"."year"
    WHERE "salaries"."year" = 2001
      AND "performances"."RBI" > 0
    ORDER BY ("salaries"."salary" * 1.0 / "performances"."RBI"), "players"."id"
    LIMIT 10
)
SELECT "players"."first_name", "players"."last_name"
FROM "players"
WHERE "players"."id" IN (
    SELECT "id" FROM "cheapest_per_hit"
    INTERSECT
    SELECT "id" FROM "cheapest_per_rbi"
)
ORDER BY "players"."id";
*/


-- ver4 using JOIN, more cleaner version
/*
WITH "cheapest_per_hit" AS (
    SELECT "players"."id"
    FROM "salaries"
    JOIN "players"
        ON "players"."id" = "salaries"."player_id"
    JOIN "performances"
        ON "performances"."player_id" = "salaries"."player_id"
       AND "performances"."year" = "salaries"."year"
    WHERE "salaries"."year" = 2001
      AND "performances"."H" > 0
    ORDER BY ("salaries"."salary" * 1.0 / "performances"."H"), "players"."id"
    LIMIT 10
),
"cheapest_per_rbi" AS (
    SELECT "players"."id"
    FROM "salaries"
    JOIN "players"
        ON "players"."id" = "salaries"."player_id"
    JOIN "performances"
        ON "performances"."player_id" = "salaries"."player_id"
       AND "performances"."year" = "salaries"."year"
    WHERE "salaries"."year" = 2001
      AND "performances"."RBI" > 0
    ORDER BY ("salaries"."salary" * 1.0 / "performances"."RBI"), "players"."id"
    LIMIT 10
)
SELECT "players"."first_name", "players"."last_name"
FROM "players"
JOIN "cheapest_per_hit"
    ON "players"."id" = "cheapest_per_hit"."id"
JOIN "cheapest_per_rbi"
    ON "players"."id" = "cheapest_per_rbi"."id"
ORDER BY "players"."id";
*/
