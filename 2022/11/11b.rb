ROUNDS = 10_000
MODS = [2, 3, 5, 7, 11, 13, 17, 19, 23, 27]
MODS_SIZE = MODS.size


def to_item(num)
	MODS.map { |m| num % m }
end

def to_mod(num)
	MODS.index(num)
end

Monkey = Struct.new(:id, :items, :op1, :op2, :test, :monkeyTrue, :monkeyFalse) do
	def operate(num)
		_op2 = op2 == nil ? num : op2
		if (op1 == "+")
			[num, _op2].transpose.map.with_index { |x, i| (x[0] + x[1]) % MODS[i] }
		elsif (op1 == "*")
			[num, _op2].transpose.map.with_index { |x, i| (x[0] * x[1]) % MODS[i] }
		end
	end

	def test_monkey(worry)
		return worry[test] == 0 ? monkeyTrue : monkeyFalse
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
		items = $1.split(", ").map {|n| n.to_i } # {|n| n.to_i.prime_division.to_h }
	elsif /Operation: new = old ([\+\*\-]) (old|\d+)/ =~ line
		op1 = $1
		op2 = $2
	elsif /Test: divisible by (\d+)/ =~ line
		test = $1.to_i
	elsif /If true: throw to monkey (\d+)/ =~ line
		monkeyTrue = $1.to_i
	elsif /If false: throw to monkey (\d+)/ =~ line
		monkeyFalse = $1.to_i

		monkeys << Monkey.new(id, items.map { |item| to_item(item) }, op1, op2 == "old" ? nil : to_item(op2.to_i), to_mod(test), monkeyTrue, monkeyFalse)
	end
end

inspections = Hash.new { 0 }
ROUNDS.times do |i|
	monkeys.each do |m|
		while not m.items.empty?
			worry = m.operate(m.items.shift)
			to_monkey = m.test_monkey(worry)
			monkeys[to_monkey].items << worry
			inspections[m.id] += 1
		end
	end
end

total = inspections.values.sort.reverse.take(2)
puts "#{total[0] * total[1]}" # 17408399184
