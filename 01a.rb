prev = nil
sum = 0
STDIN.read.split("\n").each do |a|
   cur = a.to_i
   sum += prev != nil && cur > prev ? 1 : 0
   prev = cur
end
puts sum
