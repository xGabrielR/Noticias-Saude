resource "snowflake_account_role" "airflow_task_role" {
  name    = "AIRFLOW_ROLE"
  comment = "Role for Airflow jobs."

  depends_on = [snowflake_schema.snowflake_noticias_database_schemas]
  
}

resource "snowflake_grant_privileges_to_account_role" "airflow_task_grant_database" {
  privileges        = ["USAGE"]
  account_role_name = snowflake_account_role.airflow_task_role.name
  on_account_object {
    object_type = "DATABASE"
    object_name = snowflake_database.snowflake_noticias_database.name
  }
}

resource "snowflake_grant_privileges_to_account_role" "airflow_task_grant_warehouse" {
  privileges        = ["USAGE", "OPERATE"]
  account_role_name = snowflake_account_role.airflow_task_role.name
  on_account_object {
    object_type = "WAREHOUSE"
    object_name = snowflake_warehouse.airflow_task_warehouse.name
  }
}

resource "snowflake_grant_privileges_to_account_role" "airflow_task_grant_schema" {
  privileges = ["USAGE", "CREATE TABLE", "CREATE VIEW"]
  # ["SELECT ON ALL TABLES", "SELECT ON FUTURE TABLES"] # SYNTAX ERROR 

  account_role_name = snowflake_account_role.airflow_task_role.name
  for_each          = toset(var.default_database_schemas)
  on_schema {
    schema_name = "${snowflake_database.snowflake_noticias_database.name}.${each.key}"
  }

}

resource "snowflake_grant_privileges_to_account_role" "airflow_task_grant_table" {
  privileges = ["SELECT", "INSERT"]

  account_role_name = snowflake_account_role.airflow_task_role.name
  for_each          = toset(var.default_database_schemas)
  on_schema_object {
    all {
      object_type_plural = "TABLES"
      in_schema          = "${snowflake_database.snowflake_noticias_database.name}.${each.key}"
    }
  }
}