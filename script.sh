source .env
if [ -z ${AIRFLOW_UID} ]; then echo -e "\nAIRFLOW_UID=$(id -u)" >> .env; fi

# docker build -t lewis/airflow:2.3.3 --build-arg ssh_prv_key="$(cat ~/.ssh/id_rsa)" --build-arg ssh_pub_key="$(cat ~/.ssh/id_rsa.pub)" .
docker-compose down --remove-orphans
docker-compose up --force-recreate airflow-init
docker-compose up
