require 'set'

DIRS = {L: [-1, 0], U: [0, -1], R: [1, 0], D: [0, 1]}

Pos = Struct.new(:x, :y) do
	def to_s
		"#{x},#{y}"
	end

	def move(dx, dy)
		Pos.new(x + dx, y + dy)
	end

	def follow(head)
		dx = head.x - x
		dy = head.y - y
		if (dx == 0 and dy == 0) or (dx == 0 and dy.abs == 1) or (dx.abs == 1 and dy == 0) or (dx.abs == 1 and dy.abs == 1)
			self
		elsif dx == 0
			move(0, dy / dy.abs)
		elsif dy == 0
			move(dx / dx.abs, 0)
		else
			move(dx / dx.abs, dy / dy.abs)
		end
	end
end

head = Pos.new(0, 0)
tail = Pos.new(0, 0)
tail_positions = Set.new
tail_positions << [0, 0]

STDIN.read.split("\n").each do |line|
	(dir, units) = line.split(" ")
	units.to_i.times do
		head = head.move(DIRS[dir.to_sym][0], DIRS[dir.to_sym][1])
		tail = tail.follow(head)
		tail_positions << [tail.x, tail.y]
	end
end

puts tail_positions.size # 6464
