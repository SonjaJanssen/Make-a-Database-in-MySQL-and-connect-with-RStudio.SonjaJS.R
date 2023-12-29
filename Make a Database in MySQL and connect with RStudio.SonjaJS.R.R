# Verderop vindt u de nederlandse versie van dit script!
# Please find below the dutch version of this code script!
###-------------------------------------------------------------------------------------###
##               Database in MySQL SQL server with Rstudio

## Code script by Sonja Janssen-Sahebzad
  ## Download MySQL and connect with my RStudio version 4.2.3 
  ## I am using Windows 11
  ## Date: 25 March 2023

  ## All Codes tested by SonjaJs: All codes are ok
  ## Step by step approach
## Purpose: Downloading stock data, formatting it, and then storing it in a MySQL database. 

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


 Nederlandse Vertaling van het script:
Database in MySQL SQL server with Rstudio
Codescript door Sonja Janssen-Sahebzad
Download MySQL en maak verbinding met mijn RStudio-versie 4.2.3
Ik gebruik Windows 11
Datum: 25 maart 2023
Alle codes getest door SonjaJs: Alle codes zijn in orde
Stapsgewijze aanpak
Doel: Financiële gegevens downloaden, opmaken en vervolgens opslaan in een MySQL-database.
###-------------------------------------------------------------------------------------###

Maak een MySQL-verbinding
###-------------------------------------------------------------------------------------###
install.packages("odbc"); require("odbc")
con <- dbConnect(odbc::odbc(),
.connection_string = "Driver={MySQL ODBC 8.0 Unicode Driver};",
Server= "localhost", Database = "data", UID = "root", PWD = .., Port= 3306)

Toelichting:

Installeer en laad het odbc-pakket.
Maak verbinding met de MySQL-database met de naam "data" op de lokale hostserver met de gebruiker "root" en het opgegeven wachtwoord.

ODBC: Open Database Connectivity. Het is een standaard application programming interface (API) voor interactie met databases.
con: Database-verbindingobject gemaakt met ODBC. Het maakt verbinding met een MySQL-database met de naam "data" op de lokale server.

###-------------------------------------------------------------------------------------###
2. Stuur gegevens naar MySQL
###-------------------------------------------------------------------------------------###

install.packages("quantmod"); require("quantmod")

ticker = "AAPL"
stock = getSymbols(ticker, auto.assign = FALSE)

... (opmaak van aandelengegevens)
stock$Symbol = ticker

TYPES = list(Date="date",Open="double(10,2)",High="double(10,2)", Low="double(10,2)",Close="double(10,2)",
Volume="Int(25)",Adjusted="double(10,2)", Symbol="varchar(5)")

system.time(dbWriteTable(con, name = "STK",value=stock, field.types=TYPES, row.names=FALSE))

Toelichting:

Installeer en laad het quantmod-pakket.
Download aandelengegevens voor het opgegeven ticker-symbool (in dit geval AAPL) met behulp van getSymbols.
Formatteer de gegevens en voeg een "Symbol"-kolom toe.
Definieer gegevenstypen voor elke kolom.
Gebruik dbWriteTable om de geformatteerde aandelengegevens naar de MySQL-tabel met de naam "STK" te schrijven.

quantmod: Een pakket voor kwantitatieve financiële modellering.
getSymbols: Een functie van quantmod om aandelengegevens op te halen.
dbWriteTable: Een functie om een gegevensframe (stock) in een MySQL-tabel met de naam "STK" te schrijven met gespecificeerde gegevenstypen.

###-------------------------------------------------------------------------------------###
3. Ga door met het vullen van de database
###-------------------------------------------------------------------------------------###
ticker = "AMZN"
stock = getSymbols(ticker,auto.assign = FALSE)

... (opmaak van aandelengegevens)
stock$Symbol = ticker

TYPES = list(Date="date",Open="double(10,2)",High="double(10,2)", Low="double(10,2)",Close="double(10,2)",
Volume="Int(25)",Adjusted="double(10,2)", Symbol="varchar(5)")

system.time(dbWriteTable(con, name = "tmp",value=stock, field.types=TYPES, row.names=FALSE))

Toelichting:

