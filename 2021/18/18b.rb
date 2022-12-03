class Leaf
	attr_accessor :value, :exploding

	def initialize(value, exploding = nil)
		@value = value
		@exploding = exploding
	end

	def magnitude
		@value
	end

	def to_s
		"#{@value}"
	end

	def leafs
		[self]
	end
end

class Pair
	attr_accessor :left, :right

	def initialize(left, right)
		@left = left
		@right = right
	end

	def isLeftPair?
		@left.is_a?(Pair)
	end

	def isRightPair?
		@right.is_a?(Pair)
	end

	def magnitude
		@left.magnitude * 3 + @right.magnitude * 2
	end

	def plus(p2)
		Pair.new(self, p2).reduce
	end

	def reduce
		changed = true
		p = self
		while(changed) do
			p, changed1 = p.explode
			if (changed1)
				#puts "after explode: #{p}"
			end
			if (!changed1)
				p, changed2 = p.split
			end
			if (changed2)
				#puts "after split: #{p}"
			end
			changed = changed1 || changed2
		end
		p
	end

	def explode
		p, changed = explodeAux
		if (changed)
			ls = p.leafs
			#puts ls
			ls.each_with_index do |l, i|
				if (l.exploding != nil)
					if (i > 0)
						ls[i - 1].value += l.exploding[0]
					end
					if (i < ls.size - 1)
						ls[i + 1].value += l.exploding[1]
					end
					l.exploding = nil
					break
				end
			end
		end
		return p, changed
	end

	def explodeAux(deep = 0)
		l = @left
		r = @right
		changedLeft = false
		changedRight = false

		if (!isLeftPair? && !isRightPair? && deep > 3)
			return Leaf.new(0, [@left.value, @right.value]), true
		end

		if (isLeftPair?)
			l, changedLeft = @left.explodeAux(deep + 1)
		end

		if (isRightPair? && !changedLeft)
			r, changedRight = @right.explodeAux(deep + 1)
		end

		return Pair.new(l, r), changedLeft || changedRight
	end

	def split
		l = @left
		r = @right
		changedLeft = false
		changedRight = false

		if isLeftPair?
			l, changedLeft = @left.split
		else
			if (@left.value > 9)
				l = Pair.new(Leaf.new(@left.value / 2), Leaf.new((@left.value / 2.0).round(half: :up)))
				changedLeft = true
			end
		end

		if (!changedLeft)
			if isRightPair?
				r, changedRight = @right.split
			else
				if (@right.value > 9)
					r = Pair.new(Leaf.new(@right.value / 2), Leaf.new((@right.value / 2.0).round(half: :up)))
					changedRight = true
				end
			end
		end

		return Pair.new(l, r), changedLeft || changedRight
	end

	def to_s
		"[#{@left},#{@right}]"
	end

	def leafs
		return @left.leafs + @right.leafs
	end
end

def parse(input, index = 0)
	r = false
	left = nil
	right = nil
	i = index + 1
	loop do
		c = input[i]
		if (c == "[")
			if (r)
				right, i = parse(input, i)
			else
				left, i = parse(input, i)
			end
		elsif (c == "]")
			return Pair.new(left, right), i
		elsif (c == ",")
			r = true
		else
			j = 0
			while(input[i + j] =~ /[0-9]/)
				j+= 1
			end
			if (r)
				right = Leaf.new(input[i, j].to_i)
			else
				left = Leaf.new(input[i, j].to_i)
			end
			i += j - 1
		end
		i += 1
	end
end


maxSum = 0
homework = ARGF.readlines.map { |l| l.chomp }

(homework.size - 2).times do |i|
	(i+1..homework.size-1).each do |j|
		#puts "#{homework[i]}+#{homework[j]}"
		s1 = parse(homework[i])[0].plus(parse(homework[j])[0]).magnitude
		if (s1 > maxSum)
			maxSum = s1
		end

		#puts "#{homework[j]}+#{homework[i]}"
		s2 = parse(homework[j])[0].plus(parse(homework[i])[0]).magnitude
		if (s2 > maxSum)
			maxSum = s2
		end
	end
end

puts maxSum
