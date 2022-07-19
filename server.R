library(shiny)
library(dygraphs)

server <- 
  function(input, output, session)  {
    library(shiny)
    library(dygraphs) 
  ##Salida a las gráficas
  output$p<-renderDygraph({p})
  output$sex<-renderDygraph({sex})
  output$pie<-renderPlot(pie)
  output$g<-renderPlotly(g)
  
  ##Salida a la tabla
  output$table<-DT::renderDataTable(tabla_año)
  
  ##Salida a los cuadros con valores totales
  output$ExTotBox <- renderValueBox({
    valueBox(
      paste0(format(tmp_ex_tot,big.mark=',')), "Total de Emigrantes",
      icon = icon('export', lib = 'glyphicon'), # icon("sign-in"),
      color = "navy"
    )
  })
  
  
  output$BlTotBox <- renderValueBox({
    valueBox(
      paste0(format(tmp_hom_tot,big.mark=',')), "Hombres Emigrantes",
      icon = shiny::icon("mars"),
      color = "aqua"
    )
  })
  
  output$ImTotBox <- renderValueBox({
    valueBox(
      paste0(format(tmp_muj_tot,big.mark=',')), "Mujeres Emigrantes",
      icon = shiny::icon("venus"), 
      color = "blue"
    )
  })
  
  tabItems(tabItem(tabName = "datos", 
                   DT::dataTableOutput("Tabla_año")))
  
}
