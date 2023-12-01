###-------------------------------------------------------------------------------------###
  ##               Database in MySQL SQL server with Rstudio

## Code script by Sonja Janssen-Sahebzad
  ## Download MySQL and connect with my RStudio version 4.2.3 
  ## I am using Windows 11
  ## Date: 25 March 2023
###-------------------------------------------------------------------------------------###
##                 All Codes tested by SonjaJs: All codes are ok
##                            Step by step approach
###-------------------------------------------------------------------------------------###
    ## Code script 
    
    ## rm(list=ls()) 
    
    ##    1. Download MySQL and connect with RStudio

    install.packages("odbc");require("odbc")
    
    con <- dbConnect(odbc::odbc(), 
                     .connection_string = "Driver={MySQL ODBC 8.0 Unicode Driver};", 
                     Server= "localhost", Database = "data", UID = "root", PWD = .., Port= 3306)   
                                                                        ## PWD = use your own MySQL password
    
    ##    2. Send some Data to my database in MySQL
    
    ## 1st make ticker
    install.packages("quantmod"); require("quantmod")
    
    ticker = "AAPL"
    stock = getSymbols(ticker,auto.assign = FALSE)
    head(stock)
    
    
    ##    3.  We need to reformat this data to make it database friendly:
    
    idx = as.data.frame(index(stock))
    stock = as.data.frame(cbind(idx,coredata(stock)))
    ## then replace the columnnames
    colnames(stock) = c("Date","Open","High","Low","Close","Volume","Adjusted")
    ## Run this block
    head(stock)
    
    
    ##    4.  Which dat does this belongs to?
    
    stock$Symbol = ticker
    head(stock)
    
    
    ##    5.  We need to assign data types for our columns
    
    TYPES = list(Date="date",Open="double(10,2)",High="double(10,2)", Low="double(10,2)",Close="double(10,2)",
                 Volume="Int(25)",Adjusted="double(10,2)", Symbol="varchar(5)")
    
    
    ##    6. This code is to see how long it takes to actually write it out!
    
    system.time(dbWriteTable(con, name = "STK",value=stock, field.types=TYPES, row.names=FALSE))
    
    
    ##    7. If you want to keep populating  this database;
    ##            I am  requesting  data from the amazon AMZN, and run the lines:
    
    ticker = "AMZN"
    stock = getSymbols(ticker,auto.assign = FALSE)
    
    idx = as.data.frame(index(stock))
    stock = as.data.frame(cbind(idx,coredata(stock)))
    ## then replace the columnnames
    colnames(stock) = c("Date","Open","High","Low","Close","Volume","Adjusted")
    
    stock$Symbol = ticker
    
    TYPES = list(Date="date",Open="double(10,2)",High="double(10,2)", Low="double(10,2)",Close="double(10,2)",
                 Volume="Int(25)",Adjusted="double(10,2)", Symbol="varchar(5)")
    
    ## Let's look at our Dataframe'
    tail(stock)

    
    ##    8.  Sent it to a temporary database with "tmp"
    
    system.time(dbWriteTable(con, name = "tmp",value=stock, field.types=TYPES, row.names=FALSE))
    
    
    ##    9.  How to merge  my stock database!
    ##  With dbSendQuery(con, "") I'll pass it to my connection and insert it to my stk and select from tmp
    
    dbSendQuery(con, "insert into stk select * from tmp")

    
    ##  10. Lastly Sent out another query to "drop the table  tmp"
    dbSendQuery(con, "drop table tmp") <OdbcResult>
    
      
    ##  11. Type in MySQL database to search where AMZN is:
    #  SELECT * FROM data.stk WHERE Date >= "2020-07-01";
    
      
    ##  12.  Create an index for the symbol column in case the table gets too long
   
    ## - Go to MySQL from table to stk and right click: go to table inspector
    ## - Go to indexes, then click on symbol
    ## - Then we are going to create an index for the selected column: selct create
    ## - Now we have an index for our symbol column: idx_stk_Symbol 
      
      
    ##  13.  Last thing we need to do when we are done with MySQL: disconnect
    
      dbDisconnect(con)
    
    
    
