/* =====================================================================
   Air Cargo Analysis  (MySQL 8.0+)
   ---------------------------------------------------------------------
   Run the whole file in MySQL Workbench or:
       mysql -u root -p < air_cargo_analysis.sql
   The four CSV datasets are embedded as INSERT statements below.
   Note: the source data spells the business class as 'Bussiness';
         it is kept as-is so the queries match the data.
   ===================================================================== */

DROP DATABASE IF EXISTS air_cargo;
CREATE DATABASE air_cargo;
USE air_cargo;

CREATE TABLE customer (
    customer_id   INT PRIMARY KEY,
    first_name    VARCHAR(50) NOT NULL,
    last_name     VARCHAR(50) NOT NULL,
    date_of_birth DATE,
    gender        CHAR(1)
);

CREATE TABLE routes (
    route_id            INT PRIMARY KEY,
    flight_num          INT NOT NULL,
    origin_airport      CHAR(3) NOT NULL,
    destination_airport CHAR(3) NOT NULL,
    aircraft_id         VARCHAR(20) NOT NULL,
    distance_miles      INT NOT NULL
);

CREATE TABLE passengers_on_flights (
    customer_id INT,
    aircraft_id VARCHAR(20),
    route_id    INT,
    depart      CHAR(3),
    arrival     CHAR(3),
    seat_num    VARCHAR(10),
    class_id    VARCHAR(20),
    travel_date DATE,
    flight_num  INT,
    FOREIGN KEY (customer_id) REFERENCES customer(customer_id)
);

CREATE TABLE ticket_details (
    p_date           DATE,
    customer_id      INT,
    aircraft_id      VARCHAR(20),
    class_id         VARCHAR(20),
    no_of_tickets    INT,
    a_code           CHAR(3),
    price_per_ticket DECIMAL(10,2),
    brand            VARCHAR(50),
    FOREIGN KEY (customer_id) REFERENCES customer(customer_id)
);

-- ---------------------------------------------------------------- data
INSERT INTO customer VALUES
  (1, 'Julie', 'Sam', '1989-01-12', 'F'),
  (2, 'Steve', 'Ryan', '1983-04-03', 'M'),
  (3, 'Morris', 'Lois', '1993-12-09', 'M'),
  (4, 'Cathenna', 'Emily', '1977-09-14', 'F'),
  (5, 'Aaron', 'Kim', '1991-02-18', 'M'),
  (6, 'Alexander', 'Scot', '1985-02-12', 'M'),
  (7, 'Anderson', 'Stewart', '1992-01-11', 'M'),
  (8, 'Floyd', 'Ted', '1993-02-21', 'M'),
  (9, 'Leo', 'Travis', '1994-03-22', 'M'),
  (10, 'Melvin', 'Tracy', '1995-04-23', 'M'),
  (11, 'Roger', 'Walson', '1996-05-24', 'M'),
  (12, 'Shirley', 'Wally', '1997-06-25', 'F'),
  (13, 'Solomon', 'Walter', '1998-07-26', 'M'),
  (14, 'Carol', 'Vernon', '1999-08-27', 'F'),
  (15, 'Linda', 'William', '1986-09-28', 'F'),
  (16, 'Chirstine', 'Willis', '1987-10-06', 'F'),
  (17, 'Catherine', 'Shad', '1988-11-09', 'F'),
  (18, 'Gloria', 'Richie', '1989-12-04', 'F'),
  (19, 'Joyce', 'Paul', '1990-06-02', 'F'),
  (20, 'Sara', 'Oliver', '1991-01-01', 'F'),
  (21, 'Chirsty', 'Josh', '2004-01-10', 'M'),
  (22, 'Pheny', 'Eri', '1999-01-29', 'M'),
  (23, 'Erwin', 'Tosh', '1994-02-03', 'M'),
  (24, 'Calvin', 'Willis', '1994-02-15', 'M'),
  (25, 'Moss', 'Morris', '2011-02-18', 'M'),
  (26, 'Bryan', 'Collin', '2011-02-28', 'M'),
  (27, 'Cherly', 'Vernon', '1992-03-19', 'F'),
  (28, 'Du plesis', 'Chris', '1994-04-17', 'M'),
  (29, 'Watson', 'Ronald', '1991-01-11', 'M'),
  (30, 'Donack', 'Dukins', '1991-02-19', 'M'),
  (31, 'James', 'Robert', '1994-04-12', 'M'),
  (32, 'Chirstoper', 'Sean', '1993-06-21', 'M'),
  (33, 'Mark', 'Ethan', '1994-05-22', 'M'),
  (34, 'Jacqueline', 'Keith', '1994-04-23', 'F'),
  (35, 'Jeffrey', 'Aaron', '1991-02-24', 'M'),
  (36, 'Kayla', 'Patrick', '1993-02-27', 'F'),
  (37, 'Samuel', 'Scott', '2000-01-28', 'M'),
  (38, 'Alexis', 'Scott', '2001-10-31', 'M'),
  (39, 'Tyler', 'Edward', '2006-11-30', 'M'),
  (40, 'Adam', 'Paul', '2007-12-31', 'M'),
  (41, 'Kyle', 'Mark', '2004-11-29', 'F'),
  (42, 'Roger', 'Mattew', '2008-11-28', 'M'),
  (43, 'Joe', 'Daniel', '2001-03-27', 'M'),
  (44, 'Bily', 'Brian', '2002-10-26', 'M'),
  (45, 'Doris', 'Walter', '1993-12-23', 'M'),
  (46, 'Louis', 'Douglas', '1997-09-22', 'M'),
  (47, 'Sophia', 'Carl', '1999-08-11', 'F'),
  (48, 'Wayne', 'Noah', '1998-07-02', 'F'),
  (49, 'Russell', 'Peter', '1996-06-01', 'M'),
  (50, 'Rose', 'Arthur', '1996-05-23', 'F');

