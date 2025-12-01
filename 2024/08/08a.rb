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

def in?(x, y)
	return x >= 0 && x <= MAX_X - 1 && y >= 0 && y <= MAX_Y - 1
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

			anti1 = [ai_pos[0] + diff[0], ai_pos[1] + diff[1]]
			anti2 = [ai_pos[0] - diff[0], ai_pos[1] - diff[1]]
			anti3 = [aj_pos[0] + diff[0], aj_pos[1] + diff[1]]
			anti4 = [aj_pos[0] - diff[0], aj_pos[1] - diff[1]]
			antinodes << anti1 if anti1 != ai_pos && anti1 != aj_pos && in?(anti1[0], anti1[1])
			antinodes << anti2 if anti2 != ai_pos && anti2 != aj_pos && in?(anti2[0], anti2[1])
			antinodes << anti3 if anti3 != ai_pos && anti3 != aj_pos && in?(anti3[0], anti3[1])
			antinodes << anti4 if anti4 != ai_pos && anti4 != aj_pos && in?(anti4[0], anti4[1])
			#puts "#{anti1},#{anti2},#{anti3},#{anti4}" if ai_type == "0"
		end
	end
end

# print_map(antenas, antinodes)
puts antinodes.size # > 361
