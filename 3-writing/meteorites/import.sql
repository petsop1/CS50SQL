.import --csv meteorites.csv meteorites_temp

-- Deletes rows where "nametype" is "Relict"
DELETE FROM "meteorites_temp" WHERE "nametype" = "Relict";

-- cleaning up short version
UPDATE "meteorites_temp"
SET
    "mass" = CASE WHEN TRIM("mass") = '' THEN NULL ELSE ROUND("mass", 2) END,
    "lat" = CASE WHEN TRIM("lat") = '' THEN NULL ELSE ROUND("lat", 2) END,
    "long" = CASE WHEN TRIM("long") = '' THEN NULL ELSE ROUND("long", 2) END,
    "year" = CASE WHEN TRIM("year") = '' THEN NULL ELSE "year" END;

-- cleaning up long version
/*
UPDATE "meteorites" SET "lat" = NULL WHERE TRIM("lat") = '';
UPDATE "meteorites" SET "long" = NULL WHERE TRIM("long") = '';
UPDATE "meteorites" SET "mass" = NULL WHERE TRIM("mass") = '';
UPDATE "meteorites" SET "year" = NULL WHERE TRIM("mass") = '';

UPDATE "meteorites" SET "lat" = ROUND("lat", 2) WHERE "lat" IS NOT NULL;
UPDATE "meteorites" SET "long" = ROUND("long", 2) WHERE "long" IS NOT NULL;
UPDATE "meteorites" SET "mass" = ROUND("mass", 2) WHERE "mass" IS NOT NULL;
UPDATE "meteorites" SET "year" = ROUND("year", 2) WHERE "mass" IS NOT NULL;
*/


CREATE TABLE "meteorites" (
    "id" INTEGER,
    "name" TEXT NOT NULL,
    "class" TEXT,
    "mass" REAL,
    "discovery" TEXT,
    "year" INTEGER,
    "lat" REAL,
    "long" REAL,
    PRIMARY KEY ("id")
);


INSERT INTO "meteorites" ("name", "class", "mass", "discovery", "year", "lat", "long")
SELECT "name", "class", "mass", "discovery", "year", "lat", "long"
FROM "meteorites_temp"
ORDER BY "year", "name";

DROP TABLE "meteorites_temp";