###-------------------------------------------------------------------------------------###
  ##               1. Download MySQL and connect with RStudio
  ##         Below I am explaining the coding process by step by step approach!            
###-------------------------------------------------------------------------------------###
  ## rm(list=ls()) 
  ## New connection: copy the connectionstring for the driver
  ## data is the schema we just created in MySQl workbench
  ## UID = User ID
  ## PWD = your password in ...., as a number or character and keep it private
  ## library(DBI)
  ## con <- dbConnect(odbc::odbc(), .connection_string = "Driver={MySQL ODBC 8.0 Unicode Driver};", 
    #  timeout = 10)    ## Delete timeout = 10 and type  Server= "localhost", Database = "data")
 

  install.packages("odbc");require("odbc")
  
  con <- dbConnect(odbc::odbc(), 
                   .connection_string = "Driver={MySQL ODBC 8.0 Unicode Driver};", 
                   Server= "localhost", Database = "data", UID = "root", PWD = .., Port= 3306)   
  
  ## Run this block, now we have established a connection, the schemas are now in my SQL workbench
  ## Created mysql databases: data, information_schema, mysql, performance_schema, sakila, sys, world
 
###-------------------------------------------------------------------------------------###
  ##                 2. Send some Data to my database in MySQL
###-------------------------------------------------------------------------------------###
  ## 1st make ticker
  install.packages("quantmod"); require("quantmod")
  
  ticker = "AAPL"
  stock = getSymbols(ticker,auto.assign = FALSE)
  head(stock)
  
#  AAPL.Open   AAPL.High AAPL.Low AAPL.Close AAPL.Volume AAPL.Adjusted
#  2007-01-03  3.081786  3.092143 2.925000   2.992857    1238319600      2.547275
#  2007-01-04  3.001786  3.069643 2.993571   3.059286    847260400       2.603815
#  2007-01-05  3.063214  3.078571 3.014286   3.037500    834741600       2.585271
#  2007-01-08  3.070000  3.090357 3.045714   3.052500    797106800       2.598038
#  2007-01-09  3.087500  3.320714 3.041071   3.306071    3349298400      2.813858
#  2007-01-10  3.383929  3.492857 3.337500   3.464286    2952880000      2.948517

###-------------------------------------------------------------------------------------###  
  ##        3.  We need to reformat this data to make it database friendly:
###-------------------------------------------------------------------------------------###
  ## Therefore we need to extract the index = idx by saving it as a dataframe
  ## and then we have to convert the stock data into a dataframe as well
  ## and then combine = cbind our idx, with the coredata of our stockdata
  
  idx = as.data.frame(index(stock))
  stock = as.data.frame(cbind(idx,coredata(stock)))
  ## then replace the columnnames
  colnames(stock) = c("Date","Open","High","Low","Close","Volume","Adjusted")
  ## Run this block
  head(stock)                                   
  
  ## and take a look at the data
  
#  Date     Open     High      Low    Close     Volume Adjusted
#  1 2007-01-03 3.081786 3.092143 2.925000 2.992857 1238319600 2.547275
#  2 2007-01-04 3.001786 3.069643 2.993571 3.059286  847260400 2.603814
#  3 2007-01-05 3.063214 3.078571 3.014286 3.037500  834741600 2.585272
#  4 2007-01-08 3.070000 3.090357 3.045714 3.052500  797106800 2.598040
#  5 2007-01-09 3.087500 3.320714 3.041071 3.306071 3349298400 2.813858
#  6 2007-01-10 3.383929 3.492857 3.337500 3.464286 2952880000 2.948517
  
###-------------------------------------------------------------------------------------### 
  ##                             Testing my codes:
  ##                    4. Which dat does this belongs to?
###-------------------------------------------------------------------------------------### 
  ## If we would save this data in a database, we don't know which data this belongs to
  ## So I will go ahead an add another column with a ticker name by running stock$Symbol
  
  ##                    4. Which dat does this belongs to?
  stock$Symbol = ticker
  head(stock) 
  
  ## and now we know that this data belongs to AAPL: 
  ## when I make request to my database, I usually call in data by the ticker
  ## If it is a match, it will return all the data that belongs to that ticker
  
