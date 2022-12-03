require 'set'

COMMON_BEACONS = 12

ROTATIONS = [
	[1, 0, 0, 0, 0, 0, -1, 0, 0, 1, 0, 0, 0, 0, 0, 1], 
	[0, -1, 0, 0, 1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1], 
	[0, 0, 1, 0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1], 
	[-1, 0, 0, 0, 0, -1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1], 
	[0, -1, 0, 0, 0, 0, -1, 0, 1, 0, 0, 0, 0, 0, 0, 1], 
	[0, 1, 0, 0, 0, 0, 1, 0, 1, 0, 0, 0, 0, 0, 0, 1], 
	[-1, 0, 0, 0, 0, 0, 1, 0, 0, 1, 0, 0, 0, 0, 0, 1], 
	[0, 1, 0, 0, -1, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1], 
	[-1, 0, 0, 0, 0, 0, -1, 0, 0, -1, 0, 0, 0, 0, 0, 1], 
	[0, 0, -1, 0, 1, 0, 0, 0, 0, -1, 0, 0, 0, 0, 0, 1], 
	[0, 0, -1, 0, -1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 1], 
	[1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1, 0, 0, 0, 0, 1], 
	[0, 1, 0, 0, 0, 0, -1, 0, -1, 0, 0, 0, 0, 0, 0, 1], 
	[0, -1, 0, 0, 0, 0, 1, 0, -1, 0, 0, 0, 0, 0, 0, 1], 
	[0, 0, -1, 0, 0, -1, 0, 0, -1, 0, 0, 0, 0, 0, 0, 1], 
	[0, 0, 1, 0, 0, -1, 0, 0, 1, 0, 0, 0, 0, 0, 0, 1], 
	[0, 0, -1, 0, 0, 1, 0, 0, 1, 0, 0, 0, 0, 0, 0, 1], 
	[0, 0, 1, 0, -1, 0, 0, 0, 0, -1, 0, 0, 0, 0, 0, 1], 
	[0, 0, 1, 0, 0, 1, 0, 0, -1, 0, 0, 0, 0, 0, 0, 1], 
	[0, -1, 0, 0, -1, 0, 0, 0, 0, 0, -1, 0, 0, 0, 0, 1], 
	[1, 0, 0, 0, 0, -1, 0, 0, 0, 0, -1, 0, 0, 0, 0, 1], 
	[0, 1, 0, 0, 1, 0, 0, 0, 0, 0, -1, 0, 0, 0, 0, 1], 
	[1, 0, 0, 0, 0, 0, 1, 0, 0, -1, 0, 0, 0, 0, 0, 1], 
	[-1, 0, 0, 0, 0, 1, 0, 0, 0, 0, -1, 0, 0, 0, 0, 1]
]

def vec3_x_mat4(v, m)
	[
		v[0] * m[0] + v[1] * m[1] + v[2] * m[2] + m[3],
		v[0] * m[4] + v[1] * m[5] + v[2] * m[6] + m[7],
		v[0] * m[8] + v[1] * m[9] + v[2] * m[10] + m[11]
	]
end

def translate_beacon(beacon, dx, dy, dz)
	vec3_x_mat4(beacon, [1, 0, 0, dx, 0, 1, 0, dy, 0, 0, 1, dz, 0, 0, 0, 1])
end

Scanner = Struct.new(:beacons, :center) do
	def to_s
		beacons.map { |c| c.to_s }.join("\n")
	end

	def rotateAll
		ROTATIONS.map { |r| Scanner.new(beacons.map { |c| vec3_x_mat4(c, r) }, [center[0], center[1], center[2]]) }
	end

	def translate(dx, dy, dz)
		Scanner.new(beacons.map { |c| translate_beacon(c, dx, dy, dz) }, [dx, dy, dz])
	end

	def findNextTo(otherScanner)
		rotateAll.each do |rs|
			rs.beacons.each_with_index do |c1, i|
				otherScanner.beacons.each_with_index do |c2, j|
					if (j > i)
						rst = rs.translate(c2[0] - c1[0], c2[1] - c1[1], c2[2] - c1[2])
						uniqueCoordinates = (rst.beacons + otherScanner.beacons).to_set
						if (rst.beacons.size + otherScanner.beacons.size - uniqueCoordinates.size >= COMMON_BEACONS)
							return rst
						end
					end
				end
			end
		end
		nil
	end

	def distance(otherScanner)
		(center[0] - otherScanner.center[0]).abs + (center[1] - otherScanner.center[1]).abs + (center[2] - otherScanner.center[2]).abs
	end
end

scanners = Array.new
scanner = nil
ARGF.readlines.each do |l|
	if (l.include? "scanner")
		if (scanner != nil)
			scanners << Scanner.new(scanner, [0, 0, 0])
		end
		scanner = Array.new
	elsif (l =~ /.+,.+,.+/)
		v = l.chomp.split(",").map { |c| c.to_i }
		scanner << v
	end
end
scanners << Scanner.new(scanner, [0, 0, 0])

scanner0 = scanners[0]
scannersSystem = [scanner0]

i = 0
while (!scanners.empty?)
	i = (i + 1) % scanners.size
	canditate = scanners[i]
	scannersSystem.each do |s1|
		rs = canditate.findNextTo(s1)
		if (rs != nil)
			scannersSystem << rs
			scanners.delete_at(i)
			break
		end
	end
end

uniqueCoordinates = Set.new
scannersSystem.each do |s|
	s.beacons.each do |c|
		uniqueCoordinates << c
	end
end
puts uniqueCoordinates.size

maxDistance = 0
scannersSystem.each_with_index do |s1, i|
	scannersSystem.each_with_index do |s2, j|
		if (j > i)
			distance = s1.distance(s2)
			maxDistance = distance if (distance > maxDistance)
		end
	end
end
puts maxDistance
