#!/bin/bash
source ./common.sh

check_root

cp mongo.repo /etc/yum.repos.d/mongo.repo

dnf install mongodb-org -y &>> $LOG_FILE
VALIDATE $? "installing mongodb"
systemctl enable mongod &>> $LOG_FILE
VALIDATE $? "enable  mongodb"
systemctl start mongod &>> $LOG_FILE
VALIDATE $? "start mongodb"

sed -i "s/127.0.0.1/0.0.0.0/g" /etc/mongod.conf 
VALIDATE $? "channging mongod conf "

systemctl restart mongod &>> $LOG_FILE
VALIDATE $? "restart mongodb"

total_execution_time
