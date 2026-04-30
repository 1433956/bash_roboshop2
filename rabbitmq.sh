#!/bin/bash

source ./common.sh
check_root 

cp rabbitmq.repo /etc/yum.repos.d/rabbitmq.repo &>> $LOG_FILE
VALIDATE $? "copy  rabbitmq repo"
echo -e "$G please enter psswd for rabbitmq::"
read -s rabbitmqpwd

   dnf install rabbitmq-server -y &>> $LOG_FILE
   VALIDATE $? "installing rabbit mq"

systemctl enable rabbitmq-server &>> $LOG_FILE
VALIDATE $? "enable rabbitmq-server"
systemctl start rabbitmq-server &>> $LOG_FILE
VALIDATE $? "start rabbitmq-server"

rabbitmqctl add_user roboshop $rabbitmqpwd &>> $LOG_FILE
VALIDATE $? "add user to  rabbitmq-server"
rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*"  &>> $LOG_FILE
VALIDATE $? "set_permissions to  rabbitmq-server"

total_execution_time
