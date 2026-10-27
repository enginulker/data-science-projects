/* =====================================================================
   United States Airlines Analysis — SQL tasks  (MySQL 8.0+)
   ---------------------------------------------------------------------
   The notebook (us_airlines.ipynb) exports tidy CSVs to sql_data/.
   Run from THIS folder with local-infile enabled:
       mysql --local-infile=1 -u root -p < us_airlines.sql
   (server side: SET GLOBAL local_infile = 1;)
   ===================================================================== */

DROP DATABASE IF EXISTS us_airlines;
CREATE DATABASE us_airlines;
USE us_airlines;

CREATE TABLE flights (
    id          INT PRIMARY KEY,
    airline     VARCHAR(3)  NOT NULL,
    flight      INT,
    airport_from CHAR(3)    NOT NULL,
    airport_to   CHAR(3)    NOT NULL,
    day_of_week TINYINT,
    dep_time    SMALLINT,          -- minutes after midnight
    length      SMALLINT,          -- flight duration in minutes
    delay       TINYINT,           -- 1 = delayed
    INDEX idx_from (airport_from),
    INDEX idx_to (airport_to)
);

CREATE TABLE airports (
    iata_code    CHAR(3) PRIMARY KEY,
    type         VARCHAR(20),
    elevation_ft INT,
    num_runways  INT                -- open runways (from runways.xlsx)
);

CREATE TABLE airlines (
    airline      VARCHAR(3) PRIMARY KEY,
    airline_name VARCHAR(100),
    founded      INT
);

LOAD DATA LOCAL INFILE 'sql_data/flights.csv' INTO TABLE flights
    FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"' IGNORE 1 LINES;

LOAD DATA LOCAL INFILE 'sql_data/airports.csv' INTO TABLE airports
    FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"' IGNORE 1 LINES
    (iata_code, type, @elev, @rw)
    SET elevation_ft = ROUND(NULLIF(@elev, '')), num_runways = ROUND(NULLIF(@rw, ''));

LOAD DATA LOCAL INFILE 'sql_data/airlines.csv' INTO TABLE airlines
    FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"' IGNORE 1 LINES
    (airline, airline_name, @founded)
    SET founded = ROUND(NULLIF(@founded, ''));


/* Task 1 : number of delayed flights on each day of the week */
SELECT day_of_week,
       ELT(day_of_week, 'Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun') AS day_name,
       SUM(delay)                     AS delayed_flights,
       COUNT(*)                       AS total_flights,
       ROUND(100 * AVG(delay), 2)     AS delay_rate_pct
FROM flights
GROUP BY day_of_week
ORDER BY day_of_week;


/* Task 2 : number of delayed flights for each airline */
SELECT f.airline, a.airline_name,
       SUM(f.delay)                   AS delayed_flights,
       COUNT(*)                       AS total_flights,
       ROUND(100 * AVG(f.delay), 2)   AS delay_rate_pct
FROM flights f
LEFT JOIN airlines a ON a.airline = f.airline
GROUP BY f.airline, a.airline_name
ORDER BY delayed_flights DESC;


/* Task 3 : delayed flights that land at airports with at least 10 runways */
SELECT COUNT(*) AS delayed_flights_at_10plus_runway_airports
FROM flights f
JOIN airports ap ON ap.iata_code = f.airport_to
WHERE f.delay = 1 AND ap.num_runways >= 10;

-- Result is 0: no airport in this data has 10+ open runways (O'Hare is the maximum with 8).
-- Supporting query: delayed arrivals at the airports with the most runways
SELECT f.airport_to, ap.num_runways, SUM(f.delay) AS delayed_flights, COUNT(*) AS arrivals
FROM flights f
JOIN airports ap ON ap.iata_code = f.airport_to
WHERE ap.num_runways >= 6
GROUP BY f.airport_to, ap.num_runways
ORDER BY ap.num_runways DESC, delayed_flights DESC;


/* Task 4 : delayed flights at airports above vs below average elevation,
            for source and destination airports                         */
WITH avg_elev AS (
    SELECT AVG(elevation_ft) AS avg_elevation
    FROM airports
    WHERE iata_code IN (SELECT airport_from FROM flights UNION SELECT airport_to FROM flights)
)
SELECT 'source' AS airport_role,
       CASE WHEN ap.elevation_ft > e.avg_elevation THEN 'above average' ELSE 'below average' END AS elevation_group,
       SUM(f.delay) AS delayed_flights, COUNT(*) AS total_flights, ROUND(100 * AVG(f.delay), 2) AS delay_rate_pct
FROM flights f JOIN airports ap ON ap.iata_code = f.airport_from CROSS JOIN avg_elev e
GROUP BY elevation_group
UNION ALL
SELECT 'destination',
       CASE WHEN ap.elevation_ft > e.avg_elevation THEN 'above average' ELSE 'below average' END,
       SUM(f.delay), COUNT(*), ROUND(100 * AVG(f.delay), 2)
FROM flights f JOIN airports ap ON ap.iata_code = f.airport_to CROSS JOIN avg_elev e
GROUP BY 2
ORDER BY 1 DESC, 2;
