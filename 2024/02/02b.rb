def safe?(nums, deep = true)
	return true if safe_aux?(nums)
	(0..nums.size-1).each do |i|
		sub_nums = Array.new(nums)
		sub_nums.delete_at(i)
		return true if safe_aux?(sub_nums)
	end
	return false
end

def safe_aux?(nums)
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
