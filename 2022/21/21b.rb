ROOT = "root"
X = "x"

CACHE = Hash.new

def operate(op1, op, op2)
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

Monkey = Struct.new(:name, :op1, :op, :op2) do
	def to_s
		op == nil ? "#{op1}" : "#{op1} #{op} #{op2}"
	end

	def value(monkeys)
		puts "Value of #{name}: #{op1}, #{op2}"
		return CACHE[name] if CACHE[name] != nil
		return nil if op1 == X or op2 == X

		value1 = (op1.is_a? String) ? monkeys[op1].value(monkeys) : op1
		value2 = (op2.is_a? String) ? monkeys[op2].value(monkeys) : op2

		return (value1 == nil or value2 == nil) ? nil : operate(value1, op, value2)
	end

	def expr(monkeys)
		def expr_value(op0, monkeys)
			if op0 == X
				nil
			elsif op0.is_a? String
				monkeys[op0].value(monkeys)
			else
				op0
			end
		end

		puts "Expr of #{name}: #{op1}, #{op2} (#{op2.class})"
		value1 = expr_value(op1, monkeys)
		value2 = expr_value(op2, monkeys)
		
		if value1 != nil and value2 != nil
			operate(value1, op, value2)
		else
			op1expr = value1 || (op1 != X ? monkeys[op1].expr(monkeys) : X)
			op2expr = value2 || (op2 != X ? monkeys[op2].expr(monkeys) : X)

			"(#{op1expr} #{op} #{op2expr})"
		end
	end
end

monkeys = Hash.new
STDIN.read.split("\n").each do |line|
	if /(\w+): (\d+)/ =~ line
		monkeys[$1] = Monkey.new($1, $2.to_i, "+", 0)
	elsif /(\w+): x/ =~ line
		monkeys[$1] = Monkey.new($1, X, "+", 0)
	elsif /(\w+): (\w+) ([\+\*\/-]) (\w+)/ =~ line
		monkeys[$1] = Monkey.new($1, $2, $3, $4)
	else
		raise "Bad input: #{line}"
	end
end

#puts monkeys
l = monkeys[monkeys[ROOT].op1].expr(monkeys)
r = monkeys[monkeys[ROOT].op2].expr(monkeys)
puts "#{l} = #{r}"
# https://wims.univ-cotedazur.fr/wims/wims.cgi?session=ZT2BD1D234.1&lang=en&cmd=reply&module=tool%2Flinear%2Flinsolver.en&system=%284+*+%2825144232728290+-+%28%28%285+*+%28159+%2B+%28%28%28%28%28%28947+%2B+%28%28%282+*+%28%28%28119+%2B+%2815+*+%28%28%28%28%28%28%28%28%28%28722+%2B+%28%28%282+*+%28%284+*+%28%28%28%28618+%2B+%28%28%287+*+%28%28%28374+%2B+%282+*+%28%28%28%285+*+%28%28%28%289+*+%28560+%2B+%28%28%28%28547+%2B+%28%28%282+*+%28%28%28%28%28%28x+%2B+0%29+-+341%29+%2F+5%29+%2B+318%29+*+112%29+%2B+712%29%29+-+216%29+%2F+4%29%29+*+3%29+-+257%29+%2F+10%29%29%29+-+15%29+%2F+5%29+%2B+112%29%29+-+911%29+%2F+3%29+-+345%29%29%29+%2F+5%29+-+94%29%29+%2B+246%29+%2F+2%29%29+%2B+657%29+%2F+2%29+-+250%29%29+-+302%29%29+%2B+709%29+%2F+3%29%29+%2F+3%29+-+319%29+*+2%29+-+498%29+*+2%29+%2B+257%29+%2B+702%29+%2F+11%29+-+786%29%29%29+%2F+8%29+-+20%29%29+%2B+408%29+%2F+2%29%29+*+8%29+-+199%29+%2F+7%29+-+670%29+%2F+3%29%29%29+%2B+262%29+%2F+2%29%29%29+%3D+42130890593816&parms=
