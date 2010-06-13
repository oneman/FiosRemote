# STB CLONEA

require 'socket'      # Sockets are in standard library

require "vhash.rb"

$control_code = "00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00"
#$control_code = ARGV.shift
$control_code = $control_code.split(" ")
puts "default control code is " + $control_code.join(" ")

def construct_fios_stb_packet_stb_first()

# i am stb packet

#0000   56 02 02 01 00 04 00 00 00 00 00 00 00 00 00 00  V...............
#0010   00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
#0020   00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
#0030   00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
#0040   00 00 00 00 00 72                                .....r

first_packet = %w{56 02 02 01 00 04 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 72}

return first_packet

end


def construct_fios_stb_packet_stb_second()

# i am stb number whatever w/ damn fuckin code

#0000   12 00 01 02 01 00 05 53 54 42 31 00 04 00 01 01  .......STB1.....
#0010   05 00 04 39 37 13 4d 06 00 04 00 00 00 14 07 00  ...97.M.........
#0020   20 48 9f 19 9f 93 73 ad 73 9a 0e 1b 9c 20 ba 39   H....s.s.... .9
#0030   eb 94 0e 01 5f 00 00 00 00 00 00 00 00 00 00 00  ...._...........
#0040   00 0b 00 04 01 0c 00 02 c0 00 0d 00 04 c0 00 00  ................
#0050   00 0e 00 04 c0 00 00 00 0f 00 06 c0 00 00 00 00  ................
#0060   06 10 00 04 c0 00 00 00 11 00 04 00 00 64 00 00  .............d..
#0070   00 00   

                                                 # changed
second_packet = %w{12 00 01 02 01 00 05 53 54 42 30 00 04 00 01 01
05 00 04 39 37 13 4d 06 00 04 00 00 00 14 07 00
20} + $control_code + %w{00 00 00 00 00 00 00 00 00 00 00
00 0b 00 04 01 0c 00 02 c0 00 0d 00 04 c0 00 00
00 0e 00 04 c0 00 00 00 0f 00 06 c0 00 00 00 00
06 10 00 04 c0 00 00 00 11 00 04 00 00 64 00 00
00 00}
puts 
return second_packet

end
                                
def construct_fios_remote_packet_yay()


#newtime()
yay_payload = %w{56 02 02 01 00 19 00 00 00 00 00 00 00 00 00 00 
00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00 00 00 00 00 00 00 00 01 00 00
00 00 00 00 00 00}

return yay_payload

end


                                
def construct_fios_remote_packet_codeforme(whattocode)

#0000   56 02 02 01 00 1b 00 39 3e 09 7f 00 00 00 00 00  V......9>.......
#0010   00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
#0020   00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
#0030   00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
#0040   00 00 00 00 00 32 04 00 01 01 05 00 01 00 06 00  .....2..........
#0050   04 00 00 00 00 07 00 20 00 00 00 00 00 00 00 00  ....... ........
#0060   00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
#30070   00 00 00 00 00 00 00 00  

#newtime()
codeme_payload = %w{56 02 02 01 00 1b 00} + whattocode + %w{00 00 00 00 00 
00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 32 04 00 01 01 05 00 01 00 06 00
04 00 00 00 00 07 00 20 00 00 00 00 00 00 00 00
00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00 00 00}

return codeme_payload

end


puts [construct_fios_stb_packet_stb_second().join ''].pack('H*')



hostname = '192.168.1.2'
port = 4532

sock = TCPSocket.open(hostname, port)


 puts "Expecting init packet / printing response"
 data = sock.recvfrom( 2220 )[0].chomp
 if data
  puts data.unpack("H*")

  time_code_to_encode = [data[7].to_s(16), data[8].to_s(16), data[9].to_s(16),data[10].to_s(16)]
  for x in time_code_to_encode
   if x.length < 2
    time_code_to_encode[time_code_to_encode.index(x)] = "0" + x.to_s
   end
  end
  time_code_to_encode = time_code_to_encode[0] + time_code_to_encode[1] + time_code_to_encode[2] + time_code_to_encode[3]
  time_code_to_encode = time_code_to_encode.upcase
  puts "time code to encode is: #{time_code_to_encode}"
  v = Vhash.find_by_input(time_code_to_encode)
  v.show
  $control_code = v.hash_as_array
 end

 puts "sending stb first packet"
 sock.write [construct_fios_stb_packet_stb_first().join ''].pack('H*')
# puts "Expecting init packet / printing response"
# data = sock.recvfrom( 2220 )[0].chomp
# if data
#  puts data.unpack("H*")
# end
 puts "sending stb second packet"
 sock.write [construct_fios_stb_packet_stb_second().join ''].pack('H*')


puts [construct_fios_stb_packet_stb_second().join ''].pack('H*')

now_in_gps = Time.now.to_i - 315964819

puts "now is #{now_in_gps}"
now_in_hex = dec2hex(now_in_gps)
puts "now is in hex #{now_in_hex}"


puts "Entering loop state"
while true
 puts "Looped"






1000.times do

 puts "sending code for me packet"

 input = [now_in_hex[0..1], now_in_hex[2..3], now_in_hex[4..5], now_in_hex[6..7] ]

 sock.write [construct_fios_remote_packet_codeforme(input).join ''].pack('H*')


 puts "Expecting / printing response"
 data = sock.recvfrom( 2220 )[0].chomp
 if data.unpack("H*").to_s.length == 240
  puts "good"
  puts data.unpack("H*")

 control_word = [data[29].to_s(16), data[30].to_s(16), data[31].to_s(16), data[32].to_s(16), data[33].to_s(16), data[34].to_s(16), data[35].to_s(16), data[36].to_s(16), data[37].to_s(16), data[38].to_s(16), 
                       data[39].to_s(16), data[40].to_s(16), data[41].to_s(16), data[42].to_s(16), data[43].to_s(16), data[44].to_s(16), data[45].to_s(16), data[46].to_s(16), data[47].to_s(16), data[48].to_s(16) ]

for x in control_word
 if x.length < 2
   control_word[control_word.index(x)] = "0" + x.to_s

 end
end

 code = control_word.join("")

  puts input


  test = Vhash2.find_by_input(now_in_hex.to_s)
  if test == nil

  newcode = Vhash2.new

  newcode.input = now_in_hex.to_s
  newcode.output = code
  newcode.save
  else
   puts "fuck I had that one already"
  end

  puts "code is: #{code}"
  now_in_gps = now_in_gps + 1
now_in_hex = dec2hex(now_in_gps)
puts "now is in hex #{now_in_hex}"
  # change what to code to next thing
 else
  puts data.unpack("H*")
  puts "============"
  puts data.unpack("H*").to_s.length
  puts "============"
  puts "blah redo"
 end

 #sleep 0.1
end

puts "got thru 1000 times"

 puts "Expecting / printing response"
 data = sock.recvfrom( 2220 )[0].chomp
 if data
  puts data.unpack("H*")
 end


 puts "sending yay packet"
 sock.write [construct_fios_remote_packet_yay().join ''].pack('H*')


 sleep 1



# puts "sending encode for me packet"
# sock.write [construct_fios_stb_packet_encodeforme().join ''].pack('H*')
# puts "Expecting / printing the code we want"
# data = sock.recvfrom( 2220 )[0].chomp
# if data
#  puts data.unpack("H*")
# end
end


#s.close 
