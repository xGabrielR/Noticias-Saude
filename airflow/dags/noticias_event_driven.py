import os
from pathlib import Path
from datetime import datetime, timedelta

from airflow import DAG
from airflow.sdk import Asset, AssetWatcher, Variable, dag, task

from airflow.operators.empty import EmptyOperator
from airflow.providers.common.messaging.triggers.msg_queue import MessageQueueTrigger

from cosmos import ProjectConfig, ProfileConfig, DbtTaskGroup
from cosmos.profiles import SnowflakeUserPasswordProfileMapping

SQS_QUEUE = "https://sqs.us-east-2.amazonaws.com/ACCOUNT-ID/noticias"

trigger = MessageQueueTrigger(
    aws_conn_id="aws_default",
    queue=SQS_QUEUE,
    waiter_delay=30 * 2,
    max_messages=1,
    num_batches=1,
    delete_message_on_reception=True
)

sqs_queue_asset = Asset(
    "sqs_queue_asset",
    watchers=[
        AssetWatcher(
            name="sqs_watcher",
            trigger=trigger
        )
    ]
)

default_dbt_root_path = Path(__file__).parent / "dbt"
dbt_root_path = Path(os.getenv("DBT_ROOT_PATH", default_dbt_root_path))

profile_config = ProfileConfig(
    profile_name="analytics",
    target_name="dev",
    profile_mapping=SnowflakeUserPasswordProfileMapping(
        conn_id="snowflake_default",
        profile_args={
            "database": "NEWS_DB",
            "schema": "BRONZE",
            "user": Variable.get("SNOWFLAKE_AIRFLOW_USER", default="AIRFLOW"),
            "password": Variable.get("SNOWFLAKE_AIRFLOW_PASSWORD"),
            "account": Variable.get("SNOWFLAKE_ACCOUNT")
        },
    ),
)

DEFAULT_ARGS = {
    "retries": 0,
    "depends_on_past": False
}

@dag(
    schedule=[sqs_queue_asset],
    max_active_runs=1,
    default_args=DEFAULT_ARGS,
    dagrun_timeout=timedelta(minutes=120),
    description="Workflow Processing Data Engineering in Snowflake",
)
def noticias_event_driven_dag():
    start = EmptyOperator(task_id="start")
    end = EmptyOperator(task_id="end")

    analytics = DbtTaskGroup(
        project_config=ProjectConfig(
            (dbt_root_path / "analytics").as_posix()
        ),
        profile_config=profile_config,
        operator_args={
            "install_deps": True
        }
    )

    start >> analytics >> end

noticias_event_driven_dag()