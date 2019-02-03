# encoding: UTF-8

=begin

  file : utils.20171123-121700.rb
  dir  : C:\Users\iwabuchiken\AppData\Roaming\MetaQuotes\Terminal\34B08C83A5AAE27A4079DE708E60511E\MQL4\utils
  date : 2018/12/05 09:09:00

<Descriptions>
1. Create a list of functions in the given file
2. Validations
      1. The directory exists
      2. The file exists

<Syntax>
utils.rb <directory path> <file name>

<Usage>
------ ruby file ------------
pushd C:\Users\iwabuchiken\AppData\Roaming\MetaQuotes\Terminal\B9B5D4C0EA7B43E1F3A680F94F757B3D\MQL4\utils\
ruby utils.20171123-121700.rb

pushd C:\Users\iwabuchiken\AppData\Roaming\MetaQuotes\Terminal\34B08C83A5AAE27A4079DE708E60511E\MQL4\Files\Research\
ruby utils.rb ../../Include utils.mqh

------ gen-func-list.bat ------------
pushd C:\Users\iwabuchiken\AppData\Roaming\MetaQuotes\Terminal\B9B5D4C0EA7B43E1F3A680F94F757B3D\MQL4\Experts\labs\44_5.3
gen-func-list.bat


=end
#tmp_Dpath = %q"C:\Users\iwabuchiken\AppData\Roaming\MetaQuotes\Terminal\34B08C83A5AAE27A4079DE708E60511E\MQL4\utils"
GLOBAL_tmp_Dpath = %q"C:\Users\iwabuchiken\AppData\Roaming\MetaQuotes\Terminal\B9B5D4C0EA7B43E1F3A680F94F757B3D\MQL4\utils"

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

#xxx
#def _exec_2_MakeList__Write2File(aryOf_Funcs, dir, fname, count)
def _exec_2_MakeList__Write2File( \
      aryOf_Funcs \
      , aryOf_Vars \
      , dpath_Src \
      , fname \
      , count \
      , dpath_Dst)

  time_Label = get_TimeLabel_Now

  time_Label_Readable = get_TimeLabel_Now("readable")
  
  fpath_Out = dpath_Dst + "/" + "func-list.(#{fname}).#{time_Label}.txt"
  #fpath_Out = dpath_Dst + "/" + "func-list_#{fname}_#{time_Label}.txt"
#  fpath_Out = dir + "/" + "func-list_#{fname}_#{time_Label}.txt"
  
  puts "[#{File.basename(__FILE__)}:#{__LINE__}] fpath_Out => #{fpath_Out}"
  
  puts
  
  fout = File.open(fpath_Out, "w");
  
  # header
  fout.write("Target file = #{fname}")
  fout.write("\n")
  
  #ref expand https://docs.ruby-lang.org/ja/latest/method/File/s/expand_path.html
  fout.write("dpath_Src = #{File.expand_path(dpath_Src)}")
#  fout.write("dir = #{dir}")
  fout.write("\n")
  
  fout.write("Entries = #{count.to_s}")
  fout.write("\n")
  
  fout.write("Created at = #{time_Label_Readable}")
  fout.write("\n")
  
#  fout.write("Created by = #{__FILE__} (#{File.dirname(__FILE__)})")
  #ref dirpath https://stackoverflow.com/questions/1937743/how-to-get-the-current-working-directorys-absolute-path-from-irb#1937761
  fout.write("Created by = #{__FILE__} (#{File.dirname(File.expand_path(__FILE__))})")
#  fout.write("Created by = #{__FILE__}")
  fout.write("\n")
  
  fout.write("This file = #{File.expand_path(fpath_Out)}")
#  fout.write("This file = #{fpath_Out}")
  fout.write("\n")
  
  fout.write("\n")
  
  ####################
  # meta
  ####################
  fout.write("/*")
  fout.write("\n")
  
  fout.write("#{time_Label_Readable}")
  fout.write("\n")

  fout.write(File.basename(fpath_Out))
  fout.write("\n")
  
  
  ####################
  # funcs
  ####################
  fout.write("==========================================")
  fout.write("\n")
  fout.write("<funcs>")
  fout.write("\n")
  fout.write("\n")
  
  # write lines
#  aryOf_FuncNames__Sorted.each_with_index {|pair, i|
  aryOf_Funcs.each_with_index {|pair, i|
    
    #ref https://ref.xaio.jp/ruby/classes/string/strip
    fout.write("#{(i + 1).to_s}\t#{pair[0]} #{pair[1].strip}")
#    fout.write("#{(i + 1).to_s}\t#{pair[0]}\t#{pair[1].strip}")
#    fout.write("#{(i + 1).to_s}\t#{pair[0]}\t#{pair[1]}")
    
    fout.write("\n")
    
  }
  
  fout.write("\n")
  fout.write("==========================================")
  fout.write("\n")

  ####################
  # vars
  ####################
  fout.write("==========================================")
  fout.write("\n")
  fout.write("<vars>")
  fout.write("\n")
  fout.write("\n")
  
  # write lines
