START = "you"
FINAL = "out"

graph = Hash.new

STDIN.read.split("\n").each do |l|
	node, paths = l.split ": "
	graph[node] = paths.split(" ")
end

puts "#{graph}"

paths = 0
to_visit = graph[START]
while to_visit.size > 0
	current = to_visit.pop
	if current == FINAL
		paths += 1
	else
		graph[current].each do |link|
			to_visit << link
		end
	end
end

puts paths # 615