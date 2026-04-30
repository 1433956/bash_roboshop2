#!/bin/bash
source ./common.sh

check_root

dnf module disable nginx -y &>> $LOG_FILE
VALIDATE $? "disabling nginx module"

dnf module enable nginx:1.24 -y &>> $LOG_FILE
VALIDATE $? "enable nginx module"


dnf install nginx -y &>> $LOG_FILE

VALIDATE $? "install nginx "

systemctl enable nginx &>> $LOG_FILE
VALIDATE $? "enable nginx "
systemctl start nginx 
VALIDATE $? "start nginx "

rm -rf /usr/share/nginx/html/* &>> $LOG_FILE
VALIDATE $? "removing default content "

curl -o /tmp/frontend.zip https://roboshop-artifacts.s3.amazonaws.com/frontend-v3.zip &>> $LOG_FILE
VALIDATE $? "downloading code "

cd /usr/share/nginx/html 
rm -rf /etc/nginx/nginx.conf &>>$LOG_FILE
VALIDATE $? "delete nginx conf code "
unzip /tmp/frontend.zip &>> $LOG_FILE

VALIDATE $? "unzipping code "
cp $current_directory/nginx.conf /etc/nginx/nginx.conf

systemctl restart nginx &>> $LOG_FILE

VALIDATE $? "restart nginx "




   