EMPTY = -1
A = 0
B = 1
C = 2
D = 3
SOL = [A, A, B, B, C, C, D, D]
MUL = [1, 10, 100, 1000]

ROOMS = 4
ROOM_SIZE = 2
HALLWAYS = 11

OUTWARDS = 0
INWARDS = 1
DIRECT = 2

$better = nil
$cache = Hash.new

hallway = Array.new(11, EMPTY)
rooms = Array.new(8, EMPTY)

#rooms = [A, B, D, C, C, B, A, D] # input test
rooms = [B, C, C, B, D, A, A, D] # input

def distance(r, h, type)
	hx = h
	hy = 2
	rx = (r / 2) * 2 + 2
	ry = r % ROOM_SIZE
	return ((rx - hx).abs + (ry - hy).abs) * MUL[type]
end

# [type, room, hallway/room]
def fetchMovements(rooms, hallway)
	movements = []
	# Direct
	ROOMS.times do |r|
		ri = 2 * r
		if (rooms[ri] != EMPTY && rooms[ri + 1] != EMPTY && rooms[ri + 1] != r)
			ri += 1
		elsif (rooms[ri] != EMPTY && rooms[ri] != r && rooms[ri + 1] == EMPTY)
			ri += 0
		else
			next
		end
		dr = rooms[ri] * 2
		if (rooms[dr] == EMPTY && rooms[dr + 1] == EMPTY)
			dr += 0
		elsif (rooms[dr] == rooms[ri] && rooms[dr + 1] == EMPTY)
			dr += 1
		else
			next
		end

		rix = 2 * r + 2
		drx = rooms[ri] * 2 + 2
		min = [rix,drx].min
		max = [rix,drx].max
		free = (min..max).to_a.all? { |i| hallway[i] == EMPTY }
		if (free)
			movements << [DIRECT, ri, dr]
		end
	end

	# Inwards
	HALLWAYS.times do |h|
		if (hallway[h] != EMPTY)
			r = hallway[h]
			ri = 2 * r
			if (rooms[ri] == EMPTY || (rooms[ri + 1] == EMPTY && rooms[ri] == r))
				ri += 1 if (rooms[ri] != EMPTY)
				rix = r * 2 + 2
				if (h < rix)
					free = (h+1..rix).to_a.all? { |j| hallway[j] == EMPTY }
				else
					free = (rix..h-1).to_a.all? { |j| hallway[j] == EMPTY }
				end
				if (free)
					movements << [INWARDS, ri, h] 
				end
			end
		end
	end

	# Outwards
	ROOMS.times do |r|
		ri = 2 * r
		if (rooms[ri + 1] != EMPTY && (rooms[ri + 1] != r || rooms[ri] != r))
			ri += 1
		elsif (rooms[ri] != EMPTY && rooms[ri] != r)
			ri += 0
		else
			next
		end
		hi = r * 2 + 2
		(hi..10).each do |i|
			break if hallway[i] != EMPTY
			if (i != 2 && i != 4 && i != 6 && i != 8)
				movements << [OUTWARDS, ri, i]
			end
		end
		hi.downto(0) do |i|
			break if hallway[i] != EMPTY
			if (i != 2 && i != 4 && i != 6 && i != 8)
				movements << [OUTWARDS, ri, i]
			end
		end
	end
	return movements
end

def amphipods(rooms, hallway, energy = 0)
	if (rooms == SOL)
		$better = energy if ($better == nil || energy < $better)
		return
	elsif ($better != nil && energy >= $better)
		return
	end
	key = "#{rooms.join}_#{hallway.join}"
	if ($cache.include? key)
		if ($cache[key] <= energy)
			return
		else
			$cache[key] = energy
		end
	else
		$cache[key] = energy
	end

	m = fetchMovements(rooms, hallway)
	m.each do |dest, ri, hi|
		r = rooms.dup
		h = hallway.dup
		if (dest == INWARDS)
			r[ri] = hallway[hi]
			h[hi] = EMPTY
		elsif (dest == OUTWARDS)
			h[hi] = rooms[ri]
			r[ri] = EMPTY
		else # DIRECT
			h[hi] = r[ri]
			r[ri] = EMPTY
		end
		letter = (dest == INWARDS) ? hallway[hi] : rooms[ri]
		d = distance(ri, hi, letter)
		amphipods(r, h, energy + d)
	end
end

def ppCase(c)
	if (c == EMPTY)
		"."
	else
		["A", "B", "C", "D"][c]
	end
end

def ppState(rooms, hallway)
	hallway.each { |h| print ppCase h }
	puts
	print "  "
	(ROOM_SIZE-1).downto(0) do |j|
		rooms.each_with_index do |r, i| 
			print "#{ppCase(r)} " if (i % ROOM_SIZE == j) 
		end
		puts
	end
	puts
end

def ppMovement(m)
	p0 = (m[0] == INWARDS) ? m[2] : m[1]
	p1 = (m[0] == INWARDS) ? m[1] : m[2]
	if (m[0] == OUTWARDS)
		dir = "outgoing"
	elsif (m[0] == INWARDS)
		dir = "incoming"
	else
		dir = "direct"
	end
	puts "#{dir}: #{p0} -> #{p1}"
end

amphipods(rooms, hallway)
puts $better

#fetchMovements(rooms, hallway).each { |mi| ppMovement(mi) }
