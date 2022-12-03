require 'set'

LIMIT = 50

input = Array.new
ARGF.readlines.each do |l|
	if (l.chomp =~ /(on|off) x=(-?\d+)\.\.(-?\d+),y=(-?\d+)\.\.(-?\d+),z=(-?\d+)\.\.(-?\d+)/)
		input << [$1 == "on", $2.to_i, $3.to_i, $4.to_i, $5.to_i, $6.to_i, $7.to_i]
	end
end

#puts "#{input}"

points = Set.new

input.each do |e|
	on, x0, x1, y0, y1, z0, z1 = e
	if (x0 > LIMIT || y0 > LIMIT || z0 > LIMIT || x1 < -LIMIT || y1 < -LIMIT || z1 < -LIMIT)
		next
	end
	(x0..x1).each do |x|
		(y0..y1).each do |y|
			(z0..z1).each do |z|
				if (on)
					points << [x, y, z]
				else
					points.delete([x, y, z])
				end
			end
		end
	end
end

puts points.size
