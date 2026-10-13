POINTS = SPACE = STDIN.read.split("\n").map { |l| l.split(",").map { |it| it.to_i } }

dists = Array.new

def dist(p1, p2)
	Math.sqrt((p1[0] - p2[0])**2 + (p1[1] - p2[1])**2 + (p1[2] - p2[2])**2)
end

for i in (0..POINTS.size-1) do
	for j in (i+1..POINTS.size-1) do
		dists << [dist(POINTS[i], POINTS[j]), i, j]
	end
end
dists.sort_by! {|e| e[0] }

graphs = Hash.new
for i in (0..POINTS.size-1)
	graphs[i] = i
end

for i in (0..dists.size) do
	_, min_i, min_j = dists[i]
	g1 = graphs[min_i]
	g2 = graphs[min_j]
	graphs = graphs.map { |k, v| [k, v == g2 ? g1 : v]  }.to_h
	if Set.new(graphs.map { |k, v| v }).size == 1
		puts "#{POINTS[min_i][0]*POINTS[min_j][0]}" # 3767453340
		break
	end
end

raise "Not found"