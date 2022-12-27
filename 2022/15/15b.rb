require 'set'

#ROW_Y = 10 # 2_000_000
MAX = 4_000_000

Sensor = Struct.new(:x, :y, :dist) do
	def to_s
		"#{x},#{y} - #{dist}"
	end
end

def dist(x0, y0, x1, y1)
	(x1 - x0).abs + (y1 - y0).abs
end

sensors = []
beacons = []

minx, miny, maxx, maxy = nil
STDIN.read.split("\n").map do |line|
	if /Sensor at x=([\d-]+), y=([\d-]+): closest beacon is at x=([\d-]+), y=([\d-]+)/ =~ line
		sensors << Sensor.new($1.to_i, $2.to_i, dist($1.to_i, $2.to_i, $3.to_i, $4.to_i))
		beacons << [$3.to_i, $4.to_i]
	end
end
beacons.uniq!

#puts "#{sensors}"

(sensors + beacons).each do |p|
	minx = p[0] if minx == nil or p[0] < minx
	miny = p[1] if miny == nil or p[1] < miny
	maxx = p[0] if maxx == nil or p[0] > maxx
	maxy = p[1] if maxy == nil or p[1] > maxy
end

#puts "#{minx},#{miny} - #{maxx},#{maxy}"

def calc_range(row_y, sensors)
	ranges = Array.new
	sensors.each do |s|
		y_dist = (s.y - row_y).abs
		x_dist = s.dist - y_dist
		if  y_dist <= s.dist
			ranges << [s.x - x_dist, s.x + x_dist]
		end
	end
	ranges.sort! { |r1, r2| r1[0] <=> r2[0] }
	#puts "#{ranges}" if row_y == 11
	loop do
		change = false
		(ranges.size - 1).times do |i|
			range1 = ranges[i]
			range2 = ranges[i + 1]
			if range1[1] >= range2[0]
				#puts "#{range1} and #{range2} interlaps" if row_y == 11
				ranges[i][0] = [range1[0], range2[0]].min 
				ranges[i][1] = [range1[1], range2[1]].max
				ranges.delete_at(i + 1)
				change = true
				#puts "#{ranges}" if row_y == 11
				break
			end
		end
		break if not change
	end
	return ranges
end
#puts "#{ranges}"
#puts ranges.map { |r| r[1] - r[0] + 1}.sum
#sensors_in_range = 0
#beacons.each do |b|
#	sensors_in_range += 1 if b[1] == ROW_Y and ranges.any? { |r| b[0] >= r[0] and b[0] <= r[1] }
#end

allx = Set.new(0..MAX)
0.upto(MAX) do |y|
	ranges = calc_range(y, sensors)
	busy = ranges.map { |r| [r[1], MAX].min - [r[0], 0].max + 1}.sum
	if busy == MAX
		ranges.each { |r| r[0].upto(r[1]) { |n| allx.delete n } }
		x = allx.to_a[0]
		puts "#{x},#{y}: #{x*4_000_000+y}" # 11558423398893
		exit
	end
end
raise "No solution found"
