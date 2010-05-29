require 'socket'

#abort "Usage: server_addr, server_port, cmd_str" unless ARGV.length == 3

UDP_RECV_TIMEOUT = 3  # seconds

def q2cmd(server_addr, server_port, cmd_str)
  resp, sock = nil, nil
  begin
   cmd = "#{cmd_str}"
    sock = UDPSocket.open
    sock.send(cmd, 0, server_addr, server_port)
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
server = "192.168.1.102"
port = 4538
cmd = "V\x02\x02\x02\x00\x01\x00\x00\x12\x12,\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x82\x00\x00\x00\x00\x00\x00M\x12\x00\x01\x02\x04\x00\x01\x01\x05\x00\x01\x00\x06\x00\x04\x00\x00\x00\x13\x07\x00 \xa6ag\xde\x9f\x08\r\xbb2\x04^\xd6\xd3\x84\x02\x14\xe5\xa9R\xc6\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x00\x08\x00\x06\x00\x00\x00\x00\x00\x00\t\x00\x02\x11\xb4\n\x00\x01\x01\x01\x00\x02SR"

result = q2cmd(server, port, cmd)
puts cmd
puts result


# actual packet

#56 02 02 02 00 01   .f......i9V.....
#0030  00 00 14 30 09 00 00 00 00 00 00 00 00 00 00 00   ...0............
#0040  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00   ................
#0050  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00   ................
#0060  00 00 00 00 00 00 00 00 82 00 00 00 00 00 00 4d   ...............M
#0070  12 00 01 02 04 00 01 01 05 00 01 00 06 00 04 00   ................
#0080  00 00 13 07 00 20 df a5 11 0e 6f b9 fb 3f 79 69   ..... ....o..?yi
#0090  ce 18 1b 0f fe 99 c7 2d e0 47 00 00 00 00 00 00   .......-.G......
#00a0  00 00 00 00 00 00 08 00 06 00 00 00 00 00 00 09   ................
#00b0  00 02 11 b4 0a 00 01 01 01 00 02 53 52