INSERT INTO routes VALUES
  (1, 1111, 'EWR', 'HNL', '767-301ER', 4962),
  (2, 1112, 'HNL', 'EWR', '767-301ER', 4962),
  (3, 1113, 'EWR', 'LHR', 'A321', 3466),
  (4, 1114, 'JFK', 'LAX', '767-301ER', 2475),
  (5, 1115, 'LAX', 'JFK', '767-301ER', 2475),
  (6, 1116, 'HNL', 'LAX', '767-301ER', 2556),
  (7, 1117, 'LAX', 'ORD', 'A321', 1745),
  (8, 1118, 'ORD', 'EWR', 'A321', 719),
  (9, 1119, 'DEN', 'LAX', 'ERJ142', 862),
  (10, 1120, 'HNL', 'DEN', 'A321', 3365),
  (12, 1122, 'ABI', 'ADK', '767-301ER', 4300),
  (13, 1123, 'ADK', 'BQN', 'A321', 2232),
  (14, 1124, 'BQN', 'CAK', 'A321', 2445),
  (15, 1125, 'CAK', 'ANI', '767-301ER', 2000),
  (16, 1126, 'ALB', 'APN', 'A321', 1700),
  (17, 1127, 'APN', 'BLV', '767-301ER', 1900),
  (18, 1128, 'ANI', 'BGR', 'ERJ142', 2450),
  (19, 1129, 'ATW', 'AVL', 'A321', 2222),
  (20, 1130, 'AVL', 'BOI', '767-301ER', 3134),
  (21, 1131, 'BFL', 'BET', 'A321', 2425),
  (22, 1132, 'BGR', 'BJI', 'ERJ142', 1242),
  (23, 1133, 'BLV', 'BFL', '767-301ER', 2354),
  (24, 1134, 'BJI', 'BQN', 'A321', 1575),
  (25, 1135, 'RDM', 'BJI', 'A321', 2425),
  (26, 1136, 'BET', 'BTM', 'ERJ142', 1311),
  (27, 1137, 'BOI', 'CLD', 'A321', 578),
  (28, 1138, 'BOS', 'CDC', '767-301ER', 246),
  (29, 1139, 'BKG', 'CRW', '767-301ER', 909),
  (30, 1140, 'BUR', 'STT', 'CRJ900', 780),
  (31, 1141, 'BTM', 'CHA', 'ERJ142', 660),
  (32, 1142, 'CLD', 'CHI', '767-301ER', 246),
  (33, 1143, 'CDC', 'CST', 'CRJ900', 1345),
  (34, 1144, 'CRW', 'COD', 'A321', 2452),
  (35, 1145, 'STT', 'CDB', 'ERJ142', 2121),
  (36, 1146, 'CHA', 'COU', 'CRJ900', 1212),
  (37, 1147, 'CHI', 'CST', '767-301ER', 999),
  (38, 1148, 'CST', 'DAL', 'A321', 1111),
  (39, 1149, 'COD', 'SCC', 'CRJ900', 1579),
  (40, 1150, 'CDB', 'DEC', 'A321', 909),
  (41, 1151, 'CAE', 'DRT', 'ERJ142', 898),
  (42, 1152, 'CSG', 'BOS', '767-301ER', 890),
  (43, 1153, 'CBM', 'BOI', 'A321', 8989),
  (44, 1154, 'COU', 'CAK', '767-301ER', 7676),
  (45, 1155, 'CCR', 'EWR', 'CRJ900', 676),
  (46, 1156, 'CDV', 'HNL', '767-301ER', 8668),
  (47, 1157, 'DAL', 'LAX', 'CRJ900', 675),
  (48, 1158, 'SCC', 'DEN', 'A321', 5645),
  (49, 1159, 'DEC', 'ABI', 'A321', 4533),
  (50, 1160, 'DRT', 'ORD', 'A321', 2445);

