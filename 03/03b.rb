$num_bits = 12
$masks = Array.new($num_bits) { |i| 2**($num_bits - i - 1) }

def check(measures, mul = 1)
   ones = Array.new($num_bits) { 0 }
   $num_bits.times do |i|
      ones = 0
      measures.each do |m|
         ones += mul * ((m & $masks[i]) == 0 ? 1 : -1)
      end
      if (ones >= 0)
         measures = measures.select { |m| (m & $masks[i]) != 0 }
      else
         measures = measures.select { |m| (m & $masks[i]) == 0 }
      end
      if (measures.size == 1)
         return measures[0]
      end
   end
end

measures = STDIN.read.split("\n").map { |m| m.to_i(2) }

e = check(measures, 1)
g = check(measures, -1)

puts e * g

