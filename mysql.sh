#!/bin/bash
 source ./common.sh
 app_name="mysql"
 check_root

echo -e "$G pleae enter mysql root psswd::$W"
read -s rootpasswd
echo -e "$G  mysql root psswd:: $rootpasswd $W"
 
dnf install mysql-server -y &>> $LOG_FILE
VALIDATE $? "mysql installation is"  &>> $LOG_FILE

systemctl enable mysqld   &>> $LOG_FILE
VALIDATE $? "enable mysql "  &>> $LOG_FILE

systemctl start mysqld  &>> $LOG_FILE
VALIDATE $? "start mysql "  &>> $LOG_FILE

mysql_secure_installation --set-root-pass $rootpasswd

total_execution_time