INSERT INTO passengers_on_flights VALUES
  (2, 'A321', 34, 'CRW', 'COD', '01B', 'Bussiness', '2019-01-26', 1117),
  (2, '767-301ER', 4, 'JFK', 'LAX', '01E', 'Economy', '2018-09-02', 1114),
  (1, 'ERJ142', 9, 'DEN', 'LAX', '01EP', 'Economy Plus', '2019-12-26', 1119),
  (1, 'CRJ900', 30, 'BUR', 'STT', '01FC', 'First Class', '2018-11-04', 1140),
  (5, '767-301ER', 12, 'ABI', 'ADK', '02B', 'Bussiness', '2018-07-02', 1122),
  (5, 'ERJ142', 18, 'ANI', 'BGR', '02E', 'Economy', '2020-05-06', 1128),
  (8, 'A321', 38, 'CST', 'DAL', '02EP', 'Economy Plus', '2020-08-09', 1148),
  (4, '767-301ER', 5, 'LAX', 'JFX', '02FC', 'First Class', '2020-04-06', 1115),
  (7, '767-301ER', 20, 'AVL', 'BOI', '03B', 'Bussiness', '2020-07-08', 1130),
  (5, 'ERJ142', 22, 'BGR', 'BJI', '03E', 'Economy', '2020-05-31', 1132),
  (11, 'ERJ142', 31, 'BTM', 'CHA', '03EP', 'Economy Plus', '2018-08-02', 1141),
  (4, '767-301ER', 4, 'JFK', 'LAX', '03FC', 'First Class', '2020-04-30', 1114),
  (11, '767-301ER', 5, 'LAX', 'JFX', '04B', 'Bussiness', '2020-11-12', 1115),
  (8, 'A321', 43, 'CBM', 'BOI', '04E', 'Economy', '2018-05-02', 1153),
  (17, 'A321', 13, 'ABI', 'ADK', '04EP', 'Economy Plus', '2019-06-03', 1123),
  (9, '767-301ER', 15, 'CAK', 'ANI', '04FC', 'First Class', '2020-09-10', 1125),
  (11, '767-301ER', 4, 'JFK', 'LAX', '05B', 'Bussiness', '2020-11-09', 1114),
  (10, 'A321', 10, 'HNL', 'DEN', '05E', 'Economy', '2020-10-11', 1120),
  (19, 'CRJ900', 47, 'DAL', 'LAX', '05EP', 'Economy Plus', '2021-01-13', 1157),
  (9, 'CRJ900', 33, 'CDC', 'CST', '05FC', 'First Class', '2018-02-01', 1143),
  (15, 'A321', 14, 'BQN', 'CAK', '06B', 'Bussiness', '2018-11-02', 1124),
  (14, 'ERJ142', 35, 'STT', 'CDB', '06E', 'Economy', '2019-04-02', 1145),
  (19, 'CRJ900', 30, 'BUR', 'STT', '06EP', 'Economy Plus', '2020-12-17', 1140),
  (13, 'A321', 13, 'ADK', 'BQN', '06FC', 'First Class', '2019-01-05', 1123),
  (21, 'CRJ900', 45, 'CCR', 'EWR', '07B', 'Bussiness', '2020-03-07', 1155),
  (14, '767-301ER', 42, 'CSG', 'BOS', '07E', 'Economy', '2020-01-25', 1152),
  (22, 'ERJ142', 22, 'BGR', 'BJI', '07EP', 'Economy Plus', '2020-02-09', 1132),
  (16, 'CRJ900', 39, 'COD', 'SCC', '07FC', 'First Class', '2019-05-04', 1149),
  (24, 'A321', 14, 'BQN', 'CAK', '08B', 'Bussiness', '2019-07-22', 1124),
  (18, '767-301ER', 46, 'CDV', 'HNL', '08E', 'Economy', '2019-07-07', 1156),
  (32, 'ERJ142', 31, 'BTM', 'CHA', '08EP', 'Economy Plus', '2021-03-04', 1141),
  (20, 'CRJ900', 36, 'CHA', 'COU', '08FC', 'First Class', '2019-09-26', 1146),
  (25, '767-301ER', 23, 'BLV', 'BFL', '09B', 'Bussiness', '2019-03-07', 1133),
  (19, '767-301ER', 32, 'CLD', 'CHI', '09E', 'Economy', '2018-02-07', 1142),
  (47, 'CRJ900', 33, 'CDC', 'CST', '09EP', 'Economy Plus', '2020-12-15', 1143),
  (20, 'CRJ900', 39, 'COD', 'SCC', '09FC', 'First Class', '2020-05-03', 1149),
  (29, 'A321', 38, 'CST', 'DAL', '10B', 'Bussiness', '2019-11-21', 1148),
  (25, '767-301ER', 44, 'COU', 'CAK', '10E', 'Economy', '2019-10-21', 1154),
  (50, 'A321', 21, 'BFL', 'BET', '10EP', 'Economy Plus', '2020-08-15', 1131),
  (41, 'A321', 34, 'CRW', 'COD', '10FC', 'First Class', '2019-02-15', 1144),
  (29, 'ERJ142', 9, 'DEN', 'LAX', '11B', 'Bussiness', '2018-05-03', 1119),
  (27, '767-301ER', 46, 'CDV', 'HNL', '11E', 'Economy', '2018-12-29', 1156),
  (44, '767-301ER', 15, 'CAK', 'ANI', '11FC', 'First Class', '2020-10-06', 1125),
  (33, 'ERJ142', 35, 'STT', 'CDB', '12B', 'Bussiness', '2020-04-15', 1145),
  (28, 'ERJ142', 26, 'BET', 'BTM', '12E', 'Economy', '2018-12-12', 1136),
  (46, 'A321', 8, 'ORD', 'EWR', '12FC', 'First Class', '2011-07-08', 1118),
  (49, '767-301ER', 15, 'CAK', 'ANI', '13B', 'Bussiness', '2020-08-19', 1125),
  (31, '767-301ER', 20, 'AVL', 'BOI', '13E', 'Economy', '2018-12-31', 1130),
  (18, '767-301ER', 1, 'EWR', 'HNL', '13FC', 'First Class', '2018-04-01', 1111),
  (46, 'A321', 25, 'RDM', 'BJI', '14E', 'Economy', '2020-11-25', 1135);

