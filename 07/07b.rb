initial = ARGF.readline.chomp.split(",").map { |n| n.to_i }

better = -1

initial.size.times do |i|
	current = 0
	initial.each_with_index do |c, j|
		c0 = (c  - i - 1).abs
		current += ((c0 * c0) + c0) / 2
	end
	
	better = current if (better == -1 || current < better)
end

puts better
