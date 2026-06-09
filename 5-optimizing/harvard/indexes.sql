-- Indexes
CREATE INDEX "enrollments_student_index" ON "enrollments" ("student_id"); --from 25 MB to 43 MB
CREATE INDEX "enrollments_course_index" ON "enrollments" ("course_id"); -- from 43 MB to 59 MB
CREATE INDEX "courses_department_index" ON "courses" ("department"); -- from 59 MB to 60 MB
CREATE INDEX "courses_semester_index" ON "courses" ("semester"); -- from 60 MB to 60 MB, so no gain
CREATE INDEX "satisfies_index" ON "satisfies" ("course_id"); -- from 60 MB to 61 MB




/*
DROP INDEX "enrollments_student_index";
DROP INDEX "enrollments_course_index";
DROP INDEX "courses_index";
DROP INDEX "courses_semester_index";
DROP INDEX "satisfies_index";
*/
-- VACUUM;
-- du -h harvard.db;
