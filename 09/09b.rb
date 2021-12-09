require 'set'

$map = []

ARGF.readlines.each do |l|
	$map << l.chomp.split("").map { |c| c.to_i }
end

H = $map.size
W = $map[0].size

def getNeighbours(i, j)
	neighbours = []
	if (i > 0)
		neighbours << (i - 1) * W + j
	end
	if (j > 0)
		neighbours << W * i + j - 1
	end
	if (i < H - 1)
		neighbours << (i + 1) * W + j
	end
	if (j < W - 1)
		neighbours << W * i + j + 1
	end
	return neighbours
end

def flood(low)
	toVisit = [low]
	basin = Set.new(toVisit)

	loop do
		candidates = Set.new
		toVisit.each do |p|
			height = $map[p / W][p % W]
			neighbours = getNeighbours(p / W, p % W)
			candidates |= neighbours
				.select { |n| !basin.include?(n) }
				.select { |n| $map[n / W][n % W] < 9 && $map[n / W][n % W] > height}
				.to_set
		end
		if (candidates.empty?)
			break
		end
		toVisit = candidates.to_a
		basin |= candidates
	end
	return basin.size
end

lows = []
H.times do |i|
	W.times do |j|
		neighbours = getNeighbours(i, j)
		if (neighbours.all? { |n| $map[i][j] < $map[n / W][n % W] })
			lows << W * i + j
		end
	end
end

regions = []
lows.each do |low|
	regions << flood(low)
end

puts regions.sort.reverse.take(3).inject(1, :*)
