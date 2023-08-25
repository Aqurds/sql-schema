-- Insert Agumon's data
INSERT INTO animals (name, date_of_birth, escape_attempts, neutered, weight_kg)
VALUES ('Agumon', '2020-02-03', 0, true, 10.23);

-- Insert Gabumon's data
INSERT INTO animals (name, date_of_birth, escape_attempts, neutered, weight_kg)
VALUES ('Gabumon', '2018-11-15', 2, true, 8);

-- Insert Pikachu's data
INSERT INTO animals (name, date_of_birth, escape_attempts, neutered, weight_kg)
VALUES ('Pikachu', '2021-01-07', 1, false, 15.04);

-- Insert Devimon's data
INSERT INTO animals (name, date_of_birth, escape_attempts, neutered, weight_kg)
VALUES ('Devimon', '2017-05-12', 5, true, 11);



INSERT INTO animals (name, date_of_birth, escape_attempts, neutered, weight_kg, species)
VALUES
    ('Charmander', '2020-02-08', 0, false, -11.0, NULL),
    ('Plantmon', '2021-11-15', 2, true, -5.7, NULL),
    ('Squirtle', '1993-04-02', 3, false, -12.13, NULL),
    ('Angemon', '2005-06-12', 1, true, -45.0, NULL),
    ('Boarmon', '2005-06-07', 7, true, 20.4, NULL),
    ('Blossom', '1998-10-13', 3, true, 17.0, NULL),
    ('Ditto', '2022-05-14', 4, true, 22.0, NULL);

-- Insert Data into the owners table:
INSERT INTO owners (full_name, age)
VALUES
    ('Sam Smith', 34),
    ('Jennifer Orwell', 19),
    ('Bob', 45),
    ('Melody Pond', 77),
    ('Dean Winchester', 14),
    ('Jodie Whittaker', 38);

-- Insert Data into the species table:
INSERT INTO species (name)
VALUES
    ('Pokemon'),
    ('Digimon');

-- Update species_id based on animal names
UPDATE animals
SET species_id = (CASE
                      WHEN name LIKE '%mon' THEN (SELECT id FROM species WHERE name = 'Digimon')
                      ELSE (SELECT id FROM species WHERE name = 'Pokemon')
                  END);

-- Update owner_id based on owner names
UPDATE animals
SET owner_id = (CASE
                     WHEN name IN ('Agumon') THEN (SELECT id FROM owners WHERE full_name = 'Sam Smith')
                     WHEN name IN ('Gabumon', 'Pikachu') THEN (SELECT id FROM owners WHERE full_name = 'Jennifer Orwell')
                     WHEN name IN ('Devimon', 'Plantmon') THEN (SELECT id FROM owners WHERE full_name = 'Bob')
                     WHEN name IN ('Charmander', 'Squirtle', 'Blossom') THEN (SELECT id FROM owners WHERE full_name = 'Melody Pond')
                     WHEN name IN ('Angemon', 'Boarmon') THEN (SELECT id FROM owners WHERE full_name = 'Dean Winchester')
                 END);

