require 'set'

SHIFT = 10000000000000

Problem = Struct.new(:a, :b, :prize) do
	def sol(na, nb)
		da = a[0] * na + b[0] * nb - prize[0] 
		db = a[1] * na + b[1] * nb - prize[1]
		if da == 0 && db == 0
			return 0
		elsif da > 0 || db > 0
			return 1
		else
			return -1
		end
	end

	def to_s
		"#{a},#{b},#{prize}"
	end
end

State = Struct.new(:pos, :tokens)

GAMES = []
a = nil
b = nil
STDIN.read.split("\n").each do |line|
	if /Button A: X\+(\d+), Y\+(\d+)/ =~ line
		a = [$1.to_i, $2.to_i]
	elsif /Button B: X\+(\d+), Y\+(\d+)/ =~ line
		b = [$1.to_i, $2.to_i]
	elsif /Prize: X=(\d+), Y=(\d+)/ =~ line
		p = [$1.to_i + SHIFT, $2.to_i + SHIFT]
		GAMES << Problem.new(a, b, p)
	end
end

#puts "#{GAMES}"

def solve(g)
	max_b = [
		g.prize[0] / g.b[0],
		g.prize[1] / g.b[1]
	].max

	while max_b > 0 do
		max_a = [
			(g.prize[0] - g.b[0] * max_b) / g.a[0],
			(g.prize[1] - g.b[1] * max_b) / g.a[1],
		].max
		solete = g.sol(max_a, max_b)
		if solete == 0
			return max_a * 3 + max_b
		end
		max_b -= 1
	end
	0
end

res = GAMES.map { |g| solve(g) }.sum
#.each { |g| puts g }.sum
puts res # 4171272677804 low
