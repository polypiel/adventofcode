require 'set'

START = "AA"
TIME = 30

# target: String
# weight: Int
Link = Struct.new(:target, :weight) do
	def to_s
		"#{target} (#{weight})"
	end
end

# name: String
# rate: Int
# links: Set<Link>
Node = Struct.new(:name, :rate, :links) do
	def to_s
		"#{name} [#{rate}]: #{links.join(", ")}"
	end
end

# node: Node
# open: Hash<String, Int> // valve => step
# pressure: Int
State = Struct.new(:step, :node, :open, :pressure) do
	def can_open?
		not open.key? node.name and node.rate > 0
	end

	def open_valve
		newOpen = open.dup
		newOpen[node.name] = step
		State.new(step + 1, node, newOpen, pressure + (TIME - step) * node.rate)
	end

	def move(node_to, steps)
		State.new(step + steps, node_to, open.dup, pressure)
	end
end

def link_id(a, b)
	[a, b].sort.join("-")
end

valves = Hash.new # <String, Int>
links = Hash.new # <String, Set<String>>
weights = Hash.new { 1 } # <String, Int>
STDIN.read.split("\n").map do |line|
	if /Valve (\w+) has flow rate=(\d+); tunnels? leads? to valves? ([\w, ]+)/ =~ line
		valves[$1] = $2.to_i
		valve_links = $3.split(", ")
		links[$1] = valve_links.to_set
		# valve_links.each { |l| weights[link_id($1, l)] = 1 }
	else
		raise "Unknown entry: #{line}"
	end
end

valves.select { |k, v| v == 0 and k != START }.each do |name, rate|
	links[name].each do |l|
		links[l].delete name
		links[name].select { |ll| ll != l}.each { |ll| 
			weights[link_id(l, ll)] = weights[link_id(l, name)] + weights[link_id(ll, name)] if not weights.key? link_id(l, ll)
			links[l] << ll
		}
	end
end
start_links = links[START]
links[START].each do |l|
	links[l].delete START
	links[START].select { |ll| ll != l}.each { |ll| 
		weights[link_id(l, ll)] = weights[link_id(l, START)] + weights[link_id(ll, START)] if not weights.key? link_id(l, ll)
		links[l] << ll
	}
end

# Hash<String, Node>
TUNNELS = valves.select { |k, v| v != 0}.map { |k, v| 
	[k, Node.new(k, v, links[k].select{ |l| valves[l] > 0 }.map { |l| Link.new(l, weights[link_id(k, l)]) })]
}.to_h

# Node
START_NODE = Node.new(START, valves[START], start_links.map { |l| Link.new(l, weights[link_id(START, l)]) })
#puts START_NODE
#puts TUNNELS

@max = nil
@max_open = nil

def step(state)
	#puts "Step #{state}"

	# Check final step
	if state.step >= TIME or state.open.size == TUNNELS.size
		@max = state.pressure if @max == nil or state.pressure > @max
		@max_open = state.open if state.pressure == @max
		return
	end

	# Discard bad states
	top = TUNNELS.values.select { |t| t.rate > 0 and not state.open.key? t.name }
			.sort { |n| n.rate }
			.reverse
			.take(TIME - state.step)
			.each_with_index
			.map { |t, i| t.rate * (TIME - state.step - i + 1) }
			.sum 
	if @max != nil and (top + state.pressure) <= @max
		return
	end

	# Movements
	if state.can_open?
		step(state.open_valve)
	end
	state.node.links
		#.sort { |t| t.rate }.reverse
		.each do |l|
			step(state.move(TUNNELS[l.target], l.weight))
		end
end

step(State.new(1, START_NODE, Hash.new, 0))

puts "Max: #{@max}" # 1943 low
puts "Valves: #{@max_open}" 
