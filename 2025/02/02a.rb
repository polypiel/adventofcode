ranges = STDIN.read.split("\n")[0].split(",").map { |it| it.split("-").map { |it| it.to_i  }  }

invalid = 0

ranges.each do |r0, r1|
	raise "Invalid range" if r1 <= r0
	(r0..r1).each do |n|
		str = n.to_s
		str_half = str.length / 2
		invalid += n if str[0,str_half] == str[str_half,str.length]
	end
end

puts invalid # 38158151648
