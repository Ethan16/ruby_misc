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

/Users/liulei/conf/set_macconf.sh;cp -vf /Users/liulei/conf/configuration.plist /emm/bin/tool/ios/;cp -vf /Users/liulei/conf/config.py /emm/bin/tool/ios/;/etc/init.d/injectsvr restart

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
require 'fileutils'
#require 'iconv'

#Mac服务器信息及需要用到的配置信息
#conf_plist="/Users/liulei/conf/configuration.plist"
#conf_py="/Users/liulei/conf/config.py"
#inj="/etc/init.d/injectsvr"
#user="root"
password="Sangfor123"
emmi_dir="/Volumes/"
#config_dir="/emm/bin/tool/ios/"
mac_cur="/emm/appversion"

#获得更新
#puts emmi_dir
#require 'iconv' #解决中文编码问题 zx 
#tip_text=Iconv.iconv("utf-8", "gbk", tip_text)
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

#执行升级
def emm_mac_update(mac_emmi_path,password)
  begin
  set_macconf_sed="/Users/liulei/conf/set_macconf.sh"
  runcmd="sudo %s;%s " % [mac_emmi_path,set_macconf_sed]
  #if (system '#{runcmd}')
    #puts "Upgrade success!"
  #else
    #puts "Upgrade failed !"
	#puts "ERROR: #{$!} AT: #{$@}"
  #end
  exp_runcmd=Expectr.new(runcmd,flush_buffer: true)
  exp_runcmd.expect("Enter password:",false) do
  exp_runcmd.puts(password)
  exp_runcmd.interact!(blocking: false)
  end
  rescue
    puts "ERROR: #{$!} AT: #{$@}"
  ensure
    system '/Users/liulei/conf/set_macconf.sh'
	puts 'ZYC: IN method named emm_mac_update , /Users/liulei/conf/set_macconf.sh  has executed!'
  end
end

#改配置并重启
def chg_conf()
  begin
  #改配置文件权限
  FileUtils.chmod_R(0777,"/emm/")
  FileUtils.cp %w(/Users/liulei/conf/configuration.plist /Users/liulei/conf/config.py),'/emm/bin/tool/ios/'
  system '/etc/init.d/injectsvr restart'
  #run_cmd="#{inj} restart"
  #exp_run_cmd=Expectr.new(run_cmd,flush_buffer: true)
  rescue
    puts "ERROR: #{$!} AT: #{$@}"
  ensure
    system '/etc/init.d/injectsvr restart'
	puts 'ZYC: Injected server has been restart!'
  end

end

mac_emmi_path = find_emmi(emmi_dir)
mac_emmi_cur_version = File.open(mac_cur,"r").first.chop
#[2015-1-4]元旦期间停电了，所有服务器都关闭。mac映射的服务器的目录丢失了。
#增加判断为做此种类型异常的处理。
if (mac_emmi_path && (mac_emmi_path.include? mac_emmi_cur_version))
  puts "ZYC: Upgrade package is : #{mac_emmi_path} !"
  puts "ZYC: Current version [%s] is last! " % mac_emmi_cur_version
  puts "ZYC: Now I will change the configuration."
  begin
  chg_conf()
  rescue
    puts "ZYC: Configure failed! ERROR: #{$!}  AT: #{$@}"
  end
  puts "ZYC: Configure success !"
elsif mac_emmi_path
  puts "ZYC: Mac current version is : %s ,but the last package is : %s ." % [mac_emmi_cur_version,mac_emmi_path]
  puts "ZYC: Now ,we will update the mac !"
  emm_mac_update(mac_emmi_path,password)
  chg_conf()
else
  puts "ZYC: Please make sure the package has been mapped!"
end


