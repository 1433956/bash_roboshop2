#!/bin/bash
source ./common.sh
app_name="shipping"

check_root
app_setup
maven_setup
system_setup

echo -e "$G pleae enter mysql root psswd::$W"
read -s rootpasswd
dnf install mysql -y &>> $LOG_FILE
VALIDATE $? "install mysql client in shipping client " &>> $LOG_FILE

mysql -h mysql.devops26.sbs -u root -p$rootpasswd -e 'use cities' &>>$LOG_FILE
if [ $? -ne 0 ]
then
    mysql -h mysql.devops26.sbs -uroot -p$rootpasswd < /app/db/schema.sql &>>$LOG_FILE
    mysql -h mysql.devops26.sbs -uroot -p$rootpasswd < /app/db/app-user.sql  &>>$LOG_FILE
    mysql -h mysql.devops26.sbs -uroot -p$rootpasswd < /app/db/master-data.sql &>>$LOG_FILE
    VALIDATE $? "Loading data into MySQL"
else
    echo -e "Data is already loaded into MySQL ... $Y SKIPPING $N"
fi

systemctl restart shipping &>> $LOG_FILE
VALIDATE $? "restart shipping service  "

total_execution_time
