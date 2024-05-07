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

yum install maven -y &>>$LOGFILE

VALIDATE $? "installing maven"

useradd roboshop &>>$LOGFILE

mkdir /app &>>$LOGFILE

curl -L -o /tmp/shipping.zip https://roboshop-builds.s3.amazonaws.com/shipping.zip &>>$LOGFILE

VALIDATE $? "downloading the shpping artifact"


unzip /tmp/shipping.zip &>>$LOGFILE


VALIDATE $? "unziping the shipping artifacts"


cd /app &>>$LOGFILE

VALIDATE $? "moving to tha app DIRECTORY"



mvn clean package &>>$LOGFILE


VALIDATE $? "installing maven"


VALIDATE $? "packaging shipping app"


mv target/shipping-1.0.jar shipping.jar &>>$LOGFILE 

VALIDATE $? "renaming the shpping jar"


cp /home/centos/roboshop.shell/shipping.service  /etc/systemd/system/shipping.service &>>$LOGFILE


VALIDATE $? "copying the shipping services"

systemctl daemon-reload &>>$LOGFILE

VALIDATE $? "daemon reloaded"


systemctl enable shipping  &>>$LOGFILE


VALIDATE $? "Enableing the shipping"


systemctl start shipping   &>>$LOGFILE


VALIDATE $? "starting the shipping"



yum install mysql -y &>>$LOGFILE

VALIDATE $? "installing mysql"

mysql -h mongodb.joinsankardevops.online -uroot -pRoboShop@1 < /app/schema/shipping.sql  &>>$LOGFILE

VALIDATE $? "loaded the country and state info"

systemctl restart shipping &>>$LOGFILE

VALIDATE $? "restart the shipping"