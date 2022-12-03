EMPTY = -1
A = 0
B = 1
C = 2
D = 3
SOL = [A, A, A, A, B, B, B, B, C, C, C, C, D, D, D, D]
MUL = [1, 10, 100, 1000]

ROOMS = 4
ROOM_SIZE = 4
HALLWAYS = 11

OUTWARDS = 0
INWARDS = 1
DIRECT = 2

$better = nil
$cache = Hash.new

hallway = Array.new(HALLWAYS, EMPTY)
rooms = Array.new(ROOMS * ROOM_SIZE, EMPTY)

#rooms = [A, D, D, B, D, B, C, C, C, A, B, B, A, C, A, D] # input test b
rooms = [B, D, D, C, C, B, C, B, D, A, B, A, A, C, A, D] # input b

def distance(r, h, type)
	hx = h
	hy = ROOM_SIZE
	rx = (r / ROOM_SIZE) * 2 + 2
	ry = r % ROOM_SIZE
	return ((rx - hx).abs + (ry - hy).abs) * MUL[type]
end

def tipNoR(rooms, r)
	tip = nil
	rs = 0
	(r * ROOM_SIZE + ROOM_SIZE - 1).downto(r * ROOM_SIZE) do |rj|
		if (rooms[rj] == EMPTY)
			next
		elsif (tip == nil)
			if (rooms[rj] != r)
				return rj
			else
				tip = rj
			end
		elsif (rooms[rj] != r)
			rs += 1
		end
	end
	tip && rs > 0 ? tip : nil
end

def firstEmptyR(rooms, r)
	tip = nil
	(r * ROOM_SIZE + ROOM_SIZE - 1).downto(r * ROOM_SIZE) do |rj|
		if (rooms[rj] == EMPTY)
			next
		elsif (rooms[rj] == r && tip == nil)
			tip = rj + 1
		elsif (rooms[rj] != r)
			return nil
		end
	end
	tip != nil ? tip : r * ROOM_SIZE
end

# [type, room, hallway/room]
def fetchMovements(rooms, hallway)
	movements = []
	# Direct
	ROOMS.times do |r|
		ri = tipNoR(rooms, r)
		next if ri == nil
		targetRoom = firstEmptyR(rooms, rooms[ri])
		next if targetRoom == nil
		rix = r * 2 + 2
		drx = rooms[ri] * 2 + 2
		min = [rix,drx].min
		max = [rix,drx].max
		free = (min..max).to_a.all? { |i| hallway[i] == EMPTY }
		if (free)
			movements << [DIRECT, ri, targetRoom]
		end
	end

	# Inwards
	HALLWAYS.times do |h|
		if (hallway[h] != EMPTY)
			r = hallway[h]
			ri = firstEmptyR(rooms, r)
			next if ri == nil
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

	# Outwards
	ROOMS.times do |r|
		ri = tipNoR(rooms, r)
		next if ri == nil
		hi = r * 2 + 2
		(hi..HALLWAYS-1).each do |i|
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
	(ROOM_SIZE-1).downto(0) do |j|
		print "  "
		rooms.each_with_index do |r, i| 
			print "#{ppCase(r)} " if (i % ROOM_SIZE == j) 
		end
		puts
	end
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
puts "Best: #{$better}"
