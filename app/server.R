library(shiny)
import::from(magrittr, "%>%")

shinyServer(function(input, output) {

  da <- docsCPI::docs %>%
    tidyr::unnest(arquivo)

  output$docs <- reactable::renderReactable({
    da %>%
      dplyr::mutate(
        n = as.integer(n),
        data_recebimento = lubridate::dmy(data_recebimento)
      ) %>%
      reactable::reactable(
        columns = list(
          n = reactable::colDef("N\u00ba", maxWidth = 50),
          arquivo_nome = reactable::colDef("Arquivo"),
          arquivo_link = reactable::colDef(
            "Download", cell = function(value) {
              htmltools::tags$a(href = value, target = "_blank", "PDF")
            },
            maxWidth = 80
          ),
          data_recebimento = reactable::colDef(
            "Data de recebimento", maxWidth = 120
          ),
          remetente = reactable::colDef("Remetente"),
          origem = reactable::colDef("Origem"),
          descricao = reactable::colDef("Descrição", minWidth = 200),
          caixa = reactable::colDef("Caixa", maxWidth = 50)
        ),
        sortable = TRUE,
        filterable = TRUE,
        defaultPageSize = 30
      )

  })

})
