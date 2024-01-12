/*

DATA Cleaning in SQL Queries

*/


SELECT *
FROM project.dbo.NashvilleHousing
;

-------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Standardize Date format



	SELECT SaleDate, CONVERT(date,saledate)
	FROM project.dbo.NashvilleHousing
	;

	UPDATE project.dbo.NashvilleHousing
	SET SaleDate = CONVERT(date,saledate);

	ALTER TABLE project.dbo.NashvilleHousing
	ADD SaleDateConverted Date;


	UPDATE project.dbo.NashvilleHousing
	SET SaleDateConverted = CONVERT(date,saledate);


	SELECT SaleDateConverted
	FROM project.dbo.NashvilleHousing;




-------------------------------------------------------------------------------------------------------------------------------------------------------------

--  Populate Property Address Date

	SELECT NH1.ParcelID, NH1.PropertyAddress, NH2.ParcelID, NH2.PropertyAddress, ISNULL(NH1.PropertyAddress,NH2.PropertyAddress)
	FROM project.dbo.NashvilleHousing NH1
	JOIN project.dbo.NashvilleHousing NH2
		ON NH1.ParcelID = NH2.ParcelID
	AND NH1.[UniqueID ] <> NH2.[UniqueID ]
	WHERE NH1.PropertyAddress IS NULL
	;

	UPDATE NH1
	SET PropertyAddress = ISNULL(NH1.PropertyAddress,NH2.PropertyAddress)
	FROM project.dbo.NashvilleHousing NH1
	JOIN project.dbo.NashvilleHousing NH2
		ON NH1.ParcelID = NH2.ParcelID
		AND NH1.[UniqueID ] <> NH2.[UniqueID ]
	WHERE NH1.PropertyAddress IS NULL;

	SELECT *
	FROM project.dbo.NashvilleHousing
	WHERE PropertyAddress IS NULL;





------------------------------------------------------------------------------------------------------------------------------------------------------------


--  Breaking Out Address Into Individual Columns (Address, City, State)

	SELECT PropertyAddress,LEN(PropertyAddress)
	FROM project.dbo.NashvilleHousing


	SELECT 
	SUBSTRING(PropertyAddress, 1, CHARINDEX( ',', PropertyAddress)-1) as Address,
	SUBSTRING(PropertyAddress,CHARINDEX(',' , PropertyAddress)+1,LEN(PropertyAddress)) as Address
	FROM project.dbo.NashvilleHousing;


	ALTER TABLE NashvilleHousing
	ADD PropertySplitAddress Nvarchar(255)

	UPDATE NashvilleHousing
	SET PropertySplitAddress = SUBSTRING(PropertyAddress, 1, CHARINDEX( ',', PropertyAddress)-1)
	
	
	ALTER TABLE NashvilleHousing
	ADD PropertySplitCountry Nvarchar(255)

	UPDATE NashvilleHousing
	SET PropertySplitCountry = SUBSTRING(PropertyAddress,CHARINDEX(',' , PropertyAddress)+1,LEN(PropertyAddress))


	SELECT *
	FROM project.dbo.NashvilleHousing;
	

	
		SELECT PARSENAME(REPLACE(OwnerAddress, ',','.'),3),
		PARSENAME(REPLACE(OwnerAddress, ',','.'),2),
		PARSENAME(REPLACE(OwnerAddress, ',','.'),1)
		FROM project.dbo.NashvilleHousing;
	


	ALTER TABLE NashvilleHousing
	ADD OwnerSplitAddress Nvarchar(255);

	UPDATE NashvilleHousing
	SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',','.'),3)
	
	
	ALTER TABLE NashvilleHousing
	ADD OwnerSplitCity Nvarchar(255);

	UPDATE NashvilleHousing
	SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',','.'),2)
	
	ALTER TABLE NashvilleHousing
	ADD OwnerSplitState Nvarchar(255);

	UPDATE NashvilleHousing
	SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',','.'),1)
	
	
	SELECT *
	FROM NashvilleHousing;




	
------------------------------------------------------------------------------------------------------------------------------------------------------------


--  Change Y and N to Yes and No in "Sold as Vacant" field


	SELECT DISTINCT(SoldAsVacant), COUNT(SoldasVacant)
	FROM NashvilleHousing
	GROUP BY SoldAsVacant
	ORDER BY 2


	SELECT SoldAsVacant,
	CASE 
		WHEN SoldAsVacant = 'Y' THEN 'Yes'
			WHEN SoldAsVacant = 'N' THEN 'No'
		ELSE SoldAsVacant
			END
	FROM NashvilleHousing;


	UPDATE NashvilleHousing
	SET SoldAsVacant = CASE 
		WHEN SoldAsVacant = 'Y' THEN 'Yes'
			WHEN SoldAsVacant = 'N' THEN 'No'
		ELSE SoldAsVacant
			END
	FROM NashvilleHousing;



	SELECT DISTINCT(SoldAsVacant)
	FROM NashvilleHousing;



	
------------------------------------------------------------------------------------------------------------------------------------------------------------


--  Remove Duplicates


	WITH row_numcte as (
	SELECT *,
	ROW_NUMBER() OVER (
	PARTITION BY  ParcelID,
				   PropertyAddress,
				   SalePrice,
				   SaleDate,
				   LegalReference
						ORDER BY UniqueID ) row_num	
	FROM NashvilleHousing
	-- ORDER BY ParcelID
	)
	
	SELECT *								--------------- Before this we ran the code "	DELETE FROM row_numcte WHERE row_num > 1	"  along with cte
	FROM row_numcte
	WHERE row_num > 1


	
------------------------------------------------------------------------------------------------------------------------------------------------------------


--  Delete Unused Columns

SELECT * 
FROM NashvilleHousing	

ALTER TABLE NashvilleHousing
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress


ALTER TABLE NashvilleHousing
DROP COLUMN saleDate