#  aryOf_FuncNames__Sorted.each_with_index {|pair, i|
  aryOf_Vars.each_with_index {|pair, i|
    
    #ref https://ref.xaio.jp/ruby/classes/string/strip
    fout.write("#{(i + 1).to_s}\t#{pair[0]} #{pair[1].strip}")
#    fout.write("#{(i + 1).to_s}\t#{pair[0]}\t#{pair[1].strip}")
#    fout.write("#{(i + 1).to_s}\t#{pair[0]}\t#{pair[1]}")
    
    fout.write("\n")
    
  }
  
  fout.write("\n")
  fout.write("==========================================")
  fout.write("\n")

  fout.write("*/")
  fout.write("\n")

  fout.close    
end#def _exec_2_MakeList(fpath, dir, fname)

def _exec_2_MakeList__Write2File__V2( \
      aryOf_Funcs \
      , aryOf_Vars \
      , aryOf_Externs \
      , dpath_Src \
      , fname \
      , count \
      , dpath_Dst)

  time_Label = get_TimeLabel_Now

  time_Label_Readable = get_TimeLabel_Now("readable")
  
  fpath_Out = dpath_Dst + "/" + "func-list.(#{fname}).#{time_Label}.txt"
  
  puts "[#{File.basename(__FILE__)}:#{__LINE__}] fpath_Out => #{fpath_Out}"
  
  puts
  
  fout = File.open(fpath_Out, "w");
  
  # header
  fout.write("Target file = #{fname}")
  fout.write("\n")
  
  #ref expand https://docs.ruby-lang.org/ja/latest/method/File/s/expand_path.html
  fout.write("dpath_Src = #{File.expand_path(dpath_Src)}")
#  fout.write("dir = #{dir}")
  fout.write("\n")
  
  fout.write("Entries = #{count.to_s}")
  fout.write("\n")
  
  fout.write("Created at = #{time_Label_Readable}")
  fout.write("\n")
  
#  fout.write("Created by = #{__FILE__} (#{File.dirname(__FILE__)})")
  #ref dirpath https://stackoverflow.com/questions/1937743/how-to-get-the-current-working-directorys-absolute-path-from-irb#1937761
  fout.write("Created by = #{__FILE__} (#{File.dirname(File.expand_path(__FILE__))})")
#  fout.write("Created by = #{__FILE__}")
  fout.write("\n")
  
  fout.write("This file = #{File.expand_path(fpath_Out)}")
#  fout.write("This file = #{fpath_Out}")
  fout.write("\n")
  
  fout.write("\n")
  
  ####################
  # meta
  ####################
  fout.write("/*")
  fout.write("\n")
  
  fout.write("#{time_Label_Readable}")
  fout.write("\n")

  fout.write(File.basename(fpath_Out))
  fout.write("\n")
  
  
  ####################
  # funcs
  ####################
  fout.write("==========================================")
  fout.write("\n")
  fout.write("<funcs>")
  fout.write("\n")
  fout.write("\n")
  
  # write lines
  aryOf_Funcs.each_with_index {|item, i|
    
    #ref https://ref.xaio.jp/ruby/classes/string/strip
    fout.write("#{(i + 1).to_s})\t#{item}")
    
    fout.write("\n")
    
  }
  
  fout.write("\n")
  fout.write("==========================================")
  fout.write("\n")

  ####################
  # vars
  ####################
  fout.write("==========================================")
  fout.write("\n")
  fout.write("<vars>")
  fout.write("\n")
  fout.write("\n")
  
  # write lines
#  aryOf_FuncNames__Sorted.each_with_index {|pair, i|
  aryOf_Vars.each_with_index {|item, i|
    
    #ref https://ref.xaio.jp/ruby/classes/string/strip
    fout.write("#{(i + 1).to_s})\t#{item}")
    
    fout.write("\n")
    
  }
  
  fout.write("\n")
  fout.write("==========================================")
  fout.write("\n")

  ####################
  # externs
  ####################
  fout.write("==========================================")
  fout.write("\n")
  #fout.write("<externs>")
  fout.write("<externs, inputs>")
  fout.write("\n")
  fout.write("\n")
  
  # write lines
#  aryOf_FuncNames__Sorted.each_with_index {|pair, i|
  aryOf_Externs.each_with_index {|item, i|
    
    #ref https://ref.xaio.jp/ruby/classes/string/strip
    fout.write("#{(i + 1).to_s})\t#{item}")
    
    fout.write("\n")
    
  }
  
  fout.write("\n")
  fout.write("==========================================")
  fout.write("\n")

  ####################
  # footer
  ####################
  fout.write("*/")
  fout.write("\n")

  ####################
  # close
  ####################
  fout.close    
  
end#def _exec_2_MakeList__Write2File__V2

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
    #hit = line.match(/^(int|void|string) (.+)/)
    hit = line.match(/^(int|void|string|bool) (.+)/)
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
  #	array ---> funcs, vars
  #
  ################################
  aryOf_Funcs = []
  aryOf_Vars = []
  
  flg_IsFunc = false
    
  aryOf_FuncNames.each do |aryOf_tokens|
    
    aryOf_tokens.each do |elem|
      
      # func?
      #ref substring https://stackoverflow.com/questions/8258517/how-to-check-whether-a-string-contains-a-substring-in-ruby#8258571
      #ref match substring https://stackoverflow.com/questions/4115115/extract-a-substring-from-a-string-in-ruby-using-a-regular-expression#4115144
      #if elem.match(/^[a-zA-Z_]+\(.*\)/)
      #ref regex numerical https://www.regular-expressions.info/numericranges.html
      if elem.match(/^[a-zA-Z_0-9]+\(.*\)/)
