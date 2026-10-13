MAP = STDIN.read.split("\n").map { |it| it.chars.map { |it2| it2 == '@' ? 1 : 0 } }
H = MAP.length
W = MAP[0].length

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

forklifts = 0
(0..H-1).each do |j|
	(0..W-1).each do |i|
		if MAP[j][i] == 1
			n = neighbours(i,j).map { |x,y| MAP[y][x] }.sum
			forklifts += 1 if n < 4
		end
	end
end

#puts "#{MAP}"
puts forklifts # 1416