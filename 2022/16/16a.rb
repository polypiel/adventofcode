START = "AA"
TIME = 25

Node = Struct.new(:name, :rate, :links) do
	def to_s
		"#{name} (#{rate}): #{links}"
	end
end

State = Struct.new(:step, :node, :open, :pressure) do
end

TUNNELS = Hash.new
STDIN.read.split("\n").map do |line|
	if /Valve (\w+) has flow rate=(\d+); tunnels? leads? to valves? ([\w, ]+)/ =~ line
		TUNNELS[$1] = Node.new($1, $2.to_i, $3.split(", "))
	else
		raise "Unknown entry: #{line}"
	end
end

VALVES = TUNNELS.values.select { |t| t.rate > 0 }.size

#puts "#{TUNNELS}"

@max = nil

def step(state)
	#puts "Step #{state}"
	if state.step == TIME or state.open.size == VALVES.size
		@max = state.pressure if @max == nil or state.pressure > @max
		return
	end
	top = TUNNELS.values.select { |t| t.rate > 0 and not state.open.key? t.name }
			.each_with_index.map { |t, i| t.rate * (TIME - state.step - i) }.sum 
	if @max != nil and (top + state.pressure) < @max
		# puts "Current #{@max} - #{state.pressure} - #{TUNNELS.values.select { |t| not state.open.key? t.name }.map { |t| t.rate * (TIME - state.step - 1) }.sum}"
		return
	end
	if not state.open.key? state.node.name and state.node.rate > 0
		newOpen = Hash[state.open]
		newOpen[state.node.name] = state.step+1
		step(State.new(state.step+1, state.node, newOpen, (TIME - state.step+1)*state.node.rate))
	end
	state.node.links.each do |link|
		step(State.new(state.step+1, TUNNELS[link], state.open, state.pressure))
	end
end

step(State.new(0, TUNNELS[START], Hash.new, 0))

puts "Max: #{@max}"
