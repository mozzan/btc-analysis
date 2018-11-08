#!/bin/bash
set -x
set -e

if [ "$#" -lt 1 ]; then
echo "usage: $0 [start|stop]"
exit -1
fi

BASE_DIR=`dirname $0`
cd $BASE_DIR

COMMAND=$1

case $COMMAND in
 start)
    WORKERS="--num-workers=3"
    gcloud dataproc clusters create cluster-1 \
    --zone asia-northeast1-b \
    --initialization-actions=\
gs://dataproc-initialization-actions/tez/tez.sh,\
gs://btc-analysis-tw/softwares/configure-hive-spark-integration.sh,\
gs://dataproc-initialization-actions/jupyter/jupyter.sh,\
gs://btc-analysis-tw/softwares/create-database.sh \
    --scopes sql,sql-admin \
    --image-version 1.1 \
    --metadata "hive-metastore-instance=btc-20181105:asia-east1:btc-analysis-tw" \
    --properties=hive:hive.exec.dynamic.partition.mode=nonstrict,\
hive:hive.exec.compress.output=true,\
hive:mapred.output.compression.codec=com.hadoop.compression.lzo.LzoCodec,\
hive:hive.metastore.warehouse.dir=gs://btc-analysis-tw/hive-warehouse \
    --initialization-action-timeout=30m \
    $WORKERS \
    --worker-machine-type=n1-standard-1 \
    --master-machine-type=n1-standard-1
    ;;
  stop)
    yes | gcloud dataproc clusters delete cluster-1
    ;;
  check_and_terminate)
    gcloud compute scp ~/git/btc-analysis/softwares/should_terminate_cluster.python cluster-1-m:
    SHOULD_TERMINATE=`gcloud compute ssh cluster-1-m --command='python should_terminate_cluster.python'`
    echo "Should Terminate: $SHOULD_TERMINATE"
    if [[ "$SHOULD_TERMINATE" == 1 ]]; then
        yes | gcloud dataproc clusters delete cluster-1
    fi
esac
