#encoding:utf-8
require 'find'

emmi_dir="/Volumes/"
=begin  研发包提交文件夹/EMM
def find_emmi()
  mac_emmi_array=[]
  #emmi_dir_tmp=["/Volumes/研发包提交文件夹/EMM"]
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


def find_emmi(emmi_dir_tmp)
  mac_emmi_array=Array.new
  Find.find(emmi_dir_tmp) do |file|
    puts file
    if File.basename(file) =~ /.*MAC.*\.emmi$/
	  mac_emmi_array.push(file)
	end
  end 
  mac_emmi_array.sort!
  mac_emmi_array[-1]
end

puts find_emmi(emmi_dir)
