minx, miny, maxy, maxx = nil
paths = STDIN.read.split("\n").map { |line|
	line.split(" -> ").map { |point|
		p = point.split(",").map { |p| p.to_i}
		minx = p[0] if minx == nil || p[0] < minx
		miny = p[1] if miny == nil || p[1] < miny
		maxx = p[0] if maxx == nil || p[0] > maxx
		maxy = p[1] if maxy == nil || p[1] > maxy
		p
	}
}
HEIGHT = maxy + 3
WIDTH = 2*HEIGHT +  (maxx - minx + 1)
SAND_X = 500 - minx + HEIGHT
AIR = "."
ROCK = "#"
SAND = "o"

cave = Array.new(WIDTH * HEIGHT) { |i| i / WIDTH == HEIGHT-1 ? ROCK : "." }

paths.each do |multi_path|
	previous_x = nil
	previous_y = nil
	multi_path.each do |path|
		x = path[0] - minx + HEIGHT
		y = path[1]
		if x == previous_x
			[y, previous_y].min.upto([y, previous_y].max) { |y0| cave[y0 * WIDTH + x] = ROCK }
		elsif y == previous_y
			[x, previous_x].min.upto([x, previous_x].max) { |x0| cave[y * WIDTH + x0] = ROCK }
		end

		previous_x = x
		previous_y = y
	end
end

def print_cave(cave)
	cave.each_with_index do |c, i|
		print c
		puts if (i + 1) % WIDTH == 0
	end
end

def empty_y(cave, x, y)
	y.upto(HEIGHT - 1) do |y0|
		return y0-1 if cave[y0*WIDTH + x] != AIR
	end
	nil
end

def fall(cave, x, y)
	return nil if x == 0 or (cave[SAND_X] == SAND)

	y_fall = empty_y(cave, x, y)
	return nil if y_fall == nil

	down_left = cave[(y_fall+1)*WIDTH + x - 1]
	down_right = x < WIDTH - 1 ? cave[(y_fall+1)*WIDTH + x + 1] : nil

	if down_left != AIR and down_right != AIR and down_right != nil
		cave[y_fall*WIDTH+x] = SAND
		return true
	elsif down_left == AIR
		return fall(cave, x-1, y_fall+1)
	elsif down_right == AIR
		return fall(cave, x+1, y_fall+1)
	end
	false
end

sand = 0
loop do
	continue = fall(cave, SAND_X, 0)
	break if not continue
	sand += 1
end

# print_cave(cave)
puts sand # 30214
