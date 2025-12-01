TICKS = 6
CACHE = Hash.new { |h, k| h[k] = Hash.new }

stones = STDIN.read.split("\n")[0].split(" ")

#puts "#{stones}"

def print_cache()
	CACHE.each do |k, v|
		puts "#{k}: #{v}"
	end
end

def find_cache(s, max_tick)
	if CACHE.include?(s)
		#candidates = CACHE[s]
		found = CACHE[s].filter { |k, v| k <= max_tick }.max { |a, b| a.key <=> b.key }
		#puts "Candidates #{max_tick} - #{candidates}"
		#puts "found #{found}"
		found
	end
end

def do_tick(s)
	if s == "0"
		["1"]
	elsif s.size % 2 == 0
		half = s.size / 2
		[s.to_s[0..half - 1], (s.to_s[half..s.size - 1]).to_i.to_s]
	else
		[(s.to_i * 2024).to_s]
	end
end

def count(s0, s, ticks)
	if ticks == 0
		return [s]
	else
		cache_value = find_cache(s, ticks)
		if cache_value != nil
			t0, v0 = cache_value
			#puts "#{ticks} => #{t0} => #{ticks - t0}"
			aux = v0.flat_map { |e| count(s0, e, ticks - t0)  }
			#CACHE[s0][TICKS - t0] = aux
			#CACHE[s][t0] = aux
			aux
		else
			next_tick = do_tick(s)
			CACHE[s][1] = next_tick
			aux = do_tick(s).flat_map { |e| count(s0, e, ticks - 1)  }
			CACHE[s0][TICKS - ticks] = aux
			aux
		end
	end
end

num_stones = 0
stones.each do |s0|
	aux = count(s0, s0, TICKS)
	#puts "#{s0} => #{aux}"
	num_stones += aux.size
end

puts "#{TICKS} => #{num_stones}"
