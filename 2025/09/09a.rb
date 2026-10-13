POINTS = STDIN.read.split("\n").map { |l| l.split(",").map { |it| it.to_i } }

def dist(p1, p2)
	((p1[0] - p2[0]).abs + 1) * ((p1[1] - p2[1]).abs + 1)
end

max = 0
for i in (0..POINTS.size-1) do
	for j in (i+1..POINTS.size-1) do
		current = dist(POINTS[i], POINTS[j])
		max = current if current > max
	end
end

puts "#{max}" # 4786902990
