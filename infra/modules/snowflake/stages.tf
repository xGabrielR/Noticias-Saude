
resource "snowflake_file_format" "s3_json_landing_bucket_file_format" {
  name        = "S3_JSON_LANDING_BUCKET_FILE_FORMAT"
  database    = snowflake_database.snowflake_noticias_database.name
  schema      = "STAGE"
  format_type = "JSON"

  strip_null_values          = true
  replace_invalid_characters = true
  strip_outer_array          = true

  depends_on = [snowflake_schema.snowflake_noticias_database_schemas]

}

resource "snowflake_stage" "s3_json_landing_bucket" {
  name        = "S3_JSON_LANDING_BUCKET"
  url         = "s3://ev-dr-landing/"
  database    = snowflake_database.snowflake_noticias_database.name
  schema      = "STAGE"
  credentials = "AWS_KEY_ID='' AWS_SECRET_KEY=''"
  file_format = "FORMAT_NAME = ${snowflake_file_format.s3_json_landing_bucket_file_format.fully_qualified_name}"

  depends_on = [snowflake_schema.snowflake_noticias_database_schemas]

}