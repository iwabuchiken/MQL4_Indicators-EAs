# encoding: UTF-8

=begin

  file : utils.rb
  dir  : C:\Users\iwabuchiken\AppData\Roaming\MetaQuotes\Terminal\34B08C83A5AAE27A4079DE708E60511E\MQL4\Files\Research\
  date : 2017/09/09 14:53:21

<Descriptions>
1. Create a list of functions in the given file
2. Validations
      1. The directory exists
      2. The file exists

<Syntax>
utils.rb <directory path> <file name>

<Usage>
pushd C:\Users\iwabuchiken\AppData\Roaming\MetaQuotes\Terminal\34B08C83A5AAE27A4079DE708E60511E\MQL4\Files\Research\
ruby utils.rb

pushd C:\Users\iwabuchiken\AppData\Roaming\MetaQuotes\Terminal\34B08C83A5AAE27A4079DE708E60511E\MQL4\Files\Research\
ruby utils.rb ../../Include utils.mqh

=end

################################
#	
#	get_TimeLabel_Now
#   
#   @return "serial" ==> "20170909_155448"     ---> "%Y%m%d_%H%M%S"
#           "readable" ==> "2017/09/09  15:54:48"     ---> "%Y/%m/%d  %H:%M:%S"
#
################################
def get_TimeLabel_Now(type = "serial")
  
  label = ""
  
  if type == "serial"
  
    label = Time.now.strftime("%Y%m%d_%H%M%S")
  
  elsif type == "readable" #if (type == "serial")
    
    label = Time.now.strftime("%Y/%m/%d %H:%M:%S")
    
  else#if (type == "serial")
  
    puts "[#{File.basename(__FILE__)}:#{__LINE__}] Unknown type => #{type}"
    puts "[#{File.basename(__FILE__)}:#{__LINE__}] Using \"serial\" type..."
    
    label = Time.now.strftime("%Y%m%d_%H%M%S")
  
  end#if (type == "serial")
  
  #ref https://stackoverflow.com/questions/7415982/how-do-i-get-the-current-date-time-in-dd-mm-yyyy-hhmm-format
  #ref format https://apidock.com/ruby/DateTime/strftime
  return label
#  return Time.now.strftime("%Y%m%d_%H%M%S")
  
end#get_TimeLabel_Now

def _exec_2_MakeList(fpath, dir, fname)
  
  #ref http://uxmilk.jp/22615
  f = File.open(fpath, "r")
  
  #debug
  count = 0
  
  #ref http://www.sejuku.net/blog/14332
  aryOf_FuncNames = Array.new()
  
#  f.each do |line|
  #ref http://qiita.com/mogulla3/items/fbc2a46478872bebbc47
  f.each_line do |line|
    
    ################################
    #	
    #	read lines
    #
    ################################
    #ref http://qiita.com/shizuma/items/4279104026964f1efca6
    #ref https://apidock.com/ruby/String/match
    hit = line.match(/^(int|void|string) (.+)/)
#    hit = line.match(/^int .+/)
    
    unless hit == nil
      
      if hit.size == 3
      
        aryOf_FuncNames << [hit[1], hit[2]]
      
        #debug
        count += 1

      elsif hit.size == 2
        
        aryOf_FuncNames << [hit[1], ""]
        
        #debug
        count += 1

      else#if (hit.size == 3)
      
        puts "[#{File.basename(__FILE__)}:#{__LINE__}] unknown func name format => #{hit}"
              
      end#if (hit.size == 3)
       

#      p hit       #=> <MatchData "string _get_FNAME(" 1:"string" 2:"_get_FNAME(">
#      p hit[0]    #=> "int get_AryOf_RSI("
#      p hit[1]    #=>     "int"
#      p hit[2]    #=>   "get_AryOf_RSI("
#      p hit.size
#      p hit.to_s

    end
    
#    #debug
#    count += 1
    
#    if count > 10
#    
#      break
#    
#    end#if count > 10
    
    
  end
  
  f.close
  
  ################################
  #	
  #	array ---> sort
  #
  ################################
  #ref http://qiita.com/hachy/items/750002ee7787485b9de7
  aryOf_FuncNames__Sorted = aryOf_FuncNames.sort { |a, b| a[1] <=> b[1] }
    
  ################################
  #	
  #	write to file
  #
  ################################
  time_Label = get_TimeLabel_Now

  time_Label_Readable = get_TimeLabel_Now("readable")
  
  fpath_Out = dir + "/" + "func-list_#{fname}_#{time_Label}.txt"
  
  puts "[#{File.basename(__FILE__)}:#{__LINE__}] fpath_Out => #{fpath_Out}"
  
  puts
  
  fout = File.open(fpath_Out, "w");
  
  # header
  fout.write("Target file = #{fname}")
  fout.write("\n")
  
  #ref expand https://docs.ruby-lang.org/ja/latest/method/File/s/expand_path.html
  fout.write("dir = #{File.expand_path(dir)}")
