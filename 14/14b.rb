STEPS = 40

template = ARGF.readline.chomp

ARGF.readline

rules = Hash.new
ARGF.readlines.map { |l| l.chomp.split(" -> ") }.each do |l, r|
	rules[l] = r
end

pairs = Hash.new
(template.size - 1).times do |i|
	prefix = template[i, 2]
	if (pairs.has_key?(prefix))
		pairs[prefix] += 1
	else
		pairs[prefix] = 1
	end
end

STEPS.times do |step|
	currentPairs = Hash.new
	pairs.each do |prefix, amount|
		if (rules.has_key?(prefix))
			rule = rules[prefix]
			pair1 = prefix[0] + rule
			pair2 = rule + prefix[1]
			currentPairs[pair1] = currentPairs.has_key?(pair1) ? currentPairs[pair1] + amount : amount
			currentPairs[pair2] = currentPairs.has_key?(pair2) ? currentPairs[pair2] + amount : amount
		else
			currentPairs[prefix] = currentPairs.has_key?(prefix) ? currentPairs[prefix] + amount : amount
		end
	end
	pairs = currentPairs
	#puts "#{step+1}: #{pairs}"
end

elements = Hash.new
pairs.each do |prefix, amount|
	a, b = prefix.chars
	elements[a] = elements.has_key?(a) ? elements[a] + amount : amount
	# elements[b] = elements.has_key?(b) ? elements[b] + amount : amount
end
lastLetter = template[template.size - 1]
elements[lastLetter] = elements.has_key?(lastLetter) ? elements[lastLetter] + 1 : 1

max = elements.values.max
min = elements.values.min
#puts "#{max} - #{min}"
res = max - min

puts res
