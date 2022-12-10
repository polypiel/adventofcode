LIMIT = 100000

Node = Struct.new(:name, :size, :parent, :children) do
	def to_s
		"#{name} - #{size}"
	end

	def ls(tabs = 0)
		if (children == nil)
			puts Array.new(tabs).map {"  "}.join + "#{name} (#{size} kb)\n"
		else
			puts Array.new(tabs).map {"  "}.join + "#{name} (#{children.size} files - #{size} kb)\n"
			children.values.each { |c| c.ls(tabs + 1) }.join("\n")
		end
	end

	def update_size(file_size)
		self.size += file_size
		if (parent != nil)
			parent.update_size(file_size)
		end
	end

	def top
		topNodes = []
		topNodes << self if size <= LIMIT
		(children || Hash.new).values.each do |c|
			c.top.each do |cc| 
				topNodes << cc if cc.children != nil and cc.size <= LIMIT
			end
		end
		topNodes
	end
end

root = Node.new("/", 0, nil, Hash.new)
current = root

STDIN.read.split("\n").each do |line|
	if /\$ cd ([\w\/\.]+)/ =~ line
		if $1 == "/"
			current = root
		elsif $1 == ".."
			raise "cd: no parent directory" if current.parent == nil
			current = current.parent
		else
			raise "cd: no directory #{$1}" if !current.children.key? $1
			current = current.children[$1]
		end
	elsif /\$ ls/ =~ line
		current.children = Hash.new if current.children == nil
	elsif /(\d+) ([\w\.]+)/ =~ line
		current.children[$2] = Node.new($2, $1.to_i, current, nil)
		current.update_size($1.to_i)
	elsif /dir (\w+)/ =~ line
		current.children[$1] = Node.new($1, 0, current, Hash.new)
	else
		raise "Unknown entry: #{line}"
	end
end

#root.ls
puts root.top.sum { |c| c.size } # 1453349
