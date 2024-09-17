create database covid19;
use covid19;

SELECT * FROM coviddeaths 
order by 3,4;

select * From covidvaccination;

-- 1.whitespaces into null values 

set sql_safe_updates=0;

update covid19.coviddeaths set total_deaths=NULL,continent=null
where total_deaths=0 and continent=0;

set sql_safe_updates=1;

SELECT continent,total_deaths from covid19.coviddeaths;

-- 2.select the data that we are going to be using;

select location,date,total_cases,new_cases,total_deaths,population
from covid19.coviddeaths order by 1,2;

-- 3.looking total_cases vs total_deaths

select location,date,total_cases,total_deaths,
(total_deaths/total_cases)*100 as death_percentage
from covid19.coviddeaths order by 1,2;

-- 4.highest count across the location

SELECT location, MAX(total_deaths) as Highest_count
FROM covid19.coviddeaths 
GROUP BY location 
ORDER BY Highest_count desc;

-- 5.total cases vs population

select location,date,total_cases,population,(total_cases/population)*100 as deathpercentage
from covid19.coviddeaths 
 order by 1,2 ;
 
 -- 6.countries with highest infection rate compared to population
 
 select location,population,max(total_cases) as highest_infection_count,
 (max(total_cases)/population)*100 as deathpercentage
 from covid19.coviddeaths
 group by location,population
 order by highest_infection_count desc;
 
 
 -- 7.showing the countries with highest death count per population
 
 select location,max(total_deaths) as totaldeathcount
 from covid19.coviddeaths
 where continent is  not null
 group by location
 order by totaldeathcount desc limit 3;
 
 -- 8.total cases according to date

select date,sum(new_cases) as totalcases,sum(new_deaths) as total_deaths
 from covid19.coviddeaths
where continent is not null
group by date
order by totalcases asc limit 5;
 
-- 9.totalpopulation vs vaccination

SELECT dea.continent, dea.location, dea.date, dea.population, vac.new_vaccinations,
SUM(vac.new_vaccinations) over (partition by dea.location,dea.continent,dea.date)as total_vaccinations
FROM covid19.coviddeaths dea
JOIN covid19.covidvaccination vac
ON dea.location = vac.location
AND dea.date = vac.date
WHERE dea.continent IS NOT NULL
group by dea.continent,dea.location,dea.date,dea.population,vac.new_vaccinations
ORDER BY total_vaccinations desc ;











