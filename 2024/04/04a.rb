STATION = STDIN.read.split("\n").map { |l| l.chars  }

# puts "#{STATION}"

H = STATION.size
W = STATION[0].size

def new_pos(x, y, dir)
	if dir == 0 # right
		return [x + 1, y]
	elsif dir == 1
		return [x+1, y+1]
	elsif dir == 2 # down
		return [x, y+1]
	elsif dir == 3
		return [x-1, y+1]
	elsif dir == 4 # left
		return [x-1, y]
	elsif dir == 5
		return [x-1, y-1]
	elsif dir == 6 # top
		return [x, y-1]
	elsif dir == 7
		return [x+1, y-1]
	else
		return nil
	end
end

def find(word, x0, y0, dir)
	x1, y1 = new_pos(x0, y0, dir)
	return 0 if x1 < 0 || x1 > (W - 1) || y1 < 0 || y1 > (H - 1)
	#puts "#{x1},#{y1}"
	l = STATION[y1][x1]
	if l != word[0]
		return 0
	elsif word.size == 1
		return 1
	else
		return find(word[1..], x1, y1, dir)
	end
end

words = 0
(0..H - 1).each do |i|
	(0..W - 1).each do |j|
		# puts "#{STATION[i][j]}"
		if STATION[i][j] == "X"
			words += (0..7).map { |d| find("MAS", j, i, d) }.sum
		end
	end
end

puts "#{words}"