INSERT INTO ticket_details VALUES
  ('2018-12-26', 27, '767-301ER', 'Economy', 1, 'DAL', 130, 'Emirates'),
  ('2020-02-02', 22, 'ERJ142', 'Economy Plus', 1, 'AGB', 220, 'Jet Airways'),
  ('2020-03-03', 21, 'CRJ900', 'Bussiness', 1, 'BOH', 490, 'Bristish Airways'),
  ('2020-04-04', 4, '767-301ER', 'First Class', 1, 'AGB', 390, 'Emirates'),
  ('2020-05-05', 5, 'ERJ142', 'Economy', 1, 'CTM', 120, 'Jet Airways'),
  ('2020-07-07', 7, '767-301ER', 'Bussiness', 1, 'BFS', 430, 'Emirates'),
  ('2020-08-08', 8, 'A321', 'Economy Plus', 1, 'DAL', 275, 'Qatar Airways'),
  ('2020-09-09', 9, '767-301ER', 'First Class', 1, 'BOH', 380, 'Emirates'),
  ('2020-10-10', 10, 'A321', 'Economy', 1, 'MCO', 135, 'Qatar Airways'),
  ('2020-11-11', 11, '767-301ER', 'Bussiness', 1, 'AGB', 465, 'Emirates'),
  ('2020-12-12', 19, 'CRJ900', 'Economy Plus', 1, 'DEN', 225, 'Bristish Airways'),
  ('2019-01-01', 13, 'A321', 'First Class', 1, 'YVR', 395, 'Qatar Airways'),
  ('2019-02-02', 14, 'ERJ142', 'Economy', 1, 'CTM', 120, 'Jet Airways'),
  ('2019-03-03', 25, '767-301ER', 'Bussiness', 1, 'BHX', 499, 'Emirates'),
  ('2019-04-04', 16, 'CRJ900', 'First Class', 1, 'YVR', 395, 'Bristish Airways'),
  ('2019-05-03', 17, 'A321', 'Economy Plus', 1, 'BFS', 250, 'Qatar Airways'),
  ('2019-06-06', 18, '767-301ER', 'Economy', 1, 'YVR', 190, 'Emirates'),
  ('2019-07-07', 24, 'A321', 'Bussiness', 1, 'CTM', 480, 'Qatar Airways'),
  ('2019-08-09', 20, 'CRJ900', 'First Class', 1, 'MCO', 365, 'Bristish Airways'),
  ('2019-09-21', 25, '767-301ER', 'Economy', 1, 'BOH', 150, 'Emirates'),
  ('2019-10-22', 29, 'A321', 'Bussiness', 1, 'PEK', 410, 'Qatar Airways'),
  ('2019-11-23', 1, 'ERJ142', 'Economy Plus', 1, 'BFS', 250, 'Jet Airways'),
  ('2019-12-24', 14, '767-301ER', 'Economy', 1, 'BHX', 170, 'Emirates'),
  ('2019-01-25', 2, 'A321', 'Bussiness', 1, 'YVR', 505, 'Qatar Airways'),
  ('2018-01-01', 9, 'CRJ900', 'First Class', 1, 'AGB', 390, 'British Airways'),
  ('2018-02-01', 19, '767-301ER', 'Economy', 1, 'AGB', 100, 'Emirates'),
  ('2018-03-01', 18, '767-301ER', 'First Class', 1, 'BFS', 375, 'Emirates'),
  ('2018-04-01', 29, 'ERJ142', 'Bussiness', 1, 'EME', 510, 'Jet Airways'),
  ('2018-05-01', 8, 'A321', 'Economy', 1, 'YVR', 190, 'Qatar Airways'),
  ('2018-06-01', 20, 'CRJ900', 'First Class', 1, 'PEK', 315, 'Bristish Airways'),
  ('2018-07-01', 5, '767-301ER', 'Bussiness', 1, 'BFS', 430, 'Emirates'),
  ('2018-08-01', 11, 'ERJ142', 'Economy Plus', 1, 'BHX', 295, 'Jet Airways'),
  ('2018-09-01', 2, '767-301ER', 'Economy', 1, 'DAL', 130, 'Emirates'),
  ('2018-10-01', 1, 'CRJ900', 'First Class', 1, 'DEN', 320, 'Bristish Airways'),
  ('2018-11-01', 15, 'A321', 'Bussiness', 1, 'BFS', 430, 'Qatar Airways'),
  ('2018-12-01', 28, 'ERJ142', 'Economy', 1, 'BHX', 170, 'Jet Airways'),
  ('2018-12-19', 31, '767-301ER', 'Economy', 1, 'DAL', 130, 'Emirates'),
  ('2020-02-04', 32, 'ERJ142', 'Economy Plus', 1, 'AGB', 220, 'Jet Airways'),
  ('2020-03-12', 33, 'CRJ900', 'Bussiness', 1, 'BOH', 490, 'Bristish Airways'),
  ('2020-04-29', 4, '767-301ER', 'First Class', 1, 'AGB', 390, 'Emirates'),
  ('2020-05-30', 5, 'ERJ142', 'Economy', 1, 'CTM', 120, 'Jet Airways'),
  ('2020-07-17', 49, '767-301ER', 'Bussiness', 1, 'BFS', 430, 'Emirates'),
  ('2020-08-12', 50, 'A321', 'Economy Plus', 1, 'DAL', 275, 'Qatar Airways'),
  ('2020-09-05', 44, '767-301ER', 'First Class', 1, 'BOH', 380, 'Emirates'),
  ('2020-10-07', 46, 'A321', 'Economy', 1, 'MCO', 135, 'Qatar Airways'),
  ('2020-11-08', 11, '767-301ER', 'Bussiness', 1, 'AGB', 465, 'Emirates'),
  ('2020-12-09', 47, 'CRJ900', 'Economy Plus', 1, 'DEN', 225, 'Bristish Airways'),
  ('2019-01-11', 41, 'A321', 'First Class', 1, 'YVR', 395, 'Qatar Airways'),
  ('2020-12-13', 19, 'CRJ900', 'Economy Plus', 1, 'DEN', 225, 'Bristish Airways'),
  ('2019-01-15', 46, 'A321', 'First Class', 1, 'YVR', 395, 'Qatar Airways');


