require 'set'
SIZE = 4
window = Array.new(SIZE)
STDIN.read.split("\n")[0].chars.each_with_index do |c, i|
	window[i % SIZE] = c
	if i >= SIZE and Set.new(window).size == SIZE
		puts "#{i+1}" # 1848
		exit
	end
end
raise "Not found"
