require 'set'

sum = 0

OPEN = "([{<".chars.to_set
CLOSE = {
	"(" => ")",
	"[" => "]",
	"{" => "}",
	"<" => ">"
}
POINTS = {
	")" => 1,
	"]" => 2,
	"}" => 3,
	">" => 4
}

def incomplete(chars)
	heap = []
	score = 0
	chars.each do |c|
		if (OPEN.include?(c))
			heap.push(c)
		else
			c0 = heap.pop()
			if (CLOSE[c0] != c)
				return nil
			end
		end
	end
	#puts heap.reverse.map { |c| CLOSE[c] }.join
	heap.reverse.map { |c| CLOSE[c] }.each do |c|
		score = 5 * score + POINTS[c]
	end

	return score
end

scores = ARGF.readlines.map { |l| l.chomp.chars}
	.map { |l| incomplete(l) }
	.select { |s| s != nil }
	.sort

puts scores[scores.size / 2]
