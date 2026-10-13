map = STDIN.read.split("\n").map { |it| it.chars.map { |it2| it2 == '@' ? 1 : 0 } }
H = map.length
W = map[0].length

puts "#{W}x#{H}"

def neighbours(x, y)
	[
		[x-1,y],
		[x-1,y-1],
		[x,y-1],
		[x+1,y-1],
		[x+1,y],
		[x+1,y+1],
		[x,y+1],
		[x-1,y+1]
	].filter { |x0, y0| x0 >= 0 && x0 < W && y0 >= 0 && y0 < H }
end

changed = true
removed = 0
while changed do
	changed = false
	(0..H-1).each do |j|
		(0..W-1).each do |i|
			if map[j][i] == 1
				n = neighbours(i,j).map { |x,y| map[y][x] }.sum
				if n < 4
					map[j][i] = 0
					changed = true
					removed += 1
				end 
			end
		end
	end
end

#puts "#{MAP}"
puts removed # 1416