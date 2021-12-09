map = []

ARGF.readlines.each do |l|
	map << l.chomp.split("").map { |c| c.to_i }
end

sum = 0
map.size.times do |i|
	map[i].size.times do |j|
		neighbours = []
		if (i > 0)
			neighbours << map[i - 1][j]
		end
		if (j > 0)
			neighbours << map[i][j - 1]
		end
		if (i < map.size - 1)
			neighbours << map[i + 1][j]
		end
		if (j < map[i].size - 1)
			neighbours << map[i][j + 1]
		end
		if (neighbours.all? { |n| map[i][j] < n })
			sum += map[i][j] + 1
		end
	end
end
puts sum
