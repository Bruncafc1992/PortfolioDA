-- Crear la base de datos Nashville si no existe --
CREATE DATABASE IF NOT EXISTS Nashville;

-- Usar la base de datos Nashville --
USE Nashville;

-- Crear la tabla nashville_housing --
CREATE TABLE nashville_housing (
    UniqueID INT,
    ParcelID VARCHAR(255),
    LandUse VARCHAR(255),
    PropertyAddress VARCHAR(255),
    SaleDate DATE,
    SalePrice INT,
    LegalReference VARCHAR(255),
    SoldAsVacant VARCHAR(255),
    OwnerName VARCHAR(255),
    OwnerAddress VARCHAR(255),
    Acreage DECIMAL(8, 2),
    TaxDistrict VARCHAR(255),
    LandValue INT,
    BuildingValue INT,
    TotalValue INT,
    YearBuilt INT,
    Bedrooms INT,
    FullBath INT,
    HalfBath INT
);

-- Seleccionar todos los registros de la tabla nashville_housing --
-- Ingresar desde la terminal con los siguientes comandos --
-- SET GLOBAL local_infile = 1; --
-- mysql --local-infile=1 -u root -p --
-- use Nashville --

-- Cargar datos desde un archivo CSV local --
LOAD DATA LOCAL INFILE '/Users/joseabjerez/Downloads/Nashville Housing Data for Data Cleaning (reuploaded)-2.csv'
INTO TABLE nashville_housing
FIELDS TERMINATED BY ','
ENCLOSED BY ""
LINES TERMINATED BY '\n' IGNORE 1 ROWS;

-- Mostrar todos los registros de la tabla nashville_housing --
SELECT * FROM Nashville.nashville_housing;
    
-- Mostrar y eliminar filas donde SaleDate sea 0 o Nulo --
SELECT * FROM Nashville.nashville_housing
WHERE SaleDate = '';

DELETE FROM Nashville.nashville_housing
WHERE SaleDate = '';
-- Eliminadas 7 filas --

-- Mostrar y eliminar filas donde SalePrice sea 0 o Nulo --
SELECT * FROM Nashville.nashville_housing
WHERE SalePrice = '';

DELETE FROM Nashville.nashville_housing
WHERE SalePrice = '';
-- Eliminadas 12 filas --

-- Mostrar todas las columnas de las filas con valores nulos o vacíos en PropertyAddress --
SELECT * FROM Nashville.nashville_housing
WHERE PropertyAddress = "" OR PropertyAddress IS NULL;

-- Revisar la columna ParcelID ordenada --
SELECT * FROM Nashville.nashville_housing
ORDER BY ParcelID;

-- Seleccionar información relacionada a direcciones de propiedad vacías --
SELECT 
    a.ParcelID,
    a.PropertyAddress AS aa,
    b.ParcelID,
    b.PropertyAddress AS bb
FROM
    Nashville.nashville_housing a
JOIN
    Nashville.nashville_housing b ON a.ParcelID = b.ParcelID
    AND a.UniqueID != b.UniqueID
WHERE
    a.PropertyAddress = '' OR b.PropertyAddress = '';

-- Actualizar la columna PropertyAddress en la tabla Nashville.nashville_housing --
UPDATE Nashville.nashville_housing a
JOIN Nashville.nashville_housing b
    ON a.ParcelID = b.ParcelID
    AND a.UniqueID != b.UniqueID
SET a.PropertyAddress = b.PropertyAddress
WHERE a.PropertyAddress = '';

-- Seleccionar una subcadena de PropertyAddress hasta el primer punto (.) y la subcadena después del último punto --
SELECT 
    SUBSTRING_INDEX(PropertyAddress, '.', 1) as ddd,  -- Obtener subcadena hasta el primer punto
    SUBSTRING_INDEX(PropertyAddress, '.', -1) as bbb  -- Obtener la subcadena después del último punto
FROM
    Nashville.nashville_housing;

-- Eliminar la columna incorrecta --
-- ALTER TABLE Nashville.nashville_housing
-- DROP COLUMN PropertySplitAddress;  -- Corregir el nombre de la columna

-- Agregar la nueva columna PropertySplitAddress --
ALTER TABLE Nashville.nashville_housing --
ADD COLUMN PropertySplitAddress VARCHAR(255); --

