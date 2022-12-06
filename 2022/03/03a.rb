require 'set'

def dup(s1, s2)
  map = Set.new(s1.chars)
  s2.each_char do |l|
    return l if map.include?(l)
  end
  raise "dup letter not found: #{s1}, #{s2}"
end

def priority(letter)
  return letter.ord - 96 if letter.downcase == letter
  letter.ord - 38
end

total = 0
STDIN.read.split("\n").each do |line|
  half = line.size / 2
  total += priority(dup(line[0, half], line[half, line.size - 1]))
end

puts total # 7980
