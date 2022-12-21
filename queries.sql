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



-- What animals belong to Melody Pond?
SELECT NAME FROM ANIMALS INNER JOIN owners ON animals.owner_id=owners.id WHERE owners.full_name='Melody Pond';

-- List of all animals that are pokemon (their type is Pokemon).
SELECT * FROM ANIMALS LEFT JOIN species ON animals.species_id=species.id WHERE species.name='Pokemon';

-- List all owners and their animals, remember to include those that don't own any animal.
SELECT * FROM OWNERS LEFT JOIN ANIMALS ON owners.id=animals.owner_id;

-- How many animals are there per species?
SELECT COUNT(anims.species_id) AS COUNT_SPECIES, spec.name FROM animals anims JOIN species spec ON anims.species_id=spec.id GROUP BY spec.name, anims.species_id;

-- List all Digimon owned by Jennifer Orwell.
SELECT * FROM animals anims JOIN owners own ON anims.owner_id=own.id JOIN species spec ON anims.species_id=spec.id WHERE own.full_name='Jennifer Orwell' AND spec.name='Digimon';

-- List all animals owned by Dean Winchester that haven't tried to escape.
SELECT * FROM animals anims JOIN owners own ON anims.owner_id=own.id WHERE own.full_name='Dean Winchester' AND anims.escape_attempts=0;

-- Who owns the most animals?
SELECT COUNT(*) AS COUNT_OWNER, own.full_name FROM animals anims JOIN owners own ON own.id=anims.owner_id GROUP BY own.full_name ORDER BY COUNT_OWNER DESC LIMIT 1;


-- Who was the last animal seen by William Tatcher?
SELECT animals.name, visit_date FROM visits JOIN animals ON animals.id = visits.animal_id JOIN vets ON visits.vets_id = vets.id WHERE vets.name = 'William Tatcher' ORDER BY visit_date DESC LIMIT 1;


-- How many different animals did Stephanie Mendez see?
SELECT COUNT(DISTINCT animal_id) FROM visits JOIN vets ON visits.vets_id = vets.id WHERE vets.name = 'Stephanie Mendez';


-- List all vets and their specialties, including vets with no specialties.
SELECT DISTINCT vets.name FROM specializations RIGHT JOIN vets ON specializations.vets_id = vets.id;


-- List all animals that visited Stephanie Mendez between April 1st and August 30th, 2020.
SELECT animals.name, visit_date FROM visits JOIN animals ON animals.id = visits.animal_id JOIN vets ON visits.vets_id = vets.id WHERE vets.name = 'Stephanie Mendez' AND visits.visit_date BETWEEN '2020-04-01' AND '2020-08-30';

-- What animal has the most visits to vets?
SELECT count(animal_id) AS amount_of_visits, animals.name FROM visits JOIN animals ON animals.id = visits.animal_id GROUP BY animal_id, animals.name ORDER BY COUNT(animal_id) DESC LIMIT 1;

-- Who was Maisy Smith's first visit?
SELECT animals.name, visit_date FROM visits JOIN animals ON animals.id = visits.animal_id JOIN vets ON visits.vets_id = vets.id WHERE vets.name = 'Maisy Smith' ORDER BY visit_date LIMIT 1;

-- Details for most recent visit: animal information, vet information, and date of visit.
SELECT animals.id AS animal_id, animals.name AS animal_name, vets.id AS vet_id, vets.name AS vet_name, visit_date FROM visits JOIN animals ON animals.id = visits.animal_id JOIN vets ON visits.vets_id = vets.id ORDER BY visit_date LIMIT 1;


-- How many visits were with a vet that did not specialize in that animal's species?
SELECT count(animals.name) FROM visits JOIN animals ON animals.id = visits.animal_id JOIN specializations ON specializations.vets_id = visits.vets_id where animals.species_id <> specializations.species_id;

-- What specialty should Maisy Smith consider getting? Look for the species she gets the most.
SELECT species.name FROM visits JOIN vets ON visits.vets_id = vets.id JOIN animals on animals.id = visits.animal_id JOIN species on species.id = animals.species_id WHERE vets.name = 'Maisy Smith' GROUP BY animal_id, species.name ORDER BY COUNT(animal_id) DESC LIMIT 1;

EXPLAIN ANALYZE SELECT COUNT(*) FROM visits where animal_id = 4;


EXPLAIN ANALYZE SELECT * FROM visits where vet_id = 2;


EXPLAIN SELECT * FROM owners where email = 'owner_18327@mail.com';


