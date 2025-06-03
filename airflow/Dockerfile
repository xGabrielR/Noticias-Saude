FROM python:3.10.12-slim
RUN apt-get update -y && apt-get upgrade -y

RUN pip install "apache-airflow==3.0.1"
COPY ./requirements.txt /root/requirements.txt
RUN pip install --upgrade pip
RUN pip install -r /root/requirements.txt
COPY ./configs/airflow.cfg /root/airflow/airflow.cfg

COPY ./start.sh /root
EXPOSE 8080

RUN chmod +x /root/start.sh
CMD /root/start.sh