-- Actualizar la nueva columna con la subcadena hasta el primer punto --
UPDATE Nashville.nashville_housing
SET PropertySplitAddress = SUBSTRING_INDEX(PropertyAddress, '.', 1);

-- Agregar la nueva columna PropertySplitCity --
ALTER TABLE Nashville.nashville_housing
ADD COLUMN PropertySplitCity VARCHAR(255);

-- Actualizar la nueva columna con la subcadena después del último punto --
UPDATE Nashville.nashville_housing
SET PropertySplitCity = SUBSTRING_INDEX(PropertyAddress, '.', -1);

-- Dividir la columna OwnerAddress en tres partes usando '.' como delimitador --
SELECT 
    SUBSTRING_INDEX(OwnerAddress, '.', 1) as Parte1,   -- Obtener la primera parte
    SUBSTRING_INDEX(SUBSTRING_INDEX(OwnerAddress, '.', 2), '.', -1) as Parte2,   -- Obtener la segunda parte
    SUBSTRING_INDEX(OwnerAddress, '.', -1) as Parte3   -- Obtener la última parte
FROM Nashville.nashville_housing;

-- Agregar la nueva columna OwnerSplitAddress --
ALTER TABLE Nashville.nashville_housing
ADD COLUMN OwnerSplitAddress VARCHAR(255);

-- Actualizar la nueva columna con la subcadena antes del primer punto --
UPDATE Nashville.nashville_housing
SET OwnerSplitAddress = SUBSTRING_INDEX(OwnerAddress, '.', 1);

-- Agregar la nueva columna OwnerSplitCity --
ALTER TABLE Nashville.nashville_housing
ADD COLUMN OwnerSplitCity VARCHAR(255);

-- Actualizar la nueva columna con la subcadena entre el primer y segundo punto --
UPDATE Nashville.nashville_housing
SET OwnerSplitCity = SUBSTRING_INDEX(SUBSTRING_INDEX(OwnerAddress, '.', 2), '.', -1);

-- Agregar la nueva columna OwnerSplitState --
ALTER TABLE Nashville.nashville_housing
ADD COLUMN OwnerSplitState VARCHAR(255);

-- Actualizar la nueva columna con la subcadena después del último punto --
UPDATE Nashville.nashville_housing
SET OwnerSplitState = SUBSTRING_INDEX(OwnerAddress, '.', -1);

-- Revisar la columna SoldAsVacant --
SELECT DISTINCT(SoldAsVacant), COUNT(SoldAsVacant)
FROM Nashville.nashville_housing
GROUP BY SoldAsVacant
ORDER BY SoldAsVacant;

SELECT DISTINCT(SoldAsVacant), 
CASE WHEN SoldAsVacant = 'Y' THEN 'Yes'
    WHEN SoldAsVacant = 'N' THEN 'No'
    ELSE SoldAsVacant
    END as uno
FROM Nashville.nashville_housing;

-- Actualizar la columna SoldAsVacant --
UPDATE Nashville.nashville_housing
SET SoldAsVacant = CASE WHEN SoldAsVacant = 'Y' THEN 'Yes'
    WHEN SoldAsVacant = 'N' THEN 'No'
    ELSE SoldAsVacant
    END;
    
-- 451 filas actualizadas --

-- Eliminar filas duplicadas con CTE --
WITH RowNumCTE AS (
    SELECT 
        *,
        ROW_NUMBER() OVER (
            PARTITION BY 
                ParcelID,
                PropertyAddress,
                SalePrice,
                SaleDate,
                LegalReference
            ORDER BY UniqueID
        ) AS row_num
    FROM 
        Nashville.nashville_housing
    ORDER BY 
        ParcelID
)
DELETE FROM Nashville.nashville_housing
WHERE (ParcelID, PropertyAddress, SalePrice, SaleDate, LegalReference, UniqueID) IN (
    SELECT ParcelID, PropertyAddress, SalePrice, SaleDate, LegalReference, UniqueID
    FROM RowNumCTE
    WHERE row_num > 1
);

-- Eliminadas 104 filas repetidas --

-- Eliminar columnas no necesarias --
ALTER TABLE Nashville.nashville_housing
DROP COLUMN PropertyAddress, 
DROP COLUMN OwnerAddress;
