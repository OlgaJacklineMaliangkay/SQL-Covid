Select *
From Covid..Case$
Order by location, date asc

Select *
From Covid..Demographic$
Order by location, date asc

Select *
From Covid..Hospitality$
Order by location, date asc

Select *
From Covid..Test$
Order by location, date asc

Select *
From Covid..Vaccinate$
Order by location, date asc

--

Drop table if exists #Temp_Covid
Create Table #Temp_Covid
(Continent nvarchar(50), Location nvarchar(50), TotalDeaths float, TotalCases float,
LifeExpectRate float, Population float, AvgStringencyIndex float, TotalVacc float, TotalBoosters float
, Aged65_Older float, Aged70_Older float, gdpPerCapita float, cardiovascDeathRate float, DiabetPrevalence float, smokers float
)

Insert Into #Temp_Covid
Select distinct(cas.continent), cas.location, max(convert(float, total_deaths)) over(partition by cas.location) TotalDeaths
, max(convert(float, total_cases)) over(partition by cas.location) TotalCases
, Round(avg(convert(float, life_expectancy)) over(partition by dem.location), 2) LifeExpectRate
, avg(convert(float, population)) over(partition by dem.location) Population
, Round(avg(convert(float, stringency_index)) over(partition by vac.location), 2) AvgStringencyIndex
, max(convert(float, total_vaccinations)) over(partition by vac.location) TotalVacc
, max(convert(float, total_boosters)) over(partition by vac.location) TotalBoosters
, convert(float, aged_65_older), convert(float, aged_70_older), convert(float, gdp_per_capita)
, convert(float, cardiovasc_death_rate), convert(float, diabetes_prevalence), convert(float, female_smokers)+convert(float, male_smokers)
From Covid..Case$ cas
Full Outer Join Covid..Vaccinate$ vac
	On cas.location = vac.location
	and cas.date = vac.date
Full Outer Join Covid..Test$ tes
	On cas.location = tes.location
	and cas.date = tes.date
Full Outer Join Covid..Demographic$ dem
	On cas.location = dem.location
	and cas.date = dem.date
Where cas.continent is not null
Order by continent, cas.location

Select *
From #Temp_Covid

Select Continent, Location, TotalDeaths, TotalCases, TotalVacc, TotalBoosters
From #Temp_Covid

Select Distinct(Continent)
, Sum(TotalDeaths) TotalDeaths
, Sum(TotalCases) TotalCases
, Sum(TotalVacc) TotalVacc
, Sum(TotalBoosters) TotalBoosters
From #Temp_Covid
Group by Continent

Select Continent, Location
, Round((TotalDeaths/TotalCases)*100, 2) DeathCaseRate
, Round((TotalCases/Population)*100, 2) PositiveCaseRate
, Round((TotalDeaths/Population)*100, 2) DeathRateCauseofCov
, Round(((Population-TotalDeaths)/Population)*100, 4) LifeRateFromCov
, LifeExpectRate
, Round(((Population-TotalDeaths)/Population)*LifeExpectRate, 2) LifePercentage
From #Temp_Covid

Select Distinct(Continent)
, Round(Avg((TotalDeaths/TotalCases)*100), 2) DeathCaseRate
, Round(Avg((TotalCases/Population)*100), 2) PositiveCaseRate
, Round(Avg((TotalDeaths/Population)*100), 2) DeathRateCauseofCov
, Round(Avg(((Population-TotalDeaths)/Population)*100), 2) LifeRateFromCov
, Round(Avg(LifeExpectRate), 2) AvgLifeExpectRate
, Round(Avg(((Population-TotalDeaths)/Population)*LifeExpectRate), 2) LifePercentage
From #Temp_Covid
Group by Continent

Select Sum(TotalDeaths) GloballDeaths
, Sum(TotalCases) GlobalCases
, Sum(TotalVacc) GlobalVacc
From #Temp_Covid

--do regresion to this data

Select Continent, Location, Population, TotalDeaths, Aged65_Older, Aged70_Older, cardiovascDeathRate, DiabetPrevalence, smokers, gdpPerCapita
From #Temp_Covid

-- do forecase to this time series

Select date, round(avg(cast(new_deaths as float)), 0) DeathPerDay
, round(avg(cast(new_cases as float)), 0) CasePerDay
From Covid..Case$
Group by date

--

--Drop table if exists #Temp_Covid2
--Create table #Temp_Covid2
--(continent nvarchar(50), Population nvarchar(50), TotalDeaths float, TotalCases float, TotalVacc float, TotalBoosters float)

