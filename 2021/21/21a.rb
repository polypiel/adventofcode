SIZE = 10
VICTORY = 1000

if (ARGF.readline =~ /Player \d starting position: (\d+)/)
	k = $1.to_i
end
if (ARGF.readline =~ /Player \d starting position: (\d+)/)
	q = $1.to_i
end

puts "#{k},#{q}"

$cache = Hash.new

p1 = 0
p2 = 0
c1 = k - 1
c2 = q - 1
i = 0
while (p1 < VICTORY && p2 < VICTORY) do
	step = i * 9 + 6
	if (i % 2 == 0)
		c1 = (c1 + step) % SIZE
		p1 += c1 + 1
	else
		c2 = (c2 + step) % SIZE
		p2 += c2 + 1
	end
	i += 1
end

puts "#{i * 3} rolls"
if (p1 >= VICTORY)
	puts "Win 1 with #{p1} at #{c1 + 1}, 2 loses with #{p2}"
	puts i * 3 * p2
else
	puts "Win 2 with #{p2} at #{c2 + 1}, 1 loses with #{p1}"
	puts i * 3 * p1
end
