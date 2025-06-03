variable "default_database_schemas" {
  default = [
    "BRONZE",
    "SILVER",
    "GOLD",
    "STAGE"
  ]
}