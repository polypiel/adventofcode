# A rock, B paper, C scissors
# X rock, Y paper, Z scissors
# 1     , 2      , 3
# 0, 3, 6

MATCH_POINTS = {
	A: {X: 3, Y: 6, Z: 0},
	B: {X: 0, Y: 3, Z: 6},
	C: {X: 6, Y: 0, Z: 3}
}
SEL_POINTS = {X: 1, Y: 2, Z: 3}

total = 0
STDIN.read.split("\n").each do |line|
  p1, p2 = line.split(" ")
  total += MATCH_POINTS[p1.to_sym][p2.to_sym]
  total += SEL_POINTS[p2.to_sym]
end

puts total
