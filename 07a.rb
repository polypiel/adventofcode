initial = ARGF.readline.chomp.split(",").map { |n| n.to_i }

better = -1

initial.size.times do |i|
	current = 0
	initial.each_with_index do |c, j|
		current += (initial[i] - c).abs
	end
	if (better == -1 || current < better)
		better = current
	end
end

puts better
