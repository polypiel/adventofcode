require 'set'

points = Set.new
folds = []
ARGF.readlines.each do |l|
	if (/(\d+),(\d+)/ =~ l)
		points << [$1.to_i, $2.to_i]
	elsif (/fold along (y|x)=(\d+)/ =~ l)
		folds << [$1 == "x", $2.to_i]
	end
end

def pp(points)
	w = points.max { |a, b| a[0] <=> b[0] }[0] + 1
	h = points.max { |a, b| a[1] <=> b[1] }[1] + 1
	h.times do |i|
		w.times do |j|
			print "#{points.include?([j, i]) ? '#' : '.'}"
		end
		puts ""
	end
end

folds.each do |x, b|
	newPoints = Set.new
	if (x)
		# x fold
		points.each do |p|
			if (p[0] < b)
				newPoints << [p[0], p[1]]
			else
				newPoints << [2 * b - p[0], p[1]]
			end
		end
	else
		# y fold
		points.each do |p|
			if (p[1] < b)
				newPoints << [p[0], p[1]]
			else
				newPoints << [p[0], 2 * b - p[1]]
			end
		end
	end
	points = newPoints
end

pp(points)
