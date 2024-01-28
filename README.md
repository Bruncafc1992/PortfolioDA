# Portafolio de Análisis de Datos

## Exploración de Datos de COVID-19

Este repositorio contiene consultas SQL relacionadas con datos de la COVID-19. Se han llevado a cabo diversos análisis sobre la propagación y el impacto de la enfermedad utilizando una base de datos que incluye información sobre casos, muertes y vacunaciones.

## Visualización de Datos de COVID-19

Se proporcionan los queries necesarios para generar cada una de las siguientes tablas en Tableau.

[Enlace a Tableau Public para las visualizaciones de datos](https://public.tableau.com/shared/MRGHTJNZD?:display_count=n&:origin=viz_share_link)

## Limpieza de Datos de Viviendas en Nashville

Se adjunta un archivo RAW para su importación y limpieza con MySQL.

### Archivos Relevantes
- [**Nashville Housing Data for Data Cleaning (reuploaded).csv**](/Nashville%20Housing%20Data%20for%20Data%20Cleaning%20%28reuploaded%29.csv): Archivo crudo que contiene datos de viviendas en Nashville.

### Instrucciones de Limpieza
1. **Creación de la Base de Datos y Tabla:** Utiliza el script SQL proporcionado para crear la base de datos y la tabla necesarias.

    ```sql
    -- Crear la base de datos Nashville si no existe --
    CREATE DATABASE IF NOT EXISTS Nashville;

    -- Usar la base de datos Nashville --
    USE Nashville;

    -- Crear la tabla nashville_housing --
    CREATE TABLE nashville_housing (
        UniqueID INT,
        ParcelID VARCHAR(255),
        -- ... (Otras columnas) ...
        HalfBath INT
    );
    ```

2. **Carga de Datos y Exploración:**
    - Carga los datos desde el archivo RAW a la tabla `nashville_housing`.
    - Explora los datos utilizando consultas SQL proporcionadas.

3. **Limpieza de Datos:**
    - Realiza las correcciones necesarias, como la actualización de valores nulos o la modificación de formatos de columnas.

    ```sql
    -- Ejemplo: Eliminar filas con valores nulos en SaleDate --
    DELETE FROM Nashville.nashville_housing
    WHERE SaleDate IS NULL;
    ```

4. **División de Direcciones:**
    - Utiliza consultas SQL para dividir las direcciones en partes (ciudad, estado, etc.) según sea necesario.

    ```sql
    -- Ejemplo: Dividir la columna OwnerAddress en tres partes --
    ALTER TABLE Nashville.nashville_housing
    ADD COLUMN OwnerSplitAddress VARCHAR(255);

    UPDATE Nashville.nashville_housing
    SET OwnerSplitAddress = SUBSTRING_INDEX(OwnerAddress, '.', 1);
    ```

5. **Eliminación de Columnas No Necesarias:**
    - Elimina las columnas que ya no son necesarias después de la limpieza.

    ```sql
    -- Ejemplo: Eliminar columnas PropertyAddress y OwnerAddress --
    ALTER TABLE Nashville.nashville_housing
    DROP COLUMN PropertyAddress, 
    DROP COLUMN OwnerAddress;
    ```

### Agradecimientos y Recursos Adicionales
- Agradecemos a [ALEX THE ANALYST] por proporcionar el conjunto de datos de viviendas en Nashville.
- Consulta el archivo SQL para obtener detalles específicos sobre cada tarea de limpieza.

Este portafolio pretende destacar las habilidades en análisis de datos y limpieza utilizando herramientas como SQL y Tableau. ¡Explora y disfruta!





