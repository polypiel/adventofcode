map = Array.new
STDIN.read.split("\n").each do |line|
	map << line.chars.map { |c| c.to_i }
end
HEIGHT = map.size
WIDTH = map[0].size

visibleCount = 2 * (HEIGHT - 2) +  2 * (WIDTH - 2) + 4

for j in 1..HEIGHT - 2
	for i in 1..WIDTH - 2
		left = (i-1).downto(0).none? { |ci| map[j][ci] >= map[j][i] }
		right = (i+1).upto(WIDTH-1).none? { |ci| map[j][ci] >= map[j][i] }
		up = (j-1).downto(0).none? { |cj| map[cj][i] >= map[j][i] }
		down = (j+1).upto(HEIGHT-1).none? { |cj| map[cj][i] >= map[j][i] }

		visibleCount += 1 if left or right or up or down
	end
end
puts visibleCount # 1693
