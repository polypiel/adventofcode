RANGES = Array.new
ingredients = Array.new

read_ranages = true
STDIN.read.split("\n").each do |l|
	if l == ""
		read_ranages = false
	elsif read_ranages
		RANGES << l.split("-").map { |r| r.to_i }
	else
		ingredients << l.to_i
	end
end

def interset?(a0, a1, b0, b1)
	(b0 <= a1 && a0 <= b1) || (a0 <= b1 && b0 <= a1)
end

def merge?
	for i in 0..(RANGES.size - 1) do
		for j in (i + 1)..(RANGES.size - 1) do
			a0, a1 = RANGES[i]
			b0, b1 = RANGES[j]
			if interset?(a0, a1, b0, b1)
				RANGES.delete_at(j)
				RANGES.delete_at(i)
				RANGES << [[a0, b0].min, [a1, b1].max]
				return true
			end
		end
	end
	false
end

keep = true
while keep
	keep = merge?
end

puts RANGES.map { |r0, r1| r1 - r0 + 1 }.sum # 366181852921027