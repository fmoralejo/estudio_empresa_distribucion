##  Pronostico de ventas en libras DISESA

## El set de datos presenta las ventas diarias

## Primero, no olvide setear su directorio de
## trabajo en Session - Set Working Directory
## y asegúrese de tener el archivo de datos
## en ese directorio

## Se leen los datos del set de datos


libras = read.csv("ventalibras.csv",header=T)

## Se convierten las fechas a formato de fechas 

libras$FECHA =  as.Date(libras$ï..fecha, format="%Y-%m-%d")

## Prueba de validacion de fechas

libras$FECHA[20] - libras$FECHA[1]

## Creacion de serie de tiempo para pronostico 

venta =  ts(libras$ventalibras, start=2019,frequency = 30)

## Se plotea la serie de tiempo

plot(venta)


## Se procede a realizar la primera proyeccion

library(forecast)

## se realiza la proyeccion para los siguientes 30 dias

dias = 30

pron1 =  forecast(venta, dias)

pron1

## Se plotean los datos y la proyeccion

plot(pron1)

## Se realiza la proyeccion ahora utilizando el modelo de ARIMA

ar = auto.arima(venta)

pron2 = forecast(ar,dias)

pron2

## Se comparan los pronosticos

plot(pron1$mean,ylim=c(0,100),col="red")
lines(pron2$mean,col="blue")

## Se evalua la precision de ambas proyecciones
## pronósticos

accuracy(pron1)

accuracy(pron2)

## comente sobre las distintas medidas de error y
## cual de los 2 pronósticos parece más confiable.

## Se graban los pronosticos de venta de cada proyeccion
## en dataframes separados para poderlos analizar desde excel

write.csv(data.frame(pron1), "Pron1ventas.csv")
write.csv(data.frame(pron2), "Pron2ventas.csv")




