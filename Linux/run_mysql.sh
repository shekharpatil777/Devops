#!/bin/bash


read -p "MySQL User: " user_name
read -sp "MySQL Password: " mysql_pwd
echo
read -p "MySQL Command: " mysql_cmd
read -p "MySQL DB: "  mysql_db
mysql -u "$user_name" -p$mysql_pwd $mysql_db -Be"$mysql_cmd"