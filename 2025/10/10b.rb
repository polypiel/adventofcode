Problem = Struct.new(:target, :buttons) do
	def dist(pos)
		target.zip(pos).map { |a| a.inject(:-) }.map { |it| it.abs }.sum
	end

	def valid?(pos)
		target.zip(pos).all? {|t, p| p <= t }
	end
end
problems = Array.new

STDIN.read.split("\n").each do |l|
	parts = l.split(" ")

	# Ignore lights
	parts.shift

	target = parts.pop[1..-2].split(",").map { |it| it.to_i }
	target_size = target.size

	buttons = parts.map { |it| it[1..-2].split(",").map { |it| it.to_i } }
		.map { |arr| Array.new(target_size) { |i| arr.include?(i) ? 1 : 0 } }
	problems << Problem.new(target, buttons)
end

def min_moves(problem)
	iters = 0
	puts "Problem #{problem.target}"
	min_moves = -1
	state = Hash.new
	to_watch = [[Array.new(problem.target.size) {0}, 0, ]]
	while to_watch.size > 0
		current, moves = to_watch.pop
		if min_moves == -1 || moves < min_moves
			problem.buttons.each do |b|
				candidate = current.zip(b).map { |a| a.inject(:+) }
				if candidate == problem.target
					min_moves = (moves + 1) if min_moves == -1 || (moves + 1) < min_moves
				else
					if (!state.include?(candidate) || (moves + 1) < state[candidate]) && problem.valid?(candidate)
						state[candidate] = moves + 1
						to_watch << [candidate, moves + 1, problem.dist(candidate)]
					end
				end
			end
		end
		to_watch.sort! { |a, b| a[2] != b[2] ? b[2] <=> a[2] : b[1] <=> a[1] }
		iters +=1
	end
	puts "Sol #{min_moves}"
	min_moves
end

puts problems.map { |p| min_moves(p) }.sum # 401

