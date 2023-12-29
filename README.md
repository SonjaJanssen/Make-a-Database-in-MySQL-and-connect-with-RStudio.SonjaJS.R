# Database Setup in MySQL SQL Server with RStudio

## Code Script by Sonja Janssen-Sahebzad
  - Download MySQL and establish connection with RStudio version 4.2.3 
  - Platform: Windows 11
  - Date: 25th March 2023

## Quality Assurance
  - All codes have undergone rigorous testing and have been verified to be in optimal working condition.

## Step-by-Step Procedure
### Purpose
This script is designed to download stock data, format it, and store it in a MySQL database.


###-------------------------------------------------------------------------------------###
1. Establish a MySQL Connection
###-------------------------------------------------------------------------------------###
install.packages("odbc"); require("odbc")

con <- dbConnect(odbc::odbc(), 
                 .connection_string = "Driver={MySQL ODBC 8.0 Unicode Driver};", 
                 Server= "localhost", Database = "data", UID = "root", PWD = .., Port= 3306)

Explanation:

Install and load the odbc package.
Establish a connection to the MySQL database named "data" on the localhost server using the root user with the specified password.

ODBC: Open Database Connectivity. It's a standard application programming interface (API) for interacting with databases.
con: Database connection object created using ODBC. It connects to a MySQL database named "data" on the local server.
