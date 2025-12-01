require 'set'

TERRAIN = STDIN.read.split("\n").map { |row| row.chars.map { |c| c == "." ? 10 : c.to_i } }

puts "#{TERRAIN}"

H = TERRAIN.size
W = TERRAIN[0].size

def next_moves(x, y)
	return [
		[x + 1, y],
		[x, y + 1],
		[x - 1, y],
		[x, y - 1]
	].filter { |x, y| x >= 0 && y >= 0 && x < W && y < H }
end

def search(x, y)
	val = TERRAIN[y][x]
	if val == 9 && !VISITED.include?([x, y])
		VISITED << [x, y]
		return 1
	end
	return next_moves(x, y)
		.filter { |x0, y0| val + 1 == TERRAIN[y0][x0] }
		.map { |x1, y1 | search(x1, y1) }.sum
end

VISITED = Set.new
sum = 0
for j in 0..H - 1 do
	for i in 0..W - 1 do
		VISITED.clear
		if TERRAIN[j][i] == 0
			val = search(i, j)
			# puts "#{i},#{j} => #{val}"
			sum += val
		end
	end
end

puts sum
