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

lines = STDIN.read.split("\n")
i = 0
right = 0
loop do
	pair1 = parse(lines[i*3].scan(/\]|\[|\d+/))[0]
	pair2 = parse(lines[i*3+1].scan(/\]|\[|\d+/))[0]
	index = compare(pair1, pair2) ? i+1 : 0
	right += index
	i += 1
	break if i*3 >= lines.size
end

puts right # 5529
