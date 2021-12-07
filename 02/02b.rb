y = 0
x = 0
aim = 0
STDIN.read.split("\n").each do |a|
   action, amount = a.split(" ")
   case action
   when "up"
      aim -= amount.to_i
   when "down"
      aim += amount.to_i
   when "forward"
      x += amount.to_i
      y += aim * amount.to_i
   end
end
puts x*y
