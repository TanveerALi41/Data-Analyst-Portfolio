

			-- Data we will be using throughout the project
	SELECT  
				location , date , total_cases , new_cases , total_deaths , population
			FROM 
				project..CovidDeaths

			ORDER BY 1,2;





		--Looking at Total Cases vs Total Deaths
		--Shows the likelihood of dying if you had covid in Pakistan
	SELECT  
				location , date , total_cases, total_deaths , (total_deaths/total_cases)*100 as Death_Percentage
			FROM 
				project..CovidDeaths
			WHERE location = 'Pakistan'
			and continent is not null
			ORDER BY 1,2	;



		--Looking at Total Cases VS the Population
		--Shows the percentage of people who got covid

	SELECT  
				location,date ,total_cases , population , (total_cases/population)*100 as Contamination_percentage
			FROM 
				project..CovidDeaths
			--WHERE location = 'Pakistan'
			WHERE continent is not null
			ORDER BY 1,2 ;
	
			--Looking at the countries with highest contamination rate compared to population.
			-- Here we add the continent is not null because the continent column is null at places and corresponding to that the location column(which is for countries) has the asia in it.
			-- So we decided to exclude that all and used this "continent is not null".

		
	SELECT  
				location , max(total_cases) as max_cases , population , max((total_cases/population)*100) as max_Contamination_percentage
			FROM 
				project..CovidDeaths
			WHERE continent is not null
			GROUP BY location,population
			ORDER BY max_Contamination_percentage desc;
		


		--Looking at the Countries with highest death per population
		--exculding the continents and world from locations
		--Using cast to change data type of column total_deaths because its type is nvarchar which is not suitabe for aggregate functions.


	
	SELECT  
				location , max(cast(total_deaths as int)) as max_deaths 
			FROM 
				project..CovidDeaths
			WHERE continent is not null
			GROUP BY location
			ORDER BY max_deaths desc   ;




		--Continents with highest death count per population.

		
	SELECT  
				continent , max(cast(total_deaths as int)) as max_deaths 
			FROM 
				project..CovidDeaths
			WHERE continent is not null
			GROUP BY continent
			ORDER BY max_deaths desc  ;




			--GLOBAL NUMBER

		
	SELECT  
				date , sum(new_cases) as total_cases , sum(cast(new_deaths as int)) as total_deaths , (sum(cast(new_deaths as int))/sum(new_cases))*100 as death_percentage
			FROM 
				project..CovidDeaths
			--WHERE location = 'Pakistan'
			WHERE continent is not null
			GROUP BY date
			ORDER BY 1,2 ;	


			--Looking at TOTAL POPULATION VS VACCINATIONS 
			--Here we used windows fucntion with aggregate function by partitions to get the sum of each location that got vaccinations. 

			with popvsvac (continent,location,date,population,new_vaccinations,rolling_people_vaccinated) 
			as
			(
			SELECT d.continent,d.location,d.date,d.population,c.new_vaccinations, SUM(convert(int,c.new_vaccinations)) OVER(partition by d.location ORDER BY d.location,d.date) as rolling_people_vaccinated
			FROM project.dbo.CovidDeaths d JOIN project.dbo.CovidVaccinations c ON d.location = c.location and d.date = c.date
			WHERE d.continent is not null
			)
			SELECT *,(rolling_people_vaccinated/population)
			FROM popvsvac
			order by location,date


			--Doing the same thing using the TEMP TABLE

			DROP TABLE IF EXISTS #PERCENTPOPULATIONVACCINATED

			CREATE TABLE #PERCENTPOPULATIONVACCINATED
			(
				continent nvarchar(255),
				location  nvarchar(255),
				date datetime,
				population numeric,
				new_vaccinations numeric,
				rolling_people_vaccinated numeric
			
			)

			INSERT INTO #PERCENTPOPULATIONVACCINATED
			SELECT d.continent,d.location,d.date,d.population,c.new_vaccinations, SUM(convert(int,c.new_vaccinations)) OVER(partition by d.location ORDER BY d.location,d.date) as rolling_people_vaccinated
			FROM project.dbo.CovidDeaths d JOIN project.dbo.CovidVaccinations c ON d.location = c.location and d.date = c.date
			WHERE d.continent is not null
			

			
			SELECT *,(rolling_people_vaccinated/population)
			FROM #PERCENTPOPULATIONVACCINATED
			order by location,date



			--- CREATING VIEW TO STORE DATA FOR LATER VISUALIZATIONS

			CREATE VIEW	PERCENTPOPULATIONVACCINATED as
			SELECT d.continent,d.location,d.date,d.population,c.new_vaccinations, SUM(convert(int,c.new_vaccinations)) OVER(partition by d.location ORDER BY d.location,d.date) as rolling_people_vaccinated
			FROM project.dbo.CovidDeaths d JOIN project.dbo.CovidVaccinations c ON d.location = c.location and d.date = c.date
			WHERE d.continent is not null
