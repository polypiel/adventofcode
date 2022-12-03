instances = 0
ARGF.readlines.each do |l|
	signals, outputs = l.chomp.split("|").map { |s| s.split(" ") }
	uniqueDigits = Hash.new
	signals.select { |s| s.size == 2 || s.size == 3 || s.size == 4 || s.size == 7 }.each do |s|
		uniqueDigits[s.size] = s
	end
	instances += outputs.select { |o| uniqueDigits.has_key?(o.size) && o.chars.sort == uniqueDigits[o.size].chars.sort }.size
end
puts instances
