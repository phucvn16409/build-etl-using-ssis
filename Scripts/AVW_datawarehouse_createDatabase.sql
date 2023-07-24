CREATE DATABASE AVW_DW
go
USE AVW_DW
go


CREATE TABLE Dim_Year
(
    YearKey NVARCHAR(4) PRIMARY KEY NOT NULL,
    Year INT NOT NULL,
    IsDeleted BIT
        DEFAULT 0,
)

CREATE TABLE Dim_Month
(
    MonthKey NVARCHAR(6) PRIMARY KEY NOT NULL,
    YearKey NVARCHAR(4) NOT NULL,
    Month INT NOT NULL,
    IsDeleted BIT
        DEFAULT 0,
    CONSTRAINT FK_Dim_Month_Dim_Year
        FOREIGN KEY (YearKey)
        REFERENCES Dim_year (YearKey)
)

CREATE TABLE Dim_Date
(
    DateKey NVARCHAR(8) PRIMARY KEY NOT NULL,
    MonthKey NVARCHAR(6) NOT NULL,
    DATE DATE NOT NULL,
    IsDeleted BIT
        DEFAULT 0,
    CONSTRAINT FK_Dim_Date_Dim_Month
        FOREIGN KEY (MonthKey)
        REFERENCES Dim_Month (MonthKey)
)

CREATE TABLE Dim_ProductCategory
(
    ProductCategoryKey INT IDENTITY(1, 1) PRIMARY KEY NOT NULL,
    ProductCategoryId INT NOT NULL,
    Name NVARCHAR(50) NOT NULL,
    IsDeleted BIT
        DEFAULT 0
)

CREATE TABLE Dim_ProductSubCategory
(
    ProductSubCategoryKey INT IDENTITY(1, 1) PRIMARY KEY NOT NULL,
    ProductSubCategoryId INT NOT NULL,
    Name NVARCHAR(50) NOT NULL,
    ProductCategoryKey INT NOT NULL,
    IsDeleted BIT
        DEFAULT 0,
        CONSTRAINT FK_Dim_ProductCategory_Dim_ProductSubCategory
        FOREIGN KEY (ProductCategoryKey) REFERENCES Dim_ProductCategory (ProductCategoryKey)
)


CREATE TABLE Dim_Product
(
    ProductKey INT IDENTITY(1, 1) PRIMARY KEY NOT NULL,
    Name NVARCHAR(50) NOT NULL,
    ProductNumber NVARCHAR(25) NOT NULL,
    StandardCost MONEY NOT NULL,
    ListPrice MONEY NOT NULL,
    Weight DECIMAL(8, 2) NULL,
    ProductSubCategoryKey INT NULL,
    ProductId INT NULL,
    IsDeleted BIT
        DEFAULT 0,
    CONSTRAINT FK_Dim_Product_Dim_ProductSubCat
        FOREIGN KEY (ProductSubCategoryKey)
        REFERENCES Dim_ProductSubCategory (ProductSubCategoryKey)
)


CREATE TABLE Dim_SalesPerson
(
    SalePersonKey INT IDENTITY(1, 1) PRIMARY KEY NOT NULL,
    SalePersonId INT NOT NULL,
    FullName NVARCHAR(500) NOT NULL,
    NationalIDNumber NVARCHAR(15) NOT NULL,
    Gender NCHAR(1) NOT NULL,
    HireDate DATE NOT NULL,
    IsDeleted BIT
        DEFAULT 0
)

CREATE TABLE Dim_Territory
(
    TerritoryKey INT IDENTITY(1, 1) PRIMARY KEY NOT NULL,
    TerritoryId INT NOT NULL,
    Name NVARCHAR(50) NOT NULL,
    ContryRegionCode NVARCHAR(3) NOT NULL,
    IsDeleted BIT
        DEFAULT 0
)

CREATE TABLE Fact_Product
(
    Id INT IDENTITY(1, 1) PRIMARY KEY NOT NULL,
    DateKey NVARCHAR(8) NOT NULL,
    TerritoryKey INT NULL,
    ProductKey INT NOT NULL,
    Qty INT NOT NULL,
    IsDeleted BIT
        DEFAULT 0,
    CONSTRAINT FK_Fact_Product_Dim_Date
        FOREIGN KEY (DateKey)
        REFERENCES Dim_Date (DateKey),
    CONSTRAINT FK_Fact_Product_Dim_Product
        FOREIGN KEY (ProductKey)
        REFERENCES Dim_Product (ProductKey),
    CONSTRAINT FK_Fact_Product_Dim_Territory
        FOREIGN KEY (TerritoryKey)
        REFERENCES dim_Territory (TerritoryKey)
)

CREATE TABLE Fact_SalesOrder
(
    Id INT IDENTITY(1, 1) PRIMARY KEY NOT NULL,
    DateKey NVARCHAR(8) NOT NULL,
    TerritoryKey INT NULL,
    SalePersonKey INT NULL,
    Revenue DECIMAL(18, 4) NOT NULL,
    NumberOrder INT NOT NULL,
    IsDeleted BIT
        DEFAULT 0,
    CONSTRAINT FK_Fact_SalesOrder_Dim_Date
        FOREIGN KEY (DateKey)
        REFERENCES Dim_Date (DateKey),
    CONSTRAINT FK_Fact_SalesOrder_Dim_Territory
        FOREIGN KEY (TerritoryKey)
        REFERENCES Dim_Territory (TerritoryKey),
    CONSTRAINT FK_Fact_SalesOrder_Dim_SalePerson
        FOREIGN KEY (SalePersonKey)
        REFERENCES Dim_SalesPerson (SalePersonKey)
)


CREATE TABLE Update_IsDeleted_FactProduct
(
    ProductKey INT
)
