require 'pathname'


=begin

file:         get_folder_list.rb
created at:   20161223_212926

<Usage>
C:\WORKS_2\WS\WS_Others\prog\D-5\1#\get_folder_list.rb

pushd C:\WORKS_2\WS\WS_Others\prog\D-5\1#
get_folder_list.rb

=end

################################
#	
#	vars (global)
#
################################
VERSION = "1.0"
FILE_PATH = "C:\\WORKS_2\\WS\\WS_Others\\prog\\D-5\\1#\\get_folder_list.rb"


################################
#   get_folder_list
# @param
#
################################
def get_folder_list(dpath_Src = __FILE__)

  ################################
  #	prep: source dir path
  ################################
  ################################
  #	validate : ARGV ?
  ################################
  if ARGV.length < 1
  
    dpath = (Pathname.new(__FILE__)).dirname
#    dpath = __FILE__
  
  else
    
    #ref https://stackoverflow.com/questions/32860766/how-to-check-whether-a-file-exists#32861082
    if not (Pathname.new(ARGV[0])).directory?
    
      puts "[#{__LINE__}] NOT a directory => '#{dpath_Src}'"
      puts "[#{__LINE__}] <Usage> get_folder_list.rb [dirpath]"
          
      return      
    
    else
    
      dpath = ARGV[0]
      
    end#if not (Pathname.new(ARGV[0])).directory?
    
    
  end#if ARGV.length < 1
  
  
  #debug
  p ARGV
  p ARGV.length
  
  puts "[#{__LINE__}] dpath => '#{dpath}'"

#  return

  ################################
  # get : list
  ################################
  #ref http://stackoverflow.com/questions/1899072/getting-a-list-of-folders-in-a-directory
  Dir.chdir(dpath)
#  Dir.chdir("c:/works_2")
#  Dir.chdir(path.dirname)
#  Dir.chdir('/destination_directory')
#  list = Dir.glob('*').select
#  list = Dir.glob('*').select {|f| File.directory? f}
  files = Dir.glob('*').select {|f| File.file? f}
  dirs = Dir.glob('*').select {|f| File.directory? f}
  

  ################################
  # sort
  ################################
  #ref https://www.thoughtco.com/sorting-arrays-2908238
  dirs.sort!
  files.sort!
  
  puts
  puts "[#{__LINE__}] directory => #{dpath}" 
  
  puts
  puts "[#{__LINE__}] folders ...."
  p dirs
  
  puts
  puts "[#{__LINE__}] files ...."
  p files
#  p files.sort
  
#  #debug
#  return
  
  ################################
  #	file: write data
  ################################
  time_label = get_time_label("serial")
  
  fname = "directory_list.#{time_label}.txt"
  
  # modify dst dir path
  if ARGV.length >= 2
    
    dpath_Dst = ARGV[1]
    Dir.chdir(dpath_Dst)
    
    
    puts "[#{__LINE__}] dpath set => '#{dpath_Dst}'"
    
    # modify path
    fname = "#{dpath_Dst}/#{fname}"
    
    puts "[#{__LINE__}] fname => '#{fname}'"
    
    #ccc
    
#    dpath_Dst = ARGV[1]
#    
#    # modify
#    fname = "#{dpath_Dst}/#{fname}"
  
  end#if ARGV.lengh >= 2
  
  
  f = File.new(fname, "w")
  
  # header
  #ref https://stackoverflow.com/questions/26260091/ruby-file-full-path#26300418
  f.write("program file path = #{File.absolute_path(__FILE__)}")
#  f.write("program file path = #{FILE_PATH}")
  f.write("\n")
  f.write("version = #{VERSION}")
  f.write("\n")
  
  f.write("list file created at = #{time_label}")
  f.write("\n")
  
  f.write("dir path = #{dpath}")
  f.write("\n")
  f.write("dirs = #{dirs.size}")
  f.write("\n")
  f.write("files = #{files.size}")
  f.write("\n")
  f.write("\n")
  
  # data: dirs
  f.write "<directories> #{dirs.size} ========================="
  f.write "\n"
  
  cnt = 1
  
  dirs.each do |elem|
    
    f.write("#{cnt}\t#{elem}")
#    f.write(elem)
    f.write("\n")
    
    # counter
    cnt += 1
    
#    #debug
#    puts "[#{__LINE__}] dirs : elem => '#{elem}'"
    
  end
  
  f.write("\n")
  f.write("\n")
  
  # data: files
  cnt = 1
  
  f.write "<files> #{files.size} ========================="
  f.write "\n"

  files.each do |elem|
    
    f.write("#{cnt}\t#{elem}")
#    f.write(elem)
    f.write("\n")
    
    # counter
    cnt += 1
    
#    #debug
#    puts "[#{__LINE__}] files : elem => '#{elem}'"
    
  end
  
  f.close
  
  puts "[#{__LINE__}] file written => #{File.absolute_path(fname)}"
#  puts "[#{__LINE__}] file written => #{fname}"
  
end#get_folder_list

################################
# @param
#   serial    20161221_141900
# @orig: C:\WORKS_2\WS\WS_Others\res.245\115\r.245-115.5#1.elec-conductivity.rb 
#
################################
def get_time_label(type = "serial")
  
  if type == "serial"
    
    #ref http://stackoverflow.com/questions/7415982/how-do-i-get-the-current-date-time-in-dd-mm-yyyy-hhmm-format
    return Time.now.strftime("%Y%m%d_%H%M%S")
    
  elsif type == "display"
    
    #ref http://stackoverflow.com/questions/7415982/how-do-i-get-the-current-date-time-in-dd-mm-yyyy-hhmm-format
    return Time.now.strftime("%Y/%m/%d  %H:%M:%S")
    
  else
    
    return Time.now.strftime("%Y%m%d_%H%M%S")
    
  end
  
end

def exec

  get_folder_list
    
end#exec

exec
