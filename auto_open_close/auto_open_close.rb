require 'watir'
require 'watir-webdriver'

while(1>0)
  #打开firefox
  firefox = Watir::Browser.new :firefox
  
  #登录vmp
  firefox.goto("https://200.201.136.106/login")
  firefox.text_field(:id,"user_name").set("admin")
  firefox.text_field(:id,"password").set("admin123.")
  firefox.button(:id,"login").click
  sleep 5
  
  #访问虚拟机控制台
  firefox.goto("https://200.201.136.106/?m=/mod-console/index&n-hfs&vmid=4996177986762&vmname=win7x86-0010001")
  sleep 10
  
  #关闭firefox
  firefox.close
end

