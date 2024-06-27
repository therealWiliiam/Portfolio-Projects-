select *
from [Project Portfolio]..['Covid Deaths$']
where continent is not null
order by 1,2

--Select data that will be used for this project 
select location, date, total_cases, new_cases, total_deaths, population
from [Project Portfolio]..['Covid Deaths$']
where continent is not null
order by 1,2

--Total cases vs Total deaths
select location, date, total_cases, total_deaths, (CAST(total_deaths as float)/Cast(total_cases as float))*100 as DeathPercentage 
from [Project Portfolio]..['Covid Deaths$']
where location like '%states%' 
order by 1,2

--looking at Total cases vs Population
select location, date,population,total_cases,(CAST(total_cases as float)/Cast(population as float))*100 as DeathPercentage
from [Project Portfolio]..['Covid Deaths$']
where location like '%states%' 
order by 1,2

--Looking at countries with the Highest Infection Rate compared to Population 
select location,population,MAX(total_cases) as Highest_Infection_Count,MAX((CAST(total_cases as float)/Cast(population as float)))*100 as PercentPopulationInfected
from [Project Portfolio]..['Covid Deaths$']
--where location like '%states%' 
group by location,population
ORDER by PercentPopulationInfected desc

--showing countries with Highest Death Count per Population 
select location,MAX(cast(total_deaths as int)) as TotalDeathCount
from [Project Portfolio]..['Covid Deaths$']
--where location like '%states%' 
where continent is not null
group by location
ORDER by TotalDeathCount desc

--breaking things down by continent
select continent,MAX(cast(total_deaths as int)) as TotalDeathCount
from [Project Portfolio]..['Covid Deaths$']
--where location like '%states%' 
where continent is not null
group by continent
ORDER by TotalDeathCount desc

--showing continents with the highest death count per population
select continent,MAX(cast(total_deaths as int)) as TotalDeathCount
from [Project Portfolio]..['Covid Deaths$']
--where location like '%states%' 
where continent is not null
group by continent
ORDER by TotalDeathCount desc

--Global Numbers
select date, total_cases, total_deaths, (CAST(total_deaths as float)/Cast(total_cases as float))*100 as DeathPercentage 
from [Project Portfolio]..['Covid Deaths$']
--where location like '%states%' 
where continent is not null
group by date 
order by 1,2

--looking at total population vs total vaccinations
select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations,
SUM(cast(vac.new_vaccinations as bigint)) over (partition by dea.location order by dea.location,dea.Date)
as RollingPeopleVaccinated --,(RollingPeopleVaccinated/population) * 100
from [Project Portfolio]..['Covid Deaths$'] dea
join [Project Portfolio]..['Covid Vaccinations$'] vac
on dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null
order by 2,3

--Using a CTE
with PopvsVac (Continent,Location,Date,Population,new_vaccinations,RollingPeopleVaccinated)
as
(
select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations,
SUM(cast(vac.new_vaccinations as bigint)) over (partition by dea.location order by dea.location,dea.Date)
as RollingPeopleVaccinated --,(RollingPeopleVaccinated/population) * 100
from [Project Portfolio]..['Covid Deaths$'] dea
join [Project Portfolio]..['Covid Vaccinations$'] vac
on dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null
--order by 2,3
)
select *,(RollingPeopleVaccinated/Population)
from PopvsVac

--Using a TEMP TABLE
create table  #PercentagePopulationVaccinated
(
continent nvarchar


insert into
select dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations,
SUM(cast(vac.new_vaccinations as bigint)) over (partition by dea.location order by dea.location,dea.Date)
as RollingPeopleVaccinated --,(RollingPeopleVaccinated/population) * 100
from [Project Portfolio]..['Covid Deaths$'] dea
join [Project Portfolio]..['Covid Vaccinations$'] vac
on dea.location = vac.location
and dea.date = vac.date
where dea.continent is not null
order by 2,3