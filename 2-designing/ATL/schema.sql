
-- Deletes prior tables if they exist
DROP TABLE IF EXISTS "passengers";
DROP TABLE IF EXISTS "checkins";
DROP TABLE IF EXISTS "airlines";
DROP TABLE IF EXISTS "flights";


CREATE TABLE "passengers" (
    "id" INTEGER,
    "first_name" TEXT NOT NULL,
    "last_name" TEXT NOT NULL,
    "age" INTEGER  NOT NULL CHECK ("age" BETWEEN 0 AND 130),
    UNIQUE ("first_name", "last_name", "age"),
    PRIMARY KEY ("id")
);


CREATE TABLE "checkins" (
    "id" INTEGER,
    "passenger_id" INTEGER,
    "datetime" NUMERIC NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "flight_code" TEXT NOT NULL,
    "destination" TEXT NOT NULL,
    PRIMARY KEY ("id")
);


CREATE TABLE "airlines" (
    "id" INTEGER,
    "airline" TEXT NOT NULL UNIQUE,
    "councourse" TEXT NOT NULL CHECK("concourse" IN ("A", "B", "C", "D", "E", "F", "T")),
    PRIMARY KEY ("id")
);

CREATE TABLE "flights" (
    "id" INTEGER,
    "flight_number" INTEGER NOT NULL,
    "airline" TEXT,
    "departure_airport_code" TEXT NOT NULL,
    "destination_airport_code" TEXT NOT NULL,
    "expected_departure" NUMBER NOT NULL,
    "expected_arrival" NUMBER NOT NULL,
    FOREIGN KEY ("airline") REFERENCES "airlines"("airline"),
    PRIMARY KEY ("id")
);


/*
CREATE TABLE "swipes" (
    "id" INTEGER,
    "card_id" INTEGER,
    "station_id" INTEGER,
    "type" TEXT NOT NULL CHECK("type" IN ('enter', 'exit', 'deposit')),
    "datetime" NUMERIC NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "amount" NUMERIC NOT NULL CHECK("amount" != 0),
    PRIMARY KEY("id"),
    FOREIGN KEY("station_id") REFERENCES "stations"("id"),
    FOREIGN KEY("card_id") REFERENCES "cards"("id")
);


CREATE TABLE "stations" (
    "id" INTEGER,
    "name" TEXT NOT NULL UNIQUE,
    "line" TEXT NOT NULL,
    PRIMARY KEY("id")
);



*/
