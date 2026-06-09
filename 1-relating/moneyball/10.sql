/*
The general manager has asked you for a report which details each player’s name, their salary for each year they’ve been playing, and their number of home runs for each year they’ve been playing. To be precise, the table should include:
    All player’s first names
    All player’s last names
    All player’s salaries
    All player’s home runs
    The year in which the player was paid that salary and hit those home runs

In 10.sql, write a query to return just such a table.
    Your query should return a table with five columns, per the above.
    Order the results, first and foremost, by player’s IDs (least to greatest).
    Order rows about the same player by year, in descending order.
    Consider a corner case: suppose a player has multiple salaries or performances for a given year. Order them first by number of home runs, in descending order, followed by salary, in descending order.
    Be careful to ensure that, for a single row, the salary’s year and the performance’s year match.
*/

-- result
SELECT "players"."first_name", "players"."last_name", "salaries"."salary", "salaries"."year", "performances"."HR"
FROM "salaries"
JOIN "players"
    ON "players"."id" = "salaries"."player_id"
JOIN "performances"
    ON "performances"."player_id" = "salaries"."player_id"
    AND "performances"."year" = "salaries"."year"
ORDER BY "players"."id", "salaries"."year" DESC, "performances"."HR" DESC;

/* helpers below
SELECT COUNT(*) FROM (
SELECT "players"."id", "players"."first_name", "players"."last_name", "salaries"."salary", "salaries"."year", "performances"."HR", "performances"."year"
FROM "salaries"
JOIN "players"
    ON "players"."id" = "salaries"."player_id"
JOIN "performances"
    ON "performances"."player_id" = "salaries"."player_id"
    AND "performances"."year" = "salaries"."year"
ORDER BY "players"."id", "salaries"."year" DESC, "performances"."HR" DESC);

SELECT "salaries"."player_id", "salaries"."year", "salaries"."salary"
FROM "performances"
JOIN "salaries"
    ON "salaries"."player_id" = "performances"."player_id"
WHERE "salaries"."player_id" = 20728;

SELECT "salaries"."player_id", "salaries"."year", "salaries"."salary"
FROM "salaries"
JOIN "performances"
    ON "performances"."player_id" = "salaries"."player_id"
WHERE "salaries"."player_id" = 20728;

SELECT "salaries"."player_id", "salaries"."year", "salaries"."salary"
FROM "salaries"
WHERE "salaries"."player_id" = 20728;

SELECT "performances"."player_id", "performances"."year", "performances"."HR"
FROM "performances"
WHERE "performances"."player_id" = 20728;

SELECT "performances"."player_id", "performances"."year", "performances"."HR", "performances"."team_id"
FROM "performances"
WHERE "performances"."player_id" = 20728;
*/
