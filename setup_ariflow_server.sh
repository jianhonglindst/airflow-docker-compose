# 讀取環境檔案
source .env
sudo rm -rf "$AIRFLOW_VOLUMES"

# 生成 AIRFLOW 需要的資料夾以及 AIRFLOW_UID
mkdir -p "$AIRFLOW_DAGS" "$AIRFLOW_LOGS" "$AIRFLOW_PLUGINS" "$AIRFLOW_VOLUMES"
if [ -z $AIRFLOW_UID ]; then sed -i "1iAIRFLOW_UID=$(id -u) " .env; fi

# 重新 build & 啟動 Airflow Server
# docker build -t lewis/airflow:2.3.3-python3.8 --build-arg ssh_prv_key="$(cat ~/.ssh/id_rsa)" --build-arg ssh_pub_key="$(cat ~/.ssh/id_rsa.pub)" .
docker-compose down --remove-orphans && \
ssh_prv_key="$(cat ~/.ssh/id_rsa)" ssh_pub_key="$(cat ~/.ssh/id_rsa.pub)" docker-compose build && \
# docker network create airflow-network  && \
docker-compose up airflow-init  && \
docker-compose up -d