#  Date     Open     High      Low    Close     Volume Adjusted Symbol
#  1 2007-01-03 3.081786 3.092143 2.925000 2.992857 1238319600 2.547275   AAPL
#  2 2007-01-04 3.001786 3.069643 2.993571 3.059286  847260400 2.603814   AAPL
#  3 2007-01-05 3.063214 3.078571 3.014286 3.037500  834741600 2.585272   AAPL
#  4 2007-01-08 3.070000 3.090357 3.045714 3.052500  797106800 2.598040   AAPL
#  5 2007-01-09 3.087500 3.320714 3.041071 3.306071 3349298400 2.813858   AAPL
#  6 2007-01-10 3.383929 3.492857 3.337500 3.464286 2952880000 2.948517   AAPL
  
###----------------------------------------------------------------------------------------###
  ##             5. We need to assign data types for our columns
###----------------------------------------------------------------------------------------### 
  ## My 1st column called date. The data type is just date.
  ## My Open column is a double and here I'll put 10, 2, which is 10 integers, followed by 2 floating integers
  ## for the volume I'll set that equal to integer with a max of 25 integers
  ## and lastly for Symbol will be a variable character, with a max of 5 characters.
  ## Run this line:
  
  ##             5. We need to assign data types for our columns
  TYPES = list(Date="date",Open="double(10,2)",High="double(10,2)", Low="double(10,2)",Close="double(10,2)",
               Volume="Int(25)",Adjusted="double(10,2)", Symbol="varchar(5)")
  
###----------------------------------------------------------------------------------------###
  ##    6. This code is to see how long it takes to actually write it out!
###----------------------------------------------------------------------------------------###
  ## Now I will send this data to my database.
  ## and write system.time to see how long it takes to actually write it out!
  ## and I am going to use dbwriteTable pass in my connection,
  ## the name for this database will be stk,
  ## What am I actually sending will be my stock, field.types will be TYPES, row names I'll set that equal to FALSE
  ## Run this line:
  
  ##       6. This code is to see how long it takes to actually write it out! 
  system.time(dbWriteTable(con, name = "STK",value=stock, field.types=TYPES, row.names=FALSE))

#  user  system elapsed 
#  0.01    0.00    0.42  
  
  ## It took approximately 0.42 seconds to write this data into my MySQL database 
  ## If we go to MySQL workbench and right click and refresh all!
  ## Right click on stock and select rows; now I have the data in my database!
  ## Check in MySQL: It has been formatted correctly
  ## Go back to Rstudio
  
###----------------------------------------------------------------------------------------###  
  ##           7. If you want to keep populating  this database
###-------------------------------------------------------------------------------------### 
  
  ##        7. If you want to keep populating  this database;
  ##            I am  requesting  data from the amazon AMZN, and run the lines:
  ticker = "AMZN"
  stock = getSymbols(ticker,auto.assign = FALSE)
  
  idx = as.data.frame(index(stock))
  stock = as.data.frame(cbind(idx,coredata(stock)))
  ## then replace the columnnames
  colnames(stock) = c("Date","Open","High","Low","Close","Volume","Adjusted")
  
  stock$Symbol = ticker
  
  TYPES = list(Date="date",Open="double(10,2)",High="double(10,2)", Low="double(10,2)",Close="double(10,2)",
               Volume="Int(25)",Adjusted="double(10,2)", Symbol="varchar(5)")
  
  ## Let's look at our Dataframe'
  tail(stock)
  
#  Date   Open   High   Low  Close   Volume Adjusted Symbol
#  4080 2023-03-17  99.79 100.66 97.46  98.95 87173200    98.95   AMZN
#  4081 2023-03-20  98.41  98.48 95.70  97.71 62388900    97.71   AMZN
#  4082 2023-03-21  98.14 100.85 98.00 100.61 58597300   100.61   AMZN
#  4083 2023-03-22 100.45 102.10 98.61  98.70 57475400    98.70   AMZN
#  4084 2023-03-23 100.43 101.06 97.62  98.71 57559300    98.71   AMZN
#  4085 2023-03-24  98.07  98.30 96.40  98.13 56095400    98.13   AMZN
  
  ##  It has formatted the way we want

###-------------------------------------------------------------------------------------###   
  ##                8.  Sent it to a temporary database "tmp"
