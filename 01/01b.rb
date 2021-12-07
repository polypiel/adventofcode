window = [nil, nil, nil]
prev = nil
sum = 0
STDIN.read.split("\n").each_with_index do |a, i|
   window[i % 3] = a.to_i
   if (i > 1)
      cur = window[0] + window[1] + window[2]
      sum += prev != nil && cur > prev ? 1 : 0
      prev = cur
   end
end
puts sum
