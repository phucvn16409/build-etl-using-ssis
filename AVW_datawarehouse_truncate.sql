USE AVW_DW
go
CREATE PROCEDURE dw_truncate
AS
BEGIN
    ALTER TABLE Dim_Month DROP CONSTRAINT FK_Dim_Month_Dim_Year
    ALTER TABLE Dim_Date DROP CONSTRAINT FK_Dim_Date_Dim_Month
    ALTER TABLE Dim_ProductSubCategory DROP CONSTRAINT FK_Dim_ProductCategory_Dim_ProductSubCategory
    ALTER TABLE Dim_Product DROP CONSTRAINT FK_Dim_Product_Dim_ProductSubCat
    ALTER TABLE Fact_Product DROP CONSTRAINT FK_Fact_Product_Dim_Date
    ALTER TABLE Fact_Product DROP CONSTRAINT FK_Fact_Product_Dim_Product
    ALTER TABLE Fact_Product DROP CONSTRAINT FK_Fact_Product_Dim_Territory
    ALTER TABLE Fact_SalesOrder DROP CONSTRAINT FK_Fact_SalesOrder_Dim_Date
    ALTER TABLE Fact_SalesOrder DROP CONSTRAINT FK_Fact_SalesOrder_Dim_Territory
    ALTER TABLE Fact_SalesOrder DROP CONSTRAINT FK_Fact_SalesOrder_Dim_SalePerson

    TRUNCATE TABLE Dim_Year
    TRUNCATE TABLE Dim_Month
    TRUNCATE TABLE Dim_Date
    TRUNCATE TABLE Dim_ProductCategory
    TRUNCATE TABLE Dim_ProductSubCategory
    TRUNCATE TABLE Dim_Product
    TRUNCATE TABLE Dim_SalesPerson
    TRUNCATE TABLE Dim_Territory
    TRUNCATE TABLE Fact_Product
    TRUNCATE TABLE Fact_SalesOrder

    ALTER TABLE Dim_Month
    ADD CONSTRAINT FK_Dim_Month_Dim_Year
        FOREIGN KEY (YearKey)
        REFERENCES Dim_year (YearKey)
    ALTER TABLE Dim_Date
    ADD CONSTRAINT FK_Dim_Date_Dim_Month
        FOREIGN KEY (MonthKey)
        REFERENCES Dim_Month (MonthKey)
    ALTER TABLE Dim_ProductSubCategory
    ADD CONSTRAINT FK_Dim_ProductCategory_Dim_ProductSubCategory
        FOREIGN KEY (ProductCategoryKey)
        REFERENCES Dim_ProductCategory (ProductCategoryKey)
    ALTER TABLE Dim_Product
    ADD CONSTRAINT FK_Dim_Product_Dim_ProductSubCat
        FOREIGN KEY (ProductSubCategoryKey)
        REFERENCES Dim_ProductSubCategory (ProductSubCategoryKey)
    ALTER TABLE Fact_Product
    ADD CONSTRAINT FK_Fact_Product_Dim_Date
        FOREIGN KEY (DateKey)
        REFERENCES Dim_Date (DateKey)
    ALTER TABLE Fact_Product
    ADD CONSTRAINT FK_Fact_Product_Dim_Product
        FOREIGN KEY (ProductKey)
        REFERENCES Dim_Product (ProductKey)
    ALTER TABLE Fact_Product
    ADD CONSTRAINT FK_Fact_Product_Dim_Territory
        FOREIGN KEY (TerritoryKey)
        REFERENCES dim_Territory (TerritoryKey)
    ALTER TABLE Fact_SalesOrder
    ADD CONSTRAINT FK_Fact_SalesOrder_Dim_Date
        FOREIGN KEY (DateKey)
        REFERENCES Dim_Date (DateKey)
    ALTER TABLE Fact_SalesOrder
    ADD CONSTRAINT FK_Fact_SalesOrder_Dim_Territory
        FOREIGN KEY (TerritoryKey)
        REFERENCES Dim_Territory (TerritoryKey)
    ALTER TABLE Fact_SalesOrder
    ADD CONSTRAINT FK_Fact_SalesOrder_Dim_SalePerson
        FOREIGN KEY (SalePersonKey)
        REFERENCES Dim_SalesPerson (SalePersonKey)
END

-- EXEC dw_truncate;
