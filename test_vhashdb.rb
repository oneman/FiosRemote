require "vhash.rb"

x = Time.parse("01/01/1970")
86400.times do 
x = x + 1.second
vhash = find_by_time(x.strftime("%H:%M:%S"))

end
