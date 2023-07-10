# Build an ETL pipeline using SSIS
This project provides a starting point for building an ETL pipeline using SQL Server Integration Services (SSIS) in Visual Studio 2019.
# Goal
The primary goal of the project is to provide a basic solution for anyone who is building a new ETL pipeline using SSIS.
# Prerequisites
* Visual Studio 2019 installed. Note Visual Studio 2017 works slightly different regarding SSIS and this article may not work exactly for Visual Studio 2017.
* Install SQL Server Integration Services in Visual Studio 2019 (https://www.mssqltips.com/sqlservertip/6481/install-sql-server-integration-services-in-visual-studio-2019/)
* SQL Server already installed.
# First-time ETL 
Build a staging area, design a data warehouse architecture, and create an SSIS package to extract, transform, and load data from the source into the data warehouse.
1. <a href="./DataSource">Download source data for practice </a>
2. Design a data warehouse architecture <p align="center"><img width="500" src="Images/Fig1.jpg"></p>
3. Create a data warehouse database in SQL Server <a href="./DataSource/#">`Scripts` </a>
4. Create a staging area database in SQL Server  <a href="./DataSource/#">`Scripts` </a>
5. Extract data from the source into the staging area <p align="center"><img width="500" src="Images/Fig1.jpg"></p>
6. Transform data in the staging area into dimension and fact tables and save it in the staging area <p align="center"><img width="500" src="Images/Fig1.jpg"></p>
7. Load dimension tables level 1 from the staging area into the data warehouse <p align="center"><img width="500" src="Images/Fig1.jpg"></p>
8. Load dimension tables level 2 from the staging area into the data warehouse <p align="center"><img width="500" src="Images/Fig1.jpg"></p>
9. Load dimension tables level 3 from the staging area into the data warehouse <p align="center"><img width="500" src="Images/Fig1.jpg"></p>
10. Load fact tables from the staging area into the data warehouse <p align="center"><img width="500" src="Images/Fig1.jpg"></p>
11. Execute the truncate table command on the dimension and fact tables in the staging area to prepare for the subsequent ETL processes

# Next-time ETL
From the source data, only extract the newly added, updated or deleted data to perform the ETL process
## Solution Idea
* <b>New and updated records:</b> use `Slowly Changing Dimension` to compare the data from the source with the data saved to the staging area previously
* <b> Deleted records:</b> In the design of the staging area and the data warehouse for the first time, the tables will include an "IsDeleted" column with a default value of 0. Before extracting data from the source, we will update the "IsDeleted" column to a value of 1 for the corresponding rows. During the data extraction process, we will update the "IsDeleted" values to 0 for the rows that satisfy the conditions, matching the IDs between the source data and the previously retrieved staging area. By doing this, the records with a value of 1 in the "IsDeleted" column will represent the deleted records in the source data.
## Tasks
1. Update the "IsDeleted" column to 1 for corresponding rows before extracting data from the source.<p align="center"><img width="500" src="Images/Fig1.jpg"></p>
2. Extract the newly added, updated or deleted data from the source into the staging are by using `Slowly Changing Dimension` and update "IsDeleted" values to 0 for rows that meet the conditions, matching IDs between the source data and previously retrieved staging area.<p align="center"><img width="500" src="Images/Fig1.jpg"></p>
3. Delete records whose value in column IsDeleted is equal to 1 in the staging area of ​​each respective table <p align="center"><img width="500" src="Images/Fig1.jpg"></p>
4. Transform data in the staging area into dimension and fact tables and save it in the staging area <p align="center"><img width="500" src="Images/Fig1.jpg"></p>
5. Update the "IsDeleted" column to 1 for the corresponding rows in both the Dimension and Fact tables in the data warehouse, following the same concept as in the staging area  <p align="center"><img width="500" src="Images/Fig1.jpg"></p>
6. Load the newly added, updated or deleted data of the Dimension and Fact table from the staging into the data warehouse are by using `Slowly Changing Dimension` and update "IsDeleted" values to 0 for rows that meet the conditions, matching IDs between the staging and previously loaded data warehouse. <p align="center"><img width="500" src="Images/Fig1.jpg"></p>
7. Execute the truncate table command on the dimension and fact tables in the staging area to prepare for the subsequent ETL processes



  
