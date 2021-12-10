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
	")" => 3,
	"]" => 57,
	"}" => 1197,
	">" => 25137
}

def line(chars)
	heap = []
	err = 0
	chars.each do |c|
		if (OPEN.include?(c))
			heap.push(c)
		else
			c0 = heap.pop()
			if (CLOSE[c0] != c)
				err += POINTS[c]
			end
		end
	end
	return err
end

ARGF.readlines.each do |l|
	sum += line(l.chomp.chars)
end

puts sum
