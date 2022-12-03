SEGMENTS = 7

def add(values, segments, mapping)
	SEGMENTS.times do |i|
		if (segments.include?(i))
			mapping[i] = values
		else
			values.each { |v| mapping[i].delete(v) }
		end
	end
end

def buildMapping(signals)
	mapping = Array.new(SEGMENTS) { "abcdefg".chars }
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
	add(one.chars, [2, 5], mapping)
	add([seven.gsub(/[#{one}]/, "")], [0], mapping)

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
	add(signalThree.chars, [3, 6], mapping)

	u0, u1 = signalsBySize[6].map { |s| s.gsub(/[#{seven}]/, "") }
		.select { |s| s.size == 3 }
	u = u0.gsub(/[#{u1}]/, "") + u1.gsub(/[#{u0}]/, "")
	add(mapping[4].select { |c| u.include?(c) }, [4], mapping)
	add(mapping[3].select { |c| u.include?(c) }, [3], mapping)

	numberMapping = Hash.new
	numberMapping[[0, 1, 2, 4, 5, 6].map { |i| mapping[i][0] }.sort.join] = 0
	numberMapping[[2, 5].map { |i| mapping[i][0] }.sort.join] = 1
	numberMapping[[0, 2, 3, 4, 6].map { |i| mapping[i][0] }.sort.join] = 2
	numberMapping[[0, 2, 3, 5, 6].map { |i| mapping[i][0] }.sort.join] = 3
	numberMapping[[1, 2, 3, 5].map { |i| mapping[i][0] }.sort.join] = 4
	numberMapping[[0, 1, 3, 5, 6].map { |i| mapping[i][0] }.sort.join] = 5
	numberMapping[[0, 1, 3, 4, 5, 6].map { |i| mapping[i][0] }.sort.join] = 6
	numberMapping[[0, 2, 5].map { |i| mapping[i][0] }.sort.join] = 7
	numberMapping[[0, 1, 2, 3, 4, 5, 6].map { |i| mapping[i][0] }.sort.join] = 8
	numberMapping[[0, 1, 2, 3, 5, 6].map { |i| mapping[i][0] }.sort.join] = 9
	return numberMapping
end

sum = 0
ARGF.readlines.each do |l|
	signals, outputs = l.chomp.split("|").map { |s| s.split(" ") }
	numberMapping = buildMapping(signals)
	number = 0
	3.downto(0) do |d|
		o = outputs[3 - d].chars.sort.join
		number += numberMapping[o] * (10 ** d)
	end
	sum += number
end

puts sum
