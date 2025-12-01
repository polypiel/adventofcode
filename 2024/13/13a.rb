require 'set'

Problem = Struct.new(:a, :b, :prize) do
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
		p = [$1.to_i, $2.to_i]
		GAMES << Problem.new(a, b, p)
	end
end

#puts "#{GAMES}"

def solve(g)
	limx, limy = g.prize
	visited = Set.new
	pending = [State.new([0, 0], 0)]
	sol = 0
	while pending.size > 0
		current = pending.pop
		cx, cy = current.pos
		visited << current.pos
		if (current.pos == g.prize)
			sol = current.tokens if sol == 0 || sol >= current.tokens
		else
			[
				State.new([cx + g.a[0], cy + g.a[1]], current.tokens + 3),
				State.new([cx + g.b[0], cy + g.b[1]], current.tokens + 1),
			]
			.filter { |state| state.pos[0] <= limx && state.pos[1] <= limy && !visited.include?(state.pos) }
			.each { |n| pending << n }
		end
	end
	#puts "#{g} => #{sol}"
	sol
end

res = GAMES.map { |g| solve(g) }.sum
puts res
