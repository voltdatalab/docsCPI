# Download + parse table
docs <- docsCPI::get_table()
usethis::use_data(docs, overwrite = TRUE)
