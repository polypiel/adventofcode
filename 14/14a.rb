STEPS = 10

template = ARGF.readline.chomp

ARGF.readline

rules = Hash.new
ARGF.readlines.map { |l| l.chomp.split(" -> ") }.each do |l, r|
	rules[l] = r
end

STEPS.times do |step|
	string = ""
	(template.size).times do |i|
		if (template.size == i - 1)
			string += template[i]
		else
			prefix = template[i, 2]
			if(rules.has_key?(prefix))
				string += prefix[0] + rules[prefix]
			else
				string += prefix[0]
			end
		end
	end
	template = string
end

elements = Hash.new(1)
template.chars.each do |c|
	elements[c] += 1
end

res = elements.values.max - elements.values.min

puts res
