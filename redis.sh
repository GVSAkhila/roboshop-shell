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

yum install https://rpms.remirepo.net/enterprise/remi-release-8.rpm -y &>>$LOGFILE

VALIDATE $? "installing redis repo"

yum module enable redis:remi-6.2 -y &>>$LOGFILE

VALIDATE $? "enable redis redis 6.2 "

yum install redis -y &>>$LOGFILE

VALIDATE $? "installing redis 6.2"

sed -i 's/127.0.0.1/0.0.0.0'  /etc/redis.conf /etc/redis.conf  &>>$LOGFILE

VALIDATE $? "Allowing remote connection to redis"

systemctl enable redis &>>$LOGFILE

VALIDATE $? "enable redis"

systemctl start redis &>>$LOGFILE

VALIDATE $? "start redis repo" &>>$LOGFILE