#      if elem.match(/\(.*\)/)
#      if elem.include?("(.*")
        
        #ref append https://stackoverflow.com/questions/12163625/create-or-append-to-array-in-ruby#12163661
        aryOf_Funcs.push(aryOf_tokens)
        
        # set : flag
        flg_IsFunc = true
        
        break
        
      end#if elem.match(/^[a-zA-Z_]+\(.*\)/)
      
    end#aryOf_tokens.each do |elem|
    
    # flag : set ?
    if flg_IsFunc == false
      
      aryOf_Vars.push(aryOf_tokens)
      
    # flag : reset
    else # flag is true : func
      
      flg_IsFunc = false
      
    end
    
  end#aryOf_FuncNames.each do |item|
  
  #debug
  puts "[#{File.basename(__FILE__)}:#{__LINE__}] aryOf_Funcs ==>"
  
  aryOf_Funcs.each do |elem|
    
    p elem
    
  end
  
  puts "[#{File.basename(__FILE__)}:#{__LINE__}] aryOf_Vars ==>"
  
  aryOf_Vars.each do |elem|
    
    p elem
    
  end
  
  ################################
  #	
  #	array ---> sort
  #
  ################################
  #ref http://qiita.com/hachy/items/750002ee7787485b9de7
  aryOf_FuncNames__Sorted = aryOf_FuncNames.sort { |a, b| a[1] <=> b[1] }

  #debug
  puts "[#{File.basename(__FILE__)}:#{__LINE__}] aryOf_FuncNames__Sorted ==>"
  
  p aryOf_FuncNames__Sorted

  # aryOf_Funcs
  aryOf_Funcs__Sorted = aryOf_Funcs.sort { |a, b| a[1] <=> b[1] }
  aryOf_Vars__Sorted = aryOf_Vars.sort { |a, b| a[1] <=> b[1] }

  #debug
  puts ""
  puts "(sorted)------------------------------"
  
  puts "[#{File.basename(__FILE__)}:#{__LINE__}] aryOf_Funcs__Sorted ==>"
  
  aryOf_Funcs__Sorted.each do |elem|
    
    p elem
    
  end
  
  puts "[#{File.basename(__FILE__)}:#{__LINE__}] aryOf_Vars__Sorted ==>"
  
  aryOf_Vars__Sorted.each do |elem|
    
    p elem
    
  end
    
  ################################
  #	
  #	write to file
  #
  ################################
  _exec_2_MakeList__Write2File(aryOf_Funcs__Sorted, aryOf_Vars__Sorted, dir, fname, count)
#  _exec_2_MakeList__Write2File(aryOf_Funcs__Sorted, dir, fname, count)

  #debug
  return
      
  #aaa
  
#  time_Label = get_TimeLabel_Now
#
#  time_Label_Readable = get_TimeLabel_Now("readable")
#  
#  fpath_Out = dir + "/" + "func-list_#{fname}_#{time_Label}.txt"
#  
#  puts "[#{File.basename(__FILE__)}:#{__LINE__}] fpath_Out => #{fpath_Out}"
#  
#  puts
#  
#  fout = File.open(fpath_Out, "w");
#  
#  # header
#  fout.write("Target file = #{fname}")
#  fout.write("\n")
#  
#  #ref expand https://docs.ruby-lang.org/ja/latest/method/File/s/expand_path.html
#  fout.write("dir = #{File.expand_path(dir)}")
##  fout.write("dir = #{dir}")
#  fout.write("\n")
#  
#  fout.write("Entries = #{count.to_s}")
#  fout.write("\n")
#  
#  fout.write("Created at = #{time_Label_Readable}")
#  fout.write("\n")
#  
##  fout.write("Created by = #{__FILE__} (#{File.dirname(__FILE__)})")
#  #ref dirpath https://stackoverflow.com/questions/1937743/how-to-get-the-current-working-directorys-absolute-path-from-irb#1937761
#  fout.write("Created by = #{__FILE__} (#{File.dirname(File.expand_path(__FILE__))})")
##  fout.write("Created by = #{__FILE__}")
#  fout.write("\n")
#  
#  fout.write("This file = #{File.expand_path(fpath_Out)}")
##  fout.write("This file = #{fpath_Out}")
#  fout.write("\n")
#  
#  fout.write("\n")
#  
#  fout.write("==========================================")
#  fout.write("\n")
#  fout.write("\n")
#  
#  # write lines
#  aryOf_FuncNames__Sorted.each_with_index {|pair, i|
#    
#    #ref https://ref.xaio.jp/ruby/classes/string/strip
#    fout.write("#{(i + 1).to_s}\t#{pair[0]} #{pair[1].strip}")
##    fout.write("#{(i + 1).to_s}\t#{pair[0]}\t#{pair[1].strip}")
##    fout.write("#{(i + 1).to_s}\t#{pair[0]}\t#{pair[1]}")
#    
#    fout.write("\n")
#    
#  }
#  
#  fout.write("\n")
#  fout.write("==========================================")
#  fout.write("\n")
#
#  fout.close
  
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

