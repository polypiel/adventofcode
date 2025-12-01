Region = Struct.new(:id, :crop, :tiles) do
	# def next_to?(c, x, y)
	# 	crop == c && tiles.any? { |t| (t[0] - x).abs + (t[1] - y).abs == 1  }
	# end

	# def inc(x, y)
	# 	@tiles << [x, y]
	# end

	def num
		perimeter = tiles.map { |x, y|
			[
				[x + 1, y],
				[x, y + 1],
				[x - 1, y],
				[x, y - 1]
			]
			.filter { |p| !in?(p) || LAND[p[1]][p[0]] != crop }.size
		}.sum

		return perimeter * tiles.size
	end

	def to_s
		"#{crop} (#{id}): #{tiles} - #{num()}"
	end
end

LAND = STDIN.read.split("\n").map { |row| row.chars }
H = LAND.size
W = LAND[0].size
REGIONS = []

#puts "Land"
#puts "#{LAND}"

def in?(coord)
	coord[0] >= 0 && coord[0] < W && coord[1] >= 0 && coord[1] < H
end

def fill_region(regId, init_pos)
	candidates = [init_pos]
	all = Set.new
	all << init_pos
	while candidates.size > 0
		x, y = candidates.pop
		#puts "#{x},#{y}"
		c = LAND[y][x]
		LAND_REGIONS[y][x] = c
		[
			[x + 1, y],
			[x, y + 1],
			[x - 1, y],
			[x, y - 1]
		]
			.filter { |p| in?(p) && !all.include?(p) && LAND[p[1]][p[0]] == c && LAND_REGIONS[p[1]][p[0]] == -1 }
			.each do |p|
				candidates << p
				all << p
			end
	end
	REGIONS << Region.new(regId, LAND[init_pos[1]][init_pos[0]], all)
end

LAND_REGIONS = Array.new(H) { Array.new(W) { -1 }  }
regId = 0
for j in 0..H - 1 do
	for i in 0..W - 1 do
		if LAND_REGIONS[j][i] == -1
			fill_region(regId, [i, j])
			regId += 1
		end
	end
end

# REGIONS.each do |r|
# 	puts "#{r}"
# end
puts "#{REGIONS.map { |r| r.num }.sum}"

# def next_to(crop, x, y)
# 	regions.find { |r| r.next_to?(c, x, y) }
# end

# for j in 0..H - 1 do
# 	for i in 0..W - 1 do
# 		c = LAND[j][i]
# 		region = regions.find { |r| r.next_to?(c, i, j) }
# 		if region != nil
# 		else
# 			regions << Region.new(c, [[i, j]])
# 		end
# 	end
# end

# puts "Regions"
# puts "#{regions}"
