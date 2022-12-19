ROUNDS = 20

Monkey = Struct.new(:id, :items, :op1, :op2, :test, :monkeyTrue, :monkeyFalse) do
	def operate(num)
		_op2 = op2 == "old" ? num : op2.to_i
		if (op1 == "+")
			num + _op2
		elsif (op1 == "*")
			num * _op2
		end
	end

	def test_monkey(worry)
		return (worry % test == 0) ? monkeyTrue : monkeyFalse
	end
end

monkeys = []

id = nil
items = nil
op1, op2 = nil
test = nil
monkeyTrue, monkeyFalse = nil
STDIN.read.split("\n").each do |line|
	if /Monkey (\d+):/ =~ line
		id = $1.to_i
	elsif /Starting items: ([\d ,]+)/ =~ line
		items = $1.split(", ").map {|n| n.to_i }
	elsif /Operation: new = old ([\+\*\-]) (old|\d+)/ =~ line
		op1 = $1
		op2 = $2
	elsif /Test: divisible by (\d+)/ =~ line
		test = $1.to_i
	elsif /If true: throw to monkey (\d+)/ =~ line
		monkeyTrue = $1.to_i
	elsif /If false: throw to monkey (\d+)/ =~ line
		monkeyFalse = $1.to_i

		monkeys << Monkey.new(id, items, op1, op2, test, monkeyTrue, monkeyFalse)
	end
end

inspections = Hash.new { 0 }
ROUNDS.times do
	monkeys.each do |m|
		while not m.items.empty?
			worry = m.operate(m.items.shift) / 3
			to_monkey = m.test_monkey(worry)
			monkeys[to_monkey].items << worry
			inspections[m.id] += 1
		end
	end
end

total = inspections.values.sort.reverse.take(2)
puts "#{total[0] * total[1]}" # 62491
