###-------------------------------------------------------------------------------------###
  ##               Database in MySQL SQL server with Rstudio

## Code script by Sonja Janssen-Sahebzad
  ## Download MySQL and connect with my RStudio version 4.2.3 
  ## I am using Windows 11
  ## Date: 25 March 2023

  ## All Codes tested by SonjaJs: All codes are ok
  ## Step by step approach


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


###-------------------------------------------------------------------------------------###
2. Send Data to MySQL
###-------------------------------------------------------------------------------------###

install.packages("quantmod"); require("quantmod")

ticker = "AAPL"
stock = getSymbols(ticker, auto.assign = FALSE)
# ... (formatting stock data)
stock$Symbol = ticker

TYPES = list(Date="date",Open="double(10,2)",High="double(10,2)", Low="double(10,2)",Close="double(10,2)",
             Volume="Int(25)",Adjusted="double(10,2)", Symbol="varchar(5)")

system.time(dbWriteTable(con, name = "STK",value=stock, field.types=TYPES, row.names=FALSE))
   
Explanation:

Install and load the quantmod package.
Download stock data for the specified ticker (AAPL in this case) using getSymbols.
Format the data and add a "Symbol" column.
Define data types for each column.
Use dbWriteTable to write the formatted stock data to the MySQL table named "STK".    

quantmod: A package for quantitative financial modeling.
getSymbols: A function from quantmod to retrieve stock data.
dbWriteTable: A function to write a data frame (stock) into a MySQL table named "STK" with specified data types.


###-------------------------------------------------------------------------------------###
3. Continue Populating the Database          
###-------------------------------------------------------------------------------------###
ticker = "AMZN"
stock = getSymbols(ticker,auto.assign = FALSE)
# ... (formatting stock data)
stock$Symbol = ticker

TYPES = list(Date="date",Open="double(10,2)",High="double(10,2)", Low="double(10,2)",Close="double(10,2)",
             Volume="Int(25)",Adjusted="double(10,2)", Symbol="varchar(5)")

system.time(dbWriteTable(con, name = "tmp",value=stock, field.types=TYPES, row.names=FALSE))

Explanation:

Download stock data for another ticker (AMZN in this case).
Format the data and add a "Symbol" column.
Write the formatted stock data to a temporary MySQL table named "tmp".

Similar to the previous step, this time for the "AMZN" stock.
A temporary table named "tmp" is used for intermediate storage.

###-------------------------------------------------------------------------------------###
4. Merge Data from Temporary Table to Main Table      
###-------------------------------------------------------------------------------------###
dbSendQuery(con, "insert into stk select * from tmp")
dbSendQuery(con, "drop table tmp") <OdbcResult>

Explanation:

Use SQL queries to insert data from the temporary table ("tmp") into the main table ("stk").
Drop the temporary table after merging.

dbSendQuery: Executes a SQL query.
SQL queries are used to insert data from "tmp" into "stk" and drop the temporary table.


###-------------------------------------------------------------------------------------###
5. Perform Additional Database Operations        
###-------------------------------------------------------------------------------------###
# ... (Additional database operations, e.g., creating an index)

Explanation:

Perform additional operations on the MySQL database (e.g., creating an index on the "Symbol" column).
The script hints at additional operations such as creating an index.

###-------------------------------------------------------------------------------------###
6. Disconnect from MySQL     
###-------------------------------------------------------------------------------------###
dbDisconnect(con)

Explanation:

dbDisconnect: Closes the database connection.


###-------------------------------------------------------------------------------------###
7. Reconnect to MySQL (Optional)       
###-------------------------------------------------------------------------------------###
con <- dbConnect(odbc::odbc(), 
                 .connection_string = "Driver={MySQL ODBC 8.0 Unicode Driver};", 
                 Server= "localhost", Database = "data", UID = "root", PWD = .., Port= 3306)
Explanation:

Optionally reconnect to the MySQL database if needed.
Optionally reconnecting to the MySQL database.

###-------------------------------------------------------------------------------------###
8. Disconnect Again (Optional)       
###-------------------------------------------------------------------------------------###
dbDisconnect(con)


Explanation:

Optionally disconnecting again from the MySQL database.
Note:
It's important to replace placeholders like ".." with the actual MySQL password.
The script uses system.time to measure the time it takes for certain operations.
The comments in the script provide additional explanations for each step.
This script demonstrates the process of downloading stock data, formatting it, and storing it in a MySQL database using R and RStudio. It also covers some database management operations.

###-------------------------------------------------------------------------------------###
Outcomes:
1. MySQL Database Interaction:
Data from AAPL and AMZN stocks is downloaded, formatted, and stored in a MySQL database.
The script demonstrates using SQL queries to merge data from a temporary table to the main table.

2.Time Measurement:
system.time is used to measure the time taken for certain operations, providing insights into performance.

3. Database Management:
The script hints at additional operations, such as creating an index, showcasing broader database management capabilities.

4. Connectivity:
The script shows how to establish, disconnect, and optionally reconnect to a MySQL database.

End Note:
Make sure to replace placeholder values like ".." with actual credentials for proper execution. 
This script is a practical example of integrating R and MySQL for financial data management.


 
