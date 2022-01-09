window = Array.new(3, nil)
prev = nil
sum = 0
ARGF.readlines.each_with_index do |a, i|
   window[i % 3] = a.chomp.to_i
   if (i > 1)
      cur = window[0] + window[1] + window[2]
      sum += 1 if prev != nil && cur > prev
      prev = cur
   end
end
puts sum
