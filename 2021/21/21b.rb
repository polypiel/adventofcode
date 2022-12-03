SIZE = 10
VICTORY = 21

$p1Wins = 0
$p2Wins = 0

diesAux = Array.new
(1..3).each do |i|
	(1..3).each do |j|
		(1..3).each do |k|
			diesAux << i + j + k
		end
	end
end
$dies = Hash.new (0)
diesAux.each do |i|
	$dies[i] += 1
end

def dirac(i, c1, c2, p1 = 0, p2 = 0, universes = 1)
	if (p1 >= VICTORY)
		$p1Wins += universes
		return
	elsif (p2 >= VICTORY)
		$p2Wins += universes
		return
	end

	if (i % 2 == 0)
		$dies.each do |die, times|
			newC1 = (c1 + die) % SIZE
			dirac(i + 1, newC1, c2, p1 + newC1 + 1, p2, universes * times)
		end
	else
		$dies.each do |die, times|
			newC2 = (c2 + die) % SIZE
			dirac(i + 1, c1, newC2, p1, p2 + newC2 + 1, universes * times)
		end
	end
end

if (ARGF.readline =~ /Player \d starting position: (\d+)/)
	k = $1.to_i
end
if (ARGF.readline =~ /Player \d starting position: (\d+)/)
	q = $1.to_i
end

dirac(0, k - 1, q - 1)

if ($p1Wins > $p2Wins)
	puts "Player 1 wins #{$p1Wins} times in #{$p1Wins + $p2Wins} universes"
else
	puts "Player 2 wins #{$p2Wins} times in #{$p1Wins + $p2Wins} universes"
end