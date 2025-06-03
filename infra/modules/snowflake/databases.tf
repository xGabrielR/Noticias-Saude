resource "snowflake_database" "snowflake_noticias_database" {
  name    = "NEWS_DB"
  comment = "Terraform Database"

  is_transient                                  = false
  quoted_identifiers_ignore_case                = false
  enable_console_output                         = false
  data_retention_time_in_days                   = 1
  max_data_extension_time_in_days               = 1
  replace_invalid_characters                    = true
  default_ddl_collation                         = "en_US"
  storage_serialization_policy                  = "OPTIMIZED"
  log_level                                     = "INFO"
  trace_level                                   = "ALWAYS"
  suspend_task_after_num_failures               = 1
  task_auto_retry_attempts                      = 1
  user_task_managed_initial_warehouse_size      = "X-SMALL"
  user_task_timeout_ms                          = 1800000
  user_task_minimum_trigger_interval_in_seconds = 120
}

resource "snowflake_schema" "snowflake_noticias_database_schemas" {
  for_each = toset(var.default_database_schemas)
  name     = each.key

  database = snowflake_database.snowflake_noticias_database.name
}

