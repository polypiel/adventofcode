require 'set'

antenas = []

max_x = 0
max_y = 0

STATION = STDIN.read.split("\n").each_with_index do |l, j|
	max_y = j if j > max_y
	l.chars().each_with_index do |e, i|
		antenas << [e, [i, j]] if e != "."
		max_x = i if i > max_x
	end
end
MAX_X = max_x + 1
MAX_Y = max_y + 1

def in?(pos)
	return pos[0] >= 0 && pos[0] <= MAX_X - 1 && pos[1] >= 0 && pos[1] <= MAX_Y - 1
end

def print_map(antenas, antinodes)
	(0..MAX_Y - 1).each do |j|
		(0..MAX_X - 1).each do |i|
			ant = antenas.detect { |a| a[1][0] == i && a[1][1] == j }
			if ant != nil
				print "#{ant[0]}"
			elsif antinodes.any? { |a| a[0] == i && a[1] == j}
				print "#"
			else
				print "."
			end
		end
		puts ""
	end
end

antinodes = Set.new
(0..antenas.size - 2).each do |i|
	(i + 1..antenas.size - 1).each do |j|
		ai_type, ai_pos = antenas[i]
		aj_type, aj_pos = antenas[j]
		if ai_type == aj_type
			diff = [ai_pos[0] - aj_pos[0], ai_pos[1] - aj_pos[1]]

			candidate_antinodes = Set.new
			loop.with_index do |_, i|
				anti = [ai_pos[0] + i * diff[0], ai_pos[1] + i * diff[1]]
				break if !in?(anti)
				candidate_antinodes << anti
			end
			loop.with_index do |_, i|
				anti = [ai_pos[0] - i * diff[0], ai_pos[1] - i * diff[1]]
				break if !in?(anti)
				candidate_antinodes << anti
			end

			candidate_antinodes.each { |it| antinodes << it }
		end
	end
end

print_map(antenas, antinodes)
puts antinodes.size # 1249
