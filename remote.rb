require 'socket'

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

$control_word = ""

def newtime()
 now = Time.now

 $hours = dec2hex(now.strftime("%H"))
 $minutes = dec2hex(now.strftime("%M"))
 $seconds = dec2hex(now.strftime("%S"))

 if $minutes.length < 2
  $minutes = "0" + $minutes.to_s
 end

 if $hours.length < 2
  $hours = "0" + $hours.to_s
 end

 if $seconds.length < 2
  $seconds = "0" + $seconds.to_s
 end
 puts "Updated Timecode: " + $hours.to_s + $minutes.to_s + $seconds.to_s
end


def construct_fios_remote_packet_init()
newtime()
                                              #hh mm ss 
init_payload = %w{56 02 02 01 00 03 00 00 00} + [$hours, $minutes, $seconds] + %w{00 00 00 00
00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00 00 00 00 00 00 00 00 00 0a 00
00 00 00 00 00 6c 12 00 01 02 01 00 02 53 52 04
00 01 01 05 00 01 00 06 00 04 00 00 00 13 07 00
20 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
00 0b 00 04 00 00 00 00 0c 00 02 00 00 0d 00 04
00 00 00 00 0e 00 04 00 00 00 00 0f 00 06 00 00
00 00 00 00 10 00 04 00 00 00 00 11 00 04 00 00
00 00}

return init_payload

end


def construct_fios_remote_packet_init2()
#newtime()
                                              #nope
init_payload2 = %w{56 02 02 01 00 04 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00 00 00 00 00 00 00 00 01 0a 00            # 00 or 01 before 0a?
00 00 00 00 00 6c 12 00 01 02 01 00 02 53 52 04
00 01 01 05 00 01 00 06 00 04 00 00 00 13 07 00
20} + $control_word + %w{00 00 00 00 00 00 00 00 00 00 00
00 0b 00 04 00 00 00 00 0c 00 02 00 00 0d 00 04
00 00 00 00 0e 00 04 00 00 00 00 0f 00 06 00 00
00 00 00 00 10 00 04 00 00 00 00 11 00 04 00 00
00 00}


#0000   56 02 02 01 00 04 00 00 00 00 00 00 00 00 00 00  V...............
#0010   00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
#0020   00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
#0030   00 00 00 00 00 00 00 00 00 00 00 00 00 01 0a 00  ................
#0040   00 00 00 00 00 6c 12 00 01 02 01 00 02 53 52 04  .....l.......SR.
#0050   00 01 01 05 00 01 00 06 00 04 00 00 00 13 07 00  ................
#0060   20 cd 07 5c 4e 04 a6 89 3a db 98 41 b9 e1 45 47   ..\N...:..A..EG
#0070   26 f5 35 0d 50 00 00 00 00 00 00 00 00 00 00 00  &.5.P...........
#0080   00 0b 00 04 00 00 00 00 0c 00 02 00 00 0d 00 04  ................
#0090   00 00 00 00 0e 00 04 00 00 00 00 0f 00 06 00 00  ................
#00a0   00 00 00 00 10 00 04 00 00 00 00 11 00 04 00 00  ................
#00b0   00 00    

return init_payload2

end



def construct_fios_remote_packet_keepalive()


newtime()
keep_payload = %w{56 02 02 01 00 29 00 00} + [$hours, $minutes, $seconds] + %w{00 00 00 00 00 
00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00 00 00 00 00 00 00 00 00 0a 00
00 00 00 00 00 00}

return keep_payload

end

def construct_fios_remote_packet_chandown()

#newtime()

channel_down_payload = %w{56 02 02 01 00 1d 00 00} + [$hours, $minutes, $seconds] + %w{00 00 00 00 00 
00 c0 a8 01 07 00 00 c0 a8 01 66 00 00} + $control_word + %w{00 00 
00 00 00 00 00 00 00 00 00 00 16 0a 00 00 00 00 00 00 00}



#cd 07 5c  ..........f....\
#0020   4e 04 a6 89 3a db 98 41 b9 e1 45 47 26 f5 35 0d  N...:..A..EG&.5.
#0030   50


#0000   56 02 02 01 00 1d 00 00 08 0f 1d 00 00 00 00 00  V...............
#0010   00 c0 a8 01 07 00 00 c0 a8 01 66 00 00 cd 07 5c  ..........f....\
#0020   4e 04 a6 89 3a db 98 41 b9 e1 45 47 26 f5 35 0d  N...:..A..EG&.5.
#0030   50 00 00 00 00 00 00 00 00 00 00 00 00 16 0a 00  P...............
#0040   00 00 00 00 00 00                                ......


return channel_down_payload

end



serv = TCPServer.new(4532)
begin
sock = serv.accept_nonblock
 rescue Errno::EAGAIN, Errno::ECONNABORTED, Errno::EPROTO, Errno::EINTR
 IO.select([serv])
 retry
end

puts "Sending Init Packet"
sock.write [construct_fios_remote_packet_init().join ''].pack('H*')

puts "Expecting / printing response"
data = sock.recvfrom( 2220 )[0].chomp
if data
   puts data
end

puts "Expecting / printing packet with control code"
#sock.write [construct_fios_remote_packet_init2().join ''].pack('H*')
data = sock.recvfrom( 2220 )[0].chomp
if data
 $control_word = [data[33].to_s(16), data[34].to_s(16), data[35].to_s(16), data[36].to_s(16), data[37].to_s(16), data[38].to_s(16), data[39].to_s(16), data[40].to_s(16), data[41].to_s(16), data[42].to_s(16), 
                       data[43].to_s(16), data[44].to_s(16), data[45].to_s(16), data[46].to_s(16), data[47].to_s(16), data[48].to_s(16), data[49].to_s(16), data[50].to_s(16), data[51].to_s(16), data[52].to_s(16) ]
for x in $control_word
 if x.length < 2
   $control_word[$control_word.index(x)] = "0" + x.to_s
 end
end

puts "Control Code: " + $control_word.to_s
end

#puts "sending init2 packet"
#sock.write [construct_fios_remote_packet_init2().join ''].pack('H*')
#puts "Expecting / printing response"
#data = sock.recvfrom( 2220 )[0].chomp
#if data
# puts data
#end

puts "Entering loop state"
while true
 puts "Looped"
 sleep 3
 puts "sending keepalive packet"
 sock.write [construct_fios_remote_packet_keepalive().join ''].pack('H*')
 puts "Expecting / printing response"
 data = sock.recvfrom( 2220 )[0].chomp
 if data
  puts data
 end
 sleep 3
 
 puts "sending channel down command"
 sock.write [construct_fios_remote_packet_chandown().join ''].pack('H*')
 puts "Expecting / printing response"
 data = sock.recvfrom( 2220 )[0].chomp
 if data
  puts data
 end

end
