SPACE = STDIN.read.split("\n").map { |l| l.chars }

def find_start
	for i in 0..SPACE.size do
		for j in 0..SPACE[0].size do
			if SPACE[i][j] == "S"
				return [j, i]
			end
		end
	end
end

splits = Set.new
visited = Set.new
positions = Array.new
positions << find_start
while positions.size > 0
	x0, y0 = positions.pop
	visited << [x0, y0]
	if y0 + 1 < SPACE.size
		down = SPACE[y0+1][x0]
		if down == "."
			positions << [x0, y0 + 1] if !visited.include?([x0, y0 + 1])
		elsif down == "^"
			positions << [x0 - 1, y0 + 1] if x0 - 1 >= 0 && !visited.include?([x0-1,y0+1])
			positions << [x0 + 1, y0 + 1] if x0 + 1 < SPACE.size && !visited.include?([x0+1,y0+1])
			splits << [x0, y0 + 1]
		end	
	end
end

puts splits.size # 1642