# -*- encoding: utf-8 -*-
"""
@File    :  stock_etl_twse_en.py
@Time    :  2022/11/30 09:04:55
@Author  :  Lewis Lin
@Desc    :  None
"""
from airflow.decorators import dag
from airflow.utils.dates import days_ago

from airflow.operators.empty import EmptyOperator
from airflow.providers.ssh.operators.ssh import SSHOperator


default_args = {
    'owner': 'airflow',
}

@dag(
    default_args=default_args,
    schedule_interval=None,
    start_date=days_ago(2),
    tags=['stock', 'crawler', 'twse']
)
def stock_crawler_twse_en():

    start = EmptyOperator(task_id='start')

    get_candidate_dates = SSHOperator(
        task_id='get_candidate_dates',
        ssh_conn_id='',
        command=''
    )

    data_process = SSHOperator(
        task_id='data_process',
        ssh_conn_id='',
        command=''
    )

    end = EmptyOperator(task_id='end')

    start >> get_candidate_dates >> data_process >> end


stock_crawler_twse_en_dag = stock_crawler_twse_en()
