y = 0
x = 0
STDIN.read.split("\n").each do |a|
   action, amount = a.split(" ")
   case action
   when "up"
      y -= amount.to_i
   when "down"
      y += amount.to_i
   when "forward"
      x += amount.to_i
   end
end
puts x*y
