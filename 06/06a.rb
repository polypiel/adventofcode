DAYS = 256
$cache = Hash.new
lanternfishes = 0

def f(n)
	if ($cache.has_key? n)
		return $cache[n]
	end

	n1 = n + 9
	l = 1
	while (n1 < DAYS)
		l += f(n1)
		n1 += 7
	end

	$cache[n] = l
	return l
end

ARGF.readline.chomp.split(",").each do |n|
	n0 = n.to_i
	fn = f(n0 - 9)
	lanternfishes += fn
end

puts lanternfishes
