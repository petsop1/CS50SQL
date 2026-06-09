-- In 13.sql, write a SQL query to explore a question of your choice. This query should:
-- SELECT"title" FROM "episodes" WHERE "air_date" LIKE '%-12-%';
SELECT "title" FROM "episodes" WHERE strftime('%m', "air_date") = '12';
