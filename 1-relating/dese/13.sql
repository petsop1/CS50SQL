/*
In 13.sql, write a SQL query to answer a question you have about the data! The query should:
Involve at least one JOIN or subquery
My goal: A parent asks you for advice on finding the "worst" public school districts in Massachusetts so he can avoid them simmilar to 12.SQL but opposite. And now the averages are made only from public schools not all of them.
*/

SELECT "districts"."name", "expenditures"."per_pupil_expenditure", "staff_evaluations"."exemplary"
FROM "districts"
JOIN "expenditures"
    ON "expenditures"."district_id" = "districts"."id"
JOIN "staff_evaluations"
    ON "staff_evaluations"."district_id" = "districts"."id"
WHERE "districts"."type" = 'Public School District'
    AND "expenditures"."per_pupil_expenditure" < (
        SELECT AVG("expenditures"."per_pupil_expenditure")
        FROM "expenditures"
        JOIN "districts"
            ON "districts"."id" = "expenditures"."district_id"
        WHERE "districts"."type" = 'Public School District'
    )
    AND "staff_evaluations"."exemplary" < (
        SELECT AVG("staff_evaluations"."exemplary")
        FROM "staff_evaluations"
        JOIN "districts"
            ON "districts"."id" = "staff_evaluations"."district_id"
        WHERE "districts"."type" = 'Public School District'
    )
ORDER BY "exemplary", "per_pupil_expenditure";
