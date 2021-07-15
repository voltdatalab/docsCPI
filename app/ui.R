library(shiny)
library(shinydashboard)

ui <- dashboardPage(
    skin = "black",

    # title ----
    dashboardHeader(title = "CPI da Pandemia"),
    # sidebar ----
    dashboardSidebar(
      sidebarMenu(
      id = "sidebarid",
      menuItem("Documentos", tabName = "page1")
    )),

    # body ----
    dashboardBody(tabItems(

      tabItem(
        tabName = "page1",
        fluidRow(
          box(
            width = 12,
            id = "docs",
            title = "Documentos recebidos",
            reactable::reactableOutput("docs")
          )
        )
      )
    ))
)
