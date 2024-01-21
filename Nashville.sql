///....

Select *
from PortfolioProject.dbo.Nashville Housing Data

/*

Cleaning Data in SQL Queries

*/

Select *
FROM [PortfolioProj].[dbo].[Nashville Housing Data]

--------------------------------------------------------------------------------------------------------------------------

-- Standardize Date Format


Select SaleDateConverted, CONVERT(Date,SaleDateConverted)
FROM [PortfolioProj].[dbo].[Nashville Housing Data]


Update [PortfolioProj].[dbo].[Nashville Housing Data]
SET SaleDateConverted = CONVERT(Date,SaleDateConverted)

-- If it doesn't Update properly

ALTER TABLE [PortfolioProj].[dbo].[Nashville Housing Data]
Add SaleDateConverted Date;

Update [PortfolioProj].[dbo].[Nashville Housing Data]
SET SaleDateConverted = CONVERT(Date,SaleDateConverted)

-- Assuming you want to rename 'SaleDateConverted' to 'SaleDate'
EXEC sp_rename [PortfolioProj].[dbo].[Nashville Housing Data], 'SaleDateConverted', 'SaleDate';


ALTER TABLE [PortfolioProj].[dbo].[Nashville Housing Data]
RENAME SaleDateConverted TO SaleDate, DATE

 --------------------------------------------------------------------------------------------------------------------------
--------------------------------------------------------------------------------------------------------------------------

-- Populate Property Address data

Select *
From [PortfolioProj].[dbo].[Nashville Housing Data]
--Where PropertyAddress is null
order by ParcelID



Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress,b.PropertyAddress)
From [PortfolioProj].[dbo].[Nashville Housing Data] a
JOIN [PortfolioProj].[dbo].[Nashville Housing Data] b
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is null


Update a
SET PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
From [PortfolioProj].[dbo].[Nashville Housing Data] a
JOIN [PortfolioProj].[dbo].[Nashville Housing Data] b
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is null

--------------------------------------------------------------------------------------------------------------------------

-- Breaking out Address into Individual Columns (Address, City, State)


Select PropertyAddress
From [PortfolioProj].[dbo].[Nashville Housing Data]
--Where PropertyAddress is null
--order by ParcelID

SELECT
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 ) as Address
, SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1 , LEN(PropertyAddress)) as Address

From [PortfolioProj].[dbo].[Nashville Housing Data]


--ALTER TABLE [Nashville Housing Data]
--Add PropertySplitAddress Nvarchar(255);

Update [Nashville Housing Data]
SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 )


--ALTER TABLE [Nashville Housing Data]
--Add PropertySplitCity Nvarchar(255);

Update [Nashville Housing Data]
SET PropertySplitCity = SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1 , LEN(PropertyAddress))



Select *
From [PortfolioProj].[dbo].[Nashville Housing Data]


Select OwnerAddress
From [PortfolioProj].[dbo].[Nashville Housing Data]


Select
PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)
,PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)
,PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)
From [PortfolioProj].[dbo].[Nashville Housing Data]



--ALTER TABLE [Nashville Housing Data]
--Add OwnerSplitAddress Nvarchar(255);

Update [Nashville Housing Data]
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', ',') , 3)

--ALTER TABLE [Nashville Housing Data]
--Add OwnerSplitCity Nvarchar(255);

Update [Nashville Housing Data]
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)


--ALTER TABLE [Nashville Housing Data]
--Add OwnerSplitState Nvarchar(255);

Update [Nashville Housing Data]
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)



Select *
From [PortfolioProj].[dbo].[Nashville Housing Data]


Select OwnerAddress
From [PortfolioProj].[dbo].[Nashville Housing Data]


Select
PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)
,PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)
,PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)
From [PortfolioProj].[dbo].[Nashville Housing Data]


--ALTER TABLE [Nashville Housing Data]
--Add OwnerSplitAddress Nvarchar(255);

Update [Nashville Housing Data]
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)


--ALTER TABLE NashvilleHousing
--Add OwnerSplitCity Nvarchar(255);

Update [Nashville Housing Data]
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)



--ALTER TABLE [Nashville Housing Data]
--Add OwnerSplitState Nvarchar(255);

Update [Nashville Housing Data]
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)



Select *
From [PortfolioProj].[dbo].[Nashville Housing Data]




--------------------------------------------------------------------------------------------------------------------------


-- Change Y and N to Yes and No in "Sold as Vacant" field


Select Distinct(SoldAsVacant), Count(SoldAsVacant)
From [PortfolioProj].[dbo].[Nashville Housing Data]
Group by SoldAsVacant
order by 2




Select SoldAsVacant
, CASE When SoldAsVacant = 'Y' THEN 'Yes'
	   When SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END
From [PortfolioProj].[dbo].[Nashville Housing Data]

Update [Nashville Housing Data]
SET SoldAsVacant = CASE When SoldAsVacant = 'Y' THEN 'Yes'
	   When SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END






-----------------------------------------------------------------------------------------------------------------------------------------------------------

-- Remove Duplicates

WITH RowNumCTE AS(
Select *,
	ROW_NUMBER() OVER (
	PARTITION BY ParcelID,
				 PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 ORDER BY
					UniqueID
					) row_num

From [PortfolioProj].[dbo].[Nashville Housing Data]
--order by ParcelID
)
Select *
From RowNumCTE
Where row_num > 1
Order by PropertyAddress



Select *
From [PortfolioProj].[dbo].[Nashville Housing Data]



---------------------------------------------------------------------------------------------------------

-- Delete Unused Columns

Select *
From [PortfolioProj].[dbo].[Nashville Housing Data]


--ALTER TABLE [PortfolioProj].[dbo].[Nashville Housing Data]
--DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress, SaleDate















-----------------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------------

--- Importing Data using OPENROWSET and BULK INSERT	

--  More advanced and looks cooler, but have to configure server appropriately to do correctly
--  Wanted to provide this in case you wanted to try it


--sp_configure 'show advanced options', 1;
--RECONFIGURE;
--GO
--sp_configure 'Ad Hoc Distributed Queries', 1;
--RECONFIGURE;
--GO


--USE PortfolioProject 

--GO 

--EXEC master.dbo.sp_MSset_oledb_prop N'Microsoft.ACE.OLEDB.12.0', N'AllowInProcess', 1 

--GO 

--EXEC master.dbo.sp_MSset_oledb_prop N'Microsoft.ACE.OLEDB.12.0', N'DynamicParameters', 1 

--GO 


---- Using BULK INSERT

--USE PortfolioProject;
--GO
--BULK INSERT nashvilleHousing FROM 'C:\Temp\SQL Server Management Studio\Nashville Housing Data for Data Cleaning Project.csv'
--   WITH (
--      FIELDTERMINATOR = ',',
--      ROWTERMINATOR = '\n'
--);
--GO


---- Using OPENROWSET
--USE PortfolioProject;
--GO
--SELECT * INTO nashvilleHousing
--FROM OPENROWSET('Microsoft.ACE.OLEDB.12.0',
--    'Excel 12.0; Database=C:\Users\alexf\OneDrive\Documents\SQL Server Management Studio\Nashville Housing Data for Data Cleaning Project.csv', [Sheet1$]);
--GO