###-------------------------------------------------------------------------------------### 
           
   ##    8.  sent it to a temporary database with "tmp"
   system.time(dbWriteTable(con, name = "tmp",value=stock, field.types=TYPES, row.names=FALSE))
   
#  user  system elapsed 
#  0.00    0.00    0.33  
  
  ## go to MySQL database, to check if it is there: right click, than "refresh all" 
  ## it is under the drop down arrow of Table: you will see stk and tmp
  
###-------------------------------------------------------------------------------------### 
  ##                     9.  How to merge  my stock database with the rmp database
###-------------------------------------------------------------------------------------### 
  
  ##    9.  How to merge  my stock database!
  ##        With dbSendQuery(con, "") I'll pass it to my connection and my SQL statement insert it to my stk which is my populated database
  ##        and select *= all from tmp
   
  dbSendQuery(con, "insert into stk select * from tmp")
  nrow(stock)   ## [1] 4085
  
#     <OdbcResult>
#    SQL  insert into stk select * from tmp
#    ROWS Fetched: 0 [complete]
#         Changed: 4085
 
###-------------------------------------------------------------------------------------###   
  ##          10. Lastly Sent out another query to "drop the table  tmp"
###-------------------------------------------------------------------------------------### 
##  10. Lastly Sent out another query to "drop the table  tmp"
    dbSendQuery(con, "drop table tmp") <OdbcResult>
    
#    SQL  drop table tmp
#  ROWS Fetched: 0 [complete]
#  Changed: 0
 
## Go to MySQL workbench database: refresh all, you will see that de tmp file isn't there anymore! 
    
###-------------------------------------------------------------------------------------###   
  ##            11. Check if it has AMZN in our MySQL database
###-------------------------------------------------------------------------------------###  
  ## Type in MySQL database to search where AMZN is:
 # SELECT * FROM data.stk WHERE Date >= "2020-07-01";     ## Run the line in MySQL
  # In the MySQL database you will see AAPL stock and also AMZN

###-------------------------------------------------------------------------------------###   
##  12.  Create an index for the symbol column in case the table gets too long
###-------------------------------------------------------------------------------------###  
  ## Because we are requesting data for AMZN without an index, it will actually reiterate through
  ## Each and every row! Which is very time consuming.
  ## It will match all the cases, where all the symbols all matches R AMZN tickers or whatever tickers
  ## INDEX symbol: when I request certain data for a ticker it will grab it automatically
    
  ## - Go to MySQL from table to stk and right click: go to table inspector
  ## - Go to indexes, then click on symbol
  ## - Then we are going to create an index for the selected column: selct create
  ## - Now we have an index for our symbol column: idx_stk_Symbol
  
###-------------------------------------------------------------------------------------###   
    ##  13.  Last thing we need to do when we are done with MySQL: disconnect
###-------------------------------------------------------------------------------------###     
  ## - Last thing we need to do when we are done with MySQL: disconnect
    
    dbDisconnect(con)
  
  ## Go to the connect screen in RStudio: it has saved our connection screen
    library(DBI)
    # con <- dbConnect(odbc::odbc(), .connection_string = "Driver={MySQL ODBC 8.0 Unicode Driver};", 
    #                Server = "localhost", Database = "data", UID = "root", PWD = .., 
    #                 Port = 3306)
  
###-------------------------------------------------------------------------------------###   
    ##  14.  Last thing we need to do when we are done with MySQL: disconnect
###-------------------------------------------------------------------------------------###     
  ## If we are trying to reconnect, just click: connect
  ## Just click: "connect" in the RStudio console, than click R Console
  ## you will see that we are connected again to MySQL
  ## Or you can run the connection screen: 
    con <- dbConnect(odbc::odbc(), 
                     .connection_string = "Driver={MySQL ODBC 8.0 Unicode Driver};", 
                     Server= "localhost", Database = "data", UID = "root", PWD = .., Port= 3306) 
  
  
###-------------------------------------------------------------------------------------###   
    ##  15. If you want to disconnect with MySQL: disconnect
###-------------------------------------------------------------------------------------###    
   # use the icon in the RStudio console: click the icon disconnect from a connection
  
  
  
