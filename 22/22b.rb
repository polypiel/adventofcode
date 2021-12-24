require 'set'

Instruction = Struct.new(:on, :cube) do
	def to_s
		"#{cube} -> #{on ? 'on': 'off'}\n"
	end
end

def collision(a, b)
	if ((a[0] < b[3] && a[3] > b[0]) && (a[1] < b[4] && a[4] > b[1]) && (a[2] < b[5] && a[5] > b[2]))
		groupA = Array.new
		i = 0
		[[a[0], b[0]], [b[0], a[3]]].each do |x|
			[[a[1], b[1]], [b[1], a[4]]].each do |y|
				[[a[2], b[2]], [b[2], a[5]]].each do |z|
					if (i == 7)
						#groupA << [x[0], y[0], z[0], x[1], y[1], z[1]]
					else
						groupA << [x[0], y[0], z[0], x[1], y[1], z[1]]
					end
					i += 1
				end
			end
		end

		i = 0
		groupB = Array.new
		[[b[0], a[3]], [a[3], b[3]]].each do |x|
			[[b[1], a[4]], [a[4], b[4]]].each do |y|
				[[b[2], a[5]], [a[5], b[5]]].each do |z|
					if (i == 0)
						groupB << [x[0], y[0], z[0], x[1], y[1], z[1]]
					else
						groupB << [x[0], y[0], z[0], x[1], y[1], z[1]]
					end
					i += 1
				end
			end
		end
		return [groupA.select { |v| v[3] > v[0] && v[4] > v[1] && v[5] > v[2] }, groupB.select { |v| v[3] > v[0] && v[4] > v[1] && v[5] > v[2] }]
	end
	return nil, nil
end

$input = Array.new
ARGF.readlines.each do |l|
	if (l.chomp =~ /(on|off) x=(-?\d+)\.\.(-?\d+),y=(-?\d+)\.\.(-?\d+),z=(-?\d+)\.\.(-?\d+)/)
		$input << Instruction.new($1 == "on", [$2.to_i - 0.5, $4.to_i - 0.5, $6.to_i - 0.5, $3.to_i + 0.5, $5.to_i + 0.5, $7.to_i + 0.5])
	end
end

puts $input

# a, b = collision([0, 0, 0, 3, 3, 3], [1, 1, 1, 5, 5, 5])
# puts "Group A"
# a.each do |i|
# 	print i.join(",")
# 	puts
# end
# puts "Group B"
# b.each do |i|
# 	print i.join(",")
# 	puts
# end

def partition()
	$input.each_with_index do |c1, i|
		$input.each_with_index do |c2, j|
			if (j > i)
				if (c1.cube != c2.cube)
					a, b = collision(c1.cube, c2.cube)
					if (a != nil)
						puts "partition #{c1.cube} and #{c2.cube}"
						$input[i] = a.map { |c| Instruction.new(c1.on, c) }
						$input[j] = b.map { |c| Instruction.new(c2.on, c) }

						$input = $input.flatten(1)
						#puts
						#puts $input
						return true
					end
				end
			end
		end
	end
	return false
end

#pp()
k = 0
while partition() do
	puts $input
	puts
	k += 1
	#break if k == 2
end
#pp()

puts
puts $input

boot = Set.new
$input.each do |i|
	#puts "#{c}: #{on}"
	if (i.on)
		boot << i.cube
	else
		boot.delete(i.cube)
	end
end

puts $input.size
puts boot.size
puts boot

puts boot
	.map { |c| ((c[3] - c[0]) * (c[4] - c[1]) * (c[5] - c[0])).to_i }
	.sum

