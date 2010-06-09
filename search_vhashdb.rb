require "vhash.rb"

v = Vhash.find_by_output(ARGV.shift.gsub(" ", ""))
v.show
