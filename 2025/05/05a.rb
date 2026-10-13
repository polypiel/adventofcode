ranges = Array.new
ingredients = Array.new

read_ranages = true
STDIN.read.split("\n").each do |l|
	if l == ""
		read_ranages = false
	elsif read_ranages
		ranges << l.split("-").map { |r| r.to_i }
	else
		ingredients << l.to_i
	end
end

fresh = 0
ingredients.each do |i|
	fresh += 1 if ranges.any? { |r| r[0] <= i && r[1] >= i }
end

puts fresh # 798
