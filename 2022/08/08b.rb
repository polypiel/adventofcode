map = Array.new
STDIN.read.split("\n").each do |line|
	map << line.chars.map { |c| c.to_i }
end
HEIGHT = map.size
WIDTH = map[0].size

score = 0
for j in 0..HEIGHT - 1
	for i in 0..WIDTH - 1
		leftCount = 0
		(i-1).downto(0) do |ci|
			leftCount += 1
			break if map[j][ci] >= map[j][i]
		end

		rightCount = 0
		(i+1).upto(WIDTH-1) do |ci|
			rightCount += 1
			break if map[j][ci] >= map[j][i]
		end

		upCount = 0
		(j-1).downto(0) do |cj|
			upCount +=1
			break if map[cj][i] >= map[j][i]
		end

		downCount = 0
		(j+1).upto(HEIGHT-1) do |cj|
			downCount += 1
			break if map[cj][i] >= map[j][i]
		end

		current_score = leftCount * rightCount * upCount * downCount
		score = current_score if current_score > score
	end
end
puts score # 422059
