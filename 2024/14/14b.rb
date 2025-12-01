SPEEDS = Array.new
POS = Array.new
TICKS = 10000

WIDTH = 101
HEIGH = 103
W2 = WIDTH / 2
H2 = HEIGH / 2

def print_map(num)
	map = Array.new(WIDTH*HEIGH) { 0 }
	POS.each do |x, y| 
		val = map[y*WIDTH + x]
		return if val == 1
		map[y*WIDTH + x] = val + 1
	end
	puts "#{num+1}"
	HEIGH.times do |y|
		WIDTH.times do |x|
			val = map[y*WIDTH + x]
			print val == 0 ? "." : "#{val}"
		end
		puts ""
	end
end

STDIN.read.split("\n").each do |line|
	if /p=(\d+),(\d+) v=(-?\d+),(-?\d+)/ =~ line
		POS << [$1.to_i, $2.to_i]
		SPEEDS << [$3.to_i, $4.to_i]
	end
end

TICKS.times do |j|
	POS.each_with_index do |p, i|
		vx, vy = SPEEDS[i]
		p[0] = (p[0] + vx) % WIDTH
		p[1] = (p[1] + vy) % HEIGH
	end
	print_map(j)
end
