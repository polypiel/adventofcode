ops = []
STDIN.read.split("\n").each do |line|
	left, righ = line.split(":").map { |n| n.strip }
	ops << [left.to_i, righ.split(" ").map { |n| n.to_i }]
end

OPS = [:*, :+]

def gen(accum, result)
	if result.size == 0
		return [accum]
	else
		return gen(accum * result[0], result[1..]) + gen(accum + result[0], result[1..])
	end
end

sum = 0
ops.each do |res, ops|
	ok = gen(0, ops).filter { |it| it == res}[0]
	# puts "#{ok}"
	sum += ok if ok != nil
end

puts sum # 1260333054159
