require 'set'

VARIATIONS = [[1, 0, 0], [-1, 0, 0], [0, 1, 0], [0, -1, 0], [0, 0, 1], [0, 0, -1]]

min = Array.new(3)
max = Array.new(3)
cubes = STDIN.read.split("\n").map { |line| 
	coord = line.split(",").map { |n| n.to_i }
	min[0] = coord[0] if min[0] == nil or coord[0] < min[0]
	min[1] = coord[1] if min[1] == nil or coord[1] < min[1]
	min[2] = coord[2] if min[2] == nil or coord[2] < min[2]
	max[0] = coord[0] if max[0] == nil or coord[0] > max[0]
	max[1] = coord[1] if max[1] == nil or coord[1] > max[1]
	max[2] = coord[2] if max[2] == nil or coord[2] > max[2]
	coord
}.to_set
#puts "#{min} - #{max}"

min[2].upto(max[2]) do |z|
	min[1].upto(max[1]) do |y|
		min[0].upto(max[0]) do |x|
			candidate = [x, y, z]
			if not cubes.include? candidate
				#puts "Checking #{candidate}"
				visited = Set.new(cubes)
				to_visit = Array.new
				to_visit << candidate
				inside = true
				while not to_visit.empty?
					#puts "#{to_visit.size}"
					next_to = to_visit.pop
					#puts "#{next_to}"
					visited << next_to
					if next_to[0] < min[0] or next_to[0] > max[0] or 
							next_to[1] < min[1] or next_to[1] > max[1] or 
							next_to[2] < min[2] or next_to[2] > max[2]
						#puts "Outside #{next_to}"
						inside = false
						break
					end
					VARIATIONS.map { |c| [c[0] + next_to[0], c[1] + next_to[1], c[2] + next_to[2]] }
							.select { |c| not visited.include? c }
							.each do |n|
						to_visit << n
					end
				end
				if inside
					#puts "Inner cube #{candidate}"
					cubes << candidate 
				end
			end
		end
	end
end

sides = cubes.map do |c|
	collisions = 0
	VARIATIONS.each do |v|
		candidate = [c[0] + v[0], c[1] + v[1], c[2] + v[2]]
		collisions += 1 if cubes.include? candidate
	end
	collisions
end

puts sides.map { |c| 6 - c }.sum # 2540
