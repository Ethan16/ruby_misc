#!/bin/sh

conf_plist="/Users/liulei/conf/configuration.plist"
conf_py="/Users/liulei/conf/config.py"
inj="/etc/init.d/injectsvr"
set_macconf="/Users/liulei/conf/set_macconf.sh"
emmi_dir="/Volumes/"
config_dir="/emm/bin/tool/ios/"
mac_cur=`cat /emm/appversion`
function find_emmi(emmi_dir){
    find /Volumes/ -name *MAC*.emmi > /Users/liulei/conf/emmilist   
    emmi="/Volumes//研发包提交文件夹/SSL/EMM/R1/20140905/SSLEMM_M65_MAC_10229_20140905.emmi"   
    for tmp in `cat /Users/liulei/conf/emmilist`  
        do
                emmi="/Volumes//研发包提交文件夹/SSL/EMM/R1/20140905/SSLEMM_M65_MAC_10229_20140905.emmi"
                if [ tmp -gt emmi ]
                    emmi=tmp
                fi
         done
    return emmi
}
    
emmi_last=find_emmi(emmi_dir)
result=$(echo ${emmi_last}|grep "${mac_cur}")

if [ "$result"!="" ]
    sudo ${emmi_last}
    sudo ${set_macconf}
    chmod -R 777 ${config_dir}
    cp -v -f  ${conf_plist} ${config_dir}
    cp -v -f  ${conf_py} ${config_dir}
    ${inj} restart
else
    echo "Current version ${mac_cur} is lastest! "
fi

exit 0