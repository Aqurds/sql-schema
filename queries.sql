-- Find all animals whose name ends in "mon".
SELECT * FROM animals WHERE name LIKE '%mon';

-- List the name of all animals born between 2016 and 2019.
SELECT name FROM animals WHERE date_of_birth BETWEEN '2016-01-01' AND '2019-12-31';

--List the name of all animals that are neutered and have less than 3 escape attempts.
SELECT name FROM animals WHERE neutered = true AND escape_attempts < 3;

-- List the date of birth of all animals named either "Agumon" or "Pikachu".
SELECT date_of_birth FROM animals WHERE name IN ('Agumon', 'Pikachu');

-- List name and escape attempts of animals that weigh more than 10.5kg
SELECT name, escape_attempts FROM animals WHERE weight_kg > 10.5;

-- Find all animals that are neutered.
SELECT * FROM animals WHERE neutered = true;

-- Find all animals not named Gabumon.
SELECT * FROM animals WHERE name != 'Gabumon';

-- Find all animals with a weight between 10.4kg and 17.3kg (including the animals with the weights that equals precisely 10.4kg or 17.3kg)
SELECT * FROM animals WHERE weight_kg BETWEEN 10.4 AND 17.3;



-- Operation 1
BEGIN;
-- Update species to 'unspecified'
UPDATE animals
SET species = 'unspecified';
-- Verify the change
SELECT * FROM animals;
-- Rollback the change
ROLLBACK;
-- Verify species column reverted to previous state
SELECT * FROM animals;



-- Operation 2
BEGIN;
-- Update species to 'digimon' for names ending in 'mon'
UPDATE animals
SET species = 'digimon'
WHERE name LIKE '%mon';
-- Update species to 'pokemon' for animals without a species
UPDATE animals
SET species = 'pokemon'
WHERE species IS NULL;
-- Verify the changes
SELECT * FROM animals;
-- Commit the transaction
COMMIT;
-- Verify changes persist after commit
SELECT * FROM animals;



-- Operation 3
-- Start a transaction
BEGIN;

-- Delete all records in the animals table
DELETE FROM animals;

-- Check if records exist after delete
SELECT COUNT(*) FROM animals;

-- Rollback the transaction
ROLLBACK;

-- Check if records still exist after rollback
SELECT COUNT(*) FROM animals;



-- Operation 4
BEGIN;
-- Delete animals born after Jan 1st, 2022
DELETE FROM animals
WHERE date_of_birth > '2022-01-01';
-- Create a savepoint
SAVEPOINT my_savepoint;
-- Update weights to be weight * -1
UPDATE animals
SET weight_kg = weight_kg * -1;
-- Rollback to the savepoint
ROLLBACK TO my_savepoint;
-- Update negative weights to be weight * -1
UPDATE animals
SET weight_kg = weight_kg * -1
WHERE weight_kg < 0;
-- Commit the transaction
COMMIT;
-- Verify changes persist after commit
SELECT * FROM animals;



-- Operation 5
-- - How many animals are there?
SELECT COUNT(*) FROM animals;

-- - How many animals have never tried to escape?
SELECT COUNT(*) FROM animals WHERE escape_attempts = 0;

-- - What is the average weight of animals?
SELECT AVG(weight_kg) FROM animals;

-- - Who escapes the most, neutered or not neutered animals?
SELECT neutered, SUM(escape_attempts) AS total_escape_attempts
FROM animals
GROUP BY neutered;

-- - What is the minimum and maximum weight of each type of animal?
SELECT species, MIN(weight_kg) AS min_weight, MAX(weight_kg) AS max_weight
FROM animals
GROUP BY species;

-- - What is the average number of escape attempts per animal type of those born between 1990 and 2000?
SELECT species, AVG(escape_attempts) AS avg_escape_attempts
FROM animals
WHERE date_of_birth BETWEEN '1990-01-01' AND '2000-12-31'
GROUP BY species;


-- Multiple query
-- 1. What animals belong to Melody Pond?
SELECT a.name AS animal_name, s.name AS species_name
FROM animals a
JOIN owners o ON a.owner_id = o.id
JOIN species s ON a.species_id = s.id
WHERE o.full_name = 'Melody Pond';

-- 2. List of all animals that are pokemon (their type is Pokemon).
SELECT a.name AS animal_name, s.name AS species_name
FROM animals a
JOIN species s ON a.species_id = s.id
WHERE s.name = 'Pokemon';

