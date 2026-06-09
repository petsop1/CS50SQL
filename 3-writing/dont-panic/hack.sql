-- VERSION 1, more academic, more align with 3 described steps
-- Alter the password of the website’s administrative account, admin, to instead be “oops!”.
UPDATE "users"
SET "password" = '982c0381c279d139fd221fce974916e7'
WHERE "username" = 'admin';

-- Erase any logs of the above password change recorded by the database.
DELETE FROM "user_logs"
WHERE "old_username" = 'admin';

-- adds completely new line
INSERT INTO "user_logs" ("type", "old_username", "new_username", "old_password", "new_password")
VALUES ('update', 'admin', 'admin', 'e10adc3949ba59abbe56e057f20f883e', (SELECT "password" FROM "users" WHERE "username" = 'emily33'));



-- VERSION 2, more practical, less queries, more simple
/*
UPDATE "users"
SET "password" = '982c0381c279d139fd221fce974916e7'
WHERE "username" = 'admin';

UPDATE "user_logs"
SET "new_password" = (SELECT "password" FROM "users" WHERE "username" = 'emily33')
WHERE "old_username" = 'admin';
*/
