--select * from PortfolioProject.dbo.[Covid Deaths]
--where continent is not null
--order by 3,4

--select * from PortfolioProject.dbo.[Covid Vaccinations]
--order by 3,4

--Select data we use
select 
  location, 
  date, 
  total_cases, 
  new_cases, 
  total_deaths, 
  population 
from 
  PortfolioProject.dbo.[Covid Deaths] 
where 
  continent is not null 
order by 
  1, 
  2


--Looking at Total cases vs Total deaths

select 
  location, 
  date, 
  total_cases, 
  total_deaths, 
  (total_deaths * 1.0 / total_cases)* 100 as percent_death 
from 
  PortfolioProject.dbo.[Covid Deaths] 
where 
  continent is not null 
order by 
  1, 
  2 
  
  --shows likelihood of death if you contract covid in your country
select 
  location, 
  date, 
  total_cases, 
  total_deaths, 
  (total_deaths * 1.0 / total_cases)* 100 as percent_death 
from 
  PortfolioProject.dbo.[Covid Deaths] 
where 
  location = 'India' 
  And continent is not null 
order by 
  1, 
  2 
  
  --Look at total cases vs population
  --Shows the percentage of population who got covid in India
select 
  location, 
  date, 
  population, 
  total_cases, 
  (total_cases * 1.0 / population)* 100 as percent_of_population 
from 
  PortfolioProject.dbo.[Covid Deaths] 
where 
  location = 'India' 
  And continent is not null 
order by 
  1, 
  2
  
  --Shows the percentage of population who got covid in the entire world
select 
  location, 
  date, 
  population, 
  total_cases, 
  (total_cases * 1.0 / population)* 100 as percent_of_population 
from 
  PortfolioProject.dbo.[Covid Deaths] 
where 
  continent is not null 
order by 
  1, 
  2 
  
  --Look at the coutnries with the highest infection rate
select 
  location, 
  population, 
  max(total_cases) as HighestInfectionCount, 
  Max(
    (total_cases * 1.0 / population)
  )* 100 as PercentPopulationInfected 
from 
  PortfolioProject.dbo.[Covid Deaths] 
where 
  continent is not null 
group by 
  location, 
  population 
order by 
  PercentPopulationInfected desc;
--Shows countries with highest death count per population
select 
  location, 
  max(total_deaths) as TotalDeathCount 
from 
  PortfolioProject.dbo.[Covid Deaths] 
where 
  continent is not null 
group by 
  location 
order by 
  TotalDeathCount desc;
--Continent wise 
select 
  continent, 
  max(total_deaths) as TotalDeathCount 
from 
  PortfolioProject.dbo.[Covid Deaths] 
where 
  continent is not null 
group by 
  continent 
order by 
  TotalDeathCount desc;
select 
  location, 
  max(total_deaths) as TotalDeathCount 
from 
  PortfolioProject.dbo.[Covid Deaths] 
where 
  continent is null 
group by 
  location 
order by 
  TotalDeathCount desc;
--Global Numbers
select 
  sum(new_cases) as DailyCases, 
  sum(new_deaths) as DailyDeaths, 
  case when sum(new_cases) = 0 then null else sum(new_deaths)* 1.0 / sum(new_cases)* 100 end as DailyDeathPercentage 
from 
  PortfolioProject.dbo.[Covid Deaths] 
where 
  continent is not null 
  --group by date
Order by 
  1, 
  2;


-- Looking at total population vs vaccination
select 
  cd.continent, 
  cd.location, 
  cd.date, 
  cd.population, 
  cv.new_vaccinations 
from 
  PortfolioProject.dbo.[Covid Deaths] cd 
  join PortfolioProject.dbo.[Covid Vaccinations] cv on cd.location = cv.location 
  and cd.date = cv.date 
where 
  cd.continent is not null 
order by 
  2, 
  3;

--My try on finding the total no. of people vaccinated in India
--select cd.location, cd.population, sum(cv.new_vaccinations) as totalvaccinatedpeople,
--sum(cv.new_vaccinations)*100.0/cd.population as percentvaccinated
--from PortfolioProject.dbo.[Covid Deaths] cd
--join PortfolioProject.dbo.[Covid Vaccinations] cv
--on cd.location = cv.location and cd.date = cv.date
--where cd.location = 'India'
--group by cd.location,cd.population
--order by 2,3;
--SELECT 
--    cd.location, 
--    cd.date, 
--    cd.population, 
--    cv.new_vaccinations,
--    SUM(cv.new_vaccinations) OVER (ORDER BY cd.date) as totalvaccinatedpeople
--FROM 
--    PortfolioProject.dbo.[Covid Deaths] cd
--JOIN 
--    PortfolioProject.dbo.[Covid Vaccinations] cv ON cd.location = cv.location AND cd.date = cv.date
--WHERE 
--    cd.location = 'India'
--GROUP BY 
--    cd.location, cd.date, cd.population, cv.new_vaccinations
--ORDER BY 
--    2, 3;


