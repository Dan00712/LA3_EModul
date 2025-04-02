
using Statistics

ls = readlines(stdin)
# essentially a tee with pipe
println(stderr, ls)

m = mean(ls .|> x-> split(x, '.') .|> x-> parse(Float64, x))[1]
println(m)
