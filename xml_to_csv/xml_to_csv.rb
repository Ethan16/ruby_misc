require 'csv'

=begin
Purpose：将SVN抓取的上库日志转换为xml文件
Author:zyc
Time:20160920
Version:1.0
Design:1.生成一个csv文件  2.抓取xml中指定的内容，写入csv文件中  3.同时检查SVN上库记录是否合规[后面做]
Usage:./xml_to_csv.rb changelog0920.xml
=end

csv=CSV.new(revision,author,date,msg,test,advice,tester,test_result,mark)
