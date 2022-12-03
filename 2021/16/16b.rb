LITERAL = 4

HEX_2_BIN = {
	"0" => "0000",
	"1" => "0001",
	"2" => "0010",
	"3" => "0011",
	"4" => "0100",
	"5" => "0101",
	"6" => "0110",
	"7" => "0111",
	"8" => "1000",
	"9" => "1001",
	"A" => "1010",
	"B" => "1011",
	"C" => "1100",
	"D" => "1101",
	"E" => "1110",
	"F" => "1111",
}

$packet = ARGF.readline.chomp.chars.map { |h| HEX_2_BIN[h] }.join

def operate(id, ops)
	if (id == 0)
		return ops.sum
	elsif (id == 1)
		return ops.inject(1, :*)
	elsif (id == 2)
		return ops.min
	elsif (id == 3)
		return ops.max
	elsif (id == 5)
		return ops[0] > ops[1] ? 1 : 0
	elsif (id == 6)
		return ops[0] < ops[1] ? 1 : 0
	elsif (id == 7)
		return ops[0] == ops[1] ? 1 : 0
	end
end

def readPacket(start)
	version = $packet[start, 3].to_i(2)
	id = $packet[start + 3, 3].to_i(2)

	if (id == LITERAL)
		num = 0
		index = start + 6
		loop do
			symbol = $packet[index + 1, 4].to_i(2)
			num = (num << 4) + symbol
			if ($packet[index].to_i(2) == 0)
				break
			end
			index += 5
		end
		return [index + 5, num]
	else
		lengthTypeId = $packet[start + 6].to_i(2)
		ops = Array.new
		subPacketsIndex = 0
		if (lengthTypeId == 0)
			numBits = $packet[start + 7, 15].to_i(2)
			subPacketsIndex = start + 22
			loop do
				if (subPacketsIndex == start + 22 + numBits)
					break
				end
				subPacketsIndex, op = readPacket(subPacketsIndex)
				ops << op
			end
		else
			numSubPackets = $packet[start + 7, 11].to_i(2)
			subPacketsIndex = start + 18
			numSubPackets.times do
				subPacketsIndex, op = readPacket(subPacketsIndex)
				ops << op
			end
		end
		return [subPacketsIndex, operate(id ,ops)]
	end
end

_, res = readPacket(0)
puts res
