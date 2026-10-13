start = nil
divisors = Set.new

width = 0
height = 0

STDIN.read.split("\n").each_with_index do |l, i|
	if (i % 2 == 0)
		i2 = i / 2
		l.chars.each_with_index do |c, j|
			if c == "S"
				start = [j, i2]
			elsif c == "^"
				divisors << [j, i2]
				height = i2 + 1 if i2 + 1 > height
			end
		end
	end
	width = i
end

flood = Array.new (height) { |arr| Array.new(width) { 0 } }
flood[start[1]][start[0]] = 1

for j in 1..height-1 do
	for i in 0..width-1 do
		if !divisors.include?([i,j])
			val = flood[j-1][i]
			val += flood[j-1][i-1] if i-1 >= 0 && divisors.include?([i-1,j])
			val += flood[j-1][i+1] if i+1 < width && divisors.include?([i+1,j])
			flood[j][i] = val
		end
	end
end

puts "#{flood[height-1].sum}" # 47274292756692
