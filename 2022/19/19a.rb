TIME = 20
MATERIALS = [:ore, :clay, :obsidian, :geode]

blueprints = []

STDIN.read.split("\n").each do |line|
	if /Blueprint \d+: (.*)/ =~ line
		robot = Hash.new
		$1.split(".").each do |robot_line|
			if /Each (\w+) robot costs (\d+) (\w+) and (\d+) (\w+)/ =~ robot_line
				robot[$1.to_sym] = {$3.to_sym => $2.to_i, $5.to_sym => $4.to_i}
			elsif /Each (\w+) robot costs (\d+) (\w+)/ =~ robot_line
				robot[$1.to_sym] = {$3.to_sym => $2.to_i}
			else
				raise "Bad input: #{line}"
			end
		end
		blueprints << robot
	else
		raise "Bad input: #{line}"
	end
end
#puts blueprints

State = Struct.new(:time, :resources, :robots) do
	def pass
		newResources = Hash.new {0}
		MATERIALS.each do |m|
			newResources[m] = resources[m] + robots[m]
		end
		State.new(time + 1, newResources, robots.clone)
	end

	def build(robot, cost)
		# puts "Built #{robot}: #{cost}"
		newRobots = robots.clone
		newRobots[robot] += 1
		newResources = Hash.new {0}
		MATERIALS.each do |m|
			newResources[m] = resources[m] + robots[m] - (cost[m] || 0)
		end
		State.new(time + 1, newResources, newRobots)
	end
end

def maximize(blueprint, state)
	#puts "#{state}"
	if state.time > TIME
		return state.resources[:geode]
	end
	next_steps = Array.new()
	next_steps << state.pass
	blueprint.each do |k, v| 
		#puts "Checking #{k}, #{v}"
		if v.all? { |m, q| state.resources[m] >= q }
			next_steps << state.build(k, v)
		end
	end

	return next_steps.map { |s| maximize(blueprint, s) }.max
end

quality_level = maximize(blueprints[0], State.new(1, Hash.new { 0 }, {:ore => 1, :clay => 0, :obsidian => 0, :geode => 0}))
#blueprints.each_with_index do |b, i|
#	quality_level = (i + 1) * maximize(b)
#end
puts "#{quality_level}"

