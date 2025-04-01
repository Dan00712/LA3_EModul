using CSV
using DataFrames

df = CSV.read(stdin, DataFrame; header=false)

df[:, 2] .= df[:,2] .- df[1, 2]
α = (df[end, 2] - df[1, 2])/(df[end, 1] - df[1, 1])
@. df[:, 2] = df[:, 2] - α * df[:, 1]

CSV.write(stdout, df)
