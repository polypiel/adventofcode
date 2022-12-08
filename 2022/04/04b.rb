puts STDIN.read.split("\n")
	.map { |line| line.split(",").map { |p| p.split("-").map { |s| s.to_i } } }
	.select { |pairs| pairs.map { |p| p[0] }.max <= pairs.map { |p| p[1] }.min }
	.size # 931
