# Download + parse table
docs <- docsCPI::table_docs()
usethis::use_data(docs, overwrite = TRUE)

req_apreciados <- docsCPI::table_reqs(TRUE)
usethis::use_data(req_apreciados, overwrite = TRUE)

req_nao_apreciados <- docsCPI::table_reqs(FALSE)
usethis::use_data(req_nao_apreciados, overwrite = TRUE)
