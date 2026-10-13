min_x = -1
min_y = -1
raw_points = STDIN.read.split("\n").map do |l| 
	x, y = l.split(",").map { |it| it.to_i }
	min_x = x if min_x == -1 || x < min_x
	min_y = y if min_y == -1 || y < min_y
	[x, y]
end
puts "#{min_x},#{min_y}"
POINTS = raw_points.map { |x,y| [x - min_x, y - min_y] }
puts "#{POINTS}"

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