/* ---------------------------------------------------------------------
   Task 1 : ER diagram  -> see the Mermaid ER diagram in README.md
   --------------------------------------------------------------------- */


/* Task 2 : route_details table with check & unique constraints */
DROP TABLE IF EXISTS route_details;
CREATE TABLE route_details (
    route_id            INT          NOT NULL,
    flight_num          INT          NOT NULL,
    origin_airport      CHAR(3)      NOT NULL,
    destination_airport CHAR(3)      NOT NULL,
    aircraft_id         VARCHAR(20)  NOT NULL,
    distance_miles      INT          NOT NULL,
    CONSTRAINT uq_route_id       UNIQUE (route_id),
    CONSTRAINT chk_flight_num    CHECK (flight_num BETWEEN 1000 AND 9999),
    CONSTRAINT chk_distance      CHECK (distance_miles > 0)
);

INSERT INTO route_details SELECT * FROM routes;
SELECT * FROM route_details;


/* Task 3 : passengers who travelled on routes 01 to 25 */
SELECT p.*, CONCAT(c.first_name, ' ', c.last_name) AS passenger_name
FROM passengers_on_flights p
JOIN customer c ON c.customer_id = p.customer_id
WHERE p.route_id BETWEEN 1 AND 25
ORDER BY p.route_id;


