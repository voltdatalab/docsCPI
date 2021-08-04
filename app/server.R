library(shiny)
import::from(magrittr, "%>%")

shinyServer(function(input, output) {

  da <- docsCPI::docs %>%
    tidyr::unnest(arquivo) %>%
    tidyr::unnest(arquivo_link, keep_empty = TRUE)

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

  output$req_votados <- reactable::renderReactable({
    docsCPI::req_apreciados %>%
      dplyr::mutate(
        data_apresentacao = lubridate::dmy(data_apresentacao),
        n = as.numeric(stringr::str_squish(stringr::str_remove(n, "/ 2021")))
      ) %>%
      tidyr::separate(
        situacao, into = c("situacao", "data_apreciacao"),
        sep = " Data de apreciação: "
      ) %>%
      dplyr::mutate(data_apreciacao = lubridate::dmy(data_apreciacao)) %>%
      reactable::reactable(
        columns = list(
          n = reactable::colDef("N\u00ba", maxWidth = 50),
          n_link = reactable::colDef(
            "Download", cell = function(value) {
              htmltools::tags$a(href = value, target = "_blank", "PDF")
            },
            maxWidth = 80
          ),
          data_apresentacao = reactable::colDef(
            "Data de apresentação", maxWidth = 120
          ),
          ementa = reactable::colDef("Descrição", minWidth = 200),
          autoria = reactable::colDef("Autoria"),
          situacao = reactable::colDef("Situação"),
          data_apreciacao = reactable::colDef(
            "Data de apreciação", maxWidth = 120
          )
        ),
        sortable = TRUE,
        filterable = TRUE,
        defaultPageSize = 30
      )
  })
  output$req_nao_apreciados <- reactable::renderReactable({
    docsCPI::req_nao_apreciados %>%
      dplyr::mutate(
        data_apresentacao = lubridate::dmy(data_apresentacao),
        n = as.numeric(stringr::str_squish(stringr::str_remove(n, "/ 2021")))
      ) %>%
      reactable::reactable(
        columns = list(
          n = reactable::colDef("N\u00ba", maxWidth = 50),
          n_link = reactable::colDef(
            "Download", cell = function(value) {
              htmltools::tags$a(href = value, target = "_blank", "PDF")
            },
            maxWidth = 80
          ),
          data_apresentacao = reactable::colDef(
            "Data de apresentação", maxWidth = 120
          ),
          ementa = reactable::colDef("Descrição", minWidth = 200),
          autoria = reactable::colDef("Autoria"),
          situacao = reactable::colDef("Situação")
        ),
        sortable = TRUE,
        filterable = TRUE,
        defaultPageSize = 30
      )
  })

})
