#!/bin/bash

# our program goal is to install mongodb

DATE=$(date +%F)
LOGDIR=/tmp
SCRIPT_NAME=$0
LOGFILE=$LOGDIR/$0-$DATE.log
USERID=$(id -u)

R="\e[31m"
G="\e[32m"
N="\e[0m"

 

if [ $USERID -ne 0 ]; then
    echo "ERROR:: Please run this script with root access"
    exit 1
fi

# this function should validate the previous command and inform user it is success or failure
VALIDATE() {
    #$1 --> it will receive the argument1
    if [ $1 -ne 0 ]; then
        echo -e "$2 ... $R FAILURE $N"
        exit 1
    else
        echo -e "$2 ... $G SUCCESS $N"
    fi
}

yum install python36 gcc python3-devel -y &>>$LOGFILE

VALIDATE $? "Installing python"

useradd roboshop &>>$LOGFILE

VALIDATE $? "useradd"

mkdir /app  &>>$LOGFILE

VALIDATE $? "creating the app dir"

curl -L -o /tmp/payment.zip https://roboshop-builds.s3.amazonaws.com/payment.zip &>>$LOGFILE

VALIDATE $? "downloading the payment zip"

cd /app  &>>$LOGFILE

VALIDATE $? "moving the app DIR"

unzip /tmp/payment.zip &>>$LOGFILE

VALIDATE $? "Unziping the payamnet servies"

cd /app  &>>$LOGFILE

VALIDATE $? "moving to the DIR"


pip3.6 install -r requirements.txt &>>$LOGFILE

VALIDATE $? "Installaling the dependencies"

cp /home/centos/roboshop.shell/payment.service  /etc/systemd/system/payment.service &>>$LOGFIL

VALIDATE $? "copyig the payment services"

systemctl daemon-reload &>>$LOGFILE

VALIDATE $? "daemon reloaded"

systemctl enable payment &>>$LOGFILE

VALIDATE $? "enable the payment"

systemctl start payment &>>$LOGFILE

VALIDATE $? "starting the payment"