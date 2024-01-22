SELECT 
    *
FROM
    portfolio_project.coviddeaths
WHERE
    continent IS NOT NULL;

# Looking at total Cases vs Total Deaths

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

# Looking at total Cases vs Population
# Show what percentage of population got covid

SELECT 
    location,
    date,
    total_cases,
    total_deaths,
    population,
    (total_cases/ population) * 100 AS CovidPercentage
FROM
    portfolio_project.coviddeaths
WHERE
    location LIKE 'Costa Rica'
ORDER BY total_cases , date;


# Countries with higher infection rates compared population

SELECT 
    location,
    population,
    MAX(total_cases) as maxcount,
	MAX((total_cases/ population)) * 100 AS CovidPercentage
FROM
    portfolio_project.coviddeaths
#WHERE
 #   location LIKE 'Costa Rica'
group by location, population
order by CovidPercentage desc;

# Show countries  with highest death count per population

SELECT 
    location,
    MAX(cast(total_deaths as signed)) as TotalDeathCount
FROM
    portfolio_project.coviddeaths
where continent != ""
group by location
order by TotalDeathCount desc;

# LETS BREAK DOWN BY CONTINENT
# showing continents with the highest death count per population

SELECT 
	continent,
    MAX(cast(total_deaths as signed)) as TotalDeathCount
FROM
    portfolio_project.coviddeaths
where continent != ""
group by continent
order by TotalDeathCount desc;


# Global numbers

SELECT 
    date, 
    SUM(new_cases) as total_cases, 
    SUM(new_deaths) as total_deaths,
    SUM(new_deaths)/SUM(new_cases)*100 as DeathPercentage
FROM
    portfolio_project.coviddeaths
WHERE
    continent != ''
GROUP BY date;


#Looking at total Population vs Vaccinations

# use CTE
with PopvsVac (continent, location, date, population, new_vaccinations, RollingPeopleVaccinated) as
(
SELECT 
    cd.continent,
    cd.location,
    cd.date,
    cd.population,
    cv.new_vaccinations,
    SUM(cd.new_vaccinations) OVER (partition by cd.location ORDER by cd.location, cd.date) as RollingPeopleVaccinated
FROM
    portfolio_project.coviddeaths cd
        JOIN
    portfolio_project.covid_vac cv ON cd.date = cv.date
        AND cd.location = cv.location
where cd.continent != ""
ORDER BY cd.date, location
)

select *,  RollingPeopleVaccinated/population*100
from PopvsVac;


#Temp Table

CREATE TABLE #PercentPopulationVaccinated(
    continent VARCHAR(255),
    location VARCHAR(255),
    date DATETIME,
    population DECIMAL,
    new_vaccinations DECIMAL,
    RollingPeopleVaccinated DECIMAL
);

INSERT INTO #PercentPopulationVaccinated(location, date, population, new_vaccinations, RollingPeopleVaccinated)
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
    portfolio_project.covid_vac cv ON cd.date = cv.date
    AND cd.location = cv.location
-- WHERE cd.continent != "" --
ORDER BY
    cd.date, location;

SELECT *, (RollingPeopleVaccinated / population) * 100 AS PercentPopulationVaccinated
FROM #PercentPopulationVaccinated;


-- Create View to store data for later viz -- 
DROP VIEW if exists PercentPopulationVaccinated;

CREATE VIEW PercentPopulationVaccinated as
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
    portfolio_project.covid_vac cv ON cd.date = cv.date
    AND cd.location = cv.location
WHERE cd.continent != "" 
ORDER BY
    cd.date, location;
