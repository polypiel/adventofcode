ranges = STDIN.read.split("\n")[0].split(",").map { |it| it.split("-").map { |it| it.to_i  }  }

def invalid?(str)
	size = str.size
	(1..size/2).each do |divisor|
		if (size % divisor == 0)
			pttr = ""
			chunks = size / divisor
			chunk = str[0, divisor]
			chunks.times { pttr += chunk }
			return true if str == pttr
		end
	end
	false
end

invalid = 0

ranges.each do |r0, r1|
	raise "Invalid range" if r1 <= r0
	(r0..r1).each do |n|
		invalid += n if invalid?(n.to_s)
	end
end


puts invalid # 45283684555
