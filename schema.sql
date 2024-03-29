CREATE TABLE animals (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255),
    date_of_birth DATE,
    escape_attempts INTEGER,
    neutered BOOLEAN,
    weight_kg DECIMAL(10, 2)
);

CREATE TABLE owners (
    id SERIAL PRIMARY KEY,
    full_name VARCHAR(255),
    age INTEGER
);

CREATE TABLE species (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255)
);

-- Add a new autoincremented PRIMARY KEY constraint on the id column
ALTER TABLE animals
ADD COLUMN id SERIAL PRIMARY KEY;

-- Remove the species column
ALTER TABLE animals
DROP COLUMN species;

-- Add the species_id column as a foreign key referencing the species table
ALTER TABLE animals
ADD COLUMN species_id INTEGER REFERENCES species(id);

-- Add the owner_id column as a foreign key referencing the owners table
ALTER TABLE animals
ADD COLUMN owner_id INTEGER REFERENCES owners(id);


CREATE TABLE vets (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255),
    age INTEGER,
    date_of_graduation DATE
);

CREATE TABLE specializations (
    id SERIAL PRIMARY KEY,
    vet_id INTEGER REFERENCES vets(id),
    species_id INTEGER REFERENCES species(id)
);


CREATE TABLE visits (
    id SERIAL PRIMARY KEY,
    animal_id INTEGER REFERENCES animals(id),
    vet_id INTEGER REFERENCES vets(id),
    visit_date DATE
);

