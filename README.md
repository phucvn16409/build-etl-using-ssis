# Build an ETL pipeline using SSIS
This project provides a starting point for building an ETL pipeline using SQL Server Integration Services (SSIS) in Visual Studio 2019.
# Goal
The primary goal of the project is to provide a basic solution for anyone who is building a new ETL pipeline using SSIS.
# Prerequisites
* Visual Studio 2019 installed. Note Visual Studio 2017 works slightly different regarding SSIS and this article may not work exactly for Visual Studio 2017.
* <a href="https://www.mssqltips.com/sqlservertip/6481/install-sql-server-integration-services-in-visual-studio-2019/">Install SQL Server Integration Services in Visual Studio 2019 </a>
* SQL Server already installed.
* SQL Server Management Studio (SSMS) installed
* The data source is the database of AdventureWorks 2019. <a href="https://github.com/Microsoft/sql-server-samples/releases/download/adventureworks/AdventureWorks2019.bak">`Download here`
# Overview
The dataset represents a sample dataset for a bicycle company. Our objective is to design and implement an ETL solution to generate sales reports per employee, sales reports by region, reports on the number of orders by employee, reports on the number of orders by region, reports on sales by product subcategory, and reports on sales by product and region.
<br><br><i> Overview - ETL Architecture Design </i>
<img width=100% src="Images/ETL-process.svg">
 # First-time ETL 
Build a staging area, design a data warehouse architecture, and create an SSIS package to extract, transform, and load data from the source into the data warehouse.<br><br><i> Overview - First-time ETL process </i> <p align="left"><img width=100% src="Images/overview_etlfirsttime1.jpg"></p>
1. <a href="https://learn.microsoft.com/en-us/sql/samples/adventureworks-install-configure?view=sql-server-ver16&tabs=ssms#tabpanel_1_ssms)">Import source data into SQL Server Management Studio (SSMS)</a>
2. Design a data warehouse architecture to serve reports for the above-mentioned overview section  <p align="left"><img width=100% src="Images/database.diagrams.jpg"></p>
3. Create a data warehouse database in SQL Server <a href="./Scripts/AVW_datawarehouse_createDatabase.sql">`Scripts` </a>
4. Create a staging area database in SQL Server  <a href="./Scripts/AVW_staging_createDatabase.sql">`Scripts` </a>
5. Extract data from the source into the staging area <p align="left"><img width=100% src="Images/extractDataSource.jpg"></p>
6. Transform data in the staging area into dimension and fact tables and save it in the staging area <p align="left"><img width=100% src="Images/transformsData.jpg"></p>
7. Load dimension tables level 1 from the staging area into the data warehouse <p align="center"><img width=100% src="Images/load_DimLevel1.jpg"></p>
8. Load dimension tables level 2 from the staging area into the data warehouse <p align="center"><img width=100% src="Images/load_DimLevel2.jpg"></p>
9. Load dimension tables level 3 from the staging area into the data warehouse <p align="center"><img width=100% src="Images/load_DimLevel3.jpg"></p>
10. Load fact SalesOrder tables from the staging area into the data warehouse <p align="center"><img width=100% src="Images/load_FactSalesOrder.jpg"></p>
11. Load fact Product tables from the staging area into the data warehouse <p align="center"><img width=100% src="Images/load_FactProduct.jpg"></p>
12. Execute the truncate table command on the dimension and fact tables in the staging area to prepare for the subsequent ETL processes <p align="center"><img width=100% src="Images/truncate_dim_fact_staging.jpg"></p>

