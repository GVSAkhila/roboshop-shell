#!/bin/bash

# our program goal is to install mysql

DATE=$(date +%F)
SCRIPT_NAME=$0
LOGFILE=/tmp

R="\e[31m"
G="\e[32m"
N="\e[0m"

USERID=$(id -u)

if [ $USERID -ne 0 ]
then
    echo "ERROR:: Please run this script with root access"
    exit 1
# else
#     echo "INFO:: You are root user"
fi

# this function should validate the previous command and inform user it is success or failure
VALIDATE(){
    #$1 --> it will receive the argument1
    if [ $1 -ne 0 ]
    then
        echo -e "$2 ... $R FAILURE $N"
        exit 1
    else
        echo -e "$2 ... $G SUCCESS $N"
    fi
}

 cp mango.repo/etc/yum.repos.d/mongo.repo &>>$LOGFILE

 VALIDATE $? "copied monogdb into yum repo.d"

 yum install mongodb-org -y &>>$LOGFILE

 VALIDATE $? "installing mongodb"

 systemctl enable mongod &>>$LOGFILE

 VALIDATE $? "enableing mongodb"

 systemctl start mongod &>>$LOGFILE

 VALIDATE $? "starting mongod"

 sed 's/127.0.0.1/0.0.0.0/' /etc/mongod.conf &>>$LOGFILE

 VALIDATE $? "edietd mongod"
 

 systemctl restart mongod &>>$LOGFILE

 VALIDATE $? "restarting mongod"
