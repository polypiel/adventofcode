disk_map = STDIN.read.split("\n")[0]

id = 0
raw_disk_map = []
disk_map.chars.each_with_index do |c, i|
	c_num = c.to_i
	if i % 2 == 0
		raw_disk_map.concat((0..c_num-1).map { "#{id}" })
		id += 1
	else
		raw_disk_map.concat((0..c_num-1).map { "." })
	end
end

left = 0
right = raw_disk_map.size - 1

loop do
	left = raw_disk_map.index(".")
	#puts "left: #{left}"
	break if left == nil

	while raw_disk_map[right] == "." && right > left
		right -= 1
	end
	#puts "right: #{right}"
	break if right == nil || right <= left

	aux = raw_disk_map[left]
	raw_disk_map[left] = raw_disk_map[right]
	raw_disk_map[right] = aux
	#puts "#{raw_disk_map}"
end

# puts "#{raw_disk_map}"
puts raw_disk_map.each_with_index.map { |c, i| c == "." ? 0 : c.to_i * i }.sum