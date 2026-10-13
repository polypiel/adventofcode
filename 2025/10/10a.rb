Problem = Struct.new(:target, :buttons)
problems = Array.new

STDIN.read.split("\n").each do |l|
	parts = l.split(" ")


	if /\[([\.#]+)\]/ =~ parts.shift
		target_size = $1.size
		target = $1.gsub(/\./, "0").gsub(/#/, "1").to_i(2)
	else
		raise "Invalid input"
	end
	parts.pop

	buttons = parts.map { |it| it[1..-2].split(",")
		.map { |it| 2**(target_size-it.to_i-1) }.sum }
	problems << Problem.new(target, buttons)
end

puts "#{problems}"

def min_moves(problem)
	min_moves = -1
	state = Hash.new
	to_watch = [[0, 0]]
	while to_watch.size > 0
		current, moves = to_watch.pop
		problem.buttons.each do |b|
			candidate = current ^ b
			if candidate == problem.target
				min_moves = (moves + 1) if min_moves == -1 || (moves + 1) < min_moves
			else
				if !state.include?(candidate) || (moves + 1) < state[candidate]
					state[candidate] = moves + 1
					to_watch << [candidate, moves + 1]
				end
			end
		end
	end
	raise "Problem not solved" if min_moves == -1
	min_moves
end

puts problems.map { |p| min_moves(p) }.sum # 401

