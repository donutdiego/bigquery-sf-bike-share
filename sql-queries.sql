--- Dashboard Data
SELECT
  trip_id,
  station_geom,
  start_station_name,
  duration_sec,
  start_date,
  end_station_name,
  IF(subscriber_type = 'nan', c_subscription_type, subscriber_type) AS subscription_status,
  IFNULL(member_gender, 'No Gender Data') AS member_gender,
  IFNULL(CAST(EXTRACT(YEAR FROM CURRENT_TIMESTAMP()) - member_birth_year AS STRING), 'No Birthdate Data') AS member_age
FROM `bigquery-public-data.san_francisco_bikeshare.bikeshare_trips` t
LEFT JOIN `bigquery-public-data.san_francisco_bikeshare.bikeshare_station_info` i
ON t.start_station_name = i.name;

--- Using Geolocation to Group Stations on Region
WITH city_centers AS(
  SELECT
    ST_GEOGPOINT(-122.42303700156648, 37.77665194961819) AS sf,
    ST_GEOGPOINT(-121.8963799010405, 37.3387397385351) AS san_jose,
    ST_GEOGPOINT(-122.27643819447734, 37.8059534427658) AS oakland,
    10700 AS sf_radius,
    16600 AS san_jose_radius,
    11700 AS oakland_radius
)

SELECT
  'San Francisco' AS region,
  name,
  ROUND(ST_DISTANCE(station_geom, sf) / 1609, 2) AS dist_to_center
FROM `bigquery-public-data.san_francisco_bikeshare.bikeshare_station_info`, city_centers
WHERE ST_DWITHIN(station_geom, sf, city_centers.sf_radius)
UNION DISTINCT
SELECT
  'San Jose' AS region,
  name,
  ROUND(ST_DISTANCE(station_geom, san_jose) / 1609, 2) AS dist_to_center
FROM `bigquery-public-data.san_francisco_bikeshare.bikeshare_station_info`, city_centers
WHERE ST_DWITHIN(station_geom, san_jose, city_centers.san_jose_radius)
UNION DISTINCT
SELECT
  'Oakland' AS region,
  name,
  ROUND(ST_DISTANCE(station_geom, sf) / 1609, 2) AS dist_to_center
FROM `bigquery-public-data.san_francisco_bikeshare.bikeshare_station_info`, city_centers
WHERE ST_DWITHIN(station_geom, oakland, city_centers.oakland_radius);

--- Stations Distance to Key Points
WITH locations AS(
  SELECT 
    ST_GEOGPOINT(-122.37884623099883, 37.623010520118775) AS airport,
    ST_GEOGPOINT(-122.4780355622899, 37.8315818306885) AS golden_gate_bridge,
    ST_GEOGPOINT(-122.50598914155854, 37.737725005206116) AS sf_zoo
)

SELECT
  name,
  ROUND(ST_DISTANCE(station_geom, airport) / 1609, 2) AS dist_to_airport_in_miles
FROM `bigquery-public-data.san_francisco_bikeshare.bikeshare_station_info`, locations
ORDER BY 2;

--- Trips per Month
SELECT
  CAST(DATE_TRUNC(start_date, month) AS DATE) month,
  COUNT(trip_id) trips
FROM `bigquery-public-data.san_francisco_bikeshare.bikeshare_trips`
GROUP BY 1
ORDER BY 1;

--- Training Data
SELECT
  name,
  capacity,
  num_bikes_available,
  num_bikes_disabled,
  num_docks_available,
  num_docks_disabled
FROM `bigquery-public-data.san_francisco_bikeshare.bikeshare_station_info` i
LEFT JOIN `bigquery-public-data.san_francisco_bikeshare.bikeshare_station_status` s
ON i.station_id = s.station_id
LIMIT 10;