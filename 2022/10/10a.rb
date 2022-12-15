signal = 0
cycle = 0
x = 1

def check_cycle?(cycle)
	cycle == 20 or cycle == 60 or cycle == 100 or cycle == 140 or cycle == 180 or cycle == 220
end

STDIN.read.split("\n").each do |line|
	if line == "noop"
		cycle += 1
		signal += cycle * x if check_cycle?(cycle)
	elsif /addx ([-\d]+)/ =~ line
		cycle += 1
		signal += cycle * x if check_cycle?(cycle)
		cycle += 1
		signal += cycle * x if check_cycle?(cycle)
		x += $1.to_i
	else
		raise "Unknown instruction: line"
	end
end

puts signal # 14620
