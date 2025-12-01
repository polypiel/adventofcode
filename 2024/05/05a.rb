RULES = Hash.new { |h, k| h[k] = Set.new }
number = 0

def check?(line)
	(0..line.size - 1).each do |i|
		(i..line.size - 1).each do |j|
			return false if RULES[line[i]].include?(line[j])
		end
	end
	return true
end

STATION = STDIN.read.split("\n").each do |l|
	if l.include?("|")
		a, b = l.split("|").map { |n| n.to_i }
		RULES[b] << a
	elsif l.include?(",")
		line = l.split(",").map { |n| n.to_i }
		number += line[line.size / 2] if check?(line)
	end
end

puts "#{number}" # 143
