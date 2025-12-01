input = STDIN.read.split("\n").join()

re = /mul\((\d{1,3}),(\d{1,3})\)/

mul = 0

input.scan(re).to_a.each do |m|
	mul += m[0].to_i * m[1].to_i
end

puts mul # > 31863451
