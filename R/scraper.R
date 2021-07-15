library(magrittr)

#' get_table
#'
#' @return tibble
#' @export
#'
get_table <- function() {
  url <- "https://legis.senado.leg.br/comissoes/docsRecCPI?codcol=2441"
  r <- httr::GET(url)
  html <- xml2::read_html(r)
  rows <- xml2::xml_find_all(html, "//tr")
  # res <- dplyr::tibble()
  # for (i in 1:1818) {
  #   message(i)
  #   linha <- parse_row(rows[i])
  #   res <- dplyr::bind_rows(res, linha)
  # }
  rows %>%
    purrr::map_dfr(parse_row) %>%
    dplyr::slice(-1)
}

#' get_doclink
#'
#' @param docname document name
#' @param campos xml nodes for columns
#'
#' @return url string
#'
get_doclink <- function(docname, campos) {
  campos[2] %>%
    xml2::xml_find_all(stringr::str_c(
      ".//a[contains(text(), '",
      docname,
      "')]"
    )) %>%
    xml2::xml_attr("href")
}

#' parse_row
#'
#' @param row xml node for row
#'
#' @return one row tibble
#'
parse_row <- function(row) {
  campos <- row %>%
    xml2::xml_children()

  n <- xml2::xml_text(campos[1])
  arquivo_nome <- campos[2] %>%
    xml2::xml_find_all(".//li") %>%
    xml2::xml_text()

  arquivo_link <- purrr::map(arquivo_nome, get_doclink, campos = campos)

  campos[2] %>%
    xml2::xml_find_all(stringr::str_c(
      ".//a[contains(text(), '",
      arquivo_nome[3],
      "')]"
    ))

  arquivo <- dplyr::tibble(
    arquivo_nome = arquivo_nome,
    arquivo_link = arquivo_link
  )
  data_recebimento <- stringr::str_squish(xml2::xml_text(campos[3]))
  remetente <- stringr::str_squish(xml2::xml_text(campos[4]))
  origem <- stringr::str_squish(xml2::xml_text(campos[5]))
  descricao <- stringr::str_squish(xml2::xml_text(campos[6]))
  caixa <- stringr::str_squish(xml2::xml_text(campos[7]))

  # em_resposta_of <- campos[8] %>%
  #   xml2::xml_find_all(".//p") %>%
  #   xml2::xml_text() %>%
  #   stringr::str_squish()
  # em_resposta_req <- campos[8] %>%
  #   xml2::xml_find_all(".//div") %>%
  #   xml2::xml_text() %>%
  #   stringr::str_squish()
  # em_resposta_req_link <- campos[8] %>%
  #   xml2::xml_find_all(".//div/a") %>%
  #   xml2::xml_attr("href")
  #
  # em_resposta_req <- dplyr::tibble(
  #   req = em_resposta_req,
  #   link = em_resposta_req_link
  # ) %>%
  #   tidyr::nest(em_resposta_req = c(req, link))

  res <- dplyr::tibble(
    n = n,
    arquivo = list(arquivo),
    data_recebimento = data_recebimento,
    remetente = remetente,
    origem = origem,
    descricao = descricao,
    caixa = caixa
    # em_resposta_of = em_resposta_of,
    # em_resposta_req = em_resposta_req
  )
  res
}

#' Documentos recebidos
#'
#' Informações sobre documentos recebidos na CPI da Pandemia
#'
#' @format Tabela com 7 colunas:
#' \describe{
#'   \item{n}{número}
#'   \item{arquivo}{lista de arquivos}
#'   \item{data_recebimento}{data de recebimento}
#'   \item{remetente}{remetente}
#'   \item{origem}{origem}
#'   \item{descricao}{descrição}
#'   \item{caixa}{caixa}
#' }
#'
#' @name docs
"docs"


