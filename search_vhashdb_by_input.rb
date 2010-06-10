require "vhash.rb"

v = Vhash.find_by_input(ARGV.shift.gsub(" ", "").upcase)
v.show
