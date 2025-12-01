disk_map = STDIN.read.split("\n")[0]

Block = Struct.new(:is_file, :size, :id) do
	def to_str()
		(1..size).map { "#{id}" }.join
	end

	def to_i()
		return is_file ? id.to_i : 0
	end

	def free()
		@is_file = false
		@id = "."
	end
end

id = 0
blocks = []
disk_map.chars.each_with_index do |c, i|
	c_num = c.to_i
	is_file = i % 2 == 0
	blocks << Block.new(is_file, c_num, is_file ? "#{id}" : ".")
	id += 1 if is_file
end

(blocks.size - 1).downto(0).each do |i|
	if blocks[i].is_file
		for j in 0..i - 1 do
			if !blocks[j].is_file && blocks[j].size >= blocks[i].size
				remaining = blocks[j].size - blocks[i].size
				file_id = blocks[i].id
				file_size = blocks[i].size
				blocks[i] = Block.new(false, file_size, ".")
				blocks[j].size = remaining
				blocks.insert(j, Block.new(true, file_size, file_id))
				# TODO compact
				break
			end
		end
	end
end

blocks.each { |b| print b.to_str }
puts ""
checksum = 0
i = 0

blocks.each do |b|
	b.size.times do
		checksum += b.to_i * i
		i += 1
	end
end
puts i

puts checksum # 6413328569890
