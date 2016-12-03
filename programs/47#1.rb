=begin

  47#1.rb
  2016/12/03 11:24:51

pushd C:\Users\iwabuchiken\AppData\Roaming\MetaQuotes\Terminal\34B08C83A5AAE27A4079DE708E60511E\MQL4\programs
ruby 47#1.rb


=end

def execute
  
  f = File.open("CD.consumer-confidence.txt", "r")
  
  f.each_line {|line|
    
    puts line
    
  }
  
#  ary = f.readlines
#  
#  p ary
  
  f.close
  
  puts "file => closed"
  
end

def exec_(fname)

#  fname = "text-1.txt"
#  fname = "US.GDP.4Qs"
  fname_src = "#{fname}.txt"
  fname_dst = "#{fname}.processed.#{get_timelabel_serial()}.txt"
#  fname_src = "CD.consumer-confidence.txt"
#  fname_dst = "CD.consumer-confidence.processed.#{get_timelabel_serial()}.txt"
#  fname_src = "programs/CD.consumer-confidence.txt"
#  fname_dst = "programs/CD.consumer-confidence.#{get_timelabel_serial()}.txt"
#  fname_src = "utils/text-1.txt"
#  fname_dst = "utils/text-1.processed.#{get_timelabel_serial()}.txt"
  
  begin
    
    f_src = File.open(fname_src, "r")
    f_dst = File.open(fname_dst, "w")
#    f_dst = File.open(fname_src, "w")
    
    puts "files opened"
    
    tab_string = "\t"
    return_string = "\r"
    
    count = 0
    
    #test
#    puts f_src.gets
    
#    File.readlines(fname_src).each do |line|
    f_src.each do |line|
      
        puts "processing line..."
        
        #test
#        puts f_src.gets
        puts line
      
        #ref http://ref.xaio.jp/ruby/classes/string/strip
#        tokens = line.split(tab_string)
        tokens = line.strip.split(tab_string)
        
        #test
#        p tokens
#      
        tokens_reverse = tokens.reverse
        
        line_final = tokens_reverse[0..-2].join(return_string)
#        line_final = tokens_reverse[0..-2].join(tab_string)
#        line_final = tokens_reverse.join(tab_string)
        
        f_dst.write(line_final)
        
        f_dst.write("\n")
        
        count += 1
    end
#        
##    end
    
    
    f_src.close
    f_dst.close
    
    puts "lines => #{count} / file closed"
    
  rescue => e
    
    p e
    
  end
  
#    puts "hi"
    
end

##########################
# 
# get_quarter_average(fname_src)
#   @param fname_src  => "CB.CC.2016.txt" (extension included)
#
##########################
def get_quarter_average(fname_src)
  
#  fname_src = "CB.CC.2016.txt"
  
  f = File.open(fname_src, "r")

  #ref http://stackoverflow.com/questions/6012930/how-to-read-lines-of-a-file-in-ruby
  text = f.read
  
  text.gsub!(/\r\n?/, "\n")
  
  p text
  
  #ref http://stackoverflow.com/questions/5809093/how-do-i-read-line-by-line-a-text-file-in-ruby-hosting-it-on-s3 http://stackoverflow.com/questions/5809093/how-do-i-read-line-by-line-a-text-file-in-ruby-hosting-it-on-s3
#  p text.split("\n")
#  
#  p text.split("\n").map{|item| item.to_i}
  
  #ref http://ref.xaio.jp/ruby/classes/array/map
  ary = text.split("\n").map{|item| item.to_f}
  
  p ary
  
  puts  "size => #{ary.size}"
    
  ###########################
  # build quartered numbers
  ###########################
  count = 1
  
  sum = 0
  #ref http://stackoverflow.com/questions/4908413/how-to-initialize-an-array-in-one-step-using-ruby asked Feb 5 '11 at 17:36
  ary_quartered = Array.new
  
  ary.each {|e|
    
    sum += e
    
    if count % 3 == 0
      
#      p sum / 3.0
      
      ary_quartered << (sum / 3.0).round(2)
#      ary_quartered << sum / 3.0
      
      sum = 0
      
    end
    
    count += 1
    
  }#ary.each {|e|
    
  puts "============ array created ==========="
  
  p ary_quartered
  
  puts  "size => #{ary_quartered.size}"

  ###########################
  # file: write  
  ###########################
  fname_src_trunk = fname_src.split(".")[0..-2].join(".")
  
  fname_src_ext = fname_src.split(".")[-1]
  
  fname_dst = "#{fname_src_trunk}.quartered.#{get_timelabel_serial}.#{fname_src_ext}"
  
  f = File.open(fname_dst, "w")
  
  ary_quartered.each {|e|
   
    f.write(e)
    f.write("\n")
     
  }
  
  f.close
  
  #report
  puts "file => written (#{fname_dst})"
  
end#get_quarter_average

def get_timelabel_serial

    #ref https://www.tutorialspoint.com/ruby/ruby_date_time.htm
    return Time.new.strftime("%Y%m%d_%H%M%S")
  
end

def show_help
  
  puts "<Usage>"
  puts "\t ruby 47#1.rb [args]"
  puts "\t -C\t CB consumer conference"
  puts "\t -G\t US GDP quarter"
  
end#show_help

#exec_
#get_quarter_average

######################################
#   executions
######################################
arg0 = ARGV[0]

if arg0 == "-h" or arg0 == "h" then
  
  show_help
  
elsif arg0 == "-C" or arg0 == "-c" or arg0 == "c" or arg0 == "C"
  
  puts "calling => get_quarter_average"
  
  get_quarter_average("CB.CC.2016.txt")   #=> convert --> monthly data to quarterly one

elsif arg0 == "-G" or arg0 == "-g" or arg0 == "g" or arg0 == "G"
  
  exec_("US.GDP.4Qs")   #=> convert: table-format to 1 column series
  
end
