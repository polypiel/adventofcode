input = STDIN.read.split("\n").join()

re = /mul\((\d{1,3}),(\d{1,3})\)|do(n't)?\(\)/

mul = 0

enabled = true
input.scan(re).to_a.each do |m|
	# puts "#{m}"
	if m[0] != nil && m[1] != nil
		mul += m[0].to_i * m[1].to_i if enabled
	else
		enabled = m[2] != "n't"
	end
end

puts mul # > 31863451
