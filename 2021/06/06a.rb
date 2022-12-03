DAYS = 256
$cache = Hash.new

def f(n)
	return $cache[n] if $cache.has_key? n

	n1 = n + 9
	l = 1
	while (n1 < DAYS)
		l += f(n1)
		n1 += 7
	end

	$cache[n] = l
	return l
end

puts ARGF.readline.chomp.split(",").map { |n| f(n.to_i - 9) }.sum
