log_file="/tmp/expense.log"
color="\e[32m"

echo -e "${color} Disable nodejs default version \e[0m"
dnf module disable nodejs -y &>>$log_file
echo $?

echo -e "${color} enable nodejs 18 version \e[0m"
dnf module enable nodejs:18 -y &>>$log_file
echo $? 

echo -e "${color} install nodejs \e[0m"
dnf install nodejs -y  &>>$log_file
echo $?

echo -e "${color} copy backend service file \e[0m"
cp backend.service /etc/systemd/system/backend.service &>>$log_file
echo $?

echo -e "${color} Add application user \e[0m"
useradd expense &>>$log_file
echo $?

echo -e "${color} create application dir \e[0m"
mkdir /app &>>$log_file
echo $?

echo -e "${color} Download application content \e[0m"
curl -o /tmp/backend.zip https://expense-artifacts.s3.amazonaws.com/backend.zip &>>$log_file
echo $?

echo -e "${color} extract aplication content \e[0m"
cd /app &>>$log_file
unzip /tmp/backend.zip &>>$log_file
echo $?

echo -e "${color} download nodeJs dependencies \e[0m"
npm install &>>$log_file
echo $?

echo -e "${color} install mysql client to load schema \e[0m"
dnf install mysql -y &>>$log_file
echo $?

echo -e "${color} load schema \e[0m"
mysql -h mysql-dev.ramkirana.online -uroot -pExpenseApp@1 < /app/schema/backend.sql &>>$log_file
echo $?

echo -e "${color} starting backend service \e[0m"
systemctl daemon-reload &>>$log_file
systemctl enable backend &>>$log_file
systemctl reatart backend &>>$log_file
echo $?


