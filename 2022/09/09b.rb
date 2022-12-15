require 'set'

DIRS = {L: [-1, 0], U: [0, -1], R: [1, 0], D: [0, 1]}
SIZE = 10
HEAD = SIZE - 1
TAIL = 0

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

rope = Array.new(SIZE) { Pos.new(0, 0) }
tail_positions = Set.new
tail_positions << [0, 0]

STDIN.read.split("\n").each do |line|
	(dir, units) = line.split(" ")
	units.to_i.times do
		rope[HEAD] = rope[HEAD].move(DIRS[dir.to_sym][0], DIRS[dir.to_sym][1])
		(SIZE-2).downto(0) do |i|
			rope[i] = rope[i].follow(rope[i+1])
		end
		tail_positions << [rope[TAIL].x, rope[TAIL].y]
	end
end

puts tail_positions.size # 2604
