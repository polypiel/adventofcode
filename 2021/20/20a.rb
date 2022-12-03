require 'set'

BLACK = "#"
TIMES = 2

$algorithm = Array.new(512)
ARGF.readline.chomp.chars.each_with_index do |c, i|
	$algorithm[i] = c == BLACK
end
#puts $algorithm.map { |c| c ? '#' : '.' }.j

ARGF.readline

image = Set.new
imageRaw = ARGF.readlines.map { |l| l.chomp.split("") }
w = imageRaw[0].size
h = imageRaw.size
puts "#{w}x#{h}"
imageRaw.each_with_index do |row, j|
	row.each_with_index do |c, i|
		if (c == BLACK)
			image << (j * h + i)
		end
	end
end

def draw(image, w, h)
	(w * h).times do |i|
		print "#{image.include?(i) ? '#' : '.'}"
		if ((i + 1) % w == 0)
			puts
		end
	end
	puts
end

#draw(image, w, h)
#puts image.size

def getNeighbours(i, j, w, h)
	[
		[-1, -1], [0, -1], [1, -1],
		[-1,  0], [0,  0], [1,  0],
		[-1,  1], [0,  1], [1,  1]
	]
	.map do |d|
		di = d[0] + i
		dj = d[1] + j
		(di >= 0 && di < w && dj >= 0 && dj < h) ? (h * dj + di) : nil
	end
end

def enhance(image, width, height, even)
	newWidth = width + 4
	newHeight = height + 4
	newImage = Set.new

	(newWidth * newHeight).times do |k|
		i = k % newHeight
		j = k / newHeight
		oldI = i - 2
		oldJ = j - 2
		number = getNeighbours(oldI, oldJ, width, height).map { |p|
			if (p == nil)
				even ? '0' : '1' # TODO
			else
				image.include?(p) ? '1' : '0'
			end
		}.join.to_i(2)

		# if (k == 16)
		# 	puts "#{oldI},#{oldJ}"
		# 	puts getNeighbours(oldI, oldJ, width, height).join(",")
		# end

		if($algorithm[number])
			newImage << k
		end
	end

	return newImage
end

dw = w
dh = h
TIMES.times do |i|
	image1 = enhance(image, dw, dh, i % 2 == 0)
	dw += 4
	dh += 4
	image = image1
end

#image2 = enhance(image, w, h)

#draw(image2, w + 2, h + 2)
#puts image2.size

#image3 = enhance(image2, w + 2, h + 2)
draw(image, dw, dh)
puts image.size
puts "#{dw},#{dh}"
