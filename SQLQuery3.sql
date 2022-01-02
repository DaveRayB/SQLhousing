--Data cleaning exercises for Nashville Housing

--View the SaleDate column
SELECT  SaleDate
FROM NashvilleHousing

--Convert SaleDate column from datetime to date format
--Try using the update method
Update NashvilleHousing
SET SaleDate = CONVERT(date, SaleDate)

--The above method didnt work
--Try creating a new column and then use the update
ALTER TABLE NashvilleHousing
Add SaleDate2 Date;
Update NashvilleHousing
SET SaleDate2 = CONVERT(date, SaleDate)



--View the Property Address data
SELECT PropertyAddress
FROM NashvilleHousing

--The address data should be split up.. create new columns that represent the street address and the city
--this can be accomplished because there is a comma in each row
select 
    CASE when CHARINDEX(',',PropertyAddress)>0  --this line checks if a comma exists
         then SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1) --SUBSTRING(string, starting position, ending position
         else PropertyAddress end Street_Address, 
    CASE WHEN CHARINDEX(',',PropertyAddress)>0 
         THEN SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress)+1,LEN(PropertyAddress))  
         ELSE NULL END as City
from NashvilleHousing

--the query above shows the correct splitting of address and city..it has duplicates but they can be removed later
--put these new columns into the nashville table using alter table, add, update, and set commands
--Make sure to execute the ALTER TABLE and ADD code first, and then separately execute the Update and SET code after
--If you execute all statements at once, it will not work
ALTER TABLE NashvilleHousing
Add Street_Address Nvarchar(255); --create the new column street address column
Update NashvilleHousing
SET Street_Address = SUBSTRING(PropertyAddress,1,CHARINDEX(',',PropertyAddress)-1)

ALTER TABLE NashvilleHousing --create the city column
Add City Nvarchar(255);
Update NashvilleHousing
SET City = SUBSTRING(PropertyAddress,CHARINDEX(',',PropertyAddress)+1,LEN(PropertyAddress))

--verify the new columns were added
SELECT *
FROM NashvilleHousing
--------------------------------
--------------------------------

--Extract the state out of the owner address column, but use PARSENAME instead
SELECT 
PARSENAME(REPLACE(OwnerAddress,',','.'),1) AS State   --parsename splits the string when it sees a period, so just replace the comma with a period
FROM NashvilleHousing
WHERE OwnerAddress IS NOT NULL

--Extract the state and notice it's easier to do parse the string than using the substring above
SELECT 
PARSENAME(REPLACE(OwnerAddress,',','.'),2) AS State   --parsename splits the string when it sees a period, so just replace the comma with a period
FROM NashvilleHousing
WHERE OwnerAddress IS NOT NULL

-----------------------------------------
-----------------------------------------

--look at the distinct values in the SoldAsVacant column
SELECT DISTINCT(SoldAsVacant)
FROM PortfolioProject.dbo.NashvilleHousing

--change the n's to no and the y's to yes by using update, set, and case statements
Update NashvilleHousing
SET SoldAsVacant = 
	CASE SoldAsVacant
		WHEN 'N' THEN 'NO'
		WHEN 'Y' THEN 'YES'
		ELSE SoldAsVacant
		END

------------------------------------
------------------------------------

----remove duplicates, although it is not standard practice unless its a temp table
--SELECT *,
--	ROW_NUMBER() OVER(
--	PARTITION BY ParcelID,
--				 PropertyAddress,
--				 SalePrice,
--				 SaleDate,
--				 LegalReference
--				 ORDER BY 
--					UniqueID
--					) row_num
--FROM NashvilleHousing
--The above code should be placed in a cte so you can query from it easily

SELECT  ParcelID
FROM NashvilleHousing