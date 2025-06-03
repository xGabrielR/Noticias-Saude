resource "snowflake_warehouse" "airflow_task_warehouse" {
  name           = "AIRFLOW_WAREHOUSE"
  comment        = "Default Warehouse for DBT jobs"
  warehouse_type = "STANDARD"
  warehouse_size = "X-SMALL"
  scaling_policy = "ECONOMY"

  max_cluster_count   = 1
  min_cluster_count   = 1
  auto_suspend        = 1200
  auto_resume         = true
  initially_suspended = true
  # resource_monitor                    = snowflake_resource_monitor.monitor.fully_qualified_name
  enable_query_acceleration           = false
  query_acceleration_max_scale_factor = 4
  max_concurrency_level               = 4
  statement_queued_timeout_in_seconds = 5
  statement_timeout_in_seconds        = 86400
}