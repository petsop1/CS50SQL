-- In 3.sql, choose a location of your own and write a SQL query to find the normal temperature at 0 meters, 100 meters, and 200 meters. You might find Google Earth helpful if you’d like to find some coordinates to use!

--  SELECT "id", "latitude", "longitude", "0m", "5m", "10m", "15m" FROM normals LIMIT 2;
--  SELECT * FROM normals WHERE "latitude" = 43.5 AND "longitude" = 14.5;
-- Italy - Croatia latitude 43.5 and longitude 14.5

 SELECT "0m", "100m", "200m" FROM "normals" WHERE "latitude" = 43.5 AND "longitude" = 14.5;

