
#!/usr/bin/python
#coding=utf-8

'''
定义了数据库操作和SCP文件操作的配置信息，如数据库的地址、端口
用户名、密码，scp服务器的地址和用户名
修改记录：
2014 9.6日
    第一次创建文件
'''

#数据库服务器地址
serverip = '200.200.139.91'
#数据库用户名
dbuser = 'emm'
#数据库用户密码
dbpwd = 'emm'
#数据库名
dbname = 'emm_base'
#数据库端口
dbport = 3306

#文件存储服务器地址，即scp服务器
scpserverip = '200.200.139.91'
#文件存储服务器用户名
scpuser = 'root'

#定义日志级别
LOGDEBUG = 0
LOGINFO = 1
LOGWARN = 2
LOGERROR = 3
LOGDEFAULT = LOGDEBUG
#注