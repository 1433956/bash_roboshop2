#!/bin/bash
 source ./common.sh
 app_name="mysql"
 check_root

echo -e "$G pleae enter mysql root psswd::$W"
read -s rootpasswd
echo -e "$G  mysql root psswd:: $rootpasswd $W"
 
dnf install mysql-server -y &>> $LOG_FILE
VALIDATE $? "mysql installation is"  

systemctl enable mysqld   &>> $LOG_FILE
VALIDATE $? "enable mysql "  

systemctl start mysqld  &>> $LOG_FILE
VALIDATE $? "start mysql "  

mysql_secure_installation --set-root-pass $rootpasswd

total_execution_time