/* Task 4 : number of passengers and total revenue in business class */
SELECT COUNT(DISTINCT customer_id)           AS business_customers,
       SUM(no_of_tickets)                    AS business_tickets,
       SUM(no_of_tickets * price_per_ticket) AS business_revenue
FROM ticket_details
WHERE class_id = 'Bussiness';


/* Task 5 : full name of each customer */
SELECT customer_id, CONCAT(first_name, ' ', last_name) AS full_name
FROM customer;


/* Task 6 : customers who registered and booked a ticket */
SELECT DISTINCT c.customer_id, c.first_name, c.last_name
FROM customer c
INNER JOIN ticket_details t ON t.customer_id = c.customer_id
ORDER BY c.customer_id;


/* Task 7 : customers who flew with Emirates */
SELECT DISTINCT c.customer_id, c.first_name, c.last_name
FROM customer c
JOIN ticket_details t ON t.customer_id = c.customer_id
WHERE t.brand = 'Emirates'
ORDER BY c.customer_id;


/* Task 8 : customers who travelled in Economy Plus (GROUP BY + HAVING) */
SELECT p.customer_id, c.first_name, c.last_name, COUNT(*) AS economy_plus_trips
FROM passengers_on_flights p
JOIN customer c ON c.customer_id = p.customer_id
GROUP BY p.customer_id, c.first_name, c.last_name, p.class_id
HAVING p.class_id = 'Economy Plus';


