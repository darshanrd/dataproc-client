# Copyright 2019 Google, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
# http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

#define parameters which are passed in
OLD_TARGET_CLUSTER=$1
YOUR_PROJECT=$2
YOUR_TARGET_CLUSTER=$3
YOUR_CLIENT=$4


#define the template
cat  << EOF
#!/bin/bash
sleep 45;
sudo sed -i "s/${OLD_TARGET_CLUSTER}-m/${YOUR_TARGET_CLUSTER}-m/g" /etc/hadoop/conf/core-site.xml /etc/hadoop/conf/hdfs-site.xml /etc/hadoop/conf/mapred-site.xml /etc/hadoop/conf/yarn-site.xml;
sudo sed -i "s/${YOUR_CLIENT}-m/${YOUR_TARGET_CLUSTER}-m/g" /etc/hadoop/conf/core-site.xml /etc/hadoop/conf/hdfs-site.xml /etc/hadoop/conf/mapred-site.xml /etc/hadoop/conf/yarn-site.xml;
sudo sed -i "s/${OLD_TARGET_CLUSTER}-m/${YOUR_TARGET_CLUSTER}-m/g" /etc/hive/conf/hive-site.xml;
sudo sed -i "s/${YOUR_CLIENT}-m/${YOUR_TARGET_CLUSTER}-m/g" /etc/spark/conf/spark-defaults.conf;
sudo sed -i "s/${OLD_TARGET_CLUSTER}-m/${YOUR_TARGET_CLUSTER}-m/g" /etc/spark/conf/spark-defaults.conf;
/etc/spark/conf/spark-env.sh;
sudo service spark-history-server restart;
sudo perl -pi -e s/hive_server_host=${OLD_TARGET_CLUSTER}-m.c.${YOUR_PROJECT}.internal/hive_server_host=${YOUR_TARGET_CLUSTER}-m.c.${YOUR_PROJECT}.internal/ /etc/hue/conf/hue.ini;
sudo systemctl restart hue;
EOF
