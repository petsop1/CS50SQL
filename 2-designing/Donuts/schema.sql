-- Deletes prior tables if they exist
DROP TABLE IF EXISTS "ingredients";
DROP TABLE IF EXISTS "donuts";
DROP TABLE IF EXISTS "composition";
DROP TABLE IF EXISTS "customers";
DROP TABLE IF EXISTS "orders";


CREATE TABLE "ingredients" (
    "id" INTEGER,
    "ingredient" TEXT NOT NULL,
    "price" INTEGER NOT NULL,
    "unit" TEXT NOT NULL UNIQUE,
    "brand" TEXT NOT NULL,
    "type" TEXT,
    UNIQUE ("ingredient", "brand", "type"),
    PRIMARY KEY ("id")
);


CREATE TABLE "donuts" (
    "id" INTEGER,
    "name" TEXT NOT NULL UNIQUE,
    "gluten-free" TEXT NOT NULL,
    "price" TEXT NOT NULL,
    "valid" INTEGER,
    PRIMARY KEY ("id")
);


CREATE TABLE "composition" (
    "id" INTEGER,
    "donut_id" INTEGER,
    "ingredient_id" INTEGER,
    FOREIGN KEY ("donut_id") REFERENCES "donuts"("id"),
    FOREIGN KEY ("ingredient_id") REFERENCES "ingredients"("id"),
    PRIMARY KEY ("id")
);


CREATE TABLE "customers" (
    "id" INTEGER,
    "first_name" TEXT NOT NULL UNIQUE,
    "last_name" TEXT NOT NULL,
    PRIMARY KEY ("id")
);


CREATE TABLE "orders" (
    "id" INTEGER,
    "customer_id" INTEGER,
    "donut_id" INTEGER,
    "count" INTEGER,
    "datetime" NUMERIC NOT NULL DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY ("customer_id") REFERENCES "customers"("id"),
    FOREIGN KEY ("donut_id") REFERENCES "donuts"("id"),
    PRIMARY KEY ("id")
);
