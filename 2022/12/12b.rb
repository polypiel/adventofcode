lines = STDIN.read.split("\n")
width = lines[0].size
height = lines.size
size = width * height

map = Array.new(size)
pos_end = 0
lines.flat_map { |line| line.split("") }.each_with_index do |pos, i|
	if pos == "S"
		map[i] = "a".ord
	elsif pos == "E"
		map[i] = "z".ord
		pos_end = i
	else
		map[i] = pos.ord
	end
end

neighbours = map.each_with_index.map do |v, i|
	n = Array.new
	n << i + 1 if i % width != width - 1 and v <= map[i+1] + 1
	n << i - 1 if i % width != 0 and v <= map[i-1] + 1
	n << i + width if i + width < height * width and v <= map[i+width] + 1
	n << i - width if i - width >= 0 and v <= map[i-width] + 1
	n
end

flow_map = Array.new(size) { -1 }

candidates = [[pos_end, 0]]

while candidates.size > 0
	(pos, weight) = candidates.pop
	flow_map[pos] = weight if flow_map[pos] == -1 or weight< flow_map[pos]
	neighbours[pos].each do |n|
		candidates << [n, weight + 1] if flow_map[n] == -1 or flow_map[n] > weight + 1
	end
end

puts flow_map.select.with_index { |val, i| val != -1 and map[i] == "a".ord}.min #363
