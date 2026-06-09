
-- *** The Lost Letter ***

-- brief knowing of tables
.tables
SELECT * FROM "addresses" LIMIT 10;
SELECT COUNT(*) FROM "addresses";

SELECT * FROM "drivers" LIMIT 10;
SELECT COUNT(*) FROM "drivers";

SELECT * FROM "packages" LIMIT 10;
SELECT COUNT(*) FROM "packages";

SELECT * FROM "scans" LIMIT 10;
SELECT COUNT(*) FROM "scans";

-- check if the Anneke adress is among adresses = id = 432, Residential type
SELECT * FROM "addresses" WHERE "address" = '900 Somerville Avenue';


-- Justo to check delivery adress, results to no result
SELECT * FROM "addresses" WHERE "address" = '2 Finnegan Street';
SELECT * FROM "addresses" WHERE "address" LIKE '%Finnegan%';
SELECT * FROM "addresses" WHERE "address" LIKE '%2 %';

-- scans table match
SELECT * FROM "scans" WHERE "address_id" = '432';

-- select id of the adress only
SELECT id FROM "addresses" WHERE "address" = '900 Somerville Avenue';

-- 1. same as above but nested query tested = package_id = 384, 5436, 2437, 3529
SELECT * FROM "scans" WHERE "address_id" = (
    SELECT id FROM "addresses" WHERE "address" = '900 Somerville Avenue'
);

-- 2. check the package id --> result 4 packages, one is Congratulatory letter with id = 384, to_address_id = 854
SELECT * FROM "packages" WHERE "from_address_id" = 432;

-- 3. check the address for id=854
SELECT * FROM "addresses" WHERE "id" = 854;

-- 4. check scans details
SELECT * FROM "scans" WHERE "package_id" = 384;



-- *** The Devious Delivery ***
-- brief table check
.tables
SELECT * FROM "addresses" LIMIT 10;
SELECT COUNT(*) FROM "addresses";

SELECT * FROM "drivers" LIMIT 10;
SELECT COUNT(*) FROM "drivers";

SELECT * FROM "packages" LIMIT 10;
SELECT COUNT(*) FROM "packages";

SELECT * FROM "scans" LIMIT 10;
SELECT COUNT(*) FROM "scans";


-- check packages with null values in from_adress_id
SELECT * FROM "packages" WHERE "from_address_id" IS NULL;

-- check the delivery to address
SELECT * FROM "addresses" WHERE "id" = 50;

-- check the scans if it was delivered
SELECT * FROM "scans" WHERE "package_id" = 5098;

-- it was delivered to wrong address_id that is = 348
SELECT * FROM "addresses" WHERE "id" = 348;





-- *** The Forgotten Gift ***
-- check the id of delivery destination = id=4983, residential
SELECT * FROM "addresses" WHERE "address" = '728 Maple Place';

-- check the id of ship off destination, id=9873, residential
SELECT * FROM "addresses" WHERE "address" = '109 Tileston Street';

-- get the package id = 9523
SELECT * FROM "packages" WHERE "from_address_id" = 9873;
SELECT * FROM "packages" WHERE "to_address_id" = 4983;

-- check the delivery history
SELECT * FROM "scans" WHERE "package_id" = 9523;
-- check the driver_id who has it
SELECT * FROM "drivers" WHERE "id" = 17;

