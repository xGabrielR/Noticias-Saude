# Nao é possível utilizar modelos de embedding no Snowflake Cortex Service via terraform

# resource "snowflake_cortex_search_service" "test" {
#   database   = snowflake_database.snowflake_noticias_database.name
#   schema     = "GOLD"
#   warehouse  = snowflake_warehouse.airflow_task_warehouse.name
# 
#   name            = "SEARCH_SERVICES_NOTICIAS"
#   on              = "CHUNK"
#   target_lag      = "1 day"
#   embedding_model = "snowflake-arctic-embed-l-v2.0"
#   
#   query = "SELECT * FROM NEWS_DB.GOLD.NOTICIAS_CHUNK"
# }