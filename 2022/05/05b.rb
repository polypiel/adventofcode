stacks = Hash.new { Array.new }
STDIN.read.split("\n").each do |line|
	if line.include? "["
		for i in 0..(line.size/4)
			crate = line[i*4 + 1]
			stacks[i] = [crate] + stacks[i] if (crate != " ")
		end
	elsif /move (\d+) from (\d+) to (\d+)/ =~ line
		num = $1.to_i
		from = $2.to_i - 1
		to = $3.to_i - 1
		stacks[to].push(stacks[from].pop(num)).flatten!
	end
end
message = stacks.keys.sort.map { |i| stacks[i][-1] }.join
puts message # CJVLJQPHS
