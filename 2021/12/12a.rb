require 'set'

NODE_START = "start"
NODE_END = "end"

cave = Hash.new

ARGF.readlines.each do |l|
	origin, target = l.chomp.split("-")
	if (cave.has_key? origin)
		cave[origin] << target
	else
		cave[origin] = [target]
	end
	if (cave.has_key? target)
		cave[target] << origin
	else
		cave[target] = [origin]
	end
end

paths = [[NODE_START]]
finishedPaths = Set.new

while (!paths.empty?)
	path = paths.pop()
	cave[path.last].each do |p|
		if (p == NODE_END)
			finishedPaths << (path + [p])
		elsif (p.upcase == p || !path.include?(p))
			paths << (path + [p])
		end
	end
end

puts finishedPaths.size
