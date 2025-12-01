TICKS = 25

stones = STDIN.read.split("\n")[0].split(" ")

puts "#{stones}"

TICKS.times do
	new_stones = []
	stones.each do |s|
		if s == "0"
			new_stones << "1"
		elsif s.size % 2 == 0
			half = s.size / 2
			new_stones << s.to_s[0..half - 1]
			new_stones << (s.to_s[half..s.size - 1]).to_i.to_s
		else
			new_stones << (s.to_i * 2024).to_s
		end
	end
	stones = new_stones
	#puts "#{stones}"
end

puts stones.size # 194557