INIT_POS = 0

cave = Array.new

$height = 0
$width = 0

ARGF.readlines.map { |l| l.chomp.split("") }.each do |row|
	$height += 1
	$width = row.size
	row.each do |n|
		cave << n.to_i
	end
end

END_POS = cave.size - 1

def getNeighbours(pos)
	i = pos / $width
	j = pos % $width
	neighbours = []
	if (i > 0)
		neighbours << (i - 1) * $width + j
	end
	if (j > 0)
		neighbours << $width * i + j - 1
	end
	if (i < $height - 1)
		neighbours << (i + 1) * $width + j
	end
	if (j < $width - 1)
		neighbours << $width * i + j + 1
	end
	return neighbours
end

def getDistance(pos)
	i = pos / $width
	j = pos % $width
	return ($width - 1 - i) + ($height - 1 - j)
end

toVisit = [INIT_POS]
bestPaths = Array.new(cave.size) { |i| i == INIT_POS ? 0 : nil }
best = nil

while(!toVisit.empty?) do
	current = toVisit.pop()
	neighbours = getNeighbours(current)
	neighbours.each do |n|
		risk = bestPaths[current] + cave[n]
		if ((bestPaths[n] == nil || bestPaths[n] > risk) && (best == nil || risk + getDistance(n) < best))
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
