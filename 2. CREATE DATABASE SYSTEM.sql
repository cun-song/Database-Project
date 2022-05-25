CREATE DATABASE FlexPhone
GO
USE FlexPhone
GO

CREATE TABLE MsStaff(
	StaffID CHAR(5) PRIMARY KEY CHECK (StaffID LIKE 'ST[0-9][0-9][0-9]') NOT NULL,
	StaffName  VARCHAR(50)NOT NULL,
	StaffEmail VARCHAR(50) CHECK (StaffEmail LIKE '%@bluejack.com' OR StaffEmail LIKE '%@sunib.edu' ) NOT NULL,
	StaffDOB DATE CHECK (YEAR(StaffDOB) >= 1960) NOT NULL,
	StaffGender VARCHAR(10) CHECK (StaffGender = 'Female' OR StaffGender = 'Male' ) NOT NULL,
	StaffPhoneNumber VARCHAR(20) NOT NULL,
	StaffAddress VARCHAR (150) NOT NULL,
	StaffSalary INT NOT NULL,
)

CREATE TABLE MsVendor(
	VendorID CHAR(5) PRIMARY KEY CHECK (VendorID LIKE 'VE[0-9][0-9][0-9]') NOT NULL,
	VendorName  VARCHAR(50)NOT NULL,
	VendorEmail VARCHAR(50) CHECK (VendorEmail LIKE '%@bluejack.com' OR VendorEmail LIKE '%@sunib.edu' ) NOT NULL,
	VendorPhoneNumber VARCHAR(20) NOT NULL,
	VendorAddress VARCHAR (150) NOT NULL,
)

CREATE TABLE MsCustomer(
	CustomerID CHAR(5) PRIMARY KEY CHECK (CustomerID LIKE 'CU[0-9][0-9][0-9]') NOT NULL,
	CustomerName  VARCHAR(50) CHECK (CustomerName LIKE '___%' ) NOT NULL,
	CustomerEmail VARCHAR(50) CHECK (CustomerEmail LIKE '%@bluejack.com' OR CustomerEmail LIKE '%@sunib.edu' ) NOT NULL,
	CustomerDOB DATE NOT NULL,
	CustomerGender VARCHAR (10) CHECK (CustomerGender = 'Female' OR CustomerGender = 'Male' ) NOT NULL,
	CustomerPhoneNumber VARCHAR(20) NOT NULL,
	CustomerAddress VARCHAR (150) NOT NULL,
)

CREATE TABLE MsBrand(
	BrandID CHAR (5) PRIMARY KEY CHECK (BrandID LIKE 'PB[0-9][0-9][0-9]') NOT NULL,
	BrandName VARCHAR (50) NOT NULL,
)

CREATE TABLE MsPhone(
	PhoneID CHAR (5) PRIMARY KEY CHECK (PhoneID LIKE 'PO[0-9][0-9][0-9]') NOT NULL,
	PhoneName VARCHAR (50) NOT NULL,
	PhonePrice INT CHECK(PhonePrice >= 100000 AND PhonePrice <= 40000000 ) NOT NULL,
	BrandID CHAR (5) FOREIGN KEY REFERENCES MsBrand(BrandID) ON UPDATE CASCADE ON DELETE CASCADE NOT NULL,
)

CREATE TABLE TrPurchase(
	PurchaseID CHAR (5) PRIMARY KEY CHECK (PurchaseID LIKE 'PH[0-9][0-9][0-9]') NOT NULL,
	StaffID CHAR (5) FOREIGN KEY REFERENCES MsStaff(StaffID) ON UPDATE CASCADE ON DELETE CASCADE NOT NULL,
	VendorID CHAR (5) FOREIGN KEY REFERENCES MsVendor(VendorID) ON UPDATE CASCADE ON DELETE CASCADE NOT NULL,
	PurchaseDate DATE NOT NULL
)

CREATE TABLE TrPurchaseDetail(
	PurchaseID CHAR (5) FOREIGN KEY REFERENCES TrPurchase(PurchaseID) ON UPDATE CASCADE ON DELETE CASCADE NOT NULL,
	PhoneID CHAR (5) FOREIGN KEY REFERENCES MsPhone(PHoneID) ON UPDATE CASCADE ON DELETE CASCADE NOT NULL,
	PurchaseQuantity INT NOT NULL,
	PRIMARY KEY(PurchaseID, PhoneID)
)


CREATE TABLE TrSales(
	SalesID CHAR (5) PRIMARY KEY CHECK (SalesID LIKE 'SH[0-9][0-9][0-9]') NOT NULL,
	StaffID CHAR (5) FOREIGN KEY REFERENCES MsStaff(StaffID) ON UPDATE CASCADE ON DELETE CASCADE NOT NULL,
	CustomerID CHAR (5) FOREIGN KEY REFERENCES MsCustomer(CustomerID) ON UPDATE CASCADE ON DELETE CASCADE NOT NULL,
	SalesDate DATE NOT NULL
)

CREATE TABLE TrSalesdetail(
	SalesID CHAR (5) FOREIGN KEY REFERENCES TrSales(SalesID) ON UPDATE CASCADE ON DELETE CASCADE NOT NULL,
	PhoneID CHAR (5) FOREIGN KEY REFERENCES MsPhone(PHoneID) ON UPDATE CASCADE ON DELETE CASCADE NOT NULL,
	SalesQuantity INT NOT NULL,
	PRIMARY KEY(SalesID, PhoneID)
)