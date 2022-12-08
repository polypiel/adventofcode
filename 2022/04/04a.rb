puts STDIN.read.split("\n")
  .map { |line| line.split(",").map { |p| p.split("-").map { |s| s.to_i } } }
  .select { |pairs| (pairs[0][0] <= pairs[1][0] and pairs[0][1] >= pairs[1][1]) or (pairs[1][0] <= pairs[0][0] and pairs[1][1] >= pairs[0][1]) }
  .size # 550
