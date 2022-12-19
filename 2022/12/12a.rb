lines = STDIN.read.split("\n")
WIDTH = lines[0].size
HEIGHT = lines.size

map = Array.new(WIDTH * HEIGHT)
pos_start = 0
pos_end = 0
lines.flat_map { |line| line.split("") }.each_with_index do |pos, i|
	if pos == "S"
		map[i] = "a".ord
		pos_start = i
	elsif pos == "E"
		map[i] = "z".ord
		pos_end = i
	else
		map[i] = pos.ord
	end
end

neighbours = map.each_with_index.map do |v, i|
	n = Array.new
	n << i + 1 if i % WIDTH != WIDTH - 1 and v + 1 >= map[i+1]
	n << i - 1 if i % WIDTH != 0 and v + 1 >= map[i-1]
	n << i + WIDTH if i + WIDTH < HEIGHT * WIDTH and v + 1 >= map[i+WIDTH]
	n << i - WIDTH if i - WIDTH >= 0 and v + 1 >= map[i-WIDTH]
	n
end

flow_map = Array.new(WIDTH * HEIGHT) { -1 }

candidates = [[pos_start, 0]]

while not candidates.empty?
	(pos, weight) = candidates.pop
	flow_map[pos] = weight if flow_map[pos] == -1 or weight < flow_map[pos]
	neighbours[pos].each do |n|
		candidates << [n, weight + 1] if flow_map[n] == -1 or flow_map[n] > weight + 1
	end
end

puts flow_map[pos_end] # 370
