#' Tabela de requerimentos
#'
#' @param apreciado requerimento apreciado ou não (TRUE, FALSE)
#'
#' @return tibble
#' @export
table_reqs <- function(apreciado = TRUE) {
  if (apreciado) {
    url <- stringr::str_c(
      "https://legis.senado.leg.br/comissoes/reqsCPI?0&codcol=2441&aprc=true&",
      "prej_retir=false&susp=false"
    )
  } else {
    url <- stringr::str_c(
      "https://legis.senado.leg.br/comissoes/reqsCPI?3&codcol=2441&aprc=false&",
      "prej_retir=false&susp=false"
    )
  }
  r <- xml2::read_html(url)
  rows <- xml2::xml_find_all(r, "//tr")
  rows <- magrittr::extract(rows, -1)
  purrr::map_df(rows, parse_row_reqs) %>%
    # lidar com os ofícios etc depois
    dplyr::filter(!is.na(n)) %>%
    dplyr::select(-c(oficio, docs_recebidos))
}

#' Parse rows
#'
#' @param row xml node for row
#'
#' @return one row tibble
parse_row_reqs <- function(row) {
  tipo <- xml2::xml_attr(row, "style")
  campos <- xml2::xml_children(row)
  if (is.na(tipo)) {
    n <- campos[1] %>%
      xml2::xml_find_all("a") %>%
      xml2::xml_text()
    n_link <- campos[1] %>%
      xml2::xml_find_all("a") %>%
      xml2::xml_attr("href")
    data_apresentacao <- xml2::xml_text(campos[2])
    ementa <- xml2::xml_text(campos[3])
    autoria <- xml2::xml_text(campos[4])
    situacao <- xml2::xml_text(campos[5]) %>% stringr::str_squish()
    dplyr::tibble(
      n,
      n_link,
      data_apresentacao,
      ementa,
      autoria,
      situacao
    )
  } else {
    oficio <- campos[2] %>%
      xml2::xml_children() %>%
      xml2::xml_children() %>%
      xml2::xml_children() %>%
      xml2::xml_text() %>%
      stringr::str_squish()
    oficio_link <- campos[2] %>%
      xml2::xml_children() %>%
      xml2::xml_children() %>%
      xml2::xml_children() %>%
      xml2::xml_attr("href")
    if (length(campos) > 2) {
      docs_recebidos <- campos[4] %>%
        xml2::xml_children() %>%
        xml2::xml_children() %>%
        xml2::xml_children() %>%
        xml2::xml_children() %>%
        xml2::xml_text()
      docs_recebidos_link <- campos[4] %>%
        xml2::xml_children() %>%
        xml2::xml_children() %>%
        xml2::xml_children() %>%
        xml2::xml_children() %>%
        xml2::xml_contents() %>%
        as.character() %>%
        stringr::str_extract("(?<=href=\").+(?=\")")
    } else {
      docs_recebidos <- NA
      docs_recebidos_link <- NA
    }
    oficio <- dplyr::tibble(oficio, oficio_link)
    docs_recebidos <- dplyr::tibble(docs_recebidos, docs_recebidos_link)
    dplyr::tibble(oficio = list(oficio), docs_recebidos = list(docs_recebidos))
  }
}