def _exec_2_MakeList__V2(dpath_Src, fname_Src, dpath_Dst)
  
    ####################
    # file : open
    ####################
  fpath_Src = "#{dpath_Src}\\#{fname_Src}"
  
  #ref http://uxmilk.jp/22615
  f = File.open(fpath_Src, "r")
#  f = File.open(fpath, "r")
  
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
    #hit = line.match(/^(int|void|string) (.+)/)
#    hit = line.match(/^(int|void|string|bool) (.+)/)
#    hit = line.match(/^(int|void|string|bool) ([a-zA-Z0-9_]+)/)
#    hit = line.match(/^(int|void|string|bool) ([a-zA-Z0-9_]+[ }]*[\(]*)/)  #=> working
    hit = line.match(/^(int|void|string|bool) ([a-zA-Z0-9_]+[ }]*[\(]*[a-zA-Z0-9_ ,]*[\)]*)/)
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

    end
    
  end
  
  f.close
  
  ################################
  #	
  #	array ---> funcs, vars
  #
  ################################
  aryOf_Funcs = []
  aryOf_Vars = []
  
  flg_IsFunc = false
    
  aryOf_FuncNames.each do |aryOf_tokens|
    
    aryOf_tokens.each do |elem|
      
      #debug
      puts "[#{File.basename(__FILE__)}:#{__LINE__}] aryOf_tokens => #{aryOf_tokens.join(" - ")}"
      
      # func?
      #ref substring https://stackoverflow.com/questions/8258517/how-to-check-whether-a-string-contains-a-substring-in-ruby#8258571
      #ref match substring https://stackoverflow.com/questions/4115115/extract-a-substring-from-a-string-in-ruby-using-a-regular-expression#4115144
      #if elem.match(/^[a-zA-Z_]+\(.*\)/)
      #ref regex numerical https://www.regular-expressions.info/numericranges.html
      if elem.match(/^[a-zA-Z_0-9]+\(.*\)/) \
        or elem.match(/^[a-zA-Z_0-9]+\(.*$/) \
        or elem.match(/^[a-zA-Z_0-9]+$/)
#        or elem.match(/^[a-zA-Z_0-9]+$/)
        
        
        #ref append https://stackoverflow.com/questions/12163625/create-or-append-to-array-in-ruby#12163661
        aryOf_Funcs.push(aryOf_tokens)
        
        # set : flag
        flg_IsFunc = true
        
        break
        
      end#if elem.match(/^[a-zA-Z_]+\(.*\)/)
      
    end#aryOf_tokens.each do |elem|
    
    # flag : set ?
    if flg_IsFunc == false
      
      aryOf_Vars.push(aryOf_tokens)
      
    # flag : reset
    else # flag is true : func
      
      flg_IsFunc = false
      
    end
    
  end#aryOf_FuncNames.each do |item|
  
  #debug
  puts "[#{File.basename(__FILE__)}:#{__LINE__}] aryOf_Funcs ==>"
  
  aryOf_Funcs.each do |elem|
    
    p elem
    
  end
  
  puts "[#{File.basename(__FILE__)}:#{__LINE__}] aryOf_Vars ==>"
  
  aryOf_Vars.each do |elem|
    
    p elem
    
  end
  
  ################################
  #	
  #	array ---> sort
  #
  ################################
  #ref http://qiita.com/hachy/items/750002ee7787485b9de7
  aryOf_FuncNames__Sorted = aryOf_FuncNames.sort { |a, b| a[1] <=> b[1] }

  #debug
  puts "[#{File.basename(__FILE__)}:#{__LINE__}] aryOf_FuncNames__Sorted ==>"
  
  p aryOf_FuncNames__Sorted

  # aryOf_Funcs
  aryOf_Funcs__Sorted = aryOf_Funcs.sort { |a, b| a[1] <=> b[1] }
  aryOf_Vars__Sorted = aryOf_Vars.sort { |a, b| a[1] <=> b[1] }

  #debug
  puts ""
  puts "(sorted)------------------------------"
  
  puts "[#{File.basename(__FILE__)}:#{__LINE__}] aryOf_Funcs__Sorted ==>"
  
  aryOf_Funcs__Sorted.each do |elem|
    
    p elem
    
  end
  
  puts "[#{File.basename(__FILE__)}:#{__LINE__}] aryOf_Vars__Sorted ==>"
  
  aryOf_Vars__Sorted.each do |elem|
    
    p elem
    
  end
    
  ################################
  #	
  #	write to file
  #
  ################################
  _exec_2_MakeList__Write2File( \
          aryOf_Funcs__Sorted \
          , aryOf_Vars__Sorted \
          , dpath_Src \
          , fname_Src \
          , count \
          , dpath_Dst)
#          aryOf_Funcs__Sorted, aryOf_Vars__Sorted, dir, fname, count)
#  _exec_2_MakeList__Write2File(aryOf_Funcs__Sorted, dir, fname, count)
#aryOf_Funcs \
#, aryOf_Vars \
#, dpath_Src \
#, fname \
#, count \
#, dpath_Dst)
          
          #abc dpath_Src, fname_Src, dpath_Dst
  #debug
  return
      
  #aaa
  
#  time_Label = get_TimeLabel_Now
#
#  time_Label_Readable = get_TimeLabel_Now("readable")
#  
#  fpath_Out = dir + "/" + "func-list_#{fname}_#{time_Label}.txt"
#  
#  puts "[#{File.basename(__FILE__)}:#{__LINE__}] fpath_Out => #{fpath_Out}"
#  
#  puts
#  
#  fout = File.open(fpath_Out, "w");
#  
#  # header
#  fout.write("Target file = #{fname}")
#  fout.write("\n")
#  
#  #ref expand https://docs.ruby-lang.org/ja/latest/method/File/s/expand_path.html
#  fout.write("dir = #{File.expand_path(dir)}")
##  fout.write("dir = #{dir}")
#  fout.write("\n")
#  
#  fout.write("Entries = #{count.to_s}")
#  fout.write("\n")
#  
#  fout.write("Created at = #{time_Label_Readable}")
#  fout.write("\n")
#  
##  fout.write("Created by = #{__FILE__} (#{File.dirname(__FILE__)})")
#  #ref dirpath https://stackoverflow.com/questions/1937743/how-to-get-the-current-working-directorys-absolute-path-from-irb#1937761
#  fout.write("Created by = #{__FILE__} (#{File.dirname(File.expand_path(__FILE__))})")
##  fout.write("Created by = #{__FILE__}")
#  fout.write("\n")
#  
#  fout.write("This file = #{File.expand_path(fpath_Out)}")
##  fout.write("This file = #{fpath_Out}")
#  fout.write("\n")
#  
#  fout.write("\n")
#  
#  fout.write("==========================================")
#  fout.write("\n")
#  fout.write("\n")
#  
#  # write lines
#  aryOf_FuncNames__Sorted.each_with_index {|pair, i|
#    
#    #ref https://ref.xaio.jp/ruby/classes/string/strip
#    fout.write("#{(i + 1).to_s}\t#{pair[0]} #{pair[1].strip}")
##    fout.write("#{(i + 1).to_s}\t#{pair[0]}\t#{pair[1].strip}")
##    fout.write("#{(i + 1).to_s}\t#{pair[0]}\t#{pair[1]}")
#    
#    fout.write("\n")
#    
#  }
#  
#  fout.write("\n")
#  fout.write("==========================================")
#  fout.write("\n")
#
#  fout.close
  
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

def _judge_Funcs(line)
  
  ####################
  # match
  ####################
#  regex = /^(int|void|string|bool) ([a-zA-Z0-9_]+[ }]*[\(]*[a-zA-Z0-9_ ,]*[\)]*)/
  regex = /^(int|void|string|bool)[ ]+([a-zA-Z0-9_]+[ ]*[}]*[\(]*[a-zA-Z0-9_ ,]*[\)]*)[ ]*[^;]$/

  #debug
  #puts "[#{File.basename(__FILE__)}:#{__LINE__}] line => #{line}"    

  hit = line.match(regex)
  
  #puts "[#{File.basename(__FILE__)}:#{__LINE__}] regex => #{regex}"    
