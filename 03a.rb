e = 0
num_bits = 12
ones = Array.new(num_bits) { 0 }
masks = Array.new(num_bits) { |i| 2**(num_bits - i - 1) }
gamma_mask = 0
num_bits.times {
   gamma_mask = (gamma_mask << 1) + 1
}

STDIN.read.split("\n").each do |a|
   measure = a.to_i(2)
   num_bits.times { |i|
      bit = (measure & masks[i]) == 0 ? -1 : 1
      ones[i] += bit
   }
end
num_bits.times do |i| 
   e = e << 1
   e += ones[i] > 0 ? 1 : 0
end
puts e * (~e & gamma_mask)
