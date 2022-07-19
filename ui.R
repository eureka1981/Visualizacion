library(shinydashboard)
library(shiny)
library(dplyr)
library(tidyr)
library(ggplot2)
#install.packages("highcharter")
library(highcharter)
library(lubridate)
library(stringr)
library(withr)
#install.packages("treemap")
library(treemap)
library(DT)
library(shinyBS)
library(shinyjs)
library(WDI)
library(geosphere)
library(magrittr)
library(shinycssloaders)
options(spinner.color="#006272")
#install.packages("timevis")
library(timevis)
library(dygraphs)


## build ui.R -----------------------------------
## 1. header -------------------------------


header <- 
  dashboardHeader( title = HTML("Tarea rediseño: Emigración"), 
                   disable = FALSE, 
                   titleWidth  = 550,
                   dropdownMenu( type = 'message',
                                       messageItem(
                                         from = "eunice@humint.mx",#'Feedback and suggestions',
                                         message =  "",#paste0("eunice@humint.mx" ),
                                         icon = icon("envelope"),
                                         href = "eunice@humint.mx"
                                       ),
                                       icon = icon('comment')
                                       )
  )

## 2. siderbar ------------------------------
siderbar <- 
  dashboardSidebar( 
    width = 200,
    sidebarMenu(
      id = 'sidebar',
      style = "position: relative; overflow: visible;",
      #style = "position: relative; overflow: visible; overflow-y:scroll",
      #style = 'height: 90vh; overflow-y: auto;',
      ## 1st tab show the Main dashboard -----------
      menuItem( "Universidad de la Rioja", tabName = 'dashboard', icon = icon('globe') ),
      
      
      ## 2nd se buscaba incluir una tabla --------------
      #menuItem("", tabName = 'table', icon = icon('uniregistry') ),
      #div( id = 'sidebar_cr',
       #    conditionalPanel("input.sidebar === 'table'"),
    #  ),  
      
                            

useShinyjs()
))



## 3. body --------------------------------
body <- dashboardBody( 
  tags$head(
    tags$script("document.title = 'Emigrantes de España'")),
  
  tabItems(
    ## 3.1 Main dashboard ----------------------------------------------------------
    tabItem( tabName = 'dashboard',
             ## contents for the dashboard tab
             div(id = 'main_wait_message',
                 h1('Emigrantes de España 2009 -2012',
                    style = "color:black" , align = "left" ) ,
                 tags$hr()
             ),
             # 1.1 board ---------------------------
             h1(paste0(" ") ,
             fluidRow(
               valueBoxOutput("ExTotBox") %>% withSpinner(type=4),
               valueBoxOutput("ImTotBox"),
               valueBoxOutput("BlTotBox"),
             )
  
             
  ))),


## 1.2 Series de tiempo ----------------------------------------
h2(paste0(" ")),
fluidRow( column( width = 6,h4("Total de Emigrantes", align = 'center'), dygraphOutput ("p")),
          column( width = 6,h4("Total de Emigrantes por Sexo", align = 'center'), dygraphOutput("sex") )
),

div( id = " " ), 
h2(paste0(" ")),
fluidRow( column( width = 6,h4("Promedio de Emigrantes por Mes", align = 'center'), plotlyOutput ("g")),
          column( width = 1,h4("", align = 'right')), 
         column( width = 4,h4("Distribución de Emigrantes por Sexo", align = 'center'), plotOutput("pie") ),
         column( width = 1,h4("", align = 'center'))
))




ui <- 
  dashboardPage(header, siderbar, body )






