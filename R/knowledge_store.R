library(ragnar)
library(ellmer)

documents <- list.files("raw documents", full.names = TRUE)

store_location <- "darbot.ragnar.duckdb"
store <- ragnar_store_create(
  store_location,
  embed = \(x) embed_ollama(x, model = "snowflake-arctic-embed2:568m"),
  overwrite = TRUE
)

for (doc in documents) {
  message("Ingesting: ", doc, "\n")
  chunks <- doc |> read_as_markdown() |> markdown_chunk()
  ragnar_store_insert(store, chunks)
}

ragnar_store_build_index(store)
