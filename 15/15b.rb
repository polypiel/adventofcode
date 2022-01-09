INIT_POS = 0
REPS = 5

template = Array.new
$templateHeight = 0
$templateWidth = 0

ARGF.readlines.map { |l| l.chomp.split("") }.each do |row|
	$templateHeight += 1
	$templateWidth = row.size
	row.each do |n|
		template << n.to_i
	end
end

W = $templateWidth * REPS
H = $templateHeight * REPS
END_POS = W * H - 1

cave = Array.new(W * H) do |i|
	x = (i / W) % $templateWidth
	y = (i % W) % $templateWidth
	temp = template[x * $templateWidth + y] + 
		((i / W) / $templateWidth) + ((i % W) / $templateWidth)
	if temp < 10
		temp
	else
		temp % 9
	end
end

Neighbour = Struct.new(:pos, :dist)

def getNeighbours(node)
	i = node.pos / W
	j = node.pos % W
	neighbours = []
	neighbours << Neighbour.new((i - 1) * W + j, node.dist + 1) if (i > 0)
	neighbours << Neighbour.new(W * i + j - 1, node.dist + 1) if (j > 0)
	neighbours << Neighbour.new((i + 1) * W + j, node.dist - 1) if (i < H - 1)
	neighbours << Neighbour.new(W * i + j + 1, node.dist - 1) if (j < W - 1)
	return neighbours
end

toVisit = [Neighbour.new(INIT_POS, W - 1 + H - 1)]
bestPaths = Array.new(W * H) { |i| i == INIT_POS ? 0 : nil }
best = (W + H) * 9

while(!toVisit.empty?) do
	current = toVisit.pop()
	neighbours = getNeighbours(current)
	neighbours.each do |neigh|
		n = neigh.pos
		risk = bestPaths[current.pos] + cave[n]
		if ((bestPaths[n] == nil || bestPaths[n] > risk) && (risk + neigh.dist) < best)
			bestPaths[n] = risk
			if (n != END_POS)
				toVisit << neigh
				toVisit.sort! { |a, b| a.dist <=> b.dist}
			else
				best = risk if (risk < best)
			end
		end
	end
end

puts bestPaths[END_POS]
