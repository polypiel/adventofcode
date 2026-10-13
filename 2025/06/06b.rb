matrix = Array.new
ops = nil

STDIN.read.split("\n").each do |line|
	if (line.include?("+") || line.include?("*"))
		ops = line
	else
		matrix << line
	end
end

numbers = Array.new
matrix.each do |line|
	ni = 0
	nj = 0
	line.chars.each_with_index do |n, i|
		new_n = i + 1 < ops.size && ops[i + 1] != " "
		if new_n
				ni += 1
				nj = 0
				new_n = true
		elsif n == " "
			numbers << Array.new if numbers.size == ni
			numbers[ni] << "" if numbers[ni].size == nj
			nj += 1
		else
			new_n = false
			numbers << Array.new if numbers.size == ni
			numbers[ni] << "" if numbers[ni].size == nj
			numbers[ni][nj] = numbers[ni][nj] + n
			nj += 1
		end
	end
end

operators = ops.split(" ")
puts numbers.map.with_index { |m,i|
	m.map{|it| it.to_i}.inject(operators[i].to_sym)
}.sum # 10442199710797