
DROP DATABASE IF EXISTS cities_database;

CREATE DATABASE cities_database;

USE cities_database;

CREATE TABLE city_start
(
	city_id INT AUTO_INCREMENT,
    city_name VARCHAR(255) NOT NULL,
    latitude FLOAT,
    longitude FLOAT,
    size VARCHAR(100),
    timezone VARCHAR(20),
    mayor VARCHAR(255),
    PRIMARY KEY (city_id)
);

CREATE TABLE country
(
	country_id INT AUTO_INCREMENT,
    country_name VARCHAR(255) NOT NULL,
    country_language VARCHAR(100),
    PRIMARY KEY (country_id)
);

CREATE TABLE city
(
	city_id INT AUTO_INCREMENT,
    city_name VARCHAR(255) NOT NULL,
    latitude FLOAT,
    longitude FLOAT,
    country_id INT,
    size VARCHAR(100),
    timezone VARCHAR(20),
    mayor VARCHAR(255),
    PRIMARY KEY (city_id),
    FOREIGN KEY (country_id) REFERENCES country(country_id)
);

CREATE TABLE population
(
    city_id INT,
    population VARCHAR(100),
    population_from VARCHAR(100),
    retrieval_year INT,
    FOREIGN KEY (city_id) REFERENCES city(city_id)
);

CREATE TABLE weather
(
	weather_id INT AUTO_INCREMENT,
	city_id INT,
    start_time DATETIME,
    temperature FLOAT,
    humidity INT,
    rain VARCHAR(20),
    snow VARCHAR(20),
    wind_speed FLOAT,
    time_retrieved DATETIME,
    PRIMARY KEY (weather_id),
    FOREIGN KEY (city_id) REFERENCES city(city_id)
);

CREATE TABLE airport
(
	icao VARCHAR(5),
    iata VARCHAR(5),
    name VARCHAR(255),
    countryCode VARCHAR(5),
    timeZone VARCHAR(20),
    latitude FLOAT,
    longitude FLOAT,
    city_id INT,
    PRIMARY KEY (icao),
    FOREIGN KEY (city_id) REFERENCES city(city_id)
);

CREATE TABLE flights
(
	flight_id INT AUTO_INCREMENT,
    number VARCHAR(10),
    callSign VARCHAR(10),
    status VARCHAR(20),
    departure_icao VARCHAR(5),
    airline VARCHAR(50),
    arrival_time_local VARCHAR(50),
    arrival_icao VARCHAR(5),
    PRIMARY KEY (flight_id),
    FOREIGN KEY (arrival_icao) REFERENCES airport(icao)
);

DROP TABLE city_start;

SELECT * FROM city;
SELECT * FROM country;
SELECT * FROM population;
SELECT * FROM weather;
SELECT * FROM airport;
SELECT * FROM flights;