/* Task 9 : has revenue crossed 10000? (IF clause) */
SELECT SUM(no_of_tickets * price_per_ticket) AS total_revenue,
       IF(SUM(no_of_tickets * price_per_ticket) > 10000,
          'Revenue crossed 10000', 'Revenue below 10000') AS revenue_status
FROM ticket_details;


/* Task 10 : create a new user and grant access */
DROP USER IF EXISTS 'aircargo_analyst'@'localhost';
CREATE USER 'aircargo_analyst'@'localhost' IDENTIFIED BY 'ChangeMe#2024';
GRANT SELECT, INSERT, UPDATE, DELETE, EXECUTE ON air_cargo.* TO 'aircargo_analyst'@'localhost';
FLUSH PRIVILEGES;
SHOW GRANTS FOR 'aircargo_analyst'@'localhost';


/* Task 11 : maximum ticket price for each class (window function) */
SELECT DISTINCT class_id,
       MAX(price_per_ticket) OVER (PARTITION BY class_id) AS max_ticket_price
FROM ticket_details
ORDER BY max_ticket_price DESC;


/* Task 12 : passengers on route 4 - add an index to improve speed */
CREATE INDEX idx_pof_route_id ON passengers_on_flights(route_id);

SELECT * FROM passengers_on_flights WHERE route_id = 4;


/* Task 13 : execution plan for route 4 (shows key = idx_pof_route_id) */
EXPLAIN SELECT * FROM passengers_on_flights WHERE route_id = 4;
-- MySQL 8.0.18+: actual timings
EXPLAIN ANALYZE SELECT * FROM passengers_on_flights WHERE route_id = 4;


/* Task 14 : total price of tickets per customer across aircraft IDs (ROLLUP) */
SELECT customer_id, aircraft_id,
       SUM(no_of_tickets * price_per_ticket) AS total_price
FROM ticket_details
GROUP BY customer_id, aircraft_id WITH ROLLUP;


/* Task 15 : view of business-class customers with the airline brand */
CREATE OR REPLACE VIEW business_class_customers AS
SELECT t.customer_id, c.first_name, c.last_name, t.brand, t.class_id
FROM ticket_details t
JOIN customer c ON c.customer_id = t.customer_id
WHERE t.class_id = 'Bussiness';

SELECT * FROM business_class_customers;


