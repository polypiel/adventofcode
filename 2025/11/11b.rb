START = "svr"
FINAL = "out"

graph = Hash.new

STDIN.read.split("\n").each do |l|
	node, paths = l.split ": "
	graph[node] = paths.split(" ")
end

puts "#{graph}"

paths = 0
to_visit = [[START]]
while to_visit.size > 0
	current_path = to_visit.pop
	current = current_path[-1]
	if current == FINAL
		paths += 1 if current_path.include?("fft") && current_path.include?("dac")
	else
		graph[current].each do |link|
			to_visit << (current_path + [link])
		end
	end
end

puts paths # 615