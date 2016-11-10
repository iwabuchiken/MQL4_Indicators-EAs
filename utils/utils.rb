# utils\utils.rb
# http://info.finance.yahoo.co.jp/fx/marketcalendar/detail/9301
# <Usage>
#   0. Change directory to: C:\Users\iwabuchiken\AppData\Roaming\MetaQuotes\Terminal\34B08C83A5AAE27A4079DE708E60511E\MQL4
#   1. Copy the data to --> utils/text-1.txt
#   2. Run the program: utils\utils.rb
#   3. COpy the data from: utils/text-1.processed.XXXXXXXX_XXXXXX.txt
#         to: web sheet


def exec_

#  fname = "text-1.txt"
  fname_src = "utils/text-1.txt"
  fname_dst = "utils/text-1.processed.#{get_timelabel_serial()}.txt"
  
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

def get_timelabel_serial

    #ref https://www.tutorialspoint.com/ruby/ruby_date_time.htm
    return Time.new.strftime("%Y%m%d\%H%M%S")
  
end

exec_
