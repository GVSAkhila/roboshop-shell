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

curl -sL https://rpm.nodesource.com/setup_lts.x | bash &>>$LOGFILE

VALIDATE $? "Setting up NPM resource" 

yum install nodejs -y &>>$LOGFILE

VALIDATE $? "INstalling nodejs"
#once user is created , if run the script 2nd time
#this cammand is fail defanatility
#improve then script 
useradd roboshop &>>$LOGFILE

# write a condtion directory created or not 

mkdir /app &>>$LOGFILE

curl -o /tmp/catalogue.zip https://roboshop-builds.s3.amazonaws.com/catalogue.zip &>>$LOGFILE

VALIDATE $? "downloading catalogue aritifact"

cd /app &>>$LOGFILE

VALIDATE $? "moving into app directory"

unzip /tmp/catalogue.zip &>>$LOGFILE

VALIDATE $? "unziping  catalogue"

npm install &>>$LOGFILE

VALIDATE $? "installing dependencies"

cp /home/centos/roboshop.shell/catalogue.service  /etc/systemd/system/catalogue.service &>>$LOGFILE
 


VALIDATE $? "Copying catalogue service file"

systemctl daemon-reload &>>$LOGFILE

VALIDATE $? "daemon reloaded"

systemctl enable catalogue &>>$LOGFILE

VALIDATE $? "enable catalogue"

systemctl start catalogue &>>$LOGFILE

VALIDATE $? "started the catalogue"

cp /home/centos/roboshop.shell/mongo.repo /etc/yum.repos.d/mongo.repo &>>$LOGFILE

VALIDATE $? "coping the mango repo"

yum install mongodb-org-shell -y &>>$LOGFILE

VALIDATE $? "installing mango clint"

mongo --host mongodb.joinsankardevops.online </app/schema/catalogue.js &>>$LOGFILE

VALIDATE $? "loading catalogue data in mangodb"