#  puts "[#{File.basename(__FILE__)}:#{__LINE__}] hit =>"    
  
#  p hit
  
  ####################
  # return
  ####################
  return hit
  
end#/def _judge_Funcs(line)

def _judge_Vars(line)
  
  ####################
  # match
  ####################
#  regex = /^(int|void|string|bool) ([a-zA-Z0-9_]+[ }]*[\(]*[a-zA-Z0-9_ ,]*[\)]*)/
  # string PGName = "abc";
  
  #regex = /^(int|void|string|bool) ([a-zA-Z0-9_]+[ ]*[ ]+=[ ]+(.)+[ ]*;)/
   regex = /^(int|void|string|bool) ([a-zA-Z0-9_]+[ ]*[ ]+=[ ]+(.)+[ ]*;(.)*)$/

  hit = line.match(regex)
  
  ####################
  # return
  ####################
  return hit
  
end#/def _judge_Vars(line)

def _judge_Externs(line)
  
  ####################
  # match
  ####################
  # e.g. "extern int Time_period        = PERIOD_M1;"
  #regex = /^extern[ ]+(int|void|string|bool|double) ([a-zA-Z0-9_]+[ ]*[ ]*=[ ]*(.)+[ ]*[;]*)/
  regex = /^(extern|input)[ ]+(int|void|string|bool|double)[ ]+([a-zA-Z0-9_]+[ ]*[ ]*=[ ]*(.)+[ ]*[;]*)/

  hit = line.match(regex)
  
  ####################
  # return
  ####################
  return hit
  
end#/def _judge_Externs(line)

def _collect_Items(lines)
  
  ####################
  # vars
  ####################
  aryOf_Funcs = []
  aryOf_Vars = []
  aryOf_Externs = []
  
  ####################
  # judge
  ####################
  lines.each do |line|
    
    ####################
    # judge : funcs
    ####################
    hit = _judge_Funcs(line)
    
    #judge
    if hit
      
      aryOf_Funcs << line.strip
      
      next
    
    end#if hit
    
    ####################
    # judge : vars
    ####################
    hit = _judge_Vars(line)
    
    #judge
    if hit
    
      aryOf_Vars << line.strip
