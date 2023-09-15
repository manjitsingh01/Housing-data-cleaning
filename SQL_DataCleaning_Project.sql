Select *
From PortfolioProject.dbo.[Housing Data]

-- Standardizing Date Format

Select saleDateConverted, CONVERT(Date,SaleDate)
From PortfolioProject.dbo.[Housing Data]


Update [Housing Data]
SET SaleDate = CONVERT(Date,SaleDate)

ALTER TABLE [Housing Data]
Add SaleDateConverted Date;

Update [Housing Data]
SET SaleDateConverted = CONVERT(Date,SaleDate)

Select *
From PortfolioProject.dbo.[Housing Data]
--Where PropertyAddress is null
order by ParcelID

Select a.ParcelID, a.PropertyAddress, b.ParcelID, b.PropertyAddress, ISNULL(a.PropertyAddress,b.PropertyAddress)
From PortfolioProject.dbo.[Housing Data] a
JOIN PortfolioProject.dbo.[Housing Data] b
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is null

Update a
SET PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
From PortfolioProject.dbo.[Housing Data] a
JOIN PortfolioProject.dbo.[Housing Data] b
	on a.ParcelID = b.ParcelID
	AND a.[UniqueID ] <> b.[UniqueID ]
Where a.PropertyAddress is null

-- Breaking out Address into Individual Columns (Address, City, State)

Select PropertyAddress
From PortfolioProject.dbo.[Housing Data]

SELECT
SUBSTRING(PropertyAddress, 1, CHARINDEX(',', PropertyAddress) -1 ) as Address
, SUBSTRING(PropertyAddress, CHARINDEX(',', PropertyAddress) + 1 , LEN(PropertyAddress)) as Address

From PortfolioProject.dbo.[Housing Data]

Select *
From PortfolioProject.dbo.[Housing Data]


Select OwnerAddress
From PortfolioProject.dbo.[Housing Data]

Select
PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)
,PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)
,PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)
From PortfolioProject.dbo.[Housing Data]

ALTER TABLE PortfolioProject.dbo.[Housing Data]
Add OwnerSplitAddress Nvarchar(255);

Update PortfolioProject.dbo.[Housing Data]
SET OwnerSplitAddress = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 3)

ALTER TABLE PortfolioProject.dbo.[Housing Data]
Add OwnerSplitCity Nvarchar(255);

Update PortfolioProject.dbo.[Housing Data]
SET OwnerSplitCity = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 2)

ALTER TABLE PortfolioProject.dbo.[Housing Data]
Add OwnerSplitState Nvarchar(255);

Update PortfolioProject.dbo.[Housing Data]
SET OwnerSplitState = PARSENAME(REPLACE(OwnerAddress, ',', '.') , 1)



-- Change Y and N to Yes and No in "Sold as Vacant" field

Select Distinct(SoldAsVacant), Count(SoldAsVacant)
From PortfolioProject.dbo.[Housing Data]
Group by SoldAsVacant
order by 2

Select SoldAsVacant
, CASE When SoldAsVacant = 'Y' THEN 'Yes'
	   When SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END
From PortfolioProject.dbo.[Housing Data]


Update PortfolioProject.dbo.[Housing Data]
SET SoldAsVacant = CASE When SoldAsVacant = 'Y' THEN 'Yes'
	   When SoldAsVacant = 'N' THEN 'No'
	   ELSE SoldAsVacant
	   END

-- Removing Duplicates

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

From PortfolioProject.dbo.[Housing Data]
)
Select *
From RowNumCTE
Where row_num > 1
Order by PropertyAddress

Select *
From PortfolioProject.dbo.[Housing Data]

-- Deleting Unused Columns

Select *
From PortfolioProject.dbo.[Housing Data]

ALTER TABLE PortfolioProject.dbo.[Housing Data]
DROP COLUMN OwnerAddress, TaxDistrict, PropertyAddress, SaleDate
