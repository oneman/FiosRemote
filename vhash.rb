require 'rubygems'
require 'active_record'

ActiveRecord::Base.establish_connection(
  :adapter => 'postgresql',
  :database => 'fiosv',
  :username => 'oneman',
  :password => 'funworld',
  :host => 'localhost',
  :port => '5432'
)

#ActiveRecord::Base.logger = Logger.new(STDERR)

def dec2hex(number)
   number = Integer(number.to_i);
   hex_digit = "0123456789ABCDEF".split(//);
   ret_hex = '';
   while(number != 0)
      ret_hex = String(hex_digit[number % 16 ] ) + ret_hex;
      number = number / 16;
   end
   return ret_hex; ## Returning HEX
end
class NilClass
def show
 puts "NOT FOUND"
end

end

class Vhash < ActiveRecord::Base
set_table_name "vhashes"

def show
 puts "FOUND input: #{self.input} as decimal: #{self.input_to_decimal_timecode} ouput: #{self.output}"
end

def hash_as_array
 v = self
 
 hash_array = [v.output[0..1], v.output[2..3], v.output[4..5], v.output[6..7], v.output[8..9], v.output[10..11], v.output[12..13], v.output[14..15], v.output[16..17], v.output[18..19], 
         v.output[20..21], v.output[22..23], v.output[24..25], v.output[26..27], v.output[28..29], v.output[30..31], v.output[32..33], v.output[34..35], v.output[36..37], v.output[38..39] ]
 
 puts hash_array.join(" ")
 
 return hash_array

end

def hash
 output
end

def input_to_decimal
  self.input[0..1].hex.to_s + self.input[2..3].hex.to_s + self.input[4..5].hex.to_s +  self.input[6..7].hex.to_s
end

def input_to_decimal_timecode
  self.input[0..1].hex.to_s + "-" + self.input[2..3].hex.to_s + ":" + self.input[4..5].hex.to_s + "." + self.input[6..7].hex.to_s
end

end

def find_by_time(time)

 hours,minutes,seconds = time.split(":")

 if minutes.length < 2
  minutes = "0" + minutes.to_s
 end

 if hours.length < 2
  hours = "0" + hours.to_s
 end

 if seconds.length < 2
  seconds = "0" + seconds.to_s
 end

 if hours.to_s == "0"
     hours = "00"
 end

 if seconds.to_s == "0"
     seconds = "00"
 end

 if minutes.to_s == "0"
     minutes = "00"
 end
 puts "converting 00#{hours}#{minutes}#{seconds} to hex"
 hours = dec2hex(hours)
 minutes = dec2hex(minutes)
 seconds = dec2hex(seconds)

 if minutes.length < 2
  minutes = "0" + minutes.to_s
 end

 if hours.length < 2
  hours = "0" + hours.to_s
 end

 if seconds.length < 2
  seconds = "0" + seconds.to_s
 end

 if hours.to_s == "0"
     hours = "00"
 end

 if seconds.to_s == "0"
     seconds = "00"
 end

 if minutes.to_s == "0"
     minutes = "00"
 end

 puts "searching for 00#{hours}#{minutes}#{seconds}"
 result = Vhash.find_by_input("00#{hours}#{minutes}#{seconds}")
 if result != nil
  puts "found hash for time #{result.hash}"
  return result
 else
   puts "oh no couldnt find!"
   Kernel.exit
 end

end

#v1 = Vhash.find(:first)
#v1.show
#puts v1.hash

#v2 = find_by_time("2:35:36")

#x = Time.parse("01/01/1970")
#86400.times do 
#x = x + 1.second
#vhash = find_by_time(x.strftime("%H:%M:%S"))

#end
#v2.show

#puts "--------"

#v3 = Vhash.find_by_output("62 75 11 73 f6 5c b5 d2 71 62 ef b7 54 be 8c ef 09 e2 86 67".gsub(" ", ""))
# v3.show


#v4 = Vhash.find_by_output("70 01 c2 04 fe 08 50 6b 80 21 37 18 84 a7 6f c2 7e ca 6d 9c".gsub(" ", ""))

# v4.show



