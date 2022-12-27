require 'set'

VARIATIONS = [[1, 0, 0], [-1, 0, 0], [0, 1, 0], [0, -1, 0], [0, 0, 1], [0, 0, -1]]

cubes = STDIN.read.split("\n").map { |line| line.split(",").map { |n| n.to_i } }.to_set

def next_to?(c1, c2)
	(c1[0] - c2[0]).abs + (c1[1] - c2[1]).abs + (c1[2] - c2[2]).abs == 1
end

sides = cubes.map do |c|
	collisions = 0
	VARIATIONS.each do |v|
		candidate = [c[0] + v[0], c[1] + v[1], c[2] + v[2]]
		collisions += 1 if cubes.include? candidate
	end
	collisions
end

puts sides.map { |c| 6 - c }.sum # 4308