#      aryOf_Vars << line
      
      next
    
    end#if hit
    
    ####################
    # judge : externs
    ####################
    hit = _judge_Externs(line)
    
    #judge
    if hit
    
      aryOf_Externs << line.strip
#      aryOf_Vars << line
      
      next
    
    end#if hit
    
  end#lines.each do |line|

  ####################
  # return
  ####################
  #debug
  puts "[#{File.basename(__FILE__)}:#{__LINE__}] aryOf_Funcs =>"
  
  p aryOf_Funcs
  puts ""
  
  return aryOf_Funcs, aryOf_Vars, aryOf_Externs
  
end#def _collect_Items(lines)

def _exec_2_MakeList__V3(dpath_Src, fname_Src, dpath_Dst)
  
    ####################
    # file : open
    ####################
  fpath_Src = "#{dpath_Src}\\#{fname_Src}"
  
  #ref http://uxmilk.jp/22615
  f = File.open(fpath_Src, "r")
#  f = File.open(fpath, "r")
  
  #debug
  count = 0
  
  #ref http://www.sejuku.net/blog/14332
  aryOf_FuncNames = Array.new()
  
  # read lines
  lines = f.readlines()
  
#  #debug
#  puts "[#{File.basename(__FILE__)}:#{__LINE__}] readlines ==> done"
#  return
  
  aryOf_Funcs, aryOf_Vars, aryOf_Externs = _collect_Items(lines)
#  aryOf_Funcs, aryOf_Vars = _collect_Items(lines)

  #debug
  puts "[#{File.basename(__FILE__)}:#{__LINE__}] aryOf_Externs ==>"
  p aryOf_Externs
  puts ""
      #  ["extern int Time_period        = PERIOD_M1;", "extern int MagicNumber=10001;", "extern double Lots
      #  =0.1;", "extern double StopLoss=3;  // StopLoss (in pips)", "extern double TakeProfit=7;  // TakePro
      #  fit (in pips)", "extern int TrailingStop=0.03;", "extern int Slippage=0.01;", "extern string Sym_Set
      #   = \"EURJPY\";"]

  ################################
  #	
  #	array ---> sort
  #
  ################################
#  #ref http://qiita.com/hachy/items/750002ee7787485b9de7
#  aryOf_FuncNames__Sorted = aryOf_FuncNames.sort { |a, b| a[1] <=> b[1] }
#
#  #debug
#  puts "[#{File.basename(__FILE__)}:#{__LINE__}] aryOf_FuncNames__Sorted ==>"
#  
#  p aryOf_FuncNames__Sorted

  # aryOf_Funcs
  #@_20190128_152126
  # e.g. "bool is_Up_Bar() {" ==> split(" ")
  aryOf_Funcs__Sorted = aryOf_Funcs.sort { |a, b| a.split(" ")[1] <=> b.split(" ")[1] }
#  aryOf_Funcs__Sorted = aryOf_Funcs.sort { |a, b| a[1] <=> b[1] }
  aryOf_Vars__Sorted = aryOf_Vars.sort { |a, b| a.split(" ")[1] <=> b.split(" ")[1] }
#  aryOf_Vars__Sorted = aryOf_Vars.sort { |a, b| a[1] <=> b[1] }

  aryOf_Externs__Sorted = aryOf_Externs.sort { |a, b| a.split(" ")[2] <=> b.split(" ")[2] }
    
  #debug
  puts ""
  puts "(sorted)------------------------------"
  
  puts "[#{File.basename(__FILE__)}:#{__LINE__}] aryOf_Funcs__Sorted ==>"
  
  aryOf_Funcs__Sorted.each do |elem|
    
    p elem
    
  end
  
  puts "[#{File.basename(__FILE__)}:#{__LINE__}] aryOf_Vars__Sorted ==>"
  
  aryOf_Vars__Sorted.each do |elem|
    
    p elem
    
  end
    
  ################################
  #	
  #	write to file
  #
  ################################
#  _exec_2_MakeList__Write2File( \
#          aryOf_Funcs__Sorted \
#          , aryOf_Vars__Sorted \
#          , dpath_Src \
#          , fname_Src \
#          , count \
#          , dpath_Dst)
          
#          aryOf_Funcs__Sorted, aryOf_Vars__Sorted, dir, fname, count)
#  _exec_2_MakeList__Write2File(aryOf_Funcs__Sorted, dir, fname, count)
#aryOf_Funcs \
#, aryOf_Vars \
#, dpath_Src \
#, fname \
#, count \
#, dpath_Dst)
          
          #abc dpath_Src, fname_Src, dpath_Dst
  
  ################################
  #  return
  ################################
  return count, aryOf_Funcs__Sorted, aryOf_Vars__Sorted, aryOf_Externs__Sorted
#  return count, aryOf_Funcs__Sorted, aryOf_Vars__Sorted
#  return
      
  #aaa
  
