/* =====================================================================
   UAV Propeller Performance Analysis — SQL tasks  (MySQL 8.0+)
   ---------------------------------------------------------------------
   Run from THIS folder with local-infile enabled:
       mysql --local-infile=1 -u root -p < uav_propeller.sql
   (server side: SET GLOBAL local_infile = 1;)
   ===================================================================== */

DROP DATABASE IF EXISTS uav_propeller;
CREATE DATABASE uav_propeller;
USE uav_propeller;

-- One table per experiment volume, same structure
CREATE TABLE experiment_1 (
    propeller_name      VARCHAR(60),
    blade_name          VARCHAR(60),
    propeller_brand     VARCHAR(30),
    number_of_blades    TINYINT,
    propeller_diameter  DECIMAL(8,3),
    propeller_pitch     DECIMAL(10,6),
    advanced_ratio      DECIMAL(10,6),
    rpm                 INT,
    thrust_coefficient  DECIMAL(10,6),
    power_coefficient   DECIMAL(10,6),
    efficiency          DECIMAL(10,6)
);
CREATE TABLE experiment_2 LIKE experiment_1;
CREATE TABLE experiment_3 LIKE experiment_1;

LOAD DATA LOCAL INFILE '../Dataset/Capstone_3/experiment_vol1.csv' INTO TABLE experiment_1
    FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"' IGNORE 1 LINES;
LOAD DATA LOCAL INFILE '../Dataset/Capstone_3/experiment_vol2.csv' INTO TABLE experiment_2
    FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"' IGNORE 1 LINES;
LOAD DATA LOCAL INFILE '../Dataset/Capstone_3/experiment_vol3.csv' INTO TABLE experiment_3
    FIELDS TERMINATED BY ',' OPTIONALLY ENCLOSED BY '"' IGNORE 1 LINES;


/* Task 1 : experiment 1 — propellers with thrust coefficient above 12% (0.12) */
SELECT COUNT(DISTINCT propeller_name) AS propellers_with_ct_above_12pct,
       COUNT(*)                       AS test_points_with_ct_above_12pct
FROM experiment_1
WHERE thrust_coefficient > 0.12;


/* Task 2 : experiment 1 — ordered by efficiency, highest first */
SELECT *
FROM experiment_1
ORDER BY efficiency DESC;


/* Task 3 : experiment 1 — the 100 least-performing records by power coefficient */
SELECT *
FROM experiment_1
ORDER BY power_coefficient ASC
LIMIT 100;


/* Task 4 : merge experiments 1, 2 and 3; propellers with zero or negative efficiency */
DROP TABLE IF EXISTS experiment_all;
CREATE TABLE experiment_all AS
SELECT *, 1 AS volume FROM experiment_1
UNION ALL
SELECT *, 2 FROM experiment_2
UNION ALL
SELECT *, 3 FROM experiment_3;

SELECT COUNT(*) AS merged_rows FROM experiment_all;

SELECT COUNT(DISTINCT propeller_name) AS propellers_with_non_positive_efficiency,
       COUNT(*)                       AS test_points_with_non_positive_efficiency
FROM experiment_all
WHERE efficiency <= 0;
