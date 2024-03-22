--Data cleaning in SQL

select * from PortfolioProject.dbo.[Nashville Housing];

--Check if we need to Standardize date format

select SaleDate from PortfolioProject.[dbo].[Nashville Housing];

--It is already in correct format.
--If it shows along with time, use the following code
--Alter table Nashville Housing
--Add saledateconverted Date
--
--update Nashville Housing
--SET saledateconverted = convert(Date,SaleDate)

--or
--Alter Table Nashville Housing
--Alter column SaleDate Date

--Populate Property Address Data

select PropertyAddress 
from PortfolioProject.[dbo].[Nashville Housing];

select PropertyAddress 
from PortfolioProject.[dbo].[Nashville Housing]
where PropertyAddress is null;

select *
from PortfolioProject.[dbo].[Nashville Housing]
--where PropertyAddress is null
order by ParcelID;

select a.ParcelID,a.PropertyAddress,b.ParcelID,b.PropertyAddress, ISNULL(a.PropertyAddress,b.PropertyAddress)
from PortfolioProject.[dbo].[Nashville Housing] a
Join PortfolioProject.[dbo].[Nashville Housing] b
    on a.ParcelID = b.ParcelID
	and a.UniqueID <> b.UniqueID
where a.PropertyAddress is Null;

Update a
SET PropertyAddress = ISNULL(a.PropertyAddress,b.PropertyAddress)
from PortfolioProject.[dbo].[Nashville Housing] a
Join PortfolioProject.[dbo].[Nashville Housing] b
    on a.ParcelID = b.ParcelID
	and a.UniqueID <> b.UniqueID
where a.PropertyAddress is Null;

--Breaking out address into individual columns(Address,city,state)


select PropertyAddress
from PortfolioProject.[dbo].[Nashville Housing]
;

Select
SUBSTRING(PropertyAddress,1, CHARINDEX(',',PropertyAddress)-1) as Address,
SUBSTRING(PropertyAddress, CHARINDEX(',',PropertyAddress)+1,LEN(PropertyAddress)) as Address
from PortfolioProject.[dbo].[Nashville Housing]

ALTER TABLE [Nashville Housing]
Add Propertysplitaddress Nvarchar(255)

Update [Nashville Housing]
SET Propertysplitaddress = SUBSTRING(PropertyAddress,1, CHARINDEX(',',PropertyAddress)-1)

ALTER TABLE [Nashville Housing]
Add Propertysplitcity Nvarchar(255)


Update [Nashville Housing]
SET Propertysplitcity = SUBSTRING(PropertyAddress, CHARINDEX(',',PropertyAddress)+1,LEN(PropertyAddress))


select * from PortfolioProject.[dbo].[Nashville Housing];

select OwnerAddress from PortfolioProject.[dbo].[Nashville Housing];

select
PARSENAME(Replace(OwnerAddress,',','.'),3),
PARSENAME(Replace(OwnerAddress,',','.'),2),
PARSENAME(Replace(OwnerAddress,',','.'),1)
from PortfolioProject.[dbo].[Nashville Housing];

Alter Table [Nashville Housing]
Add OwnerSplitAddress Nvarchar(255)

Update  [Nashville Housing]
SET OwnerSplitAddress = PARSENAME(Replace(OwnerAddress,',','.'),3)

Alter Table [Nashville Housing]
Add OwnerSplitCity Nvarchar(255)

Update  [Nashville Housing]
SET OwnerSplitCity = PARSENAME(Replace(OwnerAddress,',','.'),2)


Alter Table [Nashville Housing]
Add OwnerSplitState Nvarchar(255)


Update  [Nashville Housing]
SET OwnerSplitState = PARSENAME(Replace(OwnerAddress,',','.'),1)

select * from PortfolioProject.[dbo].[Nashville Housing];


--SoldAsVacant(If it is having "Y", "N", "yes","No" , how to change it into "Yes" and "No" 
--as the count is high for Yes and No instead of Y and N
--In my dataset, it is 0 and 1 with 51802 "0" and 4675 "1"



select Distinct(SoldAsVacant)
from PortfolioProject.[dbo].[Nashville Housing];

select Distinct(SoldAsVacant),count(SoldAsVacant)
from PortfolioProject.[dbo].[Nashville Housing]
Group by SoldAsVacant
Order by 2;

--Including the code to change if required

--select SoldAsVacant, CASE when SoldAsVacant = 'Y' then 'Yes'
--------------------------- when SoldAsVacant = 'N' then 'No'
--------------------------- Else SoldAsVacant
--------------------------- End
--from PortfolioProject.[dbo].[Nashville Housing];

--Update [Nashville Housing]
--Set SoldAsVacant =CASE when SoldAsVacant = 'Y' then 'Yes'
--------------------------- when SoldAsVacant = 'N' then 'No'
--------------------------- Else SoldAsVacant
--------------------------- End

select Distinct(SoldAsVacant),count(SoldAsVacant)
from PortfolioProject.[dbo].[Nashville Housing]
Group by SoldAsVacant
Order by 2;

--Remove Duplicates


--Check for Duplicates

With RowNumCTE as(
select * ,
    ROW_NUMBER() over(
	Partition by ParcelID,
	             PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 Order by UniqueId
				 ) row_num

from PortfolioProject.[dbo].[Nashville Housing]
--order by ParcelID
)
select * from RowNumCTE
where row_num >1
order by PropertyAddress;


--Remove these duplicates
With RowNumCTE as(
select * ,
    ROW_NUMBER() over(
	Partition by ParcelID,
	             PropertyAddress,
				 SalePrice,
				 SaleDate,
				 LegalReference
				 Order by UniqueId
				 ) row_num

from PortfolioProject.[dbo].[Nashville Housing]
--order by ParcelID
)
Delete from RowNumCTE
where row_num >1
;



--Delete unused columns

select * 
from PortfolioProject.[dbo].[Nashville Housing]

Alter Table PortfolioProject.[dbo].[Nashville Housing]
Drop Column PropertyAddress, OwnerAddress, TaxDistrict;


--I accidentally dropped SaleDate column based on the video but we didn't convert it into SaleDateConverted, so we need this column
--Alter Table PortfolioProject.[dbo].[Nashville Housing]
--Drop Column SaleDate;

