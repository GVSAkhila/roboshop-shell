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

curl -s https://packagecloud.io/install/repositories/rabbitmq/erlang/script.rpm.sh | bash &>>$LOGFILE

VALIDATE $? "downloaded the erlang packages"


curl -s https://packagecloud.io/install/repositories/rabbitmq/rabbitmq-server/script.rpm.sh | bash &>>$LOGFILE

VALIDATE $? "downloaded the rabbitmq server"


yum install rabbitmq-server -y  &>>$LOGFILE

VALIDATE $? "installing rabbitmq"


systemctl enable rabbitmq-server  &>>$LOGFILE

VALIDATE $? "enable rabbitmq-server"


systemctl start rabbitmq-server &>>$LOGFILE

VALIDATE $? "start rabbitmq-server"
 

rabbitmqctl add_user roboshop roboshop123 &>>$LOGFILE

VALIDATE $? "added the user"


rabbitmqctl set_permissions -p / roboshop ".*" ".*" ".*" &>>$LOGFILE

VALIDATE $? "setting the permissions"


