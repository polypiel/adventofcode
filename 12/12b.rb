require 'set'

NODE_START = "start"
NODE_END = "end"

cave = Hash.new

Path = Struct.new(:path, :smallCave) do
	def hasSmallCave?
		return smallCave != nil
	end

	def go(node, newSmallCave = smallCave)
		return Path.new(path + [node], newSmallCave)
	end
end

ARGF.readlines.each do |l|
	origin, target = l.chomp.split("-")
	if (target != NODE_START)
		if (cave.has_key? origin)
			cave[origin] << target
		else
			cave[origin] = [target]
		end
	end
	if (origin != NODE_START)
		if (cave.has_key? target)
			cave[target] << origin
		else
			cave[target] = [origin]
		end
	end
end

paths = [Path.new([NODE_START], nil)]
finishedPaths = Set.new

while (!paths.empty?)
	path = paths.pop()
	cave[path.path.last].each do |p|
		if (p == NODE_END)
			finishedPaths << path.go(p)
		elsif (p.upcase == p)
			paths << path.go(p)
		else
			# small cave
			if (path.hasSmallCave?)
				if (!path.path.include?(p))
					paths << path.go(p)
				end
			else
				if (path.path.include?(p))
					paths << path.go(p, p)
				else
					paths << path.go(p)
				end
			end
		end
	end
end

puts finishedPaths.size
