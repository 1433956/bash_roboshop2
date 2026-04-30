#!/bin/bash
 source ./common.sh
 check_root

dnf list --installed mysql-server &>> $LOG_FILE

if [ $? -ne 0 ]
then
   echo -e "$R mysql not installed going to install  $W" &>> $LOG_FILE 
   dnf install mysql-server -y &>> $LOG_FILE
else
   echo -e "$G mysql  installed in machine :: $Y skipping::  $W" &>> $LOG_FILE
   
fi

VALIDATE $? "mysql installation is"  &>> $LOG_FILE

systemctl enable mysqld   &>> $LOG_FILE
VALIDATE $? "enable mysql "  &>> $LOG_FILE

systemctl start mysqld  &>> $LOG_FILE
VALIDATE $? "start mysql "  &>> $LOG_FILE

echo -e "$G pleae enter mysql root psswd::$W"
read -s rootpasswd
echo -e "$G  mysql root psswd:: $rootpasswd $W"

mysql_secure_installation --set-root-pass $rootpasswd

total_execution_time