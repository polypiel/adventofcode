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

def ok?(x, y)
	return !(x < 0 || x > (W - 1) || y < 0 || y > (H - 1))
end

def find(x0, y0)
	mx0, my0 = new_pos(x0, y0, 3)
	mx1, my1 = new_pos(x0, y0, 5)
	sx0, sy0 = new_pos(x0, y0, 1)
	sx1, sy1 = new_pos(x0, y0, 7)
	return 0 if !ok?(mx0, my0) || !ok?(mx1, my1) || !ok?(sx0, sy0) || !ok?(sx1, sy1) 
	cross = STATION[my0][mx0] + STATION[my1][mx1] + STATION[sy1][sx1] + STATION[sy0][sx0]
	return cross == "MMSS" || cross == "MSSM" || cross == "SSMM" || cross == "SMMS" ? 1 : 0
end

words = 0
(0..H - 1).each do |i|
	(0..W - 1).each do |j|
		# puts "#{STATION[i][j]}"
		if STATION[i][j] == "A"
			res = find(j, i)
			words += res
			# puts "#{j},#{i}" if res == 1
		end
	end
end

puts "#{words}"
