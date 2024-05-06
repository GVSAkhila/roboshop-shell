#!/bin/bash

# Define variables
DATE=$(date +%F)
LOGDIR=/tmp
SCRIPT_NAME=$0
LOGFILE=$LOGDIR/$SCRIPT_NAME-$DATE.log
USERID=$(id -u)

# Define colors
R="\e[31m"
G="\e[32m"
N="\e[0m"

# Check if script is run as root
if [ $USERID -ne 0 ]; then
    echo -e "${R}ERROR:${N} Please run this script with root access"
    exit 1
fi

# Function to validate command execution
VALIDATE() {
    if [ $1 -ne 0 ]; then
        echo -e "$2 ... ${R}FAILURE${N}"
    else
        echo -e "$2 ... ${G}SUCCESS${N}"
    fi
}

# Set up NPM resource
curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>>$LOGFILE
VALIDATE $? "Setting up NPM resource"

# Install Node.js
yum install nodejs -y &>>$LOGFILE
VALIDATE $? "Installing Node.js"

# Create user 'roboshop' (assuming it doesn't already exist)
useradd roboshop &>>$LOGFILE
VALIDATE $? "Creating user 'roboshop'"

# Create directory for the application
mkdir /app &>>$LOGFILE
VALIDATE $? "Creating directory '/app'"

# Download catalogue artifact
curl -o /tmp/catalogue.zip https://roboshop-builds.s3.amazonaws.com/catalogue.zip &>>$LOGFILE
VALIDATE $? "Downloading catalogue artifact"

# Move to application directory
cd /app &>>$LOGFILE
VALIDATE $? "Moving to application directory"

# Unzip catalogue artifact
unzip /tmp/catalogue.zip &>>$LOGFILE
VALIDATE $? "Unzipping catalogue artifact"

# Install Node.js dependencies
npm install &>>$LOGFILE
VALIDATE $? "Installing Node.js dependencies"

# Copy catalogue service file
cp /home/centos/roboshop.shell/catalogue.service /etc/systemd/system/catalogue.service &>>$LOGFILE
VALIDATE $? "Copying catalogue service file"

# Reload systemd daemon
systemctl daemon-reload &>>$LOGFILE
VALIDATE $? "Reloading systemd daemon"

# Enable catalogue service
systemctl enable catalogue &>>$LOGFILE
VALIDATE $? "Enabling catalogue service"

# Start catalogue service
systemctl start catalogue &>>$LOGFILE
VALIDATE $? "Starting catalogue service"

# Copy MongoDB repository file
cp /home/centos/roboshop.shell/mongo.repo /etc/yum.repos.d/mongo.repo &>>$LOGFILE
VALIDATE $? "Copying MongoDB repository file"

# Install MongoDB shell
yum install mongodb-org-shell -y &>>$LOGFILE
VALIDATE $? "Installing MongoDB shell"

# Load catalogue data into MongoDB
mongo --host mongodb.joinsankardevops.online </app/schema/catalogue.js &>>$LOGFILE
VALIDATE $? "Loading catalogue data into MongoDB"

# Print completion message
echo "MongoDB installation and configuration completed successfully."
