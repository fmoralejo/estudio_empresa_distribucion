library(xlsx)
library(openxlsx)
library(arules)
library(plyr)
library(naniar)


lectura_datos = function(file_path,sheet)
{
  wb <- loadWorkbook(file_path)
  sheet_names <- getSheetNames(file_path)
  sheet <- readWorkbook(xlsxFile = file_path, sheet = sheet, colNames = TRUE, skipEmptyRows = TRUE)
  print(sheet)
  return(sheet)
}

# coerce_to_list = function(df)
# {
#   rows = seq(1:nrow(df))
#   lista = list()
#   for (i in rows)
#   {
#     element <- as.character(df[i,])
#     lista[1] <- element
#   }
#   return(lista)
