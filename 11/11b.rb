require 'set'

SIZE = 10

octopuses = Array.new(SIZE) { Array.new(SIZE)}

def getNeighbours(pos)
	x = pos / SIZE
	y = pos % SIZE
	return [
		[x - 1, y - 1], [x, y - 1], [x + 1, y - 1],
		[x - 1, y], [x + 1, y],
		[x - 1, y + 1], [x, y + 1], [x + 1, y + 1]
	]
		.select { |p| p[0] >= 0 && p[0] < SIZE && p[1] >= 0 && p[1] < SIZE }
		.map { |p| SIZE * p[0] + p[1] }
end

def pp(octopuses)
	SIZE.times do |i|
		SIZE.times do |j|
			print "#{octopuses[i][j]}"
		end
		puts ""
	end
	puts ""
end

ARGF.readlines.each_with_index do |l, i|
	octopuses[i] = l.chomp.split("").map { |c| c.to_i }
end

#pp(octopuses)

firstSuperFlash = false
i = 1
while (!firstSuperFlash)
	nines = Set.new
	(SIZE * SIZE).times do |j|
		x = j / SIZE
		y = j % SIZE
		octopuses[x][y] += 1
		#puts "#{x},#{y}=#{octopuses[x][y]}"
		if (octopuses[x][y] == 10)
			nines << j
		end
	end
	#puts "Nines: #{nines}"

	remainingNines = nines.to_a
	while (!remainingNines.empty?)
		aNine = remainingNines.pop()
		neighbours = getNeighbours(aNine)
		neighbours.each do |n|
			x = n / SIZE
			y = n % SIZE
			octopuses[x][y] += 1
			if (octopuses[x][y] > 9 && !nines.include?(n))
				nines << n
				remainingNines << n
			end
		end
	end

	nines.each do |n|
		x = n / SIZE
		y = n % SIZE
		octopuses[x][y] = 0
	end

	if (nines.size == SIZE * SIZE)
		puts i
		firstSuperFlash = true
	end
	i += 1
end
