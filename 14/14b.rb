STEPS = 40

template = ARGF.readline.chomp

ARGF.readline

rules = Hash.new
ARGF.readlines.map { |l| l.chomp.split(" -> ") }.each do |l, r|
	rules[l] = r
end

pairs = Hash.new(0)
(template.size - 1).times do |i|
	prefix = template[i, 2]
	pairs[prefix] += 1
end

STEPS.times do |step|
	currentPairs = Hash.new(0)
	pairs.each do |prefix, amount|
		if (rules.has_key?(prefix))
			rule = rules[prefix]
			pair1 = prefix[0] + rule
			pair2 = rule + prefix[1]
			currentPairs[pair1] += amount
			currentPairs[pair2] += amount
		else
			currentPairs[prefix] += amount
		end
	end
	pairs = currentPairs
end

elements = Hash.new(0)
pairs.each do |prefix, amount|
	a, _ = prefix.chars
	elements[a] += amount
end
lastLetter = template[template.size - 1]
elements[lastLetter] += 1

res = elements.values.max - elements.values.min
puts res
