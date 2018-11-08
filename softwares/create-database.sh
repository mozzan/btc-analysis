#!/bin/bash

## gsutil cp xx yy

cd /usr/lib/spark/lib/
wget --no-check-certificate  "http://dev.polipoli.com.tw/btc-analysis/json-serde-1.3.7-jar-with-dependencies.jar" -O json-serde-1.3.7-jar-with-dependencies.jar

SQL="CREATE DATABASE IF NOT EXISTS \`btc_analysis\`;
use \`btc_analysis\`;
CREATE TABLE \`block\`(
  \`hash\` string,
  \`confirmations\` string,
  \`size\` string,
  \`strippedsize\` string,
  \`weight\` string,
  \`height\` string,
  \`version\` string,
  \`versionHex\` string,
  \`merkleroot\` string,
  \`tx\` array<string>,
  \`time\` string,
  \`mediantime\` string,
  \`nonce\` string,
  \`bits\` string,
  \`difficulty\` float,
  \`chainwork\` string,
  \`previousblockhash\` string,
  \`nextblockhash\` string)
ROW FORMAT SERDE
  'org.apache.hive.hcatalog.data.JsonSerDe'
STORED AS INPUTFORMAT
  'org.apache.hadoop.mapred.TextInputFormat'
OUTPUTFORMAT
  'org.apache.hadoop.hive.ql.io.HiveIgnoreKeyTextOutputFormat';
CREATE TABLE \`tx\`(
  \`in_active_chain\` boolean,
  \`hex\` string,
  \`txid\` string,
  \`hash\` string,
  \`size\` string,
  \`vsize\` string,
  \`version\` string,
  \`locktime\` string,
  \`vin\` array<struct<txid:string,vout:string,scriptSig:struct<asm:string,hex:string>,sequence:string,txinwitness:array<string>>>,
  \`vout\` array<struct<value:string,n:string,scriptPubKey:struct<asm:string,hex:string,reqSigs:string,type:string,addresses:array<string>>>>,
  \`blockhash\` string,
  \`confirmations\` string,
  \`time\` string,
  \`blocktime\` string)
ROW FORMAT SERDE
  'org.apache.hive.hcatalog.data.JsonSerDe'
STORED AS INPUTFORMAT
  'org.apache.hadoop.mapred.TextInputFormat'
OUTPUTFORMAT
  'org.apache.hadoop.hive.ql.io.HiveIgnoreKeyTextOutputFormat';
"
echo "$SQL"
spark-sql -e "$SQL"


