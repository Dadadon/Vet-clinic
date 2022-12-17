/*Queries that provide answers to the questions from all projects.*/

-- Find all animals whose name ends in "mon".
SELECT * FROM ANIMALS WHERE NAME LIKE '%mon';

-- List the name of all animals born between 2016 and 2019.
SELECT NAME FROM ANIMALS WHERE DATE_OF_BIRTH >= '2016-1-1' AND DATE_OF_BIRTH <= '2019-12-30';

-- List the name of all animals that are neutered and have less than 3 escape attempts.
SELECT NAME FROM ANIMALS WHERE NEUTERED IS TRUE AND ESCAPE_ATTEMPTS < 3;

-- List the date of birth of all animals named either "Agumon" or "Pikachu".
SELECT DATE_OF_BIRTH FROM ANIMALS WHERE NAME LIKE 'Agumon' OR NAME LIKE 'Pikachu';

-- List name and escape attempts of animals that weigh more than 10.5kg
SELECT NAME, ESCAPE_ATTEMPTS FROM ANIMALS WHERE WEIGHT_KG > 10.5;

-- Find all animals that are neutered.
SELECT * FROM ANIMALS WHERE NEUTERED IS TRUE;

-- Find all animals not named Gabumon.
SELECT * FROM ANIMALS WHERE NAME NOT LIKE 'Gabumon';

-- Find all animals with a weight between 10.4kg and 17.3kg (including the animals with the weights that equals precisely 10.4kg or 17.3kg)
SELECT * FROM ANIMALS WHERE WEIGHT_KG >= 10.4 AND WEIGHT_KG <= 17.3;

BEGIN TRANSACTION;
    UPDATE ANIMALS SET SPECIES = 'unspecified';
    SELECT * FROM ANIMALS;
ROLLBACK;

BEGIN TRANSACTION;
    DELETE FROM animals;
    SELECT * FROM animals;
ROLLBACK;


BEGIN;
    UPDATE ANIMALS SET SPECIES = 'digimon' WHERE NAME LIKE '%mon';
    UPDATE ANIMALS SET SPECIES = 'pokemon' WHERE NAME NOT LIKE '%mon';
COMMIT;

BEGIN;
    DELETE FROM ANIMALS WHERE DATE_OF_BIRTH > '2022-01-01';
    SAVEPOINT vet_clinic_savepoint;
    UPDATE ANIMALS SET WEIGHT_KG = WEIGHT_KG * -1;
    ROLLBACK TO SAVEPOINT vet_clinic_savepoint;
    UPDATE ANIMALS SET WEIGHT_KG = WEIGHT_KG * -1 WHERE WEIGHT_KG < 0;
COMMIT;

-- How many animals are there?
SELECT COUNT(*) FROM ANIMALS;

-- How many animals have never tried to escape?
SELECT COUNT(*) FROM ANIMALS WHERE ESCAPE_ATTEMPTS = 0;

-- What is the average weight of animals?
SELECT AVG(WEIGHT_KG) FROM ANIMALS;

-- Who escapes the most, neutered or not neutered animals?
SELECT NEUTERED, SUM(ESCAPE_ATTEMPTS) AS MOST_ESCAPE_ATTEMPTS_GROUP_BY_NEUTERED FROM ANIMALS GROUP BY NEUTERED;

-- What is the minimum and maximum weight of each type of animal?
SELECT SPECIES, MIN(WEIGHT_KG) AS MIN_WEIGHT, MAX(WEIGHT_KG) AS MAX_WEIGHT FROM ANIMALS GROUP BY SPECIES;

-- What is the average number of escape attempts per animal type of those born between 1990 and 2000?
SELECT SPECIES, AVG(ESCAPE_ATTEMPTS) AS AVG_ESCAPES FROM ANIMALS WHERE DATE_OF_BIRTH BETWEEN '1990-01-01' AND '2000-12-31' GROUP BY SPECIES;

