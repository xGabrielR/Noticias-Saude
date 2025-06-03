#!/bin/bash 
sleep 10
airflow db migrate 
sleep 5
airflow api-server --port 8080 & airflow scheduler & airflow dag-processor & airflow triggerer