# A rock, B paper, C scissors
# X lose, Y draw, Z win
# 1     , 2      , 3
# 0, 3, 6

SEL_POINTS = {
	A: {X: 3, Y: 1, Z: 2},
	B: {X: 1, Y: 2, Z: 3},
	C: {X: 2, Y: 3, Z: 1}
}
MATCH_POINTS = {X: 0, Y: 3, Z: 6}

total = 0
STDIN.read.split("\n").each do |line|
  p1, p2 = line.split(" ")
  total += MATCH_POINTS[p2.to_sym]
  total += SEL_POINTS[p1.to_sym][p2.to_sym]
end

puts total
