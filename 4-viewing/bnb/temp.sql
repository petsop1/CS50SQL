SELECT * FROM "availabilities" LIMIT 15;
SELECT COUNT(*) FROM "availabilities";

SELECT "id", "property_type", "host_name", "acommodates", "bedrooms", concat(substr("description", 1, 20), ' ...') AS "description" FROM "listings" LIMIT 2;
SELECT COUNT(*) FROM "listings";

SELECT "id", "listing_id", "date", "reviewer_name", concat(substr("comments", 1, 20), ' ...') AS "comments"  FROM "reviews" LIMIT 2;
SELECT COUNT(*) FROM "reviews";