--Insert into #Temp_Covid2
--Select distinct(Continent)
--, sum(Population) Population
--, sum(TotalDeaths) TotalDeaths
--, sum(TotalCases) TotalCases
--, sum(TotalVacc) TotalVacc
--, sum(TotalBoosters) TotalBoosters
--From #Temp_Covid
--Group by continent
--Order by Continent

--Select *
--From #Temp_Covid2

-- visualization

--Create table Covid
--(Continent nvarchar(50), Location nvarchar(50), TotalDeaths float, TotalCases float,
--LifeExpectRate float, Population float, AvgStringencyIndex float, TotalVacc float, TotalBoosters float
--, Aged65_Older float, Aged70_Older float, gdpPerCapita float, cardiovascDeathRate float, DiabetPrevalence float, smokers float
--)

--Insert Into Covid
--Select distinct(cas.continent), cas.location, max(convert(float, total_deaths)) over(partition by cas.location) TotalDeaths
--, max(convert(float, total_cases)) over(partition by cas.location) TotalCases
--, Round(avg(convert(float, life_expectancy)) over(partition by dem.location), 2) LifeExpectRate
--, avg(convert(float, population)) over(partition by dem.location) Population
--, Round(avg(convert(float, stringency_index)) over(partition by vac.location), 2) AvgStringencyIndex
--, max(convert(float, total_vaccinations)) over(partition by vac.location) TotalVacc
--, max(convert(float, total_boosters)) over(partition by vac.location) TotalBoosters
--, convert(float, aged_65_older), convert(float, aged_70_older), convert(float, gdp_per_capita)
--, convert(float, cardiovasc_death_rate), convert(float, diabetes_prevalence), convert(float, female_smokers)+convert(float, male_smokers)
--From Covid..Case$ cas
--Full Outer Join Covid..Vaccinate$ vac
--	On cas.location = vac.location
--	and cas.date = vac.date
--Full Outer Join Covid..Test$ tes
--	On cas.location = tes.location
--	and cas.date = tes.date
--Full Outer Join Covid..Demographic$ dem
--	On cas.location = dem.location
--	and cas.date = dem.date
--Where cas.continent is not null
--Order by continent, cas.location

--Create view Covid1 as
--Select Continent, Location, TotalDeaths, TotalCases, TotalVacc, TotalBoosters
--From Covid..Covid

--Create view Covid2 as
--Select Distinct(Continent)
--, Sum(TotalDeaths) TotalDeaths
--, Sum(TotalCases) TotalCases
--, Sum(TotalVacc) TotalVacc
--, Sum(TotalBoosters) TotalBoosters
--From Covid..Covid
--Group by Continent

--Create view Covid3 as
--Select Continent, Location
--, Round((TotalDeaths/TotalCases)*100, 2) DeathCaseRate
--, Round((TotalCases/Population)*100, 2) PositiveCaseRate
--, Round((TotalDeaths/Population)*100, 2) DeathRateCauseofCov
--, Round(((Population-TotalDeaths)/Population)*100, 4) LifeRateFromCov
--, LifeExpectRate
--, Round(((Population-TotalDeaths)/Population)*LifeExpectRate, 2) LifePercentage
--From Covid..Covid

--Create view Covid4 as
--Select Distinct(Continent)
--, Round(Avg((TotalDeaths/TotalCases)*100), 2) DeathCaseRate
--, Round(Avg((TotalCases/Population)*100), 2) PositiveCaseRate
--, Round(Avg((TotalDeaths/Population)*100), 2) DeathRateCauseofCov
--, Round(Avg(((Population-TotalDeaths)/Population)*100), 2) LifeRateFromCov
--, Round(Avg(LifeExpectRate), 2) AvgLifeExpectRate
--, Round(Avg(((Population-TotalDeaths)/Population)*LifeExpectRate), 2) LifePercentage
--From Covid..Covid
--Group by Continent

----do regresion to this data

--Create view Covid5 as
--Select Continent, Location, Population, TotalDeaths, Aged65_Older, Aged70_Older, cardiovascDeathRate, DiabetPrevalence, smokers, gdpPerCapita
--From Covid..Covid

----

--Create view Covid6 as
--Select Sum(TotalDeaths) GloballDeaths
--, Sum(TotalCases) GlobalCases
--, Sum(TotalVacc) GlobalVacc
--From Covid..Covid

