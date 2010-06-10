require 'socket'
require "vhash.rb"


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

# command? hash

command = {}
command['keepalive'] = %w{29}

$houri = 0
$minutei = 2
$secondi = 10

# example once valid one...
$control_word = %w{7e 79 93 63 2f a9 0e 6d ca 61 74 82 bc cc 1a 7f fd de dd ed}

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

def get_hash_array_from_time(hide=false)
 v = Vhash.find_by_input("00#{$hours}#{$minutes}#{$seconds}")
 unless hide
  v.show
 end
 return [v.output[0..1], v.output[2..3], v.output[4..5], v.output[6..7], v.output[8..9], v.output[10..11], v.output[12..13], v.output[14..15], v.output[16..17], v.output[18..19], 
         v.output[20..21], v.output[22..23], v.output[24..25], v.output[26..27], v.output[28..29], v.output[30..31], v.output[32..33], v.output[34..35], v.output[36..37], v.output[38..39] ]
end

def construct_fios_remote_packet_udp_init()

#0000   56 02 02 02 00 01 00 00 01 26 36 00 00 00 00 00  V........&6.....
#0010   00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
#0020   00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
#0030   00 00 00 00 00 00 00 00 00 00 00 00 00 00 82 00  ................
#0040   00 00 00 00 00 4d 12 00 01 02 04 00 01 01 05 00  .....M..........
#0050   01 00 06 00 04 00 00 00 13 07 00 20 44 c8 71 98  ........... D.q.
#0060   36 e7 cb 48 a5 81 53 b3 80 23 2b 38 e1 45 ee a4  6..H..S..#+8.E..
#0070   00 00 00 00 00 00 00 00 00 00 00 00 08 00 06 00  ................
#0080   00 00 00 00 00 09 00 02 11 b4 0a 00 01 01 01 00  ................
#0090   02 53 52                                         .SR

newtime()
udp_payload = %w{56 02 02 02 00 01 00 00} + [$hours, $minutes, $seconds] + %w{00 00 00 00 00 
00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00 00 00 00 00 00 00 00 00 82 00
00 00 00 00 00 4d 12 00 01 02 04 00 01 01 05 00
01 00 06 00 04 00 00 00 13 07 00 20} + get_hash_array_from_time() + %w{
00 00 00 00 00 00 00 00 00 00 00 00 08 00 06 00
00 00 00 00 00 09 00 02 11 b4 0a 00 01 01 01 00
02 53 52}

return udp_payload

end

def construct_fios_remote_packet_getcode(code)
newtime()
                                              #hh mm ss 


