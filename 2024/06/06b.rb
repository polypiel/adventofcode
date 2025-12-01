MAP = []

UP = 1
RIGHT = 2
DOWN = 4
LEFT = 8
BLOCK = 32
EMPTY = 16

guard_pos = nil
STATION = STDIN.read.split("\n").each_with_index do |l, j|
	i = l.index("^")
	guard_pos = [i, j] if i != nil
	MAP << l.chars().map { |c| c == "#" ? BLOCK : EMPTY }
end


H = MAP.size
W = MAP[0].size
# DIRS_A = ["^", ">", "v", "<"]
# DIRS_M = {"^": 0, ">": 1, "v": 2, "<": 3}
# DIRS_OLD = {"^": "|", ">": "-", "v": "|", "<": "-"}
DIRS_MOVE = {"1": [0, -1], "2": [1, 0], "4": [0, 1], "8": [-1, 0]}
DIRS_PRINT = {"1": "^", "2": ">", "4": "v", "8": "<"}

def in?(pos)
	pos[0] >= 0 && pos[0] <= W - 1 && pos[1] >= 0 && pos[1] <= H - 1
end

def turn(dir)
	# DIRS_A[(DIRS_M[dir.to_sym] + 1) % 4]
	(dir * 2) % 15
end

def print_lab(map, pos, dir)
	map.each_with_index do |row, j|
		row.each_with_index do |e, i|
			if pos[0] == i && pos[1] == j
				print "#{DIRS_PRINT[dir.to_s.to_sym]}"
			elsif e == EMPTY
				print "."
			elsif e == BLOCK
				print "#"
			elsif (e & UP > 0 || e & DOWN > 0) && (e & RIGHT > 0 || e & LEFT > 0)
				print "+"
			elsif e & UP > 0 || e & DOWN > 0
				print "|"
			elsif e & RIGHT > 0 || e & LEFT > 0
				print "-"
			end
		end
		print "\n"
	end
end

def has_loop?(map, pos, dir)
	# print_lab(map, pos, dir)
	#n = 0
	loop do
		#puts "loop #{dir}"
		#print_lab(map, pos, dir)
		# dir = map[pos[1]][pos[0]]
		# puts dir
		dx, dy = DIRS_MOVE[dir.to_s.to_sym]
		next_pos = [pos[0] + dx, pos[1] + dy]

		if !in?(next_pos)
			#puts "out!"
			# print_lab(map)
			return false
		end
		next_space = map[next_pos[1]][next_pos[0]]

		if next_space == BLOCK
			# puts "turn"
			map[pos[1]][pos[0]] |= dir
			dir = turn(dir)
			map[pos[1]][pos[0]] |= dir
		else
			if dir & next_space > 0
				#puts "in!"
				# print_lab(map, pos, dir)
				return true
			end
			map[pos[1]][pos[0]] |= dir
			pos = next_pos
		end
		#n += 1
		#return if n > 20
	end
end

num_loops = 0
(0..H - 1).each do |j|
	(0..W - 1).each do |i|
		if MAP[j][i] == EMPTY
			#puts "trying #{i},#{j}"
			new_map = MAP.clone.map(&:clone)
			new_map[j][i] = BLOCK
			num_loops += 1 if has_loop?(new_map, guard_pos, UP)
		end
		# exit(0)
	end
end

puts num_loops # 1748
