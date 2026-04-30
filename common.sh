#!/bin/bash
Start_time=$(date +%s)

LOG_FOLDER="/var/log/roboshop-logs"
mkdir -p $LOG_FOLDER
LOG_FILENAME=$(echo $0 | cut -d "." -f1)
LOG_FILE="$LOG_FOLDER/$LOG_FILENAME.log"
current_directory=$PWD
R="\e[31m"
G="\e[32m"
Y="\e[33m"
W="\e[0m"
echo -e "$G script started executing at :: $(date) $W"| tee -a $LOG_FILE

check_root(){
  if [ $? -ne 0 ]
  then
     echo -e "$R please log user as root user::  $W" &>> $LOG_FILE
     exit 1
  else 
     echo -e "$G logged as a root user:: $W " &>> $LOG_FILE
  fi
}

  
    VALIDATE(){
    if [ $1 -ne 0 ]
    then 
        echo -e "$R $2 is Failure:: $W" | tee -a $LOG_FILE
        exit 1
    else
        echo -e "$G $2 is Success:: $W" | tee -a $LOG_FILE
    fi

    }


nodejs_setup(){

    dnf module disable nodejs -y  &>> $LOG_FILE
    VALIDATE $? "disabling the nodejs"
    dnf module enable nodejs:20 -y &>> $LOG_FILE
    VALIDATE $? "enable  the nodejs version of 20"
    dnf install nodejs -y &>> $LOG_FILE
    VALIDATE $? "install nodejs"
    npm install &>> $LOG_FILE
    VALIDATE $? "npm installing::"


}

app_setup(){

user=$(id roboshop)

    if [ $? -eq 0 ]
    then 
    echo -e "$Y system user is created skiping user creation::$user $W" | tee -a $LOG_FILE
    
    else
    echo -e "$G system user not created, Creting system user:: $user $W" | tee -a $LOG_FILE
    
    useradd --system --home /app --shell /sbin/nologin  --comment "creating system user" roboshop
    exit 1
    fi

    mkdir -p /app

    VALIDATE $? "creating directory for app"

    rm -rf /app/*

    curl -o /tmp/$app_name.zip https://roboshop-artifacts.s3.amazonaws.com/$app_name-v3.zip  &>>$LOG_FILE
    VALIDATE $? "downloading $app_name code "

    cd /app 
    unzip /tmp/$app_name.zip  &>>$LOG_FILE
    VALIDATE $? "unziping the $app_name folder"

}

system_setup(){
    
    cp $current_directory/$app_name.service /etc/systemd/system/$app_name.service &>> $LOG_FILE
    VALIDATE $? "copying  $app_name service" 

    systemctl daemon-reload &>> $LOG_FILE

    VALIDATE $? "daemon reload " 

    systemctl enable $app_name &>> $LOG_FILE
    VALIDATE $? "enable $app_name "
    systemctl start $app_name &>> $LOG_FILE

    VALIDATE $? "start $app_name "
    
}

total_execution_time(){
    End_time=$(date +%s)

    Total_execution_time=$(($End_time - $Start_time ))
    
    echo -e "$G total execution for $app_name::$W $Total_execution_time"


}