#  time_Label = get_TimeLabel_Now
#
#  time_Label_Readable = get_TimeLabel_Now("readable")
#  
#  fpath_Out = dir + "/" + "func-list_#{fname}_#{time_Label}.txt"
#  
#  puts "[#{File.basename(__FILE__)}:#{__LINE__}] fpath_Out => #{fpath_Out}"
#  
#  puts
#  
#  fout = File.open(fpath_Out, "w");
#  
#  # header
#  fout.write("Target file = #{fname}")
#  fout.write("\n")
#  
#  #ref expand https://docs.ruby-lang.org/ja/latest/method/File/s/expand_path.html
#  fout.write("dir = #{File.expand_path(dir)}")
##  fout.write("dir = #{dir}")
#  fout.write("\n")
#  
#  fout.write("Entries = #{count.to_s}")
#  fout.write("\n")
#  
#  fout.write("Created at = #{time_Label_Readable}")
#  fout.write("\n")
#  
##  fout.write("Created by = #{__FILE__} (#{File.dirname(__FILE__)})")
#  #ref dirpath https://stackoverflow.com/questions/1937743/how-to-get-the-current-working-directorys-absolute-path-from-irb#1937761
#  fout.write("Created by = #{__FILE__} (#{File.dirname(File.expand_path(__FILE__))})")
##  fout.write("Created by = #{__FILE__}")
#  fout.write("\n")
#  
#  fout.write("This file = #{File.expand_path(fpath_Out)}")
##  fout.write("This file = #{fpath_Out}")
#  fout.write("\n")
#  
#  fout.write("\n")
#  
#  fout.write("==========================================")
#  fout.write("\n")
#  fout.write("\n")
#  
#  # write lines
#  aryOf_FuncNames__Sorted.each_with_index {|pair, i|
#    
#    #ref https://ref.xaio.jp/ruby/classes/string/strip
#    fout.write("#{(i + 1).to_s}\t#{pair[0]} #{pair[1].strip}")
##    fout.write("#{(i + 1).to_s}\t#{pair[0]}\t#{pair[1].strip}")
##    fout.write("#{(i + 1).to_s}\t#{pair[0]}\t#{pair[1]}")
#    
#    fout.write("\n")
#    
#  }
#  
#  fout.write("\n")
#  fout.write("==========================================")
#  fout.write("\n")
#
#  fout.close
  
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
  
end#def _exec_2_MakeList__V3(dpath_Src, fname_Src, dpath_Dst)

#xxx
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

  # report
  #ref multi lines https://stackoverflow.com/questions/2337510/ruby-can-i-write-multi-line-string-with-no-concatenation#6032910
  puts "[#{File.basename(__FILE__)}:#{__LINE__}] path, name currently ==>" \
      "\ndir : #{dir}" \
      "\nfname : #{fname}"
  
  
  
  ################################
  # 
  # dat file
  #
  ################################
  #ref quote expression https://blog.appsignal.com/2016/12/21/ruby-magic-escaping-in-ruby.html
  #tmp_Dpath = %q"C:\Users\iwabuchiken\AppData\Roaming\MetaQuotes\Terminal\34B08C83A5AAE27A4079DE708E60511E\MQL4\utils"
  tmp_Dpath = GLOBAL_tmp_Dpath
  
  tmp_Fname = "utils.20171123-121700.dat"
  
  tmp_Fpath = "#{tmp_Dpath}\\#{tmp_Fname}"
  
  if File.exists?(tmp_Fpath)

    puts "[#{File.basename(__FILE__)}:#{__LINE__}] file => exists : #{tmp_Fpath}"
    
    # read lines
    f_Dat = File.open(tmp_Fpath, "r")
    
    # array
    #ref associative https://stackoverflow.com/questions/4266695/ruby-associative-arrays#4266731
    params = {}
    
    f_Dat.each_line do |line|
      
      # comment line
      if line.start_with?("#")
        
        next
        
      end
      
#      puts "[#{File.basename(__FILE__)}:#{__LINE__}] line => '#{line}'"
      
      tokens = line.split("=")
      
      # validate
      if tokens.length < 2
        
        next
        
      end#if tokens.length < 2
      
      # set vars
      params[tokens[0].strip] = tokens[1].strip
#      params[tokens[0]] = tokens[1]
      
    end#f.each_line do |line|
    
    # close
    f_Dat.close
    
#    # report
#    puts "[#{File.basename(__FILE__)}:#{__LINE__}] params =>"
#    
#    p params
    
    # validate
    key_Dpath = "dpath_Target"
    key_Fname = "fname_Target"
    
    #ref https://stackoverflow.com/questions/4528506/how-to-check-if-a-specific-key-is-present-in-a-hash-or-not#4528522
    if params.key?(key_Dpath) and params.key?(key_Fname)
      
      puts "[#{File.basename(__FILE__)}:#{__LINE__}] keys exist\n#{key_Dpath} : #{params[key_Dpath]}\n#{key_Fname} : #{params[key_Fname]}"
