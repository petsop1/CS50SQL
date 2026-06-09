
-- Deletes prior tables if they exist
DROP TABLE IF EXISTS "users";
DROP TABLE IF EXISTS "schools";
DROP TABLE IF EXISTS "companies";
DROP TABLE IF EXISTS "connections_people";
DROP TABLE IF EXISTS "connections_schools";
DROP TABLE IF EXISTS "connections_companies";


CREATE TABLE "users" (
    "id" INTEGER,
    "first_name" TEXT NOT NULL,
    "last_name" TEXT NOT NULL,
    "user_name" TEXT NOT NULL UNIQUE,
    "password" TEXT NOT NULL,
    "school_id" INTEGER,
    "company_id" INTEGER,
    UNIQUE ("first_name", "last_name", "user_name"),
    FOREIGN KEY("school_id") REFERENCES "schools"("id"),
    FOREIGN KEY("company_id") REFERENCES "company"("id"),
    PRIMARY KEY ("id")
);


CREATE TABLE "schools" (
    "id" INTEGER,
    "school" TEXT NOT NULL UNIQUE,
    "type" TEXT NOT NULL,
    "location" TEXT NOT NULL,
    "founded_in" INTEGER,
    PRIMARY KEY ("id")

);


CREATE TABLE "companies" (
    "id" INTEGER,
    "company" TEXT NOT NULL UNIQUE,
    "industry" TEXT NOT NULL,
    "location" TEXT NOT NULL,
    PRIMARY KEY ("id")
);


CREATE TABLE "connections_people" (
    "id" INTEGER,
    "user_id_A" INTEGER,
    "user_id_B" INTEGER,
    FOREIGN KEY ("user_id_A") REFERENCES "users"("id"),
    FOREIGN KEY ("user_id_B") REFERENCES "users"("id"),
    PRIMARY KEY ("id")
);


CREATE TABLE "connections_schools" (
    "id" INTEGER,
    "user_id" INTEGER,
    "school_id" INTEGER,
    "start_date" NUMERIC,
    "end_date" NUMERIC,
    "degree" TEXT,
    FOREIGN KEY ("user_id") REFERENCES "users"("id"),
    FOREIGN KEY ("school_id") REFERENCES "schools"("id"),
    PRIMARY KEY ("id")
);


CREATE TABLE "connections_companies" (
    "id" INTEGER,
    "user_id" INTEGER,
    "company_id" INTEGER,
    "start_date" NUMERIC,
    "end_date" NUMERIC,
    "job_title" TEXT,
    FOREIGN KEY ("user_id") REFERENCES "users"("id"),
    FOREIGN KEY ("company_id") REFERENCES "companies"("id"),
    PRIMARY KEY ("id")
);
