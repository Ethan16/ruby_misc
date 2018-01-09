#!/usr/bin/env ruby
# encoding: UTF-8

require 'pty'
require 'find'
require 'expectr'

user_password="sangfor"
mysql_password="123456"
emmi_dir="/Volumes/研发包提交文件夹/SSL/EMM/"
emmi_curr="/emm/appversion"

# 获得更新
def find_emmi(emmi_dir)
    web_emmi_array=[]
    Find.find(emmi_dir) do |file|
        #puts file if File.basename(file) =~ /.*WEB.*\.emmi$/
        if File.basename(file) =~ /.*WEB.*\.emmi$/
            web_emmi_array.push(file)
        end
    end
    web_emmi_array.sort!
    web_emmi_array[-1]
end

# 执行升级
def emm_web_update(web_emmi_path, user_password, mysql_password)
    mysql_sed="/home/sangfor/set_webconf.sh"
    runcmd = "sudo %s && sudo %s" % [web_emmi_path, mysql_sed]
    exp = Expectr.new(runcmd, flush_buffer: true)
    exp.expect("[sudo]")
    exp.puts(user_password)
    exp.expect("Enter password:")
    exp.puts(mysql_password)
    exp.interact!(blocking: true)
end

web_emmi_path=find_emmi(emmi_dir)
if not File.exist?(emmi_curr)
    emm_web_update(web_emmi_path,user_password,mysql_password)
else
    curr_emmi_version = File.open("/emm/appversion", "r").first.chop
    if web_emmi_path.include?(curr_emmi_version)
        puts "当前版本[%s]已最新!" % curr_emmi_version
    else
        emm_web_update(web_emmi_path,user_password,mysql_password)
    end
end
