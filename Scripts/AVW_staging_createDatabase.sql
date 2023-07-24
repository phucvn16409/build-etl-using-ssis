CREATE DATABASE AVW_Staging
go
USE AVW_Staging
go


CREATE TABLE Person
(
    BusinessEntityID INT PRIMARY KEY NOT NULL,
    Title NVARCHAR(8) NULL,
    FirstName NVARCHAR(50) NOT NULL,
    MiddleName NVARCHAR(50) NULL,
    LastName NVARCHAR(50) NOT NULL,
    IsDeleted BIT
        DEFAULT 0
)

CREATE TABLE Product
(
    ProductID INT PRIMARY KEY NOT NULL,
    Name NVARCHAR(50) NOT NULL,
    ProductNumber NVARCHAR(25) NOT NULL,
    StandardCost MONEY NOT NULL,
    ListPrice MONEY NOT NULL,
    Weight DECIMAL(8, 2) NULL,
    ProductSubcategoryID INT NULL,
    IsDeleted BIT
        DEFAULT 0
)


CREATE TABLE Employee
(
    BusinessEntityID INT PRIMARY KEY NOT NULL,
    NationalIDNumber NVARCHAR(15) NOT NULL,
    Gender NCHAR(1) NOT NULL,
    HireDate DATE NOT NULL,
    IsDeleted BIT
        DEFAULT 0
)

CREATE TABLE OrderHeader
(
    SalesOrderID INT PRIMARY KEY,
    OrderDate DATETIME NOT NULL,
    TerritoryID INT NULL,
    TotalDue MONEY NOT NULL,
    Status TINYINT NOT NULL,
    SalesPersonID INT NULL,
    IsDeleted BIT
        DEFAULT 0
)

CREATE TABLE OrderDetail
(
    SalesOrderID INT NOT NULL,
    SalesOrderDetailID INT NOT NULL,
    OrderQty SMALLINT NOT NULL,
    ProductID INT NOT NULL,
    IsDeleted BIT
        DEFAULT 0
        CONSTRAINT PK_SalesOrderDetail_SalesOrderID_SalesOrderDetailID
        PRIMARY KEY (
                        SalesOrderID,
                        SalesOrderDetailID
                    )
)


CREATE TABLE Territory
(
    TerritoryId INT PRIMARY KEY NOT NULL,
    Name NVARCHAR(50) NOT NULL,
    ContryRegionCode NVARCHAR(3) NOT NULL,
    IsDeleted BIT
        DEFAULT 0
)

CREATE TABLE ProductSubCategory
(
    ProductSubCategoryId INT PRIMARY KEY NOT NULL,
    Name NVARCHAR(50) NOT NULL,
    ProductCategoryId INT NOT NULL,
    IsDeleted BIT
        DEFAULT 0
)


CREATE TABLE ProductCategory
(
    ProductCategoryId INT PRIMARY KEY NOT NULL,
    Name NVARCHAR(50) NOT NULL,
    IsDeleted BIT
        DEFAULT 0
)


CREATE TABLE Dim_Territory
(
    TerritoryId INT NOT NULL,
    Name NVARCHAR(50) NOT NULL,
    ContryRegionCode NVARCHAR(3) NOT NULL
)


CREATE TABLE Dim_ProductCategory
(
    ProductCategoryId INT NOT NULL,
    Name NVARCHAR(50) NOT NULL
)

CREATE TABLE Dim_ProductSubCategory
(
    ProductSubCategoryId INT NOT NULL,
    Name NVARCHAR(50) NOT NULL,
    ProductCategoryKey INT NOT NULL
)


CREATE TABLE Dim_Product
(
    Name NVARCHAR(50) NOT NULL,
    ProductNumber NVARCHAR(25) NOT NULL,
    StandardCost MONEY NOT NULL,
    ListPrice MONEY NOT NULL,
    Weight DECIMAL(8, 2) NULL,
    ProductSubCategoryKey INT NOT NULL,
    ProductId INT NULL,
)


CREATE TABLE Dim_Date
(
    OrderDate DATE,
    Month INT,
    Year INT
)

CREATE TABLE Dim_SalesPerson
(
    SalePersonId INT NOT NULL,
    FullName NVARCHAR(306) NOT NULL,
    NationalIDNumber NVARCHAR(15) NOT NULL,
    Gender NCHAR(1) NOT NULL,
    HireDate DATE NOT NULL,
)

CREATE TABLE Fact_SalesOrder
(
    OrderDate DATE,
    SalePersonId INT,
    TerritoryID INT,
    Revenue DECIMAL(18, 2),
    NumberOrder INT
)

CREATE TABLE Fact_Product
(
    OrderDate DATE,
    TerritoryID INT,
    ProductID INT,
    Qty INT
)

CREATE TABLE Update_IsDeleted_OrderHeader
(
    SalesOrderID INT 
)

CREATE TABLE Update_IsDeleted_OrderDetail
(
    SalesOrderDetailID INT 
)

CREATE TABLE Update_IsDeleted_Person
(
    BusinessEntityID INT 
)
