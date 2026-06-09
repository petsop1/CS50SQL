SELECT * FROM "courses" LIMIT 10;
SELECT COUNT(*) FROM "courses";

SELECT * FROM "enrollments" LIMIT 10;
SELECT COUNT(*) FROM "enrollments";

SELECT * FROM "requirements" LIMIT 10;
SELECT COUNT(*) FROM "requirements";

SELECT * FROM "satisfies" LIMIT 10;
SELECT COUNT(*) FROM "satisfies";

SELECT * FROM "students" LIMIT 10;
SELECT COUNT(*) FROM "students";

-- VACUUM;
-- du -h harvard.db;

DROP INDEX "enrollments_student_index";
DROP INDEX "enrollments_course_index";
DROP INDEX "courses_index";
DROP INDEX "courses_semester_index";
DROP INDEX "satisfies_index";



-- ****
SELECT * FROM "courses" LIMIT 10;
SELECT DISTINCT "department" FROM "courses";
SELECT DISTINCT "title" FROM "courses";
SELECT COUNT(DISTINCT "title") FROM "courses";

SELECT * FROM "courses" GROUP BY "title" ORDER BY "department", "title" LIMIT 10;
SELECT COUNT(*) FROM (SELECT * FROM "courses" GROUP BY "title" ORDER BY "department", "title");

SELECT * FROM "courses" WHERE "department" IN ('Literature', 'Material Science', 'Mathematics', 'Philosophy', 'Sociology') GROUP BY "title" ORDER BY "department", "title";
SELECT * FROM "courses" WHERE "department" IN ('Art History', 'Classics', 'Computer Science', 'Education', 'History', 'Humanities') GROUP BY "title" ORDER BY "department", "title";
SELECT DISTINCT "department" FROM "courses";
SELECT COUNT(*) FROM (SELECT DISTINCT "department" FROM "courses");


SELECT COUNT(DISTINCT "semester") FROM "courses";
SELECT "semester", COUNT("title") as "title" FROM "courses" GROUP BY "semester" ORDER BY "title" DESC;

SELECT "department", COUNT("title") as "title" FROM "courses" GROUP BY "department" ORDER BY "title";
SELECT COUNT(*) FROM "courses";




-- **************
.schema
CREATE TABLE IF NOT EXISTS "students" (
    "id" INTEGER,
    "name" TEXT NOT NULL,
    PRIMARY KEY("id")
);
CREATE TABLE IF NOT EXISTS "enrollments" (
    "id" INTEGER,
    "student_id" INTEGER,
    "course_id" INTEGER,
    PRIMARY KEY("id"),
    FOREIGN KEY("student_id") REFERENCES "students"("id"),
    FOREIGN KEY("course_id") REFERENCES "courses"("id")
);
CREATE TABLE IF NOT EXISTS "courses" (
    "id" INTEGER,
    "department" TEXT NOT NULL,
    "number" INTEGER NOT NULL,
    "semester" TEXT NOT NULL,
    "title" TEXT NOT NULL,
    PRIMARY KEY("id")
);
CREATE TABLE IF NOT EXISTS "satisfies" (
    "id" INTEGER,
    "course_id" INTEGER,
    "requirement_id" INTEGER,
    PRIMARY KEY("id"),
    FOREIGN KEY("course_id") REFERENCES "courses"("id"),
    FOREIGN KEY("requirement_id") REFERENCES "requirements"("id")
);
CREATE TABLE IF NOT EXISTS "requirements" (
    "id" INTEGER,
    "name" TEXT NOT NULL,
    PRIMARY KEY("id")
);




