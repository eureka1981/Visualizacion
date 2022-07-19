#install.packages("dygraphs")

# Library
library(dygraphs)
library(xts)          
library(tidyverse)
library(lubridate)
library(dplyr)
library (readxl)

setwd("~/Downloads/App")
data <- read_excel("data/Libro1.xlsx")
data$date<-as.Date(data$Fecha2)


data<-data %>%  group_by(date)%>%  
  summarise( numero = sum(`Número emigrantes`)
  )


data<-as.data.frame(data)



data2<- xts(x = data$numero, order.by = data$date)



##Serie de tiempo por sexo

p=dygraph(data2)%>%
  dyOptions(labelsUTC = TRUE, fillGraph=FALSE, fillAlpha=0.1, drawGrid = FALSE, colors= "#00afb9") %>%
  dyRangeSelector() %>%
  dyCrosshair(direction = "vertical") %>%
  dyHighlight(highlightCircleSize = 5, highlightSeriesBackgroundAlpha = 0.2, hideOnMouseOut = FALSE)  %>%
  dyRoller(rollPeriod = 1)

p





##Hacemos tablas

data <- read_excel("data/Libro1.xlsx")
data$date<-as.Date(data$Fecha2)

mes_t<-data %>%  group_by(date)%>%  
  summarise( numero = sum(`Número emigrantes`)
  )


mes_t<-as.data.frame(mes_t)

Year_1<-data %>%  group_by(Año)%>%  
  summarise( numero = sum(`Número emigrantes`)
  )

Year_1<-as.data.frame (Year1)

Year_1





### Hacemos dos base de datos por sexo
Mujeres<-subset(data, data$Sexo=="Mujer")
Hombres<-subset(data, data$Sexo=="Hombre")

####Hacemos unos vectores que usaremos despues para la tabla resumen
####

Year_m<-Mujeres %>%  group_by(Año)%>%  
  summarise( numero = sum(`Número emigrantes`)
  )
Year_h<-Hombres %>%  group_by(Año)%>%  
  summarise( numero = sum(`Número emigrantes`)
  )


## Tabla por año

tabla_año<- c(Year_1, Year_m, Year_h)
tabla_año<-data.frame(tabla_año)


tabla_año<-tabla_año[-3]
tabla_año
tabla_año<-tabla_año[-4]

names (tabla_año) = c("Año", "Total", "Mujeres", "Hombres")


#### Importamos las librerías y hacemos los preparativos para generar tablas 

library( kableExtra )

knitr.table.format="html"

tabla_año$Total<-format(tabla_año$Total, big.mark = ",")
tabla_año$Mujeres<-format(tabla_año$Mujeres, big.mark = ",")
tabla_año$Hombres<-format(tabla_año$Hombres, big.mark = ",")

tabla_año

Form.Basic<-c("striped", "bordered", "hover", "condensed", "responsive")
tabla_año<-kable (tabla_año)%>%
  kable_styling(bootstrap_options = Form.Basic, full_width = F, position = "center", font_size = 10, fixed_thead = T)
tabla_año


###Hacemos las preparaciones de las series de tiepo

Mujeres <- xts(x = Mujeres$`Número emigrantes`, order.by = Mujeres$date)
Hombres <- xts(x = Hombres$`Número emigrantes`, order.by = Hombres$date)

sexo <- cbind(Mujeres, Hombres)

##Serie de tiempo por sexo

sex=dygraph(sexo)%>%
  dyOptions(labelsUTC = TRUE, fillGraph=FALSE, fillAlpha=0.5, drawGrid = FALSE, colors=c( "#00afb9", "#f07167")) %>%
  dyRangeSelector() %>%
  dyCrosshair(direction = "vertical") %>%
  dyHighlight(highlightCircleSize = 5, highlightSeriesBackgroundAlpha = 0.5, hideOnMouseOut = FALSE)  %>%
  dyRoller(rollPeriod = 1)

sex

####Definimos una variable de transparencia


transparent=function(size=0){
  
  
  temp=theme(rect= element_rect(fill = 'transparent',size=size),
             panel.background=element_rect(fill = 'transparent'),
             panel.border=element_rect(size=size),
             panel.grid.major=element_blank(),
             panel.grid.minor=element_blank())
  temp
}



### Tabla de promedio mensual
mes<-data %>%  group_by(Mes)%>%  
  summarise( Promedio = mean(`Número emigrantes`)
  )


mes<-as.data.frame(mes)

### gráfica de promedio mensual- lollipop
g<-mes %>%
  arrange(Promedio) %>%
  mutate(Mes = factor(Mes, levels=c("Enero", "Febrero", "Marzo", "Abril", "Mayo", "Junio", "Julio", "Agosto", "Septiembre", "Octubre", "Noviembre", "Diciembre"))) %>%
  ggplot( aes(x=Mes, y=Promedio) ) +
  geom_segment( aes(xend=Mes, yend=0)) +
  geom_point( size=4, color="#0081a7") +
  scale_x_discrete() +
  theme(axis.text.x = element_text(angle = 90,
                                   vjust = 0.5, hjust = 1))+
  xlab("")+
  ylab("")+
  transparent()


###Lo convertimos a interactivo
library (plotly)

g<-ggplotly(g)

g
##### 

### preparación de librerías para hacer gráfico de dona
#install.packages("webr")
library(webr)
library(dplyr)


s<-c( "Hombres", "Mujeres")
t<-c( 50.8, 49.2)
data1<-data.frame(s,t)

# Gráfico de donut

library(RColorBrewer)
library(leaflet)
library (ggplot2)


pie=PieDonut(data1, aes(s,  count=t), r0=.5, showPieName=FALSE) +
  theme(panel.background = element_rect(fill = '#ecf0f5', colour='#ecf0f5'),
        plot.background = element_rect(fill = "#ecf0f5",colour='#ecf0f5' ))


### Valores totales

tmp_ex_tot= 175503.00 
tmp_muj_tot=86370
tmp_hom_tot=89133

### Impresión de gráficos

g
p
pie
sex
tabla_año
