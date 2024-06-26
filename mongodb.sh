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

# Copy MongoDB repository file
 cp mongo.repo /etc/yum.repos.d/mongo.repo &>>$LOGFILE

 VALIDATE $? "copied MongoDB"

# Install MongoDB
yum install mongodb-org -y &>>$LOGFILE
VALIDATE $? "Installing MongoDB"

# Enable MongoDB service
systemctl enable mongod &>>$LOGFILE
VALIDATE $? "Enabling MongoDB service"

# Start MongoDB service
systemctl start mongod &>>$LOGFILE
VALIDATE $? "Starting MongoDB service"

# Edit MongoDB configuration
sed -i 's/127.0.0.1/0.0.0.0/' /etc/mongod.conf &>>$LOGFILE
VALIDATE $? "Editing MongoDB configuration"


# Restart MongoDB service
systemctl restart mongod &>>$LOGFILE
VALIDATE $? "Restarting MongoDB service"

echo "MongoDB installation and configuration completed successfully."
