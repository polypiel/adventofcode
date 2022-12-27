ROOT = "root"

Monkey = Struct.new(:op1, :op, :op2) do
	def to_s
		op == nil ? "#{op1}" : "#{op1} #{op} #{op2}"
	end

	def value(monkeys)
		if op1.is_a? String
			self.op1 = monkeys[op1].value(monkeys)
		end
		if op2.is_a? String
			self.op2 = monkeys[op2].value(monkeys)
		end
		
		if op == "+"
			op1 + op2
		elsif op == "-"
			op1 - op2
		elsif op == "*"
			op1 * op2
		elsif op == "/"
			op1 / op2
		end
	end
end

monkeys = Hash.new
STDIN.read.split("\n").each do |line|
	if /(\w+): (\d+)/ =~ line
		monkeys[$1] = Monkey.new($2.to_i, "+", 0)
	elsif /(\w+): (\w+) ([\+\*\/-]) (\w+)/ =~ line
		monkeys[$1] = Monkey.new($2, $3, $4)
	else
		raise "Bad input: #{line}"
	end
end

#puts monkeys
puts monkeys[ROOT].value(monkeys)
