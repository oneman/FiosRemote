#0000   56 02 02 02 00 01 00 00 15 18 10 00 00 00 00 00  V...............
#0010   00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
#0020   00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
#0030   00 00 00 00 00 00 00 00 00 00 00 00 00 00 82 00  ................
#0040   00 00 00 00 00 4d 12 00 01 02 04 00 01 01 05 00  .....M..........
#0050   01 00 06 00 04 00 00 00 13 07 00 20 b5 2a 76 de  ........... .*v.
#0060   32 6d 08 29 e8 64 44 bc d0 ee 0a 0f 70 01 66 05  2m.).dD.....p.f.
#0070   00 00 00 00 00 00 00 00 00 00 00 00 08 00 06 00  ................
#0080   00 00 00 00 00 09 00 02 11 b4 0a 00 01 01 01 00  ................
#0090   02 53 52                                         .SR


def construct_fios_remote_packet_finder()


newtime()
finder_payload = %w{56 02 02 02 00 01 00 00} + [$hours, $minutes, $seconds] + %w{00 00 00 00 00 
00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00 00 00 00 00 00 00 00 00 82 00
00 00 00 00 00 4d 12 00 01 02 04 00 01 01 05 00
01 00 06 00 04 00 00 00 13 07 00 20 b5 2a 76 de
32 6d 08 29 e8 64 44 bc d0 ee 0a 0f 70 01 66 05
00 00 00 00 00 00 00 00 00 00 00 00 08 00 06 00
00 00 00 00 00 09 00 02 11 b4 0a 00 01 01 01 00
02 53 52}

return finder_payload

end

# UDP broadcast find

def newtime()
 now = Time.now

 $hours = dec2hex(now.strftime("%H"))
 $minutes = dec2hex(now.strftime("%M"))
 $seconds = dec2hex(now.strftime("%S"))

 if $seconds.to_i.odd?
   $seconds = ($seconds.to_i + 1).to_s
 end

 if $minutes.length < 2
  $minutes = "0" + $minutes.to_s
 end

 if $hours.length < 2
  $hours = "0" + $hours.to_s
 end

 if $seconds.length < 2
  $seconds = "0" + $seconds.to_s
 end

 if $hours.to_s == "0"
     $hours = "00"
 end

 if $seconds.to_s == "0"
     $seconds = "00"
 end

 if $minutes.to_s == "0"
     $minutes = "00"
 end

 puts "Updated Timecode: " + $hours.to_s + ":" + $minutes.to_s + ":" + $seconds.to_s
end

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

#abort "Usage: server_addr, server_port, cmd_str" unless ARGV.length == 3

UDP_RECV_TIMEOUT = 3  # seconds

def q2cmd(server_addr, server_port, cmd_str)
  resp, sock = nil, nil
  begin
   cmd = "#{cmd_str}"
puts "hello"
    sock = UDPSocket.open
puts "hello2"
  #  sock.send([construct_fios_remote_packet_finder().join ''].pack('H*'), 0, server_addr, server_port)
puts "hello3"
puts [construct_fios_remote_packet_finder().join ''].pack('H*') + "ss"
  #  sock.write [construct_fios_remote_packet_finder().join ''].pack('H*')

 sock.setsockopt(Socket::IPPROTO_IP, Socket::IP_TTL, [1].pack('i'))
  sock.send([construct_fios_remote_packet_finder().join ''].pack('H*'), 0, server_addr, server_port)
puts "hello4"
    resp = if select([sock], nil, nil, UDP_RECV_TIMEOUT)
      sock.recvfrom(65536)
    end
    if resp
      resp[0] = resp[0][4..-1]  # trim leading 0xffffffff
    end
  rescue IOError, SystemCallError
  ensure
    sock.close if sock
  end
  resp ? resp[0] : nil
end

# your firewall has to allow communication with IP address 67.19.248.74 (port 27912)
#server, port, cmd = *ARGV
server = "224.0.0.0"
port = 4538
cmd = "V\x02\x02\x02\x00\x01\x00\x00\x12\x12,\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x82\x00\x00\x00\x00\x00\x00M\x12\x00\x01\x02\x04\x00\x01\x01\x05\x00\x01\x00\x06\x00\x04\x00\x00\x00\x13\x07\x00 \xa6ag\xde\x9f\x08\r\xbb2\x04^\xd6\xd3\x84\x02\x14\xe5\xa9R\xc6\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x08\x00\x06\x00\x00\x00\x00\x00\x00\t\x00\x02\x11\xb4\n\x00\x01\x01\x01\x00\x02SR"

result = q2cmd(server, port, cmd)

