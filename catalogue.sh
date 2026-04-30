#!/bin/bash

source ./common.sh
app_name="catalogue"
nodejs_setup
app_setup
system_setup

 cp $current_directory/mongo.repo  /etc/yum.repos.d/mongo.repo &>> $LOG_FILE

 VALIDATE $? "copy mongo repo "

 dnf install mongodb-mongosh -y &>>$LOG_FILE

 VALIDATE $? "installing mongodb client "

 DBStatus=$(mongosh --host mongodb.devops26.sbs --eval 'db.getMongo().getDBNames().indexOf("catalogue")')

if [ $DBStatus -lt 0 ]
then
    echo -e "$G data is not load, going to load data $W" | tee -a $LOG_FILE

    mongosh --host mongodb.devops26.sbs </app/db/master-data.js &>>$LOG_FILE
else 
     echo -e "Data is already loaded ... $Y SKIPPING $N"
fi
End_time=$(date +%s)
systemctl restart catalogue &>> $LOG_FILE
VALIDATE $? "restart  catalogue "

Total_execution_time=$(($End_time - $Start_time))

echo -e " $G Total_execution_time:: $Total_execution_time:: $W"
 






