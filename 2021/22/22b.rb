Instruction = Struct.new(:on, :cube) do
	def to_s
		"#{cube} -> #{on ? 'on': 'off'}\n"
	end

	def value
		v =  (cube[3] - cube[0] + 1) * (cube[4] - cube[1] + 1) * (cube[5] - cube[2] + 1)
		if (on)
			v
		else
			-v
		end
	end
end

input = Array.new
ARGF.readlines.each do |l|
	if (l.chomp =~ /(on|off) x=(-?\d+)\.\.(-?\d+),y=(-?\d+)\.\.(-?\d+),z=(-?\d+)\.\.(-?\d+)/)
		input << Instruction.new($1 == "on", [$2.to_i, $4.to_i, $6.to_i, $3.to_i, $5.to_i, $7.to_i])
	end
end

cubes = []
input.each do |cmd|
	diffCubes = []
	cubes.each do |cube|
		# Intersection cube
		x1 = [cmd.cube[0], cube.cube[0]].max
		y1 = [cmd.cube[1], cube.cube[1]].max
		z1 = [cmd.cube[2], cube.cube[2]].max
		x2 = [cmd.cube[3], cube.cube[3]].min
		y2 = [cmd.cube[4], cube.cube[4]].min
		z2 = [cmd.cube[5], cube.cube[5]].min

        if (x1 <= x2 && y1 <= y2 && z1 <= z2)
            diffCubes << Instruction.new(!cube.on, [x1, y1, z1, x2, y2, z2])
        end
	end
	cubes += diffCubes
	if (cmd.on)
		cubes << cmd
	end
end

puts cubes
	.map { |c| c.value }
	.sum

