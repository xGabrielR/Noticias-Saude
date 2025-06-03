
resource "snowflake_user" "airflow_task_user" {
  name         = "AIRFLOW_USER"
  login_name   = "AIRFLOW_USER"
  first_name   = "AIRFLOW"
  middle_name  = "AIRFLOW"
  last_name    = "AIRFLOW"
  display_name = "AIRFLOW"
  comment      = "User for Airflow DBT jobs."
  password     = "AIRFLOW" # get password from AWS Secrets

  disabled             = false
  must_change_password = false
  disable_mfa          = true

  default_warehouse = snowflake_warehouse.airflow_task_warehouse.fully_qualified_name
  default_role      = snowflake_account_role.airflow_task_role.name

}