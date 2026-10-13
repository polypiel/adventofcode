POINTS = SPACE = STDIN.read.split("\n").map { |l| l.split(",").map { |it| it.to_i } }

NUMBERS = 1000


dists = Array.new(POINTS.size) { Array.new(POINTS.size) }

def dist(p1, p2)
	Math.sqrt((p1[0] - p2[0])**2 + (p1[1] - p2[1])**2 + (p1[2] - p2[2])**2)
end

for i in (0..POINTS.size-1) do
	for j in (i+1..POINTS.size-1) do
		dists[j][i] = dist(POINTS[i], POINTS[j])
	end
end

graphs = Hash.new
for i in (0..POINTS.size-1)
	graphs[i] = i
end

min = min_i = min_j = -1
g1 = g2 = nil
NUMBERS.times do
	min = -1
	min_i = -1
	min_j = -1
	# Find min
	for i in (0..POINTS.size-1) do
		for j in (i+1..POINTS.size-1) do
			dist = dists[j][i]
			if dist != -1 && (min == -1 || dist < min)
				min = dist
				min_i = i
				min_j = j
			end
		end
	end
	# Connect
	g1 = graphs[min_i]
	g2 = graphs[min_j]
	dists[min_j][min_i] = -1
	graphs = graphs.map { |k, v| [k, v == g2 ? g1 : v]  }.to_h
end

amounts = Hash.new { 0 }
graphs.each do |k, v|
	amounts[v] += 1
end
puts "#{amounts.map { |k, v| v }.sort.reverse[0..2].inject(:*)}" # 67488