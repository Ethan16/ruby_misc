#encoding:gbk

require 'iconv'

#require 'iconv' #解决中文编码问题 zx 
#tip_text=Iconv.iconv("utf-8", "gbk", tip_text)

emmi_dir="/Volumes/研发包提交文件夹/SSL/M6.9/"
emmi_dir=Iconv.iconv("utf-8","gbk",emmi_dir)

puts emmi_dir
puts "I love you."
