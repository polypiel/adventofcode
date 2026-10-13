DIAL = 100

rotations = Array.new
STDIN.read.split("\n").each do |r|
	if (/(L|R)(\d+)/ =~ r)
		if ($1 == "R")
			rotations << $2.to_i
		else 
			rotations << (-1 * $2.to_i)
		end
	end
end

pos = 50
num_zeros = 0
rotations.each { |r|
	if pos == 0
		first_tick = DIAL
	elsif r > 0
		first_tick = DIAL - pos
	else
		first_tick = pos
	end
	rest_ticks = (r.abs - first_tick) / DIAL


	num_zeros += 1 if r.abs >= first_tick
	num_zeros += rest_ticks if r.abs >= first_tick

	pos = (pos + r) % DIAL
}

# 6166
puts num_zeros
