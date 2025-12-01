list1 = []
map2 = Hash.new(0)

STDIN.read.split("\n").each do |a|
   nums = a.split(" ")
   list1 << nums[0].to_i

   map2[nums[1].to_i] += 1
end

puts list1.map { |n| n * map2[n] }.sum # 21070419