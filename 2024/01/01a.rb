list1 = []
list2 = []

STDIN.read.split("\n").each do |a|
   nums = a.split(" ")
   list1 << nums[0].to_i
   list2 << nums[1].to_i
end

list1.sort!
list2.sort!

dist = 0
list1.size.times do |i|
	dist += (list1[i] - list2[i]).abs
end

puts dist