Download aandelengegevens voor een ander ticker-symbool (in dit geval AMZN).
Formatteer de gegevens en voeg een "Symbol"-kolom toe.
Schrijf de geformatteerde aandelengegevens naar een tijdelijke MySQL-tabel met de naam "tmp".

Vergelijkbaar met de vorige stap, deze keer voor het aandeel "AMZN".
Een tijdelijke tabel met de naam "tmp" wordt gebruikt voor tussentijdse opslag.

###-------------------------------------------------------------------------------------###
4. Voeg gegevens samen vanuit de tijdelijke tabel naar de hoofdtabel
###-------------------------------------------------------------------------------------###
dbSendQuery(con, "insert into stk select * from tmp")
dbSendQuery(con, "drop table tmp") <OdbcResult>

Toelichting:

Gebruik SQL-query's om gegevens vanuit de tijdelijke tabel ("tmp") in de hoofdtabel ("stk") in te voegen.
Verwijder de tijdelijke tabel na samenvoeging.

dbSendQuery: Voert een SQL-query uit.
SQL-query's worden gebruikt om gegevens van "tmp" in "stk" in te voegen en de tijdelijke tabel te verwijderen.

###-------------------------------------------------------------------------------------###
5. Voer aanvullende databasebewerkingen uit
###-------------------------------------------------------------------------------------###

... (Aanvullende databasebewerkingen, bijvoorbeeld het maken van een index)
Toelichting:

Voer aanvullende bewerkingen uit op de MySQL-database (bijvoorbeeld het maken van een index op de kolom "Symbol").
Het script geeft aan dat er aanvullende bewerkingen zijn, zoals het maken van een index.

###-------------------------------------------------------------------------------------###
6. Verbinding verbreken met MySQL
###-------------------------------------------------------------------------------------###
dbDisconnect(con)

Toelichting:

dbDisconnect: Sluit de databaseverbinding.

###-------------------------------------------------------------------------------------###
7. Herstel verbinding met MySQL (Optioneel)
###-------------------------------------------------------------------------------------###
con <- dbConnect(odbc::odbc(),
.connection_string = "Driver={MySQL ODBC 8.0 Unicode Driver};",
Server= "localhost", Database = "data", UID = "root", PWD = .., Port= 3306)
Toelichting:

Herstel optioneel de verbinding met de MySQL-database indien nodig.
Optioneel opnieuw verbinden met de MySQL-database.

###-------------------------------------------------------------------------------------###
8. Verbreek opnieuw de verbinding (Optioneel)
###-------------------------------------------------------------------------------------###
dbDisconnect(con)

Toelichting:

Optioneel opnieuw verbreken van de verbinding met de MySQL-database.
Opmerking:
Het is belangrijk om de aanduidingen zoals ".." te vervangen door de daadwerkelijke MySQL-wachtwoorden.
Het script gebruikt system.time om de tijd te meten die nodig is voor bepaalde bewerkingen.
De opmerkingen in het script geven aanvullende uitleg bij elke stap.
Dit script toont het proces van het downloaden van aandelengegevens, het opmaken ervan en het opslaan in een MySQL-database met behulp van R en RStudio. Het behandelt ook enkele databasebeheerbewerkingen.

###-------------------------------------------------------------------------------------###
Resultaten:

Interactie met MySQL-database:
Gegevens van de aandelen AAPL en AMZN worden gedownload, opgemaakt en opgeslagen in een MySQL-database.
Het script demonstreert het gebruik van SQL-query's om gegevens van een tijdelijke tabel naar de hoofdtabel samen te voegen.

Tijdsmeting:
system.time wordt gebruikt om de tijd te meten die nodig is voor bepaalde bewerkingen, wat inzicht geeft in de prestaties.

Databasebeheer:
Het script hint naar aanvullende bewerkingen, zoals het maken van een index, waarmee bredere mogelijkheden voor databasebeheer worden getoond.

Connectiviteit:
Het script laat zien hoe je een verbinding met een MySQL-database tot stand brengt, verbreekt en optioneel opnieuw verbindt.

Eindopmerking:
Zorg ervoor dat je aanduidingen zoals ".." vervangt door de daadwerkelijke referenties voor een correcte uitvoering. Dit script is een praktisch voorbeeld van het integreren van R en MySQL voor het beheer van financiële gegevens.