getcode_payload = %w{56 02 02 01 00 03 00} + code + %w{00 00 00 00 00
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

return getcode_payload

end


def construct_fios_remote_packet_init()
newtime()
                                              #hh mm ss 


init_payload = %w{56 02 02 01 00 03 00 00} + [$hours, $minutes, $seconds] + %w{00 00 00 00 00
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

init2_control_word = %w{62 75 11 73 f6 5c b5 d2 71 62 ef b7 54 be 8c ef 09 e2 86 67}
init2_control_word_test = %w{98 a9 e9 e3 da a5 92 7c 85 97 21 f6 c7 64 bf 1d 74 81 38 1b}
                                              #nope                 # 00 or 01 before 0a?
init_payload2 = %w{56 02 02 01 00 04 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00 00 00 00 00 00 00 00 01 0a 00            
00 00 00 00 00 6c 12 00 01 02 01 00 02 53 52 04
00 01 01 05 00 01 00 06 00 04 00 00 00 13 07 00
20} + init2_control_word + %w{00 00 00 00 00 00 00 00 00 00 00
00 0b 00 04 00 00 00 00 0c 00 02 00 00 0d 00 04
00 00 00 00 0e 00 04 00 00 00 00 0f 00 06 00 00
00 00 00 00 10 00 04 00 00 00 00 11 00 04 00 00
00 00}

init_payload2_test = %w{56 02 02 01 00 04 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00 00 00 00 00 00 00 00 01 0a 00            
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

return init_payload2_test

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
00 c0 a8 01 05 00 00 c0 a8 01 66 00 00} + get_hash_array_from_time() + %w{00 00 
00 00 00 00 00 00 00 00 00 00 16 0a 00 00 00 00 00 00 00}

 # ok the c0 a8 stuff is the IP ADDRESS

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

def construct_fios_remote_packet_custom_command(command)

#newtime()
hide = true
custom_command_payload = %w{56 02 02 01 00 1d 00 00} + [$hours, $minutes, $seconds] + %w{00 00 00 00 00 
00 c0 a8 01 05 00 00 c0 a8 01 66 00 00} + get_hash_array_from_time(hide) + %w{00 00 
00 00 00 00 00 00 00 00 00 00} + [command] + %w{0a 00 00 00 00 00 00 00}
                        

return custom_command_payload

end

def construct_set_control_packet()
set_control_payload = %w{56 02 02 01 00 1c 00 00} + [$hours, $minutes, $seconds] + %w{00 00 00 00 00 
00 c0 a8 01 02 00 00 c0 a8 01 66 00 00} + $control_word + %w{00 00 00 00 00 00 00 00 00 00 00 00 00 0a 00 
00 00 00 00 00 32 04 00 01 01 05 00 01 00 06 00 04 00 00 00 13 07 00 20} + $control_word + %w{00 00 00 00 00 00 00 00 00 00 00 00}


#0000   56 02 02 01 00 1c 00 00 11 38 1c 00 00 00 00 00  V........8......
                   #xx the byte below this xx is 07 on some other packets...  # aha i was on to the ip address change!
#0010   00 c0 a8 01 02 00 00 c0 a8 01 66 00 00 58 b9 14  ..........f..X..
#0020   75 89 61 8e ab a5 37 b5 bb 88 b4 41 8f 68 6d 88  u.a...7....A.hm.
#0030   f7 00 00 00 00 00 00 00 00 00 00 00 00 00 0a 00  ................
#0040   00 00 00 00 00 32 04 00 01 01 05 00 01 00 06 00  .....2..........
#0050   04 00 00 00 13 07 00 20 58 b9 14 75 89 61 8e ab  ....... X..u.a..
#0060   a5 37 b5 bb 88 b4 41 8f 68 6d 88 f7 00 00 00 00  .7....A.hm......
#0070   00 00 00 00 00 00 00 00                          ........

# another example

#0000   56 02 02 01 00 1c 00 00 01 12 39 00 00 00 00 00  V.........9.....
#0010   00 c0 a8 01 02 00 00 c0 a8 01 66 00 00 76 72 d3  ..........f..vr.
#0020   d3 0b b7 28 da 2e fe 3b e6 2f af 7b 2f a0 d2 c0  ...(...;./.{/...
#0030   bd 00 00 00 00 00 00 00 00 00 00 00 00 00 0a 00  ................
#0040   00 00 00 00 00 32 04 00 01 01 05 00 01 00 06 00  .....2..........
#0050   04 00 00 00 13 07 00 20 76 72 d3 d3 0b b7 28 da  ....... vr....(.
#0060   2e fe 3b e6 2f af 7b 2f a0 d2 c0 bd 00 00 00 00  ..;./.{/........
#0070   00 00 00 00 00 00 00 00                          ........

return set_control_payload
end


def construct_fios_remote_packet_exp()

#newtime()

exp_payload = %w{56 02 02 01 00 27 00 00} + [$hours, $minutes, $seconds] + %w{00 00 00 00 00 
00 c0 a8 01 07 00 00 c0 a8 01 66 00 00} + $control_word + %w{00 00 
00 00 00 00 00 00 00 00 00 00 15 0a 00 00 00 00 00 00 00}



#cd 07 5c  ..........f....\
#0020   4e 04 a6 89 3a db 98 41 b9 e1 45 47 26 f5 35 0d  N...:..A..EG&.5.
#0030   50


#0000   56 02 02 01 00 1d 00 00 08 0f 1d 00 00 00 00 00  V...............
#0010   00 c0 a8 01 07 00 00 c0 a8 01 66 00 00 cd 07 5c  ..........f....\
#0020   4e 04 a6 89 3a db 98 41 b9 e1 45 47 26 f5 35 0d  N...:..A..EG&.5.
#0030   50 00 00 00 00 00 00 00 00 00 00 00 00 16 0a 00  P...............
#0040   00 00 00 00 00 00                                ......


return exp_payload

end

def construct_fios_remote_packet_PNG()

#56 02 02 01 00 27 00 00 14 30 0a 00 00 00   _PV....'...0....
##0050  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00   ................
#0060  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00   ................
#0070  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00   ................
#0080  0a 00 00 00 00 00 12 8d 01 00 00 02 00 02 00 01   ................
#0090  14 00 04 00 00 12 76 17 00 02 00 02 03 12 76



# 56 02 02 01 00 27 00 00 14 30 0a 00 00 00   _PV....'...0....
# 0050  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00   ................
#0060  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00   ................
#0070  00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00   ................
#0080  0a 00 00 00 00 00 12 8d 01 00 00 02 00 02 00 01   ................
#0090  14 00 04 00 00 12 76 17 00 02 00 02 03 12 76

                                             # was 14 30 0a
png_packet_header = %w{56 02 02 01 00 27 00 00} + [$hours, $minutes, $seconds] + %w{00 00 00 00 00
00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00
00 00 00 00 00 00 00 00 00 00 00 00 00 00 0a 00
00 00 00 00 12 8d 01 00 00 02 00 02 00 01 14 00
04 00 00 12 76 17 00 02 00 02 03 12 76}


connecting_png_image = %w{89 50 4e
47 0d 0a 1a 0a 00 00 00 0d 49 48 44 52 00 00 00
a8 00 00 00 32 08 06 00 00 00 c8 b6 90 91 00 00
12 3d 49 44 41 54 78 da ed 9d 7b 74 54 d5 bd c7
3f fb cc 7b 12 48 cc 84 47 15 08 b6 24 83 50 49
b4 55 0c 8a eb 16 8a ad 62 ef 12 95 d6 5b b5 da
75 6f a5 34 7d ba 6a 1f 7f dc 6b db 75 ad 55 b0
ea ed 45 da db 5e d4 aa 5d b7 56 81 fa 06 1a 68
8d e6 21 cf d0 42 1e 80 e4 01 24 21 33 21 8f 79
9f 73 f6 be 7f cc 83 99 24 80 48 b0 05 cf 77 ad
bd e6 cc d9 67 f6 fe ed bd bf f3 fd ed df 3e 7b
e6 08 46 c1 aa 55 ab 6e 02 ee 02 2a 80 e9 58 b0
70 f6 d0 06 ec 02 9e ae aa aa 5a 3f 3c 53 0c 23
66 05 f0 64 8a 98 16 2c 7c d0 d8 05 7c b9 aa aa
6a d7 08 82 ae 5a b5 ea 6e e0 51 a0 d0 30 0c ba
bb bb e9 e9 e9 21 14 0a 59 dd 66 e1 ac 21 3f 3f
9f 49 93 26 31 79 f2 64 ec 76 3b 40 3f f0 9d aa
aa aa a7 32 04 4d 29 e7 16 a0 b0 bf bf 9f 3d 7b
f6 60 18 86 d5 7b 16 3e 30 d8 ed 76 66 cf 9e 4d
61 61 61 9a a4 9f aa aa aa da a5 a5 f2 9f 4c 93
b3 b1 b1 d1 22 a7 85 0f 1c 86 61 d0 d8 d8 48 20
10 00 28 4c 71 12 91 0a 88 d6 19 86 41 43 43 c3
59 21 67 7e 7e 3e 6e b7 9b fc fc fc 53 1a 19 0a
85 e8 ef ef b7 46 ec 43 ac a4 73 e7 ce 4d bb fb
25 f6 54 b4 4e 77 77 f7 98 93 b3 b0 b0 90 4f 5e
71 05 b3 2e 99 85 df 5f c6 d1 a3 47 e9 ee ee 26
1c 0e 13 89 44 32 af d1 68 94 48 24 42 61 61 21
f1 78 1c d3 34 e9 eb eb a3 a3 a3 c3 1a b1 0f a1
92 76 77 77 33 65 ca 14 80 bb ec e9 88 bd ab ab
0b 29 e5 98 55 34 61 c2 04 ae 99 7f 2d e1 70 98
3f ff 79 0b 7f fc e3 7a ec 76 3b 89 44 82 44 22
81 ae eb 39 c9 30 0c 0c c3 40 4a 89 d7 eb 65 f2
e4 c9 f8 fd 7e 9a 9a 9a 4e ab 5e 81 42 e5 2e 4e
58 38 c7 d0 d5 d5 95 26 68 85 9d d4 3a e7 e0 e0
e0 98 56 52 5a 5a c6 de bd 7b 70 a4 48 a9 94 22
1c 0e e7 90 d3 30 8c 1c 72 1a 86 81 69 9a 0c 0d
0d d1 d5 d5 c5 cc 99 33 29 28 28 e0 d8 b1 63 ef
b9 5e 0d 85 40 61 a2 59 23 7d 8e 22 8b 8b d3 ed
e9 a3 b1 54 4f 8f c7 43 ff c0 00 64 91 f2 64 aa
99 26 66 fa d5 34 4d a4 94 1c 3c 78 90 e9 d3 a7
9f 96 6d 12 f0 28 03 5d d8 ad 91 3e 1f e6 a4 67
83 a0 2e 97 8b 70 38 8c 69 e8 a3 92 f3 64 c4 4c
93 d3 34 4d 02 81 00 25 25 25 a7 6d 9b 81 c2 a9
12 c4 b0 48 7a de 10 54 8d 21 41 95 94 1c eb eb
c3 34 74 a2 91 08 a6 61 62 98 06 7a 6a 8e 29 85
0d 5b c1 64 94 54 e8 83 3d e8 46 18 a5 14 0a 05
76 85 4d 68 68 d2 c6 40 5f 3f 4e a7 f3 84 b6 69
28 e4 28 f3 cd 38 30 81 18 51 bc d6 08 9f 37 0a
aa d4 98 15 2a 95 c2 d4 13 24 62 31 62 b1 18 38
bd 4c ba f2 f3 84 fb 07 38 5c ff 3b 0a ca 16 b1
68 e9 72 82 21 c9 40 47 2d f5 cf 3f 88 f2 55 f0
b1 ab 97 d0 dd b8 9e 60 6b 1d 4e a7 0b c3 30 50
4a 9d c4 36 89 1d 45 02 db 88 40 49 43 62 c7 18
91 67 c1 72 f1 28 a5 d0 0d 83 68 34 8a e1 28 e4
33 5f 7b 9c 81 de 21 de 7c e5 b7 18 46 82 de 3d
6f f0 d4 de b7 30 0c 89 8d 28 9a 32 d0 8f 75 e3
30 6c 7c f6 4b 0f f1 f2 1f 7e 49 f8 6f cf 27 c9
7d 52 db 14 5e e2 c4 70 8f 50 d6 08 82 22 22 1c
21 cf 1a 65 8b a0 c3 74 4d 4a 74 3d 39 ff 8c 47
03 bc f6 bf 2b e9 3f 58 87 8d 18 d2 34 b9 66 de
95 8c 2f 2a 42 da 0b 91 d1 c3 6c db be 8b ae 9e
83 ec 5a 77 1f 7f ad f9 24 89 c4 10 24 12 48 29
93 0a 7a 12 82 0a 24 f9 c4 18 c4 99 73 3e 8e e0
22 2d ca 21 e9 b1 46 d9 22 e8 48 05 35 74 83 58
2c 86 9e 48 10 3b f0 27 90 12 87 c7 43 5c 1a d8
9d 20 5c 6e 8e 76 1f 61 82 c7 24 14 8e 60 d7 1c
e8 7a 82 78 77 3d 88 24 29 d3 36 65 db 96 3b ef
54 c4 80 89 5a 94 7e 69 cf 21 a8 42 e2 c4 c0 2e
0d 12 d6 92 93 45 d0 91 2e 5e 27 9e 88 63 ea 46
46 09 e7 5f 53 c9 b4 e9 25 ac 5e fd 6b a4 00 bb
d7 45 38 d0 cf 8c 92 29 fc db dd 77 f1 e8 aa d5
28 3d 8e a1 1b d8 6c 36 4c d3 1c a1 a0 5e 61 10
52 f6 0c 11 a5 50 14 12 47 48 2f 66 16 71 a5 90
98 40 81 8a d3 a3 5c d6 48 5b 04 cd 75 f1 a6 61
62 e8 3a 86 6e 20 a5 c2 94 26 c5 a5 57 f0 d1 8b
2f 20 16 8f 31 e3 0e 3f 13 3f 76 31 fb d6 35 e1
8e d8 e8 8f 48 26 4c 98 44 5b db bb c9 bb 41 9a
18 55 41 9d 9a 81 53 41 4c 69 88 34 11 35 f0 11
a3 5b ba 32 41 92 14 8a 98 d0 b8 40 c4 e9 32 1d
d6 48 5b cb 4c c3 5c bc 61 90 d0 75 4c c3 40 49
05 02 a4 84 3c 8f 17 a5 14 fd 47 7b b1 7f c4 4b
24 3c c4 b8 a2 e9 f4 99 e3 52 9f 95 68 36 1b 28
99 51 de 6c db 4c 14 17 88 38 47 a4 0b 09 28 4d
a1 4b 28 22 4e 97 74 a4 62 7b 50 9a c4 54 8a 09
5a 0c 25 ad e5 26 4b 41 87 2b a8 69 a2 27 74 66
ce 9a 45 5f 20 48 ef d1


1e 7a 9a 1b a8 ee 1e 8f db e9 22 f4 66 84 ee d7
b7 32 7e dc 78 8e 24 8e f2 4f 05 71 7e 77 e0 5d
24 26 a5 33 fc ec 3f d0 3a aa 82 c6 80 8f d8 12
1c ca 90 51 12 d7 60 a2 16 e3 af 59 44 94 48 62
42 e0 d4 e4 98 b6 cd c2 79 32 07 4d df 15 ca 1f
5f c0 fc eb 16 b3 e6 bf 1f 65 d3 c6 4d 24 8c 04
f7 7d ef 3e fc b3 2e 21 91 d0 49 44 23 ac 7a 62
35 2b 56 ae 44 62 b0 e4 96 2f d0 d5 d3 87 b3 bd
6d d4 28 5e 22 29 74 24 90 d2 03 02 94 54 28 a9
70 67 13 51 80 94 0a a5 49 8a 45 c2 22 e8 79 41
d0 31 5c a8 57 29 05 35 0c 83 ad b5 6f 33 38 38
c4 a7 ae bb 9e d7 d6 bf 80 c7 e3 61 73 f5 16 f6
be db c3 80 99 87 37 d6 c6 e1 c3 5d c4 e2 31 26
4e 9a 4c 5b c7 11 5a f7 ec 42 89 ac 28 3e cb 36
29 15 52 a5 ce 29 85 d4 92 24 1e af 19 c7 af 53
49 72 2a 05 0e 21 c7 ac 6d a5 33 66 50 5a 3a 83
60 5f 1f fb f7 ed 27 d8 d7 77 4e 0d f6 94 8b 2e
e2 96 5b 96 50 df f0 0e 0d 0d ef 7c 88 5d 7c 4a
41 0d d3 44 99 92 ed 0d b5 ec dc da 80 cd a6 31
34 14 62 7b d3 01 e2 75 75 68 36 0d e1 f4 90 88
45 b1 21 e8 e9 ea e2 50 67 27 4e a7 03 9b cd 8e
69 9a 49 12 66 2b a8 26 b1 ab 34 79 93 cb 49 4a
29 5c 22 db 95 2b 24 c9 cf e9 4a 9c 71 db ca e7
5c ca 9d 77 de 81 c7 93 bb a6 fa d8 e3 ff c5 be
7d fb ff 61 07 f7 aa b9 73 29 2d 9d c1 33 cf 3e
07 80 cb ed 62 c6 8c 19 b4 b6 ee 3b 67 bc ca d9
71 f1 a9 35 4c 69 98 94 cd fe 38 e5 73 af 65 d6
ec 8f f3 8b 87 ef c7 76 e1 d5 fc eb f7 7e c2 23
df b8 9e c4 60 0f cb fe f3 f7 ec de b6 8d fa 17
7e ca 67 17 df c4 f4 99 73 18 18 38 c6 ef d7 3c
91 74 f1 c3 6c 93 24 15 31 4d 50 89 4a dd 0e 65
18 41 93 c4 05 75 46 6d 9b 32 e5 22 ee b9 e7 2b
44 a3 51 9e fe ed 33 34 36 ee c6 eb f1 50 5a 56
4a 4b 4b eb 3f f4 e0 ce 9d 7b 65 ce d8 b6 b4 b4
b2 fc 6b 5f b7 a2 78 a5 92 cb 4a a6 32 39 b8 7f
1f dd 87 8f b0 e9 8f 02 dd 94 5c 9c 17 e2 a9 07
bf 8b 7e ac 0b 84 e2 f9 5f fc 98 82 f1 2e f2 f2
f2 a9 d9 b2 89 ed 5b eb 89 44 22 68 9a 96 ec d8
61 51 bc 42 a1 ab a4 bd 0a 90 22 49 c4 41 53 cb
5c a7 00 95 3a ef 16 f2 8c da b6 f4 d6 5b 01 58
bd fa 97 b4 b6 ee 03 20 12 0e a7 7f 3b 03 40 59
59 29 0b 17 2e c0 e3 f1 12 8d 46 a8 ad ad a7 b1
b1 11 00 9f cf 47 65 e5 55 d4 d5 d5 53 59 79 15
65 65 65 04 83 41 9e 7f fe 0f 44 a3 d1 53 e6 43
72 fb e2 c2 85 0b 28 2b 2b 03 a0 ba 7a 73 a6 7c
80 05 0b 17 50 51 5e 0e c0 a1 43 9d 54 57 6f a1
b2 f2 2a 7c be 22 00 16 df 70 3d 75 75 f5 00 54
56 5e 45 6b 6b 2b ad ad fb 28 2b 2b a5 ac ac 8c
ea ea cd 7c fe f3 4b f1 f9 7c b4 b6 b6 f2 ca 2b
af 1e f7 1e e5 e5 2c 5c b8 80 68 34 42 75 f5 66
7c 3e 1f 40 a6 bc 73 d6 c5 4b 29 91 a6 44 37 4d
ca cb 2f e3 f0 c1 7d f4 1f ee 64 7f 63 3d a6 69
50 fa a9 2f 70 e1 47 3f ce 5f 9e fc 0f 8e 69 02
61 d3 18 5f 58 cc d4 8b 67 b0 73 6b d2 fd 9f 48
41 0d 99 3c 27 44 f2 cb a0 94 22 22 8f bb 72 91
0e 9e 94 24 a0 db ce a8 6d 65 65 a5 04 83 41 9a
9b 5b 46 cf f7 97 71 ef bd df 21 18 0c 52 5b 5b
c7 bc 79 95 2c 5f be 8c a7 9e 7a 9a da da 3a 2e
28 ba 80 1b 6f 5c 4c 79 79 39 5e af 27 53 a6 c7
e3 e1 89 27 56 9f 32 1f e0 de 7b bf 83 cf 57 44
75 f5 66 a6 4e 9d c2 f2 e5 cb 58 f9 c8 cf 69 6d
69 e5 ee bb ef 62 de bc 4a 82 c1 20 81 40 10 b7
db 83 cb ed a2 b4 b4 14 9f cf 47 24 12 a1 b4 b4
94 1d 3b 77 e2 f5 7a b9 f1 c6 c5 bc fc b2 a2 b9
b9 85 d2 d2 d2 4c dd a0 f0 f9 7c 94 95 95 12 0e
47 a8 ae ae a6 a2 a2 82 e5 cb 97 11 0c 06 69 69
09 f0 d5 af 2e 23 1a 8d 12 08 06 79 fb ed da 73
df c5 2b a5 98 fa d1 32 e6 5d 33 1f 7d ce 6c 1e
7b f4 91 a4 22 02 81 43 9d 44 c2 36 94 92 80 0d
65 4a 6e be fd cb c4 02 47 b1 9b 3a 3b 76 6e 1f
75 99 49 0a c9 51 5d 64 08 2a 85 44 2a 49 50 cf
25 a8 14 12 29 15 03 a6 f6 be db 36 75 ea 54 00
02 81 e0 09 cb 58 b8 60 01 00 0f 3f bc 92 60 30
c8 c6 4d 7f e2 a1 9f fd 94 cf 7d ee 46 de 7a eb
ed e4 1a 30 10 89 84 f9 f1 8f 7f 02 c0 cf 7e f6
20 15 15 e5 c9 3e 3a 45 7e c5 65 15 4c 9d 3a 85
35 6b 9e a2 b6 b6 36 93 bf 70 c1 02 c2 a1 30 f3
e6 55 d2 d2 d2 c2 8a 15 8f e4 d8 b5 62 c5 4a 7e
f3 9b ff a1 b3 f3 10 2b 56 ac 04 c0 ef f7 67 3c
5c 7a 7c 00 76 ee dc c9 4b 2f bd 8c cf e7 e3 a1
87 92 75 6f da b4 89 85 0b 73 db e6 f7 97 71 df
7d df 3d 69 7f 9c 3b 0a 6a 4a a4 69 62 77 38 b0
6b 02 e5 74 61 9a 06 52 d9 99 f3 c9 2b 68 f9 db
56 cc c0 5e 7c 93 2f e2 e8 a1 76 ec 0e 07 d2 30
98 7a f1 c5 74 1d ee 00 21 46 5d 66 72 d9 4c 0e
c7 b5 e3 0a 2a 24 2e 24 5d 09 6d 04 41 bd c2 64
c0 78 ff 41 52 6f 6f 6f 66 5a 71 a2 32 2e bb ac
82 8e 8e ce cc b5 e1 50 88 8e ce 4e 66 fa fd 49
2f a2 92 9f 6b 6e 6e c9 94 11 08 06 28 2e f6 bd
a7 fc a9 c9 df e6 f0 e9 45 0b b9 fa ea 4a 00 bc
5e 0f 1e af 87 8a 8a a4

5b df b8 f1 4f 27 b4 2f db f6 74 5d c3 09 da d4
dc 8c 94 72 44 7b fd fe b2 9c 7e 68 6a 6a 3e 65
7f 9c 53 0a 6a 4a 89 61 4a 4c e1 24 21 05 08 8d
fc 71 30 7b 5a 0b 3b 1a c2 44 a3 11 be f4 9b 5d
3c f7 f8 23 d0 fc 7f 18 12 fa 06 c2 48 91 54 56
21 c4 48 db 94 e2 98 2e 90 2a ad a0 0a 1b 2a 43
da e3 04 55 08 95 7b fe 74 11 0a 85 08 04 02 cc
f4 fb 29 2a 2a ca 99 77 66 c3 eb f5 0c b3 f1 78
9f a6 15 32 e7 8b 76 1a f9 e1 70 18 80 8e f6 8e
4c fd 4d 4d cd 04 02 01 bc 5e 6f 6a 8e ea 3e 71
1b b3 82 c7 e1 75 a5 09 aa a4 1a 61 bf 94 92 48
24 82 d7 eb 1d 59 b6 e2 03 23 a8 96 a3 7a 63 94
d2 1d 20 a5 44 4f c4 41 b3 11 8d 25 d0 34 81 86
60 f3 96 7e dc 4e 0d 21 34 d6 fc e0 1e 12 ad 1b
53 d1 b6 42 b3 39 30 53 65 08 21 32 1b 96 d3 e9
98 0e ba 54 c7 e7 b9 4a 12 31 a1 4f cf 6a 83 4c
06 46 0e a1 e8 d5 c5 19 b5 65 c3 86 8d 00 7c f3
9b 5f a7 c8 e7 cb 9c 2f f2 f9 70 7b 3c 6c df b1
83 e2 e2 62 fc fe b2 cc f9 99 33 fd 04 02 81 54
5f 64 a9 56 66 f3 b5 ca f4 f9 a9 f2 f7 a6 7e d5
da db db cb da 75 eb 33 69 db f6 1d 99 bc eb ae
5b 84 db e3 41 2a 95 79 4d af fd 7a bd 9e ac 71
c9 ad 2b 43 50 25 73 3e 03 c9 e3 a6 e6 a4 62 2e
5a f4 69 a4 52 2c 5a f4 e9 9c 7c b7 c7 83 df ef
cf f4 4b 91 cf 87 df ef cf d8 30 fc fd e9 a4 0f
26 48 92 92 ae f6 fd 6c ad d9 4c d7 a1 36 34 a1
e1 89 d8 f9 51 c5 3c be 52 bb 19 1c 76 be 71 ff
b5 3c fb eb 27 89 36 c1 1b eb 7e c7 e5 9f 98 cb
b6 86 b7 00 81 a6 69 23 6c 8b ca a4 8b 49 dd 30
02 25 e9 8e e7 5e 23 52 eb a5 36 24 3d f1 64 68
f5 7e f1 fa 1b 1b 98 36 6d 2a f3 e7 cf e7 e7 8f
ac a0 bd bd 83 bc 3c 2f c5 c5 c5 3c f0 c0 83 ac
7d 71 1d 97 cc 9c c9 b7 be f5 4d da db 3b 28 29
99 06 c0 33 cf 3e 97 ea 83 91 0a a9 b2 14 f2 54
f9 6d 6d ed d4 d4 d4 b0 64 c9 4d 5c 7e f9 e5 04
02 01 8a 8b 8b 79 f6 d9 e7 68 6a 6e a6 a6 a6 26
c7 b6 92 92 69 dc b3 6c 39 00 db b7 ef e0 13 9f
b8 9c 1f fe e0 fb d4 d4 d4 d0 db 1b 18 55 41 e5
30 05 55 29 85 4c b7 ed f6 db bf c8 ed b7 7f 91
f6 f6 0e da db 3b 32 f9 53 a7 4c e1 87 3f fc 3e
6b d7 ae 63 ed ba f5 5c 73 f5 3c 6e be 79 09 0f
3c f0 20 4d cd cd 23 de bf 1f d8 16 2f 5e fc 23
80 86 fa fa a4 65 63 90 c6 8d 1b c7 b1 81 7e 86
06 07 d1 34 8d b6 03 2d 04 7b 8f 82 10 18 4a f2
b7 ae 4e fa 34 0d 9b 66 a3 b9 a9 91 d0 c1 21 34
34 74 3d 41 ff b1 00 43 83 03 08 21 08 0d 85 b8
f4 d2 4b e9 ec e8 c8 94 ad b2 ea 11 4a 31 de 2e
e9 89 0b 0c 45 ce 79 97 50 b8 35 38 12 17 67 dc
9e 6d db b6 d3 d4 d4 44 38 1c 21 2f cf 4b 7b 7b
07 af bf be 81 a6 a6 26 7a 7b 7b a9 ab ab c7 e1
70 50 58 58 40 63 e3 6e d6 ac 79 32 f9 7b fe f4
0a 43 24 92 b9 36 79 0e da db db 69 da db 74 ca
fc 74 fd bd bd 01 0a 0b 0b c8 cb f3 d2 d8 b8 9b
6d db b6 a3 27 12 99 3c 87 c3 81 ae eb bc fe fa
06 da db db 41 29 1a 1b 77 e3 70 38 70 38 1c 34
36 36 d2 db db 9b 5b 17 8a de de 00 7b f7 36 11
09 87 33 df 8c bd 7b 9b 68 6f 6f a7 bf bf 9f ba
ba 7a 02 81 00 bb 77 ef e6 99 67 9e e5 96 5b 6e
66 60 a0 9f 37 ff f2 e6 48 db 87 97 37 5a f9 ef
31 cd 9d 3b 37 29 36 ab 56 ad 52 00 8f 3f f6 d8
98 29 e8 45 53 a6 d0 d1 d1 49 77 d7 11 f2 bc 5e
84 26 52 73 43 0d 21 92 93 44 01 c9 f3 42 20 10
28 a1 00 91 5a 3a 02 97 c3 49 77 77 0f b7 dd 76
1b 6f d5 d4 8c fe ed 02 0a 1d 8a a0 2e 46 9c bf
d0 9d 5c 8e ea 4a 58 9b 95 cf 04 13 26 14 67 94
f7 da 6b af 65 f9 f2 65 bc f0 c2 8b bc f8 e2 da
b3 5a ef b7 be fd ed b3 18 24 29 95 f9 63 47 a5
14 ca 54 08 4d 3b 3e fb 57 69 3f 2c c0 a6 52 6b
99 c9 e0 26 ed a4 95 00 87 c3 71 d2 9f 7c 68 02
fa 12 23 f7 11 08 01 2e a1 e8 8c 8b 4c e4 6a e1
f4 31 6b d6 2c ee bf ff df 69 6b 6f 07 60 7a 49
09 6d 6d ed bc fa da 6b e7 7e 14 af 09 0d bb c3
81 2b 75 ff 5a 1c 67 5f e6 58 08 91 73 3c fc 9c
c3 e1 38 a9 6d fa 71 ca e7 2a a8 80 81 04 18 a6
b2 58 76 06 78 f7 e0 41 1e 7e 78 25 d3 a7 97 00
f0 ea 2b af f2 ce d6 6d 29 f7 7d 0e df 8b 97 4a
e1 cd f3 12 8d 46 89 c5 62 c8 7f 36 b0 6d b7 a3
e6 48 6c 3b ec 68 7d b6 0c 11 85 48 06 43 4b a2
51 04 e0 05 f6 b8 5c ec f5 78 70 3a 9d 23 36 8b
bc 17 38 ed 10 8c 27 37 48 5b 78 ff 08 0d 0d d1
d0 d0 40 43 43 c3 df ff 5e fc 58 2b e8 8c 19 a5
b4 b6 b4 20 84 c0 5e 63 87 f1 a0 35 0a b4 01 1b
c2 9e 24 65 9a 9c 42 08 5e 73 b9 32 ef 35 4d c3
a5 69 78 bd 5e 22 d1 e8 69 db a6 24 44 ac bf 38
3d 2f 70 56 f6 83 76 77 77 f3 99 eb 6f e0 ad 9a
37 89 c5 62 88 98 40 c4 53 64 74 e4 92 73 f8 71
76 2a 29 29 21 14 0a 9d 96 6d 0e 01 21 03 a4 e5
dd cf 2f 82 8e e5 6e a6 68 34 ca e1 43 87 f8 c2
6d ff c2 fa 75 6b 89 46 a3 27 24 e3 f0 f7 36 9b
0d 4d d3 b8 f0 c2 0b b9 e4 92 4b d8 f0 c6 1b a7
65 9b 99 4a 16 ce 37 82


aa b1 95 9c 8d 1b de e0 2b cb 96 b1 62 e5 4a 76
ee d8 49 4b 4b 33 3b 76 ec 18 55 29 d3 a9 b8 b8
98 82 82 02 26 4f 9e cc c4 89 13 a9 af ab 3b ed
7f 5b b6 3c fb 79 4a d0 b1 46 2c 16 e3 d7 bf fa
15 95 95 95 5c 7f c3 0d dc 71 c7 ed e4 e7 e7 e3
70 38 88 c5 62 0c 0e 0e 32 38 38 c8 d0 d0 10 a1
50 88 a1 a1 21 22 91 08 86 61 70 e0 c0 01 5e 7e
e9 25 7a 7a 7a ac 11 b2 08 7a f6 10 8b c5 d8 b2
65 0b 5b b6 6c a1 a0 a0 20 fd 04 07 a6 95 94 e4
5c 37 d0 df cf c0 c0 00 90 bc 83 62 c1 42 36 41
db 80 e9 93 26 4d 1a 73 c5 52 59 1b 12 fa fa fa
08 06 83 28 a5 d8 b7 2f b9 33 3d 3d a9 10 70 fc
ee 52 d6 f2 d3 f0 35 52 0b 1f 0e 4c 9a 34 29 7d
d8 a6 91 7c ba 17 73 52 3f 19 38 1b e4 54 59 bb
8c d2 29 fb 0f 6b 4d d3 44 9a 66 ce 6e a8 4c 3a
0b f3 63 0b ff d8 48 6f ac 06 76 69 c0 d3 00 73
e6 cc c1 ed 76 8f 59 25 d9 d1 b9 cd 66 c3 6e b3
e1 70 38 70 3a 9d 38 5d 2e 5c 2e 17 ee 54 72 a5
92 d3 e1 c0 61 b7 63 b3 d9 32 d1 bc 96 a5 a4 16
ce 7f b8 dd 6e ae b8 f2 ca f4 db a7 b5 d4 03 3c
77 b9 dd 6e 6e 5d ba f4 ac 55 9c 73 e7 68 94 75
cf d1 5c bb 85 0f 1f 6e 5d ba 34 2d 94 bb aa aa
aa d6 a7 b7 fa 7c 19 e8 2f 29 29 e1 8e 3b ef 1c
53 25 b5 60 e1 bd 2a e7 d2 a5 4b 29 49 06 d0 fd
29 4e 8e fe 30 d9 58 2c c6 d6 77 de a1 a5 a5 c5
5a ea b1 70 d6 03 a2 39 e5 e5 d9 53 cc 91 0f 93
cd 22 a9 f5 38 6e 0b 7f 4f 9c f8 71 dc c3 88 7a
13 c9 47 24 56 90 7a d0 97 05 0b 67 09 6d 29 62
3e 9d 8a 87 72 f0 ff 9a 3e 07 4e 33 5f b5 36 00
00 00 00 49 45 4e 44 ae 42 60 82}


png_payload = png_packet_header + connecting_png_image

return png_payload

end

Thread.new do

#abort "Usage: server_addr, server_port, cmd_str" unless ARGV.length == 3

UDP_RECV_TIMEOUT = 3  # seconds

def send_udp_init_packet(server_addr, server_port)
  resp, sock = nil, nil
  begin
   
    sock = UDPSocket.open
    puts "sending udp init packet"
    puts [construct_fios_remote_packet_udp_init().join '']
    sock.send([construct_fios_remote_packet_udp_init().join ''].pack('H*'), 0, server_addr, server_port)
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

server = "192.168.1.102"
port = 4538
result = send_udp_init_packet(server, port)

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
   puts data.unpack("H*")
end

puts "Expecting / printing packet with control code"

data = sock.recvfrom( 2220 )[0].chomp
if data
puts data.unpack("H*")

 $code_i_need_hash_for = [data[19].to_s(16), data[20].to_s(16), data[21].to_s(16), dec2hex(data[22].to_s(16).hex + 1)]
 if $code_i_need_hash_for[3].length < 2
     $code_i_need_hash_for[3] = "0" + $code_i_need_hash_for[3]
 end
 $control_word = [data[33].to_s(16), data[34].to_s(16), data[35].to_s(16), data[36].to_s(16), data[37].to_s(16), data[38].to_s(16), data[39].to_s(16), data[40].to_s(16), data[41].to_s(16), data[42].to_s(16), 
                       data[43].to_s(16), data[44].to_s(16), data[45].to_s(16), data[46].to_s(16), data[47].to_s(16), data[48].to_s(16), data[49].to_s(16), data[50].to_s(16), data[51].to_s(16), data[52].to_s(16) ]
for x in $control_word
 if x.length < 2
   $control_word[$control_word.index(x)] = "0" + x.to_s

 end
end

puts "Control Code: " + $control_word.to_s

end



puts "Sending get code Packet"
sock.write [construct_fios_remote_packet_getcode($code_i_need_hash_for).join ''].pack('H*')

puts "Expecting / printing useless ? response"
data = sock.recvfrom( 2220 )[0].chomp
if data
   puts data.unpack("H*")
end


puts "Expecting / printing packet with code i wanted"

data = sock.recvfrom( 2220 )[0].chomp
if data
puts data.unpack("H*")
 $control_word = [data[33].to_s(16), data[34].to_s(16), data[35].to_s(16), data[36].to_s(16), data[37].to_s(16), data[38].to_s(16), data[39].to_s(16), data[40].to_s(16), data[41].to_s(16), data[42].to_s(16), 
                       data[43].to_s(16), data[44].to_s(16), data[45].to_s(16), data[46].to_s(16), data[47].to_s(16), data[48].to_s(16), data[49].to_s(16), data[50].to_s(16), data[51].to_s(16), data[52].to_s(16) ]
for x in $control_word
 if x.length < 2
   $control_word[$control_word.index(x)] = "0" + x.to_s

 end
end

puts "Control Code: " + $control_word.to_s

end

sleep 2
puts "sending init2 packet"
sock.write [construct_fios_remote_packet_init2().join ''].pack('H*')

# puts "Expecting / printing response"
# data = sock.recvfrom( 2220 )[0].chomp
# if data
#  puts data.unpack("H*")
# end


puts "sending png image"
sock.write [construct_fios_remote_packet_PNG().join ''].pack('H*')


sleep 2

sock.flush

def isNumeric(s)
    Float(s) != nil rescue false
end

commands = {
"17" => "volup",
"18" => "voldown",
"01" => "mute",
"14" => "fiostv",
"12" => "favirotes",
"15" => "chanup",
"16" => "chandown",
"09" => "up",
"0b" => "left",
"0c" => "right",
"0a" => "down",
"0d" => "ok",
"02" => "enter",
"07" => "guide",
"06" => "menu",
"08" => "info",
"13" => "last",
"0f" => "options",
"0e" => "exit",
"21" => "record",
"1a" => "next",
"19" => "prev",
"1e" => "pause",
"20" => "rewind",
"1c" => "play",
"1f" => "fast forward",
"1d" => "stop",
"1b" => "dvr",
"10" => "widgets",
"2e" => "A",
"2f" => "B",
"30" => "C",
"31" => "D",
"80" => "backspace",
"22" => "1",
"23" => "2",
"24" => "3",
"25" => "4",
"26" => "5",
"27" => "6",
"28" => "7",
"29" => "8",
"2a" => "9",
"2b" => "0"}

puts "\n\n** Initing FiOS TV Remote Web Server **\n\nThis is BIG!\n\n"

$commands = commands

def handle_command(cmd)
commands = $commands
if isNumeric(cmd)

cmd.split(//).each { |num|
  sock.write [construct_fios_remote_packet_custom_command(commands.index(num).to_s).join ''].pack('H*')
  sleep 0.1
}
  sock.write [construct_fios_remote_packet_custom_command(commands.index("ok").to_s).join ''].pack('H*')
  sleep 0.1
  sock.write [construct_fios_remote_packet_custom_command(commands.index("enter").to_s).join ''].pack('H*')

else

# handle command
if cmd == "quit"
  puts "Disconnecting..."
  sock.close
  puts "Bye!"
  Kernel.exit
end

if cmd == "help"
  puts "Commands: "
  puts commands.values.join(" \n")
end

if (commands.has_value?(cmd) && (cmd != "help"))
 sock.write [construct_fios_remote_packet_custom_command(commands.index(cmd).to_s).join ''].pack('H*')
else
 puts "Command not found. Type Help for commands"
end

 command = nil

end
end
 

page = ""
page << "<h1>Fios Web Remote</h1><br/><br/><br/>"

for command in commands
 page << "<p style=\"display: inline;\"><a style=\"margin: 8px;\" href=\"/?cmd=#{command.last}\">#{command.last}</a></p><br/>"
end

remote = '
<img src="http://media.rawdod.com/real_remote.png" width="400" height="900" border="0" usemap="#map" />

<map name="map">
<area shape="rect" coords="127,122,164,165" href="/?cmd=menu" />
<area shape="rect" coords="177,116,213,142" href="/?cmd=guide" />
<area shape="rect" coords="216,125,264,153" href="/?cmd=info" />
<area shape="rect" coords="166,149,217,180" href="/?cmd=up" />
<area shape="rect" coords="177,188,215,224" href="/?cmd=ok" />
<area shape="rect" coords="225,178,258,226" href="/?cmd=right" />
<area shape="rect" coords="139,179,168,231" href="/?cmd=left" />
<area shape="rect" coords="177,235,225,256" href="/?cmd=down" />
<area shape="rect" coords="262,225,285,259" href="/?cmd=options" />
<area shape="rect" coords="110,234,144,265" href="/?cmd=exit" />
<area shape="rect" coords="144,269,168,291" href="/?cmd=widgets" />
<area shape="rect" coords="188,276,219,296" href="/?cmd=ondemand" />
<area shape="rect" coords="237,268,258,291" href="/?cmd=favorites" />
<area shape="rect" coords="132,306,170,323" href="/?cmd=mute" />
<area shape="rect" coords="235,304,282,322" href="/?cmd=last" />
<area shape="rect" coords="190,320,225,367" href="/?cmd=fiostv" />
<area shape="rect" coords="130,344,160,359" href="/?cmd=volup" />
<area shape="rect" coords="151,379,177,404" href="/?cmd=voldown" />
<area shape="rect" coords="257,332,286,361" href="/?cmd=chanup" />
<area shape="rect" coords="245,373,278,400" href="/?cmd=chandown" />
<area shape="rect" coords="185,425,236,448" href="/?cmd=dvr" />
<area shape="rect" coords="189,465,241,489" href="/?cmd=play" />
<area shape="rect" coords="198,497,237,521" href="/?cmd=pause" />
<area shape="rect" coords="261,458,291,477" href="/?cmd=fastforward" />
<area shape="rect" coords="140,460,169,477" href="/?cmd=rewind" />
<area shape="rect" coords="133,429,169,446" href="/?cmd=prev" />
<area shape="rect" coords="258,418,287,436" href="/?cmd=next" />
<area shape="rect" coords="141,496,174,519" href="/?cmd=stop" />
<area shape="rect" coords="267,488,294,518" href="/?cmd=record" />
<area shape="rect" coords="149,541,184,560" href="/?cmd=1" />
<area shape="rect" coords="202,538,241,564" href="/?cmd=2" />
<area shape="rect" coords="257,533,295,557" href="/?cmd=3" />
<area shape="rect" coords="145,572,183,599" href="/?cmd=4" />
<area shape="rect" coords="200,578,245,595" href="/?cmd=5" />
<area shape="rect" coords="262,570,297,596" href="/?cmd=6" />
<area shape="rect" coords="153,616,183,638" href="/?cmd=7" />
<area shape="rect" coords="204,616,246,639" href="/?cmd=8" />
<area shape="rect" coords="268,609,298,626" href="/?cmd=9" />
<area shape="rect" coords="216,653,243,673" href="/?cmd=0" />
<area shape="rect" coords="155,686,181,713" href="/?cmd=a" />
<area shape="rect" coords="193,686,225,715" href="/?cmd=b" />
<area shape="rect" coords="232,682,264,705" href="/?cmd=c" />
<area shape="rect" coords="271,678,299,702" href="/?cmd=d" />
</map>
<form action="/" method="get">
<input name="cmd" type="text" size="12">
<input type="submit" value="send custom command">
</form>

'





server = TCPServer.new('127.0.0.1', 5202)
while (session = server.accept)
  request = session.gets
  puts request
  if request.include?("?cmd=")
   cmd = request.split("?cmd=").last.split(" ").first
   handle_command(cmd)
  end
  session.print "HTTP/1.1 200/OK\rContent-type: text/html\r\n\r\n"
  session.print "<html><head><title>FiOS TV Remote</title><style type=\"text/css\">margin: 0px; a:link { color: white;} a:visited { color: white;} a:active { color: red;} </style></head>\r\n"
  session.print "<body background=\"#777777\"><div style=\"font-family: Verdana, sans-serif; padding: 20px; font-size: 18px; color: white; background-color: #555555;\">"
  session.print remote
  session.print page
  session.print "</div></body></html>"
  session.close
end



