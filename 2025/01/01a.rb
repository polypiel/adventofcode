DIAL = 100
START = 50

rotations = Array.new
STDIN.read.split("\n").each do |r|
	if (/(L|R)(\d+)/ =~ r)
		if ($1 == "L")
			rotations << $2.to_i
		else 
			rotations << (-1 * $2.to_i)
		end
	end
end

pos = START
num_zeros = 0
rotations.each { |r|
	pos = (pos + r) % DIAL
	num_zeros += 1 if pos == 0
}

# 1034
puts num_zeros