#      puts "[#{File.basename(__FILE__)}:#{__LINE__}] key exists => #{key_Dpath} : #{params[key_Dpath]}"
    
      # set variables
      dir = params[key_Dpath]
      fname = params[key_Fname]
      
      # report
      puts "[#{File.basename(__FILE__)}:#{__LINE__}] path, name ==> updated" \
            "\ndir : #{dir}" \
            "\nfname : #{fname}"
      
      
    else
      
      puts "[#{File.basename(__FILE__)}:#{__LINE__}] key NOT exists => #{key_Dpath}"
      
    end
    
  else
    
    puts "[#{File.basename(__FILE__)}:#{__LINE__}] file => NOT exists : #{tmp_Fpath}"
    
  end#if File.exists?(tmp_Fpath)
  
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
  fpath = "#{dir}#{File::SEPARATOR}#{fname}"
#  fpath = q%"#{dir}\#{fname}"
#  fpath = dir + "/" + fname
  
  if File.exists?(fpath)

    puts "[#{File.basename(__FILE__)}:#{__LINE__}] file => exists : #{fpath}"
    
  
  else#if (File.exists?(dir))
  
    puts "[#{File.basename(__FILE__)}:#{__LINE__}] file => NOT exists : #{fpath}"
    
    puts "[#{File.basename(__FILE__)}:#{__LINE__}] quitting..."
    
    return -1
    
  end#if (File.exists?(dir))

#  #debug
#  return
  
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

def exec_2
  
  ################################
  #	
  #	setup
  #
  ################################
  lenOf_ARGs = ARGV.length
  
  ################################
  #	
  #	dflt values
  #
  ################################
  if lenOf_ARGs < 1
    
    puts "[#{File.basename(__FILE__)}:#{__LINE__}] args needed ==>\n" \
        "<Usage> utils.20171123-121700.rb <source dpath> <source file name> <dest dir path>"
    
    return
  
  else
    
    dpath_Src = ARGV[0]
    
    fname_Src = ARGV[1]
    
    dpath_Dst = ARGV[2]
    
  end#if lenOf_ARGs < 1

  # report
  #ref multi lines https://stackoverflow.com/questions/2337510/ruby-can-i-write-multi-line-string-with-no-concatenation#6032910
  puts "[#{File.basename(__FILE__)}:#{__LINE__}] args ==>\n" \
      "dpath_Src = #{dpath_Src}\n" \
      "fname_Src = #{fname_Src}\n" \
      "dpath_Dst = #{dpath_Dst}\n"
  
#  #debug
#  return
      
  ################################
  # 
  # validate : source file, source dir
  #
  ################################
  #ref quote expression https://blog.appsignal.com/2016/12/21/ruby-magic-escaping-in-ruby.html
  #tmp_Dpath = %q"C:\Users\iwabuchiken\AppData\Roaming\MetaQuotes\Terminal\34B08C83A5AAE27A4079DE708E60511E\MQL4\utils"
  fpath_Src = "#{dpath_Src}\\#{fname_Src}"
  
  if File.exists?(fpath_Src)

    puts "[#{File.basename(__FILE__)}:#{__LINE__}] file => exists : #{fpath_Src}"
    
  else
    
    puts "[#{File.basename(__FILE__)}:#{__LINE__}] file => NOT exists : #{fpath_Src}"
    
    return -1
    
  end#if File.exists?(tmp_Fpath)

#  #debug
#  return
    
  ################################
  #	
  #	validate : dest dir
  #
  ################################
  if File.exists?(dpath_Dst)
  
    puts "[#{File.basename(__FILE__)}:#{__LINE__}] dpath_Dst => exists : #{dpath_Dst}"
    
  
  else#if (File.exists?(dir))
  
    puts "[#{File.basename(__FILE__)}:#{__LINE__}] dpath_Dst => NOT exists : #{dpath_Dst}"
    
    puts "[#{File.basename(__FILE__)}:#{__LINE__}] quitting..."
    
    return -1
    
  end#if (File.exists?(dir))

  ################################
  #	
  #	file content
  #
  ################################
#  _exec_2_MakeList__V2(dpath_Src, fname_Src, dpath_Dst)
#  _exec_2_MakeList(fpath, dir, fname)
  
  #@_20190128_112142
  count, aryOf_Funcs__Sorted, aryOf_Vars__Sorted, aryOf_Externs__Sorted = \
          _exec_2_MakeList__V3(dpath_Src, fname_Src, dpath_Dst)
#  count, aryOf_Funcs__Sorted, aryOf_Vars__Sorted = _exec_2_MakeList__V3(dpath_Src, fname_Src, dpath_Dst)
  #ccc
  ################################
  #	
  #	write to file
  #
  ################################
#  fpath_Src = "#{dpath_Src}\\#{fname_Src}"
  
  _exec_2_MakeList__Write2File__V2( \
        aryOf_Funcs__Sorted \
        , aryOf_Vars__Sorted \
        , aryOf_Externs__Sorted \
        , dpath_Src \
        , fname_Src \
        , count \
        , dpath_Dst)  
  #ccc
  ################################
  #	
  #	message : final
  #
  ################################
#  puts "[#{File.basename(__FILE__)}:#{__LINE__}] dir = #{dir} / fname = #{fname}"
  
  puts "[#{File.basename(__FILE__)}:#{__LINE__}] done"
  
  
end#exec_2

exec_2
#exec
