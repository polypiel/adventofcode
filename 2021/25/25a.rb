EMPTY = 0
EAST = 1
SOUTH = 2

PP = [".", ">", "v"]

def ppLand(land)
	$height.times do |j|
		$width.times do |i|
			print PP[land[j][i]]
		end
		puts
	end
	puts
end


land = []
ARGF.readlines.each do |l|
	land << l.chomp.split("").map do |c|
		if (c == ">")
			EAST
		elsif (c == "v")
			SOUTH
		else
			EMPTY
		end
	end
end

$width = land[0].size
$height = land.size

def step(land)
	numMovements = 0
	copy = Array.new($height) { |j| Array.new($width) { |i| land[j][i] }}

	# EAST
	$height.times do |j|
		$width.times do |i|
			if (land[j][i] == EAST && land[j][(i + 1) % $width] == EMPTY)
				#puts "Move #{i+1},#{j+1} to #{((i + 1) % $width) + 1},#{j+1}"
				copy[j][i] = EMPTY
				copy[j][(i + 1) % $width] = EAST
				numMovements += 1
			end
		end
	end
	land = copy
	copy = Array.new($height) { |j| Array.new($width) { |i| land[j][i] }}
	# SOUTH
	 $height.times do |j|
	 	$width.times do |i|
	 		if (land[j][i] == SOUTH && land[(j + 1) % $height][i] == EMPTY)
	 			copy[j][i] = EMPTY
	 			copy[(j + 1) % $height][i] = SOUTH
	 			numMovements += 1
	 		end
	 	end
	 end
	return copy, numMovements
end

steps = 0
numMovements = 1
while (numMovements > 0) do
	land, numMovements = step(land)
	#ppLand(land)
	steps += 1
end

puts steps
