require "vhash.rb"

v = Vhash2.find_by_output(ARGV.shift.gsub(" ", ""))
v.show
