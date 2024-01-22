-- Seleccionar todas las columnas de la tabla coviddeaths donde continent no es nulo
SELECT 
    *
FROM
    portfolio_project.coviddeaths
WHERE
    continent IS NOT NULL;

-- Analizando casos totales vs. Muertes totales en Costa Rica
SELECT 
    location,
    date,
    total_cases,
    total_deaths,
    (total_deaths / total_cases) * 100 AS DeathPercentage
FROM
    portfolio_project.coviddeaths
WHERE
    location LIKE 'Costa Rica'
ORDER BY location , date;

-- Analizando casos totales vs. Población
-- Mostrar el porcentaje de la población que contrajo COVID-19
SELECT 
    location,
    date,
    total_cases,
    total_deaths,
    population,
    (total_cases / population) * 100 AS CovidPercentage
FROM
    portfolio_project.coviddeaths
WHERE
    location LIKE 'Costa Rica'
ORDER BY total_cases , date;

-- Países con tasas de infección más altas en comparación con la población
SELECT 
    location,
    population,
    MAX(total_cases) as maxcount,
    MAX((total_cases / population)) * 100 AS CovidPercentage
FROM
    portfolio_project.coviddeaths
GROUP BY location, population
ORDER BY CovidPercentage DESC;

-- Países con el recuento de muertes más alto por población
SELECT 
    location,
    MAX(cast(total_deaths as signed)) as TotalDeathCount
FROM
    portfolio_project.coviddeaths
WHERE continent != ""
GROUP BY location
ORDER BY TotalDeathCount DESC;

-- Desglose por continente: mostrando continentes con el recuento de muertes más alto por población
SELECT 
	continent,
    MAX(cast(total_deaths as signed)) as TotalDeathCount
FROM
    portfolio_project.coviddeaths
WHERE continent != ""
GROUP BY continent
ORDER BY TotalDeathCount DESC;

-- Estadísticas globales
SELECT 
    date, 
    SUM(new_cases) as total_cases, 
    SUM(new_deaths) as total_deaths,
    SUM(new_deaths) / SUM(new_cases) * 100 AS DeathPercentage
FROM
    portfolio_project.coviddeaths
WHERE
    continent != ''
GROUP BY date;

-- Relación entre población y vacunaciones utilizando CTE
WITH PopvsVac (continent, location, date, population, new_vaccinations, RollingPeopleVaccinated) AS (
    SELECT 
        cd.continent,
        cd.location,
        cd.date,
        cd.population,
        cv.new_vaccinations,
        SUM(cd.new_vaccinations) OVER (PARTITION BY cd.location ORDER BY cd.location, cd.date) as RollingPeopleVaccinated
    FROM
        portfolio_project.coviddeaths cd
    JOIN
        portfolio_project.covid_vac cv ON cd.date = cv.date AND cd.location = cv.location
    WHERE cd.continent != ""
    ORDER BY cd.date, location
)

-- Seleccionar todo con el porcentaje de la población vacunada
SELECT *, RollingPeopleVaccinated / population * 100
FROM PopvsVac;

-- Crear una tabla temporal
CREATE TEMPORARY TABLE PercentPopulationVaccinated(
    continent VARCHAR(255),
    location VARCHAR(255),
    date DATETIME,
    population DECIMAL,
    new_vaccinations DECIMAL,
    RollingPeopleVaccinated DECIMAL
);

-- Insertar datos en la tabla temporal
INSERT INTO PercentPopulationVaccinated(location, date, population, new_vaccinations, RollingPeopleVaccinated)
SELECT
    cd.continent,
    cd.location,
    cd.date,
    cd.population,
    cv.new_vaccinations,
    SUM(cd.new_vaccinations) OVER (PARTITION BY cd.location ORDER BY cd.location, cd.date) AS RollingPeopleVaccinated
FROM
    portfolio_project.coviddeaths cd
JOIN
    portfolio_project.covid_vac cv ON cd.date = cv.date AND cd.location = cv.location
ORDER BY
    cd.date, location;

-- Seleccionar datos de la tabla temporal con el porcentaje de la población vacunada
SELECT *, (RollingPeopleVaccinated / population) * 100 AS PercentPopulationVaccinated
FROM PercentPopulationVaccinated;

-- Crear una vista para almacenar datos para visualización posterior
DROP VIEW IF EXISTS PercentPopulationVaccinated;

CREATE VIEW PercentPopulationVaccinated AS
SELECT
    cd.continent,
    cd.location,
    cd.date,
    cd.population,
    cv.new_vaccinations,
    SUM(cd.new_vaccinations) OVER (PARTITION BY cd.location ORDER BY cd.location, cd.date) AS RollingPeopleVaccinated
FROM
    portfolio_project.coviddeaths cd
JOIN
    portfolio_project.covid_vac cv ON cd.date = cv.date AND cd.location = cv.location
WHERE cd.continent != "" 
ORDER BY
    cd.date, location;
