require 'set'

SIZE = 5

$values = ARGF.readline.split(",").map { |t| t.to_i }
$inverse_cardboards = Hash.new

cardboards = Array.new
cardboard = nil

def find_winner(num_players)
	# Rows, columns
	bingo = Array.new(num_players) { Array.new(SIZE + SIZE, 0) }
	winners = Array.new(num_players, false)
	num_winners = 0
	$values.each_with_index do |num, num_index|
		if($inverse_cardboards.has_key?(num))
			$inverse_cardboards[num].each do |player, pos|
				c = pos % SIZE
				r = pos / SIZE
				bingo[player][r] = bingo[player][r] + 1
				bingo[player][SIZE + c] = bingo[player][SIZE + c] + 1
				if (bingo[player][r] == SIZE || bingo[player][SIZE + c] == SIZE)
					if (!winners[player])
						num_winners += 1
						if (num_winners == num_players)
							return [player, num_index]
						end
					end
					winners[player] = true
				end
			end
		end
	end
end

i = 0
player = 0
ARGF.readlines.each do |line|
	if (line.chomp.size > 0)
		if (i == 0)
			cardboard = Array.new(SIZE * SIZE)
		end
		line.chomp.split(" ").each_with_index do |n, j|
			index = i * SIZE + j
			number = n.to_i
			cardboard[index] = number
			if ($inverse_cardboards.has_key?(number))
				$inverse_cardboards[number] << [player, index]
			else
				$inverse_cardboards[number] = [[player, index]]
			end
		end
		i += 1
		if (i == SIZE)
			i = 0
			cardboards << cardboard
			player += 1
		end
	end
end

winner_player, nums = find_winner(player)

winner_cardboard = cardboards[winner_player]
winner_values = Set.new($values.take(nums + 1))

unmarkedSum = winner_cardboard.select { |n| !winner_values.include?(n) }.sum

puts unmarkedSum * $values[nums]