# Next-time ETL
From the source data, only extract the newly added, updated or deleted data to perform the ETL process
## Solution Idea
* <b>New and updated records:</b> use `Slowly Changing Dimension` and `Lookup Transformation` to compare the data from the source with the data saved to the staging area previously <br>
<i>!Tips: You should refer to the articles below to understand how to use `Slowly Changing Dimension` and `Lookup Transformation`</i><br>
<a href="https://sqlgiant.wordpress.com/2012/03/18/slowly-changing-dimension-type-1-with-lookup-and-conditional-split/">Slowly Changing Dimension with Lookup and Conditional Split </a><br>
<a href="https://sqlgiant.wordpress.com/2012/03/21/an-alternative-to-the-ole-db-command-to-update-slowly-changing-dimensions/">An Alternative to the OLE DB Command to update Slowly Changing Dimensions </a>
* <b> Deleted records:</b> In the design of the staging area and the data warehouse for the first time, the tables will include an "IsDeleted" column with a default value of 0. Before extracting data from the source, we will update the "IsDeleted" column to a value of 1 for the corresponding rows. During the data extraction process, we will update the "IsDeleted" values to 0 for the rows that satisfy the conditions, matching the IDs between the source data and the previously retrieved staging area. By doing this, the records with a value of 1 in the "IsDeleted" column will represent the deleted records in the source data.
<br><br><i> Overview - Next-time ETL process </i> <p align="left"><img width=100% src="Images/overview_etlnexttime.jpg"></p>
## Tasks
1. Update the "IsDeleted" column in Staging area to 1 for corresponding rows before extracting data from the source.<p align="left"><img width=100% src="Images/Updated_Stag_IsDeleted_1.jpg"></p>
2. Extract the newly added, updated or deleted data from the source into the staging <br><p>Using `Slowly Changing Dimension` 
for tables with small data</p>
Retrieve data from the source and split it into two streams. The first stream will utilize Slowly Changing Dimensions (SCDs) to add new records (those with distinct IDs compared to the ones already present in the Staging area) and update existing data with records having the same IDs but different information in the remaining fields. On the other hand, the second stream will focus on updating the IsDeleted column to zero for records whose IDs from the source match the IDs of the records in the staging area <p align="left"><img width=100% src="Images/scds.jpg"></p>
<br><p>Using `Lookup Transformation` for tables with large data</p>
Retrieve the data from the source and divide it into two streams. The initial stream will employ a Lookup on the IDs column to identify records with IDs originating from a different source than those in the Staging area. These new records will be added accordingly. For records with identical IDs, utilize an additional lookup block to update the modified data in the remaining fields.<br>
The second stream will solely extract the IDs column from the source and store them in the 'Updated_IsDelete_nameTable' table within the Staging area. This process will facilitate a subsequent bulk update on the IsDeleted column of the corresponding tables. <p align="left"><img width=100% src="Images/lookup.jpg"></p>
3. Utilize the 'Execute SQL Task' block to update the IsDeleted column with a value of 0 in the corresponding tables (Person, OrderHeader, and OrderDetail tables). This update will occur when the records' IDs in the corresponding tables match the IDs in the 'Update_IsDelete_nameTable' table, which were obtained in the task mentioned earlier. Once the previous tasks are completed, you can add an additional "Execute SQL Task" block to truncate the 'Update_IsDelete_nameTable' table to prepare it for reuse in the next ETL <p align="left"><img width=100% src="Images/Updated_Stag_IsDeleted_0.jpg"></p>
4. Delete records whose value in column IsDeleted is equal to 1 in the staging area of ​​each respective table <p align="left"><img width=100% src="Images/Deleted_Stag_IsDeleted_1.jpg"></p>
5. Transform data in the staging area into dimension and fact tables and save it in the staging area <p align="left"><img width=100% src="Images/transformsData.jpg"></p>
6. Update the "IsDeleted" column to 1 for the corresponding rows in both the Dimension and Fact tables in the data warehouse, following the same concept as in the staging area  <p align="left"><img width=100% src="Images/Updated_DW_IsDeleted_1.jpg"></p>
7. Load the newly added, updated or deleted data of the Dimension and Fact table from the staging into the data warehouse are by using `Slowly Changing Dimension` and `Lookup Transformation` and update "IsDeleted" values to 0 for rows that meet the conditions, matching IDs between the staging and previously loaded data warehouse, following the same concept as in step 2, 3. <br><i>Note! We will not use the "hard delete" technique like step 4, but only implement the "soft delete" technique in the data warehouse </i><br>
<br><i> Load dimension tables level 1 </i> <p align="left"><img width=100% src="Images/dimLV1.jpg"></p>
<br><i> Load dimension tables level 2 </i> <p align="left"><img width=100% src="Images/dimLV2.jpg"></p>
<br><i> Load dimension tables level 3 </i> <p align="left"><img width=100% src="Images/dimLV3.jpg"></p>
<br><i> Load fact SalesOrder tables </i> <p align="left"><img width=100% src="Images/factSalesOrder.jpg"></p>
<br><i> Load fact Product tables </i> <p align="left"><img width=100% src="Images/factProduct.jpg"></p>
<br><i> Update the IsDeleted column with a value of 0 in the corresponding tables and truncate Update_IsDeleted_nameTable in DW after the update is complete </i> <p align="left"><img width=100% src="Images/Updated_DW_FactProduct.jpg"></p>
8. Execute the truncate table command on the dimension and fact tables in the staging area to prepare for the subsequent ETL processes, following the same concept as in step 12 of First-time ETL 

-----------------------------------
!!! I HAVE PLACED ALL THE CODE FOR SSIS IN THE PACKAGE SECTION `Package-SSIS` <br>
If you have any questions about the code or encounter any issues while creating your ETL flow, please do not hesitate to contact me via email. Thank you.


  
