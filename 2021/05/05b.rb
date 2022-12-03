$matrix = Hash.new(0)

def add(x, y)
	$matrix["#{x}-#{y}"] += 1
end

ARGF.readlines.each do |line|
	vector = line.chomp.sub!(" -> ", ",").split(",").map { |d| d.to_i }

	if (vector[0] == vector[2])
		((vector[3] - vector[1]).abs + 1).times do |dy|
			y0 = vector[1] + (vector[3] > vector[1] ? dy : -dy)
			add(vector[0], y0)
		end
	elsif (vector[1] == vector[3])
		((vector[2] - vector[0]).abs + 1).times do |dx|
			x0 = vector[0] + (vector[2] > vector[0] ? dx : -dx)
			add(x0, vector[1])
		end
	else
		((vector[3] - vector[1]).abs + 1).times do |d|
			x0 = vector[0] + (vector[2] > vector[0] ? d : -d)
			y0 = vector[1] + (vector[3] > vector[1] ? d : -d)
			add(x0, y0)
		end
	end
end

puts $matrix.select { |k, v| v > 1 }.size
