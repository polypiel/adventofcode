MAP = []

guard_pos = nil
STATION = STDIN.read.split("\n").each_with_index do |l, j|
	i = l.index("^")
	guard_pos = [i, j] if i != nil
	MAP << l.chars()
end
H = MAP.size
W = MAP[0].size

def in?(pos)
	pos[0] >= 0 && pos[0] <= W - 1 && pos[1] >= 0 && pos[1] <= H - 1
end

def turn(dir)
	if dir == "^"
		return ">"
	elsif dir == ">"
		return "v"
	elsif dir == "v"
		return "<"
	elsif dir == "<"
		return "^"
	end
end

#puts "#{guard_pos}"
#puts "#{MAP}"

loop do
	dir = MAP[guard_pos[1]][guard_pos[0]]
	#puts dir
	if dir == "^"
		next_pos = [guard_pos[0], guard_pos[1] - 1]
	elsif dir == ">"
		next_pos = [guard_pos[0] + 1, guard_pos[1]]
	elsif dir == "v"
		next_pos = [guard_pos[0], guard_pos[1] + 1]
	elsif dir == "<"
		next_pos = [guard_pos[0] - 1, guard_pos[1]]
	end
	if !in?(next_pos)
		MAP[guard_pos[1]][guard_pos[0]] = "X"
		break
	end
	next_space = MAP[next_pos[1]][next_pos[0]]
	#puts next_space
	if next_space == "." || next_space == "X"
		# puts "going next"
		MAP[guard_pos[1]][guard_pos[0]] = "X"
		guard_pos = next_pos
		MAP[guard_pos[1]][guard_pos[0]] = dir
	elsif next_space == "#"
		# puts "turn"
		MAP[guard_pos[1]][guard_pos[0]] = turn(dir)
	end
			
end

MAP.each do |row|
	row.each do |e|
		print e
	end
	print "\n"
end
num = MAP.map { |row| row.map { |e| e == "X" ? 1 : 0 }.sum }.sum
puts num # 5312