def safe?(nums)
	asc = false
	desc = false
	(1..nums.size-1).each do |i|
		diff = nums[i] - nums[i - 1]
		return false if diff == 0
		asc = true if diff < 0
		desc = true if diff > 0
		return false if diff.abs > 3
		return false if asc && desc
	end
	return true
end

num_safe = 0
STDIN.read.split("\n").each do |a|
# puts safe?(a.split(" ").map { |n| n.to_i })
   num_safe += 1 if safe?(a.split(" ").map { |n| n.to_i })
end

puts num_safe # 383