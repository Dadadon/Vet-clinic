/* Database schema to keep the structure of entire database. */

CREATE TABLE animals ( 
    ID INT PRIMARY KEY NOT NULL, 
    NAME VARCHAR(20) NOT NULL, 
    DATE_OF_BIRTH DATE, 
    ESCAPE_ATTEMPTS INT, 
    NEUTERED BOOLEAN, 
    WEIGHT_KG REAL
);