select 
  cd.continent, 
  cd.location, 
  cd.date, 
  cd.population, 
  cv.new_vaccinations, 
  sum(cv.new_vaccinations) over(
    partition by cd.location 
    order by 
      cd.location, 
      cd.date
  ) as Rollingpeoplevaccinated 
from 
  PortfolioProject.dbo.[Covid Deaths] cd 
  join PortfolioProject.dbo.[Covid Vaccinations] cv on cd.location = cv.location 
  and cd.date = cv.date 
where 
  cd.continent is not null 
order by 
  2, 
  3;


--To find percentage
--use CTE
with popvsvac (
  continent, location, date, population, 
  new_vaccinations, Rollingpeoplevaccinated
) as (
  select 
    cd.continent, 
    cd.location, 
    cd.date, 
    cd.population, 
    cv.new_vaccinations, 
    sum(cv.new_vaccinations) over(
      partition by cd.location 
      order by 
        cd.location, 
        cd.date
    ) as Rollingpeoplevaccinated 
  from 
    PortfolioProject.dbo.[Covid Deaths] cd 
    join PortfolioProject.dbo.[Covid Vaccinations] cv on cd.location = cv.location 
    and cd.date = cv.date 
  where 
    cd.continent is not null
) 
select 
  *, 
  (
    Rollingpeoplevaccinated * 1.0 / population
  )* 100 as Percentpeoplevaccinated 
from 
  popvsvac 
  
  
  --TempTable
Drop 
  table if exists #percentpeoplevaccinated
  create table #percentpeoplevaccinated
  (
    continent nvarchar(255), 
    location nvarchar(255), 
    Date datetime, 
    Population numeric, 
    New_vaccinations numeric, 
    RollingPeopleVaccinated numeric
  ) Insert into #percentpeoplevaccinated
select 
  cd.continent, 
  cd.location, 
  cd.date, 
  cd.population, 
  cv.new_vaccinations, 
  sum(cv.new_vaccinations) over(
    partition by cd.location 
    order by 
      cd.location, 
      cd.date
  ) as Rollingpeoplevaccinated 
from 
  PortfolioProject.dbo.[Covid Deaths] cd 
  join PortfolioProject.dbo.[Covid Vaccinations] cv on cd.location = cv.location 
  and cd.date = cv.date
  --where cd.continent is not null
select 
  *, 
  (
    Rollingpeoplevaccinated * 1.0 / population
  )* 100 as Percentpeoplevaccinated 
from 
  #percentpeoplevaccinated;
  
  
  --Creating view to store data for later visualizations
  create view percentpopulationvaccinated as 
select 
  cd.continent, 
  cd.location, 
  cd.date, 
  cd.population, 
  cv.new_vaccinations, 
  sum(cv.new_vaccinations) over(
    partition by cd.location 
    order by 
      cd.location, 
      cd.date
  ) as Rollingpeoplevaccinated 
from 
  PortfolioProject.dbo.[Covid Deaths] cd 
  join PortfolioProject.dbo.[Covid Vaccinations] cv on cd.location = cv.location 
  and cd.date = cv.date 
where 
  cd.continent is not null;
select 
  * 
from 
  percentpopulationvaccinated;

--Queries used for Tableau project
--1.

  Select sum(new_cases) as total_cases, sum(new_deaths) as total_deaths, sum(new_deaths*1.0)/sum(new_cases)*100 as DeathPercentage
  from PortfolioProject.dbo.[Covid Deaths]
  where continent is not null
  order by 1,2;

  --2.

  Select location,sum(new_deaths) as TotalDeathCount
  from PortfolioProject.dbo.[Covid Deaths]
  where continent is null
  and location not in ('World','European Union','High income','Upper middle income','Lower middle income','Low income')
  Group by location
  order by TotalDeathCount desc;

  --3.

  select location, population, max(total_cases) as Highestinfectioncount, max((total_cases*1.0/population))*100 as PercentPopulationInfected
  from PortfolioProject.dbo.[Covid Deaths]
  group by location,population
  order by PercentPopulationInfected desc;

  --4. 

  Select location, population,date,max(total_cases) as Highestinfectioncount, max((total_cases*1.0/population))*100 as PercentPopulationInfected
  from PortfolioProject.dbo.[Covid Deaths]
  group by location,population,date
  order by PercentPopulationInfected desc;



