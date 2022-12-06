require 'set'

def dup(s1, s2, s3)
  map = Hash.new(0)
  Set.new(s1.chars).each do |l|
    map[l] = map[l] + 1
  end
  Set.new(s2.chars).each do |l|
    map[l] = map[l] + 1
  end
  Set.new(s3.chars).each do |l|
    return l if map[l] == 2 
  end
  raise "dup letter not found: #{s1}, #{s2}, #{s3}"
end

def priority(letter)
  return letter.ord - 96 if letter.downcase == letter
  letter.ord - 38
end

total = 0
window = Array.new(3)
STDIN.read.split("\n").each_with_index do |line, i|
  window[i % 3] = line
  if i % 3 == 2
    total += priority(dup(window[0], window[1], window[2]))
  end
end

puts total # 2881
