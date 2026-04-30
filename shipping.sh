#!/bin/bash
source ./common.sh
app_name="shipping"

check_root
app_setup
maven_setup
system_setup

echo -e "$G pleae enter mysql root psswd::$W"
read -s rootpasswd

dnf list --installed mysql &>> $LOG_FILE
if [ $? -eq 1 ]
then 
   dnf install mysql -y &>> $LOG_FILE
   echo -e "$G not installed in machine installing mysql $W" &>> $LOG_FILE
else
   echo -e "$Y installed in machine Skipping installing mysql $W" &>> $LOG_FILE
   VALIDATE $? "alreday insatlled, Skipping installing mysql is "
   
fi 

VALIDATE $? "install mysql client in shipping client " &>> $LOG_FILE

mysql -h mysql.devops26.sbs -uroot -p$rootpasswd -e 'use cities'  &>> $LOG_FILE

if [ $? -ne 0 ]
then
    echo $R data is not loaded.. $Y Data loading $W" &>> $LOG_FILE
    mysql -h mysql.devops26.sbs -uroot -p$rootpasswd < /app/db/schema.sql &>> $LOG_FILE
    mysql -h mysql.devops26.sbs -uroot -p$rootpasswd < /app/db/app-user.sql  &>> $LOG_FILE
    mysql -h mysql.devops26.sbs -uroot -p$rootpasswd < /app/db/master-data.sql &>> $LOG_FILE
    VALIDATE $? "data loaded is "
else
   echo $G data is  loaded.. $Y Data loading is skipped:: $W" &>> $LOG_FILE
   VALIDATE $? "data loadeding skipped "
fi


systemctl restart shipping
VALIDATE $? "restart shipping service  "

End_time=$(date +%s)

Total_execution_time=$(($End_time - $Start_time))

echo -e " $G Total_execution_time:: $Total_execution_time:: $W"
 

