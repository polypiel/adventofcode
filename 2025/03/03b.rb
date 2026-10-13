banks = STDIN.read.split("\n").map { |it| it.chars }

ITERS = 12

def max_pos(b, i, j)
	max = 0
	pos = 0
	(i..j).each do |k|
		bk = b[k].to_i
		return k if bk == 9
		if bk > max
			pos = k
			max = bk
		end
	end
	pos
end


jolts = Array.new

banks.each do |b|
	jolt = 0
	current_i = -1
	ITERS.times do |i|
		current_i = max_pos(b, current_i+1, b.size - ITERS + i)
		jolt = jolt * 10 + b[current_i].to_i
	end
	jolts << jolt
end

puts jolts.sum # 170997883706617