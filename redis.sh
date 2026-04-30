#!/bin/bash
 source ./common.sh
 check_root

dnf module disable redis -y &>> $LOG_FILE

VALIDATE $? "disable  latest redis version "

dnf module enable redis:7 -y &>> $LOG_FILE

VALIDATE $? "enable  redis version of 7 "

dnf list --installed redis &>> $LOG_FILE

if [ $? -ne 0 ]
then
   echo -e "$R redis not installed going to install  $W" &>> $LOG_FILE 
   dnf install redis -y &>> $LOG_FILE
else
   echo -e "$G redis  installed in machine :: $Y skipping::  $W" &>> $LOG_FILE
   
fi
VALIDATE $? "install  redis version of 7 "

sed -i -e 's/127.0.0.1/0.0.0.0/g' -e '/protected-mode/ c protected-mode no' /etc/redis/redis.conf

VALIDATE $? "redis conf change"

systemctl enable redis &>> $LOG_FILE
VALIDATE $? "enable redis " 
systemctl start redis  &>> $LOG_FILE
VALIDATE $? "start redis " 

total_execution_time



