banks = STDIN.read.split("\n").map { |it| it.chars }

jolts = Array.new

banks.each do |b|
	pos_i = 0
	max_i = 0
	(0..b.size-2).each do |i|
		if b[i].to_i > max_i
			pos_i = i
			max_i = b[i].to_i
		end
	end
	max_j = 0
	(pos_i+1..b.size-1).each do |j|
		if b[j].to_i > max_j
			max_j = b[j].to_i
		end
	end
	jolts << max_i * 10 + max_j
end

puts jolts.sum # 17207s
