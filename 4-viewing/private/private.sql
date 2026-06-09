DROP TABLE IF EXISTS "triplets";

CREATE TABLE "triplets" (
    "id" INTEGER,
    "sentence" INTEGER NOT NULL,
    "start_char" INTEGER NOT NULL,
    "length" INTEGER NOT NULL,
    PRIMARY KEY ("id")
);

INSERT INTO "triplets" ("sentence", "start_char", "length")
VALUES
('14', '98', 4),
('114', '3', 5),
('618', '72', 9),
('630', '7', 3),
('932', '12', 5),
('2230', '50', 7),
('2346', '44', 10),
('3041', '14', 5);

CREATE VIEW "message" AS
SELECT substr("sentences"."sentence", "triplets"."start_char", "triplets"."length") AS "phrase"
FROM "sentences"
JOIN "triplets"
    ON "triplets"."sentence" = "sentences"."id";

/* *************helpers
SELECT * FROM "sentences" LIMIT 10;
SELECT * FROM "triplets";
SELECT "phrase" FROM "message";
SELECT COUNT(*) FROM "sentences";
*/
