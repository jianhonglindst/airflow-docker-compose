#-------------------------------------------------------------------------------
FROM apache/airflow:2.4.0-python3.8 as lewis-airflow

USER root

ARG ssh_prv_key
ARG ssh_pub_key

RUN apt-get update \
  && apt-get install -y git \
  && apt-get install -y --no-install-recommends \
         vim \
         git \
         openssh-server \
         libmysqlclient-dev \
  && apt-get autoremove -yqq --purge \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/*

USER airflow

# Authorize SSH Host
RUN mkdir -p /home/airflow/.ssh && \
    chmod 0700 /home/airflow/.ssh && \
    ssh-keyscan github.com > /home/airflow/.ssh/known_hosts

# Add the keys and set permissions
RUN echo "$ssh_prv_key" > /home/airflow/.ssh/id_rsa && \
    echo "$ssh_pub_key" > /home/airflow/.ssh/id_rsa.pub && \
    chmod 600 /home/airflow/.ssh/id_rsa && \
    chmod 600 /home/airflow/.ssh/id_rsa.pub

# for package
COPY requirements.txt .

RUN pip install --upgrade pip \
  &&  pip install -r requirements.txt --no-cache-dir --user

# Remove SSH keys
RUN rm -rf /home/airflow/.ssh/

#-------------------------------------------------------------------------------
FROM alpine:edge as lewis-socat

ARG VERSION=1.7.4.3-r1

RUN apk update && apk --no-cache add socat=${VERSION}

ENTRYPOINT ["socat"]