-- 3. List all owners and their animals, including those who don't own any animals.
SELECT o.full_name, a.name AS animal_name
FROM owners o
LEFT JOIN animals a ON o.id = a.owner_id;

-- 4. How many animals are there per species?
SELECT s.name AS species_name, COUNT(a.id) AS animal_count
FROM species s
LEFT JOIN animals a ON s.id = a.species_id
GROUP BY s.name;

-- 5. List all Digimon owned by Jennifer Orwell.
SELECT a.name AS animal_name
FROM animals a
JOIN owners o ON a.owner_id = o.id
JOIN species s ON a.species_id = s.id
WHERE o.full_name = 'Jennifer Orwell' AND s.name = 'Digimon';

-- 6. List all animals owned by Dean Winchester that haven't tried to escape.
SELECT a.name AS animal_name
FROM animals a
JOIN owners o ON a.owner_id = o.id
WHERE o.full_name = 'Dean Winchester' AND a.escape_attempts = 0;

-- 7. Who owns the most animals?
SELECT o.full_name, COUNT(a.id) AS animal_count
FROM owners o
LEFT JOIN animals a ON o.id = a.owner_id
GROUP BY o.full_name
ORDER BY animal_count DESC
LIMIT 1;


-- join table
-- Who was the last animal seen by William Tatcher?
SELECT a.name AS animal_name
FROM animals a
JOIN visits v ON a.id = v.animal_id
JOIN vets vt ON v.vet_id = vt.id
WHERE vt.name = 'William Tatcher'
ORDER BY v.visit_date DESC
LIMIT 1;

-- How many different animals did Stephanie Mendez see?
SELECT COUNT(DISTINCT v.animal_id) AS animal_count
FROM visits v
JOIN vets vt ON v.vet_id = vt.id
WHERE vt.name = 'Stephanie Mendez';

-- List all vets and their specialties, including vets with no specialties.
SELECT v.name AS vet_name, s.name AS specialty
FROM vets v
LEFT JOIN specializations sp ON v.id = sp.vet_id
LEFT JOIN species s ON sp.species_id = s.id;

-- List all animals that visited Stephanie Mendez between April 1st and August 30th, 2020.
SELECT a.name AS animal_name
FROM animals a
JOIN visits v ON a.id = v.animal_id
JOIN vets vt ON v.vet_id = vt.id
WHERE vt.name = 'Stephanie Mendez'
  AND v.visit_date BETWEEN '2020-04-01' AND '2020-08-30';

-- What animal has the most visits to vets?
SELECT a.name AS animal_name, COUNT(v.id) AS visit_count
FROM animals a
LEFT JOIN visits v ON a.id = v.animal_id
GROUP BY a.name
ORDER BY visit_count DESC
LIMIT 1;

-- Who was Maisy Smith's first visit?
SELECT a.name AS animal_name
FROM animals a
JOIN visits v ON a.id = v.animal_id
JOIN vets vt ON v.vet_id = vt.id
WHERE vt.name = 'Maisy Smith'
ORDER BY v.visit_date
LIMIT 1;

-- Details for most recent visit: animal information, vet information, and date of visit.
SELECT a.name AS animal_name, vt.name AS vet_name, v.visit_date
FROM animals a
JOIN visits v ON a.id = v.animal_id
JOIN vets vt ON v.vet_id = vt.id
ORDER BY v.visit_date DESC
LIMIT 1;

-- How many visits were with a vet that did not specialize in that animal's species?
SELECT COUNT(*) AS mismatched_specialties_count
FROM visits v
JOIN animals a ON v.animal_id = a.id
JOIN vets vt ON v.vet_id = vt.id
LEFT JOIN specializations sp ON vt.id = sp.vet_id AND a.species_id = sp.species_id
WHERE sp.vet_id IS NULL;

-- What specialty should Maisy Smith consider getting? Look for the species she gets the most.
SELECT s.name AS suggested_specialty
FROM visits v
JOIN animals a ON v.animal_id = a.id
JOIN species s ON a.species_id = s.id
JOIN vets vt ON v.vet_id = vt.id
WHERE vt.name = 'Maisy Smith'
GROUP BY s.name
ORDER BY COUNT(*) DESC
LIMIT 1;


