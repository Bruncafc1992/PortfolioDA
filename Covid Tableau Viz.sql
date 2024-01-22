-- Tableau Table 1 Project 2 Viz --
-- Calcula el total de casos, total de muertes y el porcentaje de muertes en comparación con nuevos casos.
SELECT 
    SUM(new_cases) AS total_cases,
    SUM(new_deaths) AS total_deaths,
    SUM(new_deaths) / SUM(New_Cases) * 100 deathper
FROM
    portfolio_project.coviddeaths
WHERE
    continent != ''
ORDER BY date , location;

-- Tableau Table 2 Project 2 Viz --
-- Calcula el recuento total de muertes por ubicación, excluyendo 'World', 'European Union' e 'International'.
SELECT 
    location, SUM(new_deaths) AS TotalDeathCount
FROM
    portfolio_project.coviddeaths
WHERE
    continent = ''
        AND location NOT IN ('World' , 'European Union', 'International')
GROUP BY location
ORDER BY TotalDeathCount DESC;

-- Tableau Table 3 Project 2 --
-- Muestra la ubicación, población, recuento máximo de casos de infección y porcentaje máximo de población infectada.
SELECT 
    Location,
    Population,
    MAX(total_cases) AS HighestInfectionCount,
    MAX((total_cases / population)) * 100 AS PercentPopulationInfected
FROM
    portfolio_project.coviddeaths
WHERE continent != ""
GROUP BY Location , Population
ORDER BY PercentPopulationInfected DESC;

-- Tableau Table 4 Project 2 Viz
-- Muestra la ubicación, población, fecha, recuento máximo de casos de infección y porcentaje máximo de población infectada.
SELECT 
    Location,
    Population,
    date,
    MAX(total_cases) AS HighestInfectionCount,
    MAX((total_cases / population)) * 100 AS PercentPopulationInfected
FROM
    portfolio_project.coviddeaths
GROUP BY Location , Population , date
ORDER BY PercentPopulationInfected DESC;

