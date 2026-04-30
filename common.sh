 #!/bin/bash
Start_time=$(date +%s)

check_root(){
    
    
    LOG_FOLDER="/var/log/roboshop-logs"
    mkdir -p $LOG_FOLDER
    LOG_FILENAME=$(echo $0 | cut -d "." -f1)
    LOG_FILE="$LOG_FOLDER/$LOG_FILENAME.log"

    R="\e[31m"
    G="\e[32m"
    Y="\e[33m"
    W="\e[0m"
    current_directory=$PWD

    USERID=$(id -u)



    if [ $? -ne 0 ]
    then
    echo -e "$R please log user as root user::  $W" &>> $LOG_FILE
    exit 1
    else 
        echo -e "$G logged as a root user:: $W " &>> $LOG_FILE
    fi

    VALIDATE(){
    if [ $1 -ne 0 ]
    then 
        echo -e "$R $2 is Failure:: $W" | tee -a $LOG_FILE
        exit 1
    else
        echo -e "$G $2 is Success:: $W" | tee -a $LOG_FILE
    fi

    }
}


Total_execution_time(){
    End_time=$(date +%s)

    Total_execution_time=$(($End_time - $Start_time ))
    
    echo -e "$G total execution::$W $Total_execution_time"
}