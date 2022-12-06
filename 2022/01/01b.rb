elfs = []
current = 0
STDIN.read.split("\n").each do |a|
   if (a == "")
   	 elfs << current
   	 current = 0
   else
   	current += a.to_i
   end
end
elfs << current

puts elfs.sort[n-3..n].sum
