#!/usr/bin/ruby
#encoding:utf-8

=begin
auth:zyc
time:2014年12月16日 08:27:08
ps:thanks for lwq help.

首先使用下列方法，在mac上挂载远程目录：
前往>连接服务器>smb:200.200.1.6>test/test>研发包提交文件夹>
最后需要将该脚本加入到contab里面，定时执行。

mac升级包括如下4个步骤：
①执行升级和配置脚本  /Users/liulei/emmfsr/SSLEMM_M65_MAC_16579_20141211.emmi  &  /Users/liulei/EMM/03-TestEnvironment/set_macconf.sh
②改配置  /emm/bin/tool/ios/config.py
③改配置  /emm/bin/tool/ios/configuration.plist
④重启封装进程 /etc/init.d/injectsvr restart

/emm/bin/tool/ios/config.py 的配置信息
conf_py="/emm/bin/tool/ios/config.py"
web_ip="200.200.139.91"
web_dbuser="emm"
web_dbpwd="emm"
web_dbname="emm_base"
web_scp_serverip="200.200.139.91"
web_scp_user="root"

/emm/bin/tool/ios/configuration.plist的配置信息
localPassword=Sangfor123
localUserName=liulei
=end

require 'pty'
require 'find'
require 'expectr'
#require 'iconv'

#Mac服务器信息及需要用到的配置信息
conf_plist="/Users/liulei/conf/configuration.plist"
conf_py="/Users/liulei/conf/config.py"
inj="/etc/init.d/injectsvr"
#user="root"
password="Sangfor123"
emmi_dir="/Volumes/"
config_dir="/emm/bin/tool/ios/"
mac_cur="/emm/appversion"

#获得更新
#puts emmi_dir
def find_emmi(emmi_dir)
  mac_emmi_array=Array.new
  Find.find(emmi_dir) do |file|
    if File.basename(file) =~ /.*MAC.*\.emmi$/
	  mac_emmi_array.push(file)
	end
  end 
  mac_emmi_array.sort!
  mac_emmi_array[-1]
end

=begin
def find_emmi(emmi_dir)
  mac_emmi_array=[]
  #emmi_dir_tmp=[emmi_dir]
  emmi_dir.each do |dir|
    Dir.glob(dir + "/*").each do |file|
	  if File.basename(file) =~ /.*MAC.*\.emmi$/
	    mac_emmi_array.push(file)
		#puts file
	  end
	end
  end
  mac_emmi_array.sort!
  mac_emmi_array(-1)
end
=end

#执行升级
def emm_mac_update(mac_emmi_path,password)
  #begin
  set_macconf_sed="/Users/liulei/conf/set_macconf.sh"
  runcmd="sudo %s; sudo %s" % [mac_emmi_path,set_macconf_sed]
  exp_runcmd=Expectr.new(runcmd,flush_buffer: true)
  exp_runcmd.expect("Enter password:",true)
  exp_runcmd.puts(password)
  exp_runcmd.interact!(blocking: false)
  #rescue
    #puts "ERROR: #{$!} AT: #{$@}"
  #end
end

#改配置并重启
def chg_conf(conf_plist,conf_py,password,config_dir,inj)
  #begin
  #改配置文件权限
  run_sudo="sudo chmod -R 777 /emm/bin/"
  #exec run_sudo
  exp_run_sudo=Expectr.new(run_sudo,flush_buffer: true)
  exp_run_sudo.expect("Enter password:",true)
  exp_run_sudo.puts(password)
  exp_run_sudo.interact!(blocking: false)
  #覆盖配置文件
  copy_conf="sudo cp -v -f %s %s; sudo cp -v -f %s %s" % [conf_py,config_dir,conf_plist,config_dir]
  exp_copy_conf=Expectr.new(copy_conf,flush_buffer: true)
  exp_copy_conf.expect("Enter password:",true)
  exp_copy_conf.puts(password)
  exp_copy_conf.interact!(blocking: false)
  #重启封装服务
  restart_inj="sudo %s restart" % [inj]
  exp_restart_inj=Expectr.new(restart_inj,flush_buffer: true)
  exp_restart_inj.expect("Enter password:",true)
  exp_restart_inj.puts(password)
  exp_restart_inj.interact!(blocking: false)
  #rescue
    #puts "ERROR: #{$!} AT: #{$@}"
  #end
end

mac_emmi_path = find_emmi(emmi_dir)
puts "Upgrade package is : #{mac_emmi_path} !"
mac_emmi_cur_version = File.open(mac_cur,"r").first.chop
if mac_emmi_path.include? mac_emmi_cur_version
  puts "Current version [%s] is last! " % mac_emmi_cur_version
else
  puts "Mac current version is : %s ,but the last package is : %s ." % [mac_emmi_cur_version,mac_emmi_path]
  puts "Now ,we will update the mac !"
  emm_mac_update(mac_emmi_path,password)
  chg_conf(conf_plist,conf_py,password,config_dir,inj)
end

