require 'set'

def buildMapping(signals)
	mapping = Array.new(7) { "abcdefg".chars }
	signalsBySize = Hash.new
	signals.each do |s| 
		if (signalsBySize.has_key?(s.size))
			signalsBySize[s.size] << s
		else
			signalsBySize[s.size] = [s]
		end
	end

	one = signalsBySize[2][0]
	seven = signalsBySize[3][0]
	signalZero = seven.gsub(/[#{one}]/, "")
	mapping[0] = [signalZero]
	mapping[2] = one.chars
	mapping[5] = one.chars
	7.times do |i|
		if (i != 0 && i != 2 && i != 5)
			mapping[i].delete(signalZero)
			mapping[i].delete(one.chars[0])
			mapping[i].delete(one.chars[1])
		end
	end 

	v0, v1 = mapping[2]
	six = signalsBySize[6]
		.select { |s| !s.chars.include?(v0) || !s.chars.include?(v1)}
		.first
	if (six.chars.include?(v0))
		mapping[2] = [v1]
		mapping[5] = [v0]
	else
		mapping[2] = [v0]
		mapping[5] = [v1]
	end

	signalThree = signalsBySize[5].map { |s| s.gsub(/[#{seven}]/, "") }.select { |s| s.size == 2 }.first
	mapping[3] = signalThree.chars
	mapping[6] = signalThree.chars
	7.times do |i|
		if (i != 3 && i != 6)
			mapping[i].delete(signalThree[0])
			mapping[i].delete(signalThree[1])
		end
	end

	u0, u1 = signalsBySize[6].map { |s| s.gsub(/[#{seven}]/, "") }
		.select { |s| s.size == 3 }
	u = u0.gsub(/[#{u1}]/, "") + u1.gsub(/[#{u0}]/, "")
	#puts "U: #{u}"
	#puts "#{mapping[4]}"

	mapping[4] = mapping[4].select { |c| u.include?(c) }
	7.times do |i|
		if (i != 4)
			mapping[i].delete(mapping[4][0])
		end
	end

	mapping[3] = mapping[3].select { |c| u.include?(c) }
	7.times do |i|
		if (i != 3)
			mapping[i].delete(mapping[3][0])
		end
	end

	numberMapping = Hash.new
	numberMapping[(mapping[0][0] + mapping[1][0] + mapping[2][0] + mapping[4][0] + mapping[5][0] + mapping[6][0]).chars.sort.join] = 0
	numberMapping[(mapping[2][0] + mapping[5][0]).chars.sort.join] = 1
	numberMapping[(mapping[0][0] + mapping[2][0] + mapping[3][0] + mapping[4][0] + mapping[6][0]).chars.sort.join] = 2
	numberMapping[(mapping[0][0] + mapping[2][0] + mapping[3][0] + mapping[5][0] + mapping[6][0]).chars.sort.join] = 3
	numberMapping[(mapping[1][0] + mapping[2][0] + mapping[3][0] + mapping[5][0]).chars.sort.join] = 4
	numberMapping[(mapping[0][0] + mapping[1][0] + mapping[3][0] + mapping[5][0] + mapping[6][0]).chars.sort.join] = 5
	numberMapping[(mapping[0][0] + mapping[1][0] + mapping[3][0] + mapping[4][0] + mapping[5][0] + mapping[6][0]).chars.sort.join] = 6
	numberMapping[(mapping[0][0] + mapping[2][0] + mapping[5][0]).chars.sort.join] = 7
	numberMapping[(mapping[0][0] + mapping[1][0] + mapping[2][0] + mapping[3][0] + mapping[4][0] + mapping[5][0] + mapping[6][0]).chars.sort.join] = 8
	numberMapping[(mapping[0][0] + mapping[1][0] + mapping[2][0] + mapping[3][0] + mapping[5][0] + mapping[6][0]).chars.sort.join] = 9
	#puts numberMapping
	return numberMapping
end

def toNumber(mapping, digit)
end

sum = 0
ARGF.readlines.each do |l|
	signals, outputs = l.chomp.split("|").map { |s| s.split(" ") }
	numberMapping = buildMapping(signals)
	number = 0
	3.downto(0) do |d|
		o = outputs[3 - d].chars.sort.join
		#puts "#{o} => #{numberMapping.has_key?(o)}"
		number += numberMapping[o] * (10 ** d)
	end
	#puts number
	sum += number
end
puts sum
