require 'net/ssh'

hostA_eth0 = "200.201.188.101"
hostA_eth1 = "200.201.189.101"
username = "root"
password = "admin123.sangfornetwork"

session = Net::SSH.start(hostA_eth1,username,:password => password) do |ssh|
  #oldip = ssh.exec!("vtpsh get /VAPIMain/VDCInterface/Getspiceinfo -vmid 6527194089504 |sed 's/,/ /g'|grep nodeip|awk -F  "':' " 'NR >0 {print $2}'|sed 's/^[  ]*//g'")
  vm_state = ssh.exec("vtpsh get /VAPIMain/VDCInterface/Getspiceinfo -vmid 6527194089504 |sed 's/,/ /g'|grep vm_status|awk -F  "':' " 'NR>0 {print $2}'|sed -e 's/^[  ]*//g'")
  #|awk -F":" '{print $2}'|sed -e 's/"//g' -e 's/^[ ]*//g'
  puts vm_state
  if vm_state == "stopped"
    puts "OK"
  else
    puts "NO"
  end
  end
