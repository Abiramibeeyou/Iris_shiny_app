library(RSQLite)
library(DBI)

con <- dbConnect(RSQLite::SQLite(), "iris_db.sqlite")

# Create table if it doesn’t exist
if (!dbExistsTable(con, "iris_data")) {
  dbWriteTable(con, "iris_data", iris, overwrite = TRUE)
}

dbDisconnect(con)
