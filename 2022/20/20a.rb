LIST = STDIN.read.split("\n").map { |n| n.to_i }
SIZE = LIST.size
SIZE_1 = SIZE - 1

Element = Struct.new(:value, :original_index) do
end

final_list = LIST.each_with_index.map { |v, i| Element.new(v, i) }

SIZE.times do |pos|
	index = final_list.index { |e| e.original_index == pos }
	element = final_list[index]
	v = element.value
	next if v == 0 or v % SIZE_1 == 0
	final_list.delete_at index
	new_index = v > 0 ? index + (v % SIZE_1) : index - (v.abs % SIZE_1)
	the_index = case
		when new_index == SIZE then  1
		when new_index > SIZE_1 then new_index - SIZE_1
		when new_index == 0 then SIZE_1
		when new_index < 0 then SIZE_1 + new_index
		else new_index
	end
	final_list.insert(the_index, element)
end

zero_index = final_list.index { |e| e.value == 0}
puts [1000, 2000, 3000].map { |n| final_list[(zero_index + n) % SIZE].value }.sum # 8028
