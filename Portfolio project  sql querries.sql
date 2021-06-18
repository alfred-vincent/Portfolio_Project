select location,date,total_cases,new_cases,total_deaths,population
from Covid_Deaths
order by 1,2

--Total cases vs Total deaths

select location,date,total_cases,total_deaths,(total_deaths/total_cases)*100 as Death_Percentage
from Covid_Deaths
where location like 'India'
order by 1,2

--Total cases vs population

select location,date,population,total_cases, (total_cases/population)*100 as Infection_Percentage
from Covid_Deaths
where location like 'India'
order by 1,2

--Countires with highest infection rates

select location,population,max(total_cases) HighestInfectionCount, max((total_cases/population))*100 as Infection_Percentage
from Covid_Deaths
--where location like 'India'
group by location,population
order by Infection_Percentage desc

--Countires with highest death count per population

select location,population,max(CAST(total_deaths AS int)) DeathCount, max((total_deaths/population))*100 as Death_Percentage
from Covid_Deaths
where continent is not null
--where location like 'India'
group by location,population
ORDER BY DeathCount desc
--order by Death_Percentage desc


--Global Stats

Select date, sum(new_cases) as Cases, sum(cast(new_deaths as int)) as Deaths, sum(cast(new_deaths as int))/ sum(new_cases) *100 as DeathPercentage
from Covid_Deaths
where continent is not null
group by date
order by 1,2

---------------

select * 
from Portfolio_Project..Covid_Deaths dea
join Portfolio_Project..Covid_Vaccinations vac
	on dea.location = vac.location
	and dea.date = vac.date




-- Population vs Vaccination


select dea.continent,dea.location,dea.population,dea.new_cases, vac.new_vaccinations, vac.date, 
SUM(cast(vac.new_vaccinations as int)) over (partition by dea.location order by dea.location, dea.date) as People_Vaccinated
from Portfolio_Project..Covid_Deaths dea
join Portfolio_Project..Covid_Vaccinations vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
order by location,date

-- using CTE to find the percentage of vaccinations

with PopvsVac (Continent,Location,Population,New_cases, New_vaccinations,Date, People_Vaccinated)
as
(
select dea.continent,dea.location,dea.population, dea.new_cases, vac.new_vaccinations, vac.date, 
SUM(cast(vac.new_vaccinations as int)) over (partition by dea.location order by dea.location, dea.date) as People_Vaccinated
from Portfolio_Project..Covid_Deaths dea
join Portfolio_Project..Covid_Vaccinations vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null
)
select *, (People_Vaccinated/Population)*100
from PopvsVac
order by 2,6


-- creating views

create view PercentageofPeopleVaccinated as
select dea.continent,dea.location,dea.population, dea.new_cases, vac.new_vaccinations, vac.date, 
SUM(cast(vac.new_vaccinations as int)) over (partition by dea.location order by dea.location, dea.date) as People_Vaccinated
from Portfolio_Project..Covid_Deaths dea
join Portfolio_Project..Covid_Vaccinations vac
	on dea.location = vac.location
	and dea.date = vac.date
where dea.continent is not null

select * from PercentageofPeopleVaccinated


