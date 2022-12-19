def parse(tokens)
	raise "Invalid tokens #{tokens}" if tokens[0] != "[" and tokens[-1] != "]"
	pair = []
	num_t = 1
	while num_t < tokens.size
		t = tokens[num_t]
		if t == "["
			(new_t, new_num_t) = parse(tokens[num_t..-1])
			pair << new_t
			num_t += new_num_t
		elsif t == "]"
			return [pair, num_t+1]
		else
			pair << t.to_i
			num_t += 1
		end
	end
end

def compare(left, right)
	if left.is_a? Integer and right.is_a? Integer
		return true if left < right
		return false if left > right
		return nil
	elsif left.is_a? Array and right.is_a? Array
		return true if left.empty? and not right.empty?
		return false if right.empty? and not left.empty?
		[left.size, right.size].max.times do |i|
			if i >= left.size and left.size != right.size
				return true
			elsif i >= right.size and left.size != right.size
				return false
			else
				value = compare(left[i], right[i])
				return value if value != nil
			end
		end
		return nil
	elsif left.is_a? Integer
		return compare([left], right)
	else # right.is_a? Integer
		return compare(left, [right])
	end
end

packets = STDIN.read.split("\n")
	.select { |line| line != "" }
	.concat(["[[2]]","[[6]]"])
	.map { |line| parse(line.scan(/\]|\[|\d+/))[0] }
	.sort { |a, b|
		value = compare(a, b)
		if value == nil
			0
		elsif value
			-1
		else
			1
		end
	}

p2 = -1
p6 = -1
packets.each_with_index do |p, i|
	p2 = i + 1 if p == [[2]]
	p6 = i + 1 if p == [[6]]
end

puts p2 * p6 # 27690
