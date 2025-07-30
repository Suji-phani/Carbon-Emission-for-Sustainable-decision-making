-- 🔍 1. Total Emissions by Country (Latest Year)
SELECT c.Country_name, SUM(e.CO2_emission) AS Total_Emissions
FROM Emission e
JOIN Country c ON e.Country_id = c.Country_id
JOIN Year y ON e.Year_id = y.Year_id
WHERE y.Year = 2019
GROUP BY c.Country_name
ORDER BY Total_Emissions DESC;

-- 🔍 2. Year-wise Emission Trend for Top 5 Countries
SELECT y.Year, c.Country_name, SUM(e.CO2_emission) AS Emissions
FROM Emission e
JOIN Country c ON e.Country_id = c.Country_id
JOIN Year y ON e.Year_id = y.Year_id
JOIN (
    SELECT c2.Country_id
    FROM Emission e2
    JOIN Country c2 ON e2.Country_id = c2.Country_id
    GROUP BY c2.Country_id
    ORDER BY SUM(e2.CO2_emission) DESC
    LIMIT 5
) top_countries ON e.Country_id = top_countries.Country_id
GROUP BY y.Year, c.Country_name
ORDER BY y.Year;

-- 🔍 3. Emissions by Sector (Latest Year)
SELECT s.Sector_name, SUM(e.CO2_emission) AS Total_Emissions
FROM Emission e
JOIN Sector s ON e.Sector_id = s.Sector_id
JOIN Year y ON e.Year_id = y.Year_id
WHERE y.Year = 2019
GROUP BY s.Sector_name
ORDER BY Total_Emissions DESC;

-- 🔍 4. Renewable vs Non-Renewable Emission Comparison
SELECT et.Energy_type, SUM(e.CO2_emission) AS Emissions
FROM Emission e
JOIN EnergyType et ON e.Energy_id = et.Energy_id
GROUP BY et.Energy_type
ORDER BY Emissions DESC;

-- 🔍 5. Countries with Highest Energy Intensity per Capita
SELECT c.Country_name, y.Year, ei.Energy_intensity_per_capita
FROM EnergyIntensity ei
JOIN Country c ON ei.Country_id = c.Country_id
JOIN Year y ON ei.Year_id = y.Year_id
ORDER BY ei.Energy_intensity_per_capita DESC
LIMIT 10;

-- 🔍 6. GDP vs CO2 Emission
SELECT c.Country_name, y.Year, ed.GDP, e.CO2_emission
FROM EconomicData ed
JOIN Emission e ON ed.Country_id = e.Country_id AND ed.Year_id = e.Year_id
JOIN Country c ON ed.Country_id = c.Country_id
JOIN Year y ON ed.Year_id = y.Year_id
ORDER BY y.Year, c.Country_name;

-- 🔍 7. Total Energy Consumption vs Production
SELECT c.Country_name, y.Year,
       SUM(ec.Consumption_value) AS Total_Consumption,
       SUM(ep.Production_value) AS Total_Production
FROM EnergyConsumption ec
JOIN EnergyProduction ep ON ec.Country_id = ep.Country_id AND ec.Year_id = ep.Year_id AND ec.Energy_id = ep.Energy_id
JOIN Country c ON ec.Country_id = c.Country_id
JOIN Year y ON ec.Year_id = y.Year_id
GROUP BY c.Country_name, y.Year;

-- 🔍 8. Countries with Increasing CO2 Emissions
SELECT c.Country_name, MIN(y.Year) AS Start_Year, MAX(y.Year) AS End_Year,
       MIN(e.CO2_emission) AS Start_Emission, MAX(e.CO2_emission) AS End_Emission
FROM Emission e
JOIN Country c ON e.Country_id = c.Country_id
JOIN Year y ON e.Year_id = y.Year_id
GROUP BY c.Country_name
HAVING MAX(e.CO2_emission) > MIN(e.CO2_emission);

-- 🔍 9. Average Population and Emission by Sector
SELECT s.Sector_name, AVG(ed.Population) AS Avg_Population, SUM(e.CO2_emission) AS Total_Emission
FROM Emission e
JOIN Sector s ON e.Sector_id = s.Sector_id
JOIN EconomicData ed ON e.Country_id = ed.Country_id AND e.Year_id = ed.Year_id
GROUP BY s.Sector_name
ORDER BY Total_Emission DESC;

-- 🔍 10. Aggregated Emissions from Result Table
SELECT y.Year, s.Sector_name, r.TotalEmissions
FROM Result r
JOIN Year y ON r.Year_id = y.Year_id
JOIN Sector s ON r.Sector_id = s.Sector_id
ORDER BY y.Year, TotalEmissions DESC;
