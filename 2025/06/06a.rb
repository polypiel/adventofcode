matrix = Array.new
operators = nil

STDIN.read.split("\n").each do |line|
	if (line.include?("+") || line.include?("*"))
		operators = line.split(" ")
	else
		line.split(" ").each_with_index do |n, j|
			matrix << Array.new if matrix.size <= j
			matrix[j] << n.to_i
		end
	end
end

puts matrix.map.with_index { |m,i|
		m.inject(operators[i].to_sym)
}.sum # 6169101504608