SPEEDS = Array.new
POS = Array.new
TICKS = 100

WIDTH = 101
HEIGH = 103
W2 = WIDTH / 2
H2 = HEIGH / 2

def quadrant(p)
	if p[0] < W2
		if p[1] < H2
			0
		elsif p[1] > H2
			1
		else
			-1
		end
	elsif p[0] > W2
		if p[1] < H2
			2
		elsif p[1] > H2
			3
		else
			-1
		end
	else
		-1
	end
end

def print_map()
	map = Array.new(WIDTH*HEIGH) { 0 }
	POS.each { |x, y| map[y*WIDTH + x] += 1}
	HEIGH.times do |y|
		WIDTH.times do |x|
			val = map[y*WIDTH + x]
			print val == 0 ? "." : "#{val}"
		end
		puts ""
	end
	puts ""
end

STDIN.read.split("\n").each do |line|
	if /p=(\d+),(\d+) v=(-?\d+),(-?\d+)/ =~ line
		POS << [$1.to_i, $2.to_i]
		SPEEDS << [$3.to_i, $4.to_i]
	end
end

#print_map()
TICKS.times do
	POS.each_with_index do |p, i|
		vx, vy = SPEEDS[i]
		p[0] = (p[0] + vx) % WIDTH
		p[1] = (p[1] + vy) % HEIGH
	end
	#print_map()
end

Q = Hash.new { 0 }
POS.each { |p| Q[quadrant(p)] += 1 }
sum = Q[0] * Q[1] * Q[2] * Q[3]
puts sum
#puts "#{Q}"

#puts "#{SPEEDS}"
print_map()