/* Task 16 : procedure - passengers between a run-time range of routes,
             with an error message if the table does not exist        */
DROP PROCEDURE IF EXISTS passengers_between_routes;
DELIMITER $$
CREATE PROCEDURE passengers_between_routes(IN from_route INT, IN to_route INT)
BEGIN
    DECLARE EXIT HANDLER FOR 1146   -- ER_NO_SUCH_TABLE
        SELECT 'Error: table passengers_on_flights does not exist' AS message;

    SELECT p.*, c.first_name, c.last_name
    FROM passengers_on_flights p
    JOIN customer c ON c.customer_id = p.customer_id
    WHERE p.route_id BETWEEN from_route AND to_route
    ORDER BY p.route_id;
END $$
DELIMITER ;

CALL passengers_between_routes(1, 10);


/* Task 17 : procedure - routes with distance more than 2000 miles */
DROP PROCEDURE IF EXISTS long_routes;
DELIMITER $$
CREATE PROCEDURE long_routes()
BEGIN
    SELECT * FROM routes WHERE distance_miles > 2000 ORDER BY distance_miles DESC;
END $$
DELIMITER ;

CALL long_routes();


/* Task 18 : procedure - distance categories SDT / IDT / LDT */
DROP PROCEDURE IF EXISTS route_distance_category;
DELIMITER $$
CREATE PROCEDURE route_distance_category()
BEGIN
    SELECT flight_num, route_id, origin_airport, destination_airport, distance_miles,
           CASE
               WHEN distance_miles BETWEEN 0 AND 2000 THEN 'SDT'
               WHEN distance_miles <= 6500            THEN 'IDT'
               ELSE                                        'LDT'
           END AS distance_category
    FROM routes
    ORDER BY distance_miles;
END $$
DELIMITER ;

CALL route_distance_category();


/* Task 19 : stored function used inside a procedure -
             complimentary services for Business and Economy Plus */
DROP FUNCTION IF EXISTS complimentary_service;
DELIMITER $$
CREATE FUNCTION complimentary_service(p_class VARCHAR(20))
RETURNS VARCHAR(3)
DETERMINISTIC
BEGIN
    RETURN IF(p_class IN ('Bussiness', 'Business', 'Economy Plus'), 'Yes', 'No');
END $$
DELIMITER ;

DROP PROCEDURE IF EXISTS ticket_complimentary_services;
DELIMITER $$
CREATE PROCEDURE ticket_complimentary_services()
BEGIN
    SELECT p_date, customer_id, class_id,
           complimentary_service(class_id) AS complimentary_services
    FROM ticket_details
    ORDER BY p_date;
END $$
DELIMITER ;

CALL ticket_complimentary_services();


/* Task 20 : cursor - first customer whose last name ends with 'Scott' */
DROP PROCEDURE IF EXISTS first_scott_customer;
DELIMITER $$
CREATE PROCEDURE first_scott_customer()
BEGIN
    DECLARE v_id INT;
    DECLARE v_first, v_last VARCHAR(50);
    DECLARE v_dob DATE;
    DECLARE v_gender CHAR(1);
    DECLARE done INT DEFAULT 0;

    DECLARE cur CURSOR FOR
        SELECT customer_id, first_name, last_name, date_of_birth, gender
        FROM customer
        WHERE last_name LIKE '%Scott'
        ORDER BY customer_id;
    DECLARE CONTINUE HANDLER FOR NOT FOUND SET done = 1;

    OPEN cur;
    FETCH cur INTO v_id, v_first, v_last, v_dob, v_gender;   -- first record only
    CLOSE cur;

    IF done = 1 THEN
        SELECT 'No customer with last name ending in Scott' AS message;
    ELSE
        SELECT v_id AS customer_id, v_first AS first_name, v_last AS last_name,
               v_dob AS date_of_birth, v_gender AS gender;
    END IF;
END $$
DELIMITER ;

CALL first_scott_customer();
