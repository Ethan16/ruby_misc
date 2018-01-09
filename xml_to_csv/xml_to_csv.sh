#!/bin/bash

#Purpose：将SVN抓取的上库日志转换为xml文件
#Author:zyc
#Time:20160920
#Version:1.0
#Design:1.生成一个csv文件  2.抓取xml中指定的内容，写入csv文件中  3.同时检查SVN上库记录是否合规[后面做]
#Usage:./xml_to_csv.rb changelog.xml

LOG_FILE_Client="/sf/log/today/LOG_xml_to_csv.log"

csv_path=`echo $PWD`

#定义日志函数
zyc_log_client()
{
	LOG_MSG="$1"
	echo "[`date +'%Y-%m-%d %H:%M:%S'`]--${LOG_MSG}" >> ${LOG_FILE_Client}
}

#格式化xml文件，去掉无关信息，只剩下logentry域
#format_xml(){
#  sed -e 's/<log>//g' -e 's///g'
#}

#获取logentry域的信息
#pick_logentry(){
#  
#}

#将提取的logentry的信息插入csv文件
#revision,author,date,msg
#insert_csv(){
#  
#}

sed -e '/\<log\>/d' -e '/\<\/log\>/d' -e '/\?xml/d' ${csv_path}/changelog.xml > changelog_format.xml

zyc_log_client "初始化CSV文件，插入指定字段。"
echo "revision,author,date,msg,test advice,tester,result,mark" >> ${csv_path}/changelog.csv

record="recording each line."

while [ -n "$record" ]
do
  current_field=1
  
  #获取域个数，用于做循环控制
  filed_num=`awk -F"\<logentry" '{print $NF}' changelog_format.xml`
  zyc_log_client "需要处理的域个数为：$filed_num ."
  
  #处理每一个域的数据，将域中的数据写入csv文件
  if [ $current_field -le $filed_num ]
  then
    
  fi
  
done


