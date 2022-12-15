WIDTH = 40
HEIGHT = 6
cycle = 0
x = 1
crt = Array.new(WIDTH * HEIGHT) { false }

def pixel(cycle,  x)
	column = cycle % WIDTH
	return (x >= column-1 and x <= column+1)
end

STDIN.read.split("\n").each do |line|
	if line == "noop"
		crt[cycle] = pixel(cycle, x)
		cycle += 1
	elsif /addx ([-\d]+)/ =~ line
		crt[cycle] = pixel(cycle, x)
		cycle += 1
		crt[cycle] = pixel(cycle, x)
		cycle += 1
		x += $1.to_i
	else
		raise "Unknown instruction: line"
	end
end

for j in (0..WIDTH*HEIGHT)
	print "\n" if j % WIDTH == 0 and j > 0
	print "#{crt[j] ? '#' : '.'}"
end
# BJFRHRFU
