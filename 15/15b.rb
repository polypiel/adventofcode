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
		(( i / W ) / $templateWidth) + 
			((i % W)/ $templateWidth)
	if temp < 10
		temp
	else
		temp % 9
	end
end

# H.times do |i|
# 	W.times do |j|
# 		print cave[i * W + j]
# 	end
# 	puts
# end


def getNeighbours(pos)
	i = pos / W
	j = pos % W
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

def getDistance(pos)
	i = pos / W
	j = pos % W
	return (W - 1 - i) + (H - 1 - j)
end

toVisit = [INIT_POS]
bestPaths = Array.new(W * H) { |i| i == INIT_POS ? 0 : nil }
best = nil

while(!toVisit.empty?) do
	current = toVisit.pop()
	neighbours = getNeighbours(current)
	neighbours.each do |n|
		risk = bestPaths[current] + cave[n]
		if ((bestPaths[n] == nil || bestPaths[n] > risk) && 
				(best == nil || risk + getDistance(n) < best))
			bestPaths[n] = risk
			if (n != END_POS)
				toVisit << n
			else
				if(best == nil || risk < best)
					best = risk
				end
			end
		end
	end
end

puts bestPaths[END_POS]
