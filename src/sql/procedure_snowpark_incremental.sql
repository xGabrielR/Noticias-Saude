CREATE OR REPLACE PROCEDURE NEWS_DB.STAGE.LANDING_TO_BRONZE("TABLE_NAME" VARCHAR)
RETURNS VARCHAR
LANGUAGE PYTHON
RUNTIME_VERSION = '3.11'
PACKAGES = ('snowflake-snowpark-python')
HANDLER = 'main'
EXECUTE AS OWNER
AS 'import snowflake.snowpark as snowpark
from snowflake.snowpark import functions as pf

from datetime import datetime
from pytz import timezone

def main(session: snowpark.Session, table_name: str):
    #table_name="TEST1"
    schema_name="STAGE"
    database_name="NEWS_DB"
    
    # Stage Pipeline
    ingestion_stage_table_workflow(
        session=session,
        table_name=table_name,
        schema_name=schema_name,
        database_name=database_name
    )
    
    # Bronze Pipeline
    ingestion_bronze_table_workflow(
        session=session,
        table_name=table_name,
        schema_name="BRONZE",
        database_name=database_name
    )
    
    return ''None''

def create_bronze_table_if_not_exists(
    session: snowpark.Session,
    table_name: str = "TEST1",
    database_name: str = "NEWS_DB",
    schema_name: str = "BRONZE"
):
    return session.sql(f"""
    CREATE TABLE IF NOT EXISTS {database_name}.{schema_name}.{table_name} (
        SRC VARIANT,
        _mt_snowflake_scan_time TIMESTAMP,
        _mt_america_sao_paulo_scan_time DATE,
        _mt_ingest_filepath VARCHAR
    );
    """).show()

def ingestion_bronze_table_current_date(
    session: snowpark.Session,
    table_name: str = "TEST1",
    database_name: str = "NEWS_DB",
    schema_name: str = "BRONZE"
):
    tbl = f"{database_name}.{schema_name}.{table_name}"
    
    session.sql(f"""
        DELETE FROM {tbl}
        WHERE _mt_america_sao_paulo_scan_time::DATE = (
            SELECT MAX(_mt_america_sao_paulo_scan_time::DATE)
            FROM {database_name}.STAGE.{table_name});
    """).show()

    session.sql(f"""
        INSERT INTO {tbl}
        SELECT * FROM {database_name}.STAGE.{table_name};
    """).show()

def ingestion_bronze_table_workflow(
    session: snowpark.Session,
    table_name: str = "TEST1",
    database_name: str = "NEWS_DB",
    schema_name: str = "BRONZE"
):
    tbl = f"{database_name}.{schema_name}.{table_name}"

    create_bronze_table_if_not_exists(
        session=session,
        table_name=table_name,
        schema_name=schema_name,
        database_name=database_name
    )

    ingestion_bronze_table_current_date(
        session=session,
        table_name=table_name,
        schema_name=schema_name,
        database_name=database_name
    )
    

    
def ingestion_stage_table_current_date(
    session: snowpark.Session,
    table_name: str = "TEST1",
    database_name: str = "NEWS_DB",
    schema_name: str = "STAGE",
):
    tbl = f"{database_name}.{schema_name}.{table_name}"
    current_date = datetime.now(timezone("America/Sao_Paulo")).strftime("%Y/%m/%d")
    current_date = "2025/01/01"

    return session.sql(f"""
    CREATE OR REPLACE TABLE {tbl}
    AS SELECT 
        $1 AS SRC,
        METADATA$START_SCAN_TIME::TIMESTAMP AS _mt_snowflake_scan_time,
        to_date(''{current_date}'', ''YYYY/MM/DD'') AS _mt_america_sao_paulo_scan_time,
        METADATA$FILENAME AS _mt_ingest_filepath
    FROM @s3_json_landing_bucket/{table_name.lower()}/{current_date}/;
    """).show()
    

def ingestion_stage_table_workflow(
    session: snowpark.Session,
    table_name: str = "TEST1",
    database_name: str = "NEWS_DB",
    schema_name: str = "STAGE",
    ingest_current_date: bool = True
):
    # Ingest current date files from S3 Bucket
    if ingest_current_date:
        ingestion_stage_table_current_date(
            session=session,
            table_name=table_name,
            database_name=database_name,
            schema_name=schema_name
        )
            
    # Ingest based on last bronze table execution
    # Add Logic to incremental reads 
    else:
        pass
';