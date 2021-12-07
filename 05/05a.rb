$matrix = Hash.new

def key(x, y)
	"#{x}-#{y}"
end

def add(x, y)
	key = key(x, y)
	$matrix[key] = $matrix.has_key?(key) ? $matrix[key] + 1 : 1
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
	end
end

puts $matrix.select { |k, v| v > 1 }.size
