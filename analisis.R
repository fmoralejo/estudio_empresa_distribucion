source('~/Progra/estudio_empresa_distribucion/funciones.R')

#la funcion lectura_datos se encuentra definida el archivo al que se llama en el encabezado
#se utiliza para la lectura de datos de un documento en formato .xlsx
#los parametros a utilizar son:
  #primero: el nombre del documento de excel a leer
  #segundo: el nombre de la hoja de excel a leer
ventas <- lectura_datos('base_datos.xlsx', 'Ventas')
clientes <- lectura_datos('base_datos.xlsx', 'Clientes')

#Se asignan valores binarios en nuevas columnas que nos indican si el producto fue comprado o no
#Luego se procesaran estas columnas para asignarles el nombre del producto
ventas$compra_chorizo <- as.numeric(ventas$Chorizo>0)
ventas$compra_Longaniza <- as.numeric(ventas$Longaniza>0)
ventas$compra_Salchicha.Corta <- as.numeric(ventas$Salchicha.Corta>0)
ventas$compra_Salchicha.Larga <- as.numeric(ventas$Salchicha.Larga>0)
ventas$compra_Salami <- as.numeric(ventas$Salami>0)

#Se agregan las filas que nos eran utiles para crear las transacciones
#Estas fias contiene el producto que se compro, sin importar la cantidad.
ventas$compra_chorizo <- mapvalues(
    ventas$compra_chorizo,
    from=c(0,1), 
    to=c(NA,'Chorizo')
    )
ventas$compra_Longaniza <- mapvalues(
  ventas$compra_Longaniza,
  from=c(0,1),
  to=c(NA,'Longaniza')
  )
ventas$compra_Salchicha.Corta <- mapvalues(
  ventas$compra_Salchicha.Corta,
  from=c(0,1),
  to=c(NA,'Salchicha.Corta')
  )
ventas$compra_Salchicha.Larga <- mapvalues(
  ventas$compra_Salchicha.Larga,
  from=c(0,1),
  to=c(NA,'Salchicha.Larga')
  )
ventas$compra_Salami <- mapvalues(
  ventas$compra_Salami,
  from=c(0,1),
  to=c(NA,'Salami')
  )

#Se graba un archivo .csv que contiene solamente las columnas que nos son de interes para las transacciones
transacciones <- ventas[,c('compra_chorizo',
                           'compra_Longaniza',
                           'compra_Salchicha.Corta',
                           'compra_Salchicha.Larga',
                           'compra_Salami')
                        ]
write.csv(transacciones,file = 'CSV_Transacciones.csv', row.names = FALSE)
#Este CSV q se crea contiene valores NA para las ubicacions de productos que no se compraron en esa venta
#por lo que es necesario eliminarlos en excel. En el siguiente link esta la explicacion de como
#hacerlo de manera eficiente: https://www.excel-easy.com/examples/delete-blank-rows.html


transacciones2 <- as.list.data.frame(transacciones)
transacciones3 <- tran
# transacciones3 <- lapply(transacciones2, function(transacciones2) transacciones2[!is.na(transacciones2)])


transacciones_procesadas <- read.transactions(
  'transacciones_listas.csv',
  format = 'basket',
  sep = ','
  )

#Se saca la frecuencia de cada uno de los items en las transacciones
#Estos nos sera util mas adelante para poder utilziar este algoritmo para la generacion
#de incremento de ventas de aquellos productos con baja venta atravez de aquelos productos
#con mas ventas.

itemFrequencyPlot(transacciones_procesadas, topN = 20, type = 'absolute')

itemFrequencyPlot(transacciones_procesadas, topN = 20, type = 'relative')

inspect(transacciones_procesadas)

most_frequent <- itemFrequency(transacciones_procesadas)
sort(most_frequent, decreasing= TRUE)

###Se crean las reglas utilizando el algoritmo apriori
reglas <- apriori(
  transacciones_procesadas,
  parameter = list(supp = 0.005, conf = 0.25, minlen = 2)
  )
reglas

# se obtienen 39 reglas de las cuales, dado el limitado numero de productos solo utilizaremos
# las primeras 10
reglas_ordenadas_confidence <- sort(reglas, decreasing = TRUE, by='conf')[1:10]
inspect(reglas_ordenadas_confidence)

reglas_ordenadas_support <- sort(reglas, decreasing = TRUE, by='sup')[1:10]
inspect(reglas_ordenadas_support)

reglas_ordenadas_lift <- sort(reglas, decreasing = TRUE, by='lift')[1:10]
inspect(reglas_ordenadas_lift)

#Dado q se quiere incrementar las ventas de los dos productos menos vendidos se buscan las reglas 
#que contiene alguno de estos productos

reglas_Salchicha.larga <-apriori(transacciones_procesadas, parameter=list(supp=0.005,conf = 0.05, minlen=2),appearance = list(default="lhs",rhs="Salchicha.Larga"))
reglas_Salchicha.larga
inspect(reglas_Salchicha.larga)

