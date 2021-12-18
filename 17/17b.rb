require 'set'

CENTER = 0
LEFT = -1
RIGHT = -2

if (/target area: x=(-?\d+)..(-?\d+), y=(-?\d+)..(-?\d+)/ =~ ARGF.readline)
	$tx0 = $1.to_i
	$tx1 = $2.to_i
	$ty0 = $3.to_i
	$ty1 = $4.to_i
end

puts "Field: #{$tx0}..#{$tx1} #{$ty0}..#{$ty1}"

$cachex = Hash.new
$cachey = Hash.new
$potentialDx = Set.new

def calcX(dt, k)
	cacheKey = "#{dt}%#{k}"
	if ($cachex.has_key? cacheKey)
		return $cachex[cacheKey]
	end
	if (dt == 0)
		0
	elsif (dt == 1)
		k
	elsif (dt <= k)
		res = k + 1 - dt + calcX(dt - 1, k)
		$cachex[cacheKey] = res
		res
	else
		calcX(k, k)
	end
end

def calcY(dt, k)
	cacheKey = "#{dt}%#{k}"
	if ($cachex.has_key? cacheKey)
		return $cachex[cacheKey]
	end
	if (dt == 0 || dt == 2 * k + 1)
		0
	elsif (dt == 1)
		k
	elsif (dt <= k)
		res = k + 1 - dt + calcX(dt - 1, k)
		$cachex[cacheKey] = res
		res
	elsif (dt <= 2 * k + 1)
		calcY(2 * k - dt + 1, k)
	else
		calcY(dt - 1, k) - dt + 2*k - 2
	end
end

(1..$tx1).each do |dx|
	i = 1
	lastX = nil
	loop do
		x = calcX(i, dx)
		if (lastX == x)
			break
		end
		if (x >= $tx0 && x <= $tx1)
			$potentialDx << dx
		elsif (x > $tx1)
			break
		end
		i += 1
		lastX = x
	end
end

puts "#{$potentialDx}"

def launch(dir)
	pos = [0, 0]
	loop do
		pos[0] += dir[0]
		pos[1] += dir[1]

		if (dir[0] > 0)
			dir[0] -= 1
		elsif (dir[0] < 0)
			dir[0] += 1
		end
		dir[1] -= 1

		if (pos[0] >= $tx0 && pos[0] <= $tx1 && pos[1] <= $ty1 && pos[1] >= $ty0)
			return CENTER
		elsif (pos[0] > $tx1)
			return RIGHT
		elsif (pos[1] < $ty0)
			return LEFT
		end
	end
end

def maxy(n)
	if (n < 0)
		n
	else
		(n*n + n) / 2
	end
end

#(0..10).each do |i|
#	puts "#{i} -> #{calcX(i, 6)}"
#end

centers = 0
$potentialDx.each do |dx|
	(-2000..2000).each do |dy|
		res = launch([dx, dy])
		if (res == CENTER)
			centers += 1
		elsif (res == RIGHT)
			break
		end
	end
end

puts centers
