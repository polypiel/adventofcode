NUM_ROCKS = 1000000000000
ROCKS = [
	[12, 13, 14, 15], # -
	[5, 8, 9, 10, 13], # +
	[6, 10, 12, 13, 14], # _|
	[0, 4, 8, 12], # |
	[8, 9, 12, 13] # o
]

WIDTH = 7
HEIGHT = 3 * NUM_ROCKS
SIZE = WIDTH * HEIGHT
#puts "#{WIDTH}*#{HEIGHT}=#{SIZE}"

CHAMBER = Array.new(SIZE) { "." }

FLOW = STDIN.read.split("").map do |w| 
	if w == "<"
		-1
	elsif w == ">"
		1
	else
		raise "Unexpected wind: #{w}"
	end
end

INITIAL_X = 2
initial_y = HEIGHT

def print_p(proyection, title = nil)
	puts title if title != nil
	(0).upto(SIZE-1) do |i|
		if proyection.any? { |p|  p[0] == (i % WIDTH) and p[1] == (i / WIDTH) }
			print "@"
		else
			print CHAMBER[i]
		end
		puts "" if (i + 1) % WIDTH == 0
	end
	puts ""
end

w = 0
NUM_ROCKS.times do |i|
	rock = ROCKS[i % ROCKS.size]

	proyection = rock.map do |p|
		local_x = (p % 4) + INITIAL_X
		local_y = (p / 4) + initial_y - 7
		[local_x, local_y]
	end
	#print_p(proyection, "New blow")

	loop do

		# Apply wind
		wind = FLOW[w % FLOW.size]
		w += 1
		if wind == 1 and proyection.none? { |p| p[0] == WIDTH - 1 or CHAMBER[p[1]*WIDTH + p[0] + 1] == "#" }
			proyection.each do |p|
				p[0] += 1
			end
		elsif wind == -1 and proyection.none? { |p| p[0] == 0 or CHAMBER[p[1]*WIDTH + p[0] - 1] == "#" }
			proyection.each do |p|
				p[0] -= 1
			end
		end
		#print_p(proyection, "Wind #{wind}")

		# check collision
		collision = proyection.each.any? { |p| 
			p0 = (p[1] + 1) * WIDTH + p[0]
			p[1] == HEIGHT - 1 or CHAMBER[p0] == "#"
		}
		if collision
			proyection.each do |p|
				CHAMBER[p[1] * WIDTH + p[0]] = "#"
				initial_y = p[1] if p[1] < initial_y
			end
			break
		end

		# Fall
		proyection.each do |p|
			p[1] += 1
		end
		#print_p(proyection, "Fall")
	end
end

# print_p([], "Final")
puts "#{HEIGHT - initial_y}" # 3151
