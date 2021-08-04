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
      menuItem("Documentos recebidos", tabName = "page1"),
      menuItem("Requerimentos votados", tabName = "page2"),
      menuItem("Requerimentos não apreciados", tabName = "page3")
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
      ),
      tabItem(
        tabName = "page2",
        fluidRow(
          box(
            width = 12,
            id = "docs",
            title = "Requerimentos votados",
            reactable::reactableOutput("req_votados") %>%
              shinycssloaders::withSpinner(type = 8, color = "#444444")
          )
        )
      ),
      tabItem(
        tabName = "page3",
        fluidRow(
          box(
            width = 12,
            id = "docs",
            title = "Requerimentos não apreciados",
            reactable::reactableOutput("req_nao_apreciados") %>%
              shinycssloaders::withSpinner(type = 8, color = "#444444")
          )
        )
      )
    ))
)
