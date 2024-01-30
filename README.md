# Portafolio de Análisis de Datos

## Exploración de Datos de COVID-19

Este segmento se enfoca en el análisis de datos de la COVID-19 mediante consultas SQL. [Visualizaciones en Tableau](https://public.tableau.com/shared/MRGHTJNZD?:display_count=n&:origin=viz_share_link).

## Análisis de Datos de Películas

Análisis de un conjunto de datos de películas, abordando tareas como tratamiento de valores nulos, cambio de tipos de datos y exploración de correlaciones.

## Limpieza de Datos de Viviendas en Nashville

Limpieza de datos de viviendas en Nashville utilizando MySQL. [Archivo RAW](/Nashville%20Housing%20Data%20for%20Data%20Cleaning%20%28reuploaded%29.csv) y script SQL proporcionados.

### Instrucciones de Limpieza

1. **Creación de Base de Datos y Tabla:**

   ```sql
   CREATE DATABASE IF NOT EXISTS Nashville;
   USE Nashville;
   CREATE TABLE nashville_housing (
       UniqueID INT,
       ParcelID VARCHAR(255),
       -- ... (Otras columnas) ...
       HalfBath INT
   );