#  fout.write("dir = #{dir}")
  fout.write("\n")
  
  fout.write("Entries = #{count.to_s}")
  fout.write("\n")
  
  fout.write("Created at = #{time_Label_Readable}")
  fout.write("\n")
  
  fout.write("This file = #{File.expand_path(fpath_Out)}")
#  fout.write("This file = #{fpath_Out}")
  fout.write("\n")
  
  fout.write("\n")
  
  fout.write("==========================================")
  fout.write("\n")
  fout.write("\n")
  
  # write lines
  aryOf_FuncNames__Sorted.each_with_index {|pair, i|
    
    #ref https://ref.xaio.jp/ruby/classes/string/strip
    fout.write("#{(i + 1).to_s}\t#{pair[0]} #{pair[1].strip}")
#    fout.write("#{(i + 1).to_s}\t#{pair[0]}\t#{pair[1].strip}")
#    fout.write("#{(i + 1).to_s}\t#{pair[0]}\t#{pair[1]}")
    
    fout.write("\n")
    
  }
  
  fout.write("\n")
  fout.write("==========================================")
  fout.write("\n")

  fout.close
  
  ################################
  #	
  #	message : final
  #
  ################################
  puts "[#{File.basename(__FILE__)}:#{__LINE__}] funcs => #{count.to_s} entries"

#  puts
#  aryOf_FuncNames.each do |item|
#  
#    p item
#  
#  end
#  
#  # sort
#  aryOf_FuncNames__Sorted = aryOf_FuncNames.sort { |a, b| a[1] <=> b[1] }
#  
#  puts
#  puts "[#{File.basename(__FILE__)}:#{__LINE__}] sorted ========================"
#  
#    
#  aryOf_FuncNames__Sorted.each do |item|
#  
#    p item
#  
#  end
  
end#_exec_2_MakeList

def exec
  
  ################################
  #	
  #	setup
  #
  ################################
  p ARGV
  
  lenOf_ARGs = ARGV.length
  
  puts "[#{File.basename(__FILE__)}:#{__LINE__}] lenOf_ARGs => #{lenOf_ARGs.to_s}"
  
  ################################
  #	
  #	dflt values
  #
  ################################
  if lenOf_ARGs < 1
  
    dir = "../Include"
    
    fname = "utils.mqh"
  
  else
    
    dir = ARGV[0]
    
    fname = ARGV[1]
    
  end#if lenOf_ARGs < 1
  
  ################################
  #	
  #	validate : dir
  #
  ################################
  if File.exists?(dir)
  
    puts "[#{File.basename(__FILE__)}:#{__LINE__}] dir => exists : #{dir}"
    
  
  else#if (File.exists?(dir))
  
    puts "[#{File.basename(__FILE__)}:#{__LINE__}] dir => NOT exists : #{dir}"
    
    puts "[#{File.basename(__FILE__)}:#{__LINE__}] quitting..."
    
    return -1
    
  end#if (File.exists?(dir))

  ################################
  # 
  # validate : dir
  #
  ################################
  fpath = dir + "/" + fname
  
  if File.exists?(fpath)
  
    puts "[#{File.basename(__FILE__)}:#{__LINE__}] file => exists : #{fpath}"
    
  
  else#if (File.exists?(dir))
  
    puts "[#{File.basename(__FILE__)}:#{__LINE__}] file => NOT exists : #{fpath}"
    
    puts "[#{File.basename(__FILE__)}:#{__LINE__}] quitting..."
    
    return -1
    
  end#if (File.exists?(dir))
  
  ################################
  #	
  #	file content
  #
  ################################
  _exec_2_MakeList(fpath, dir, fname)
  
  
  ################################
  #	
  #	message : final
  #
  ################################
  puts "[#{File.basename(__FILE__)}:#{__LINE__}] dir = #{dir} / fname = #{fname}"
  
  puts "[#{File.basename(__FILE__)}:#{__LINE__}] done"
  
  
end

exec
