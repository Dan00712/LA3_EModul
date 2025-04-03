using Statistics

using DataFrames
using CSV
using Plots

df = CSV.File(ARGS[1]) |>  DataFrame
adder = ARGS[2]

function do_stuff(df, du_big = [], du_small = [], outfname, column=2)
    M = df[:, 1]
    dU = df[:, column]

    # du = α * M
    α = dU ./ M
    p = plot()
    plot!(p, M, dU)
    plot!(p, M, M.*α)

    savefig(p, outfname)

    println("α: $(α)")
    println("M1 $(test_du1 .* α)")
    println("M2 $(test_du2 .* α)")
end


do_stuff(df, 
         [],    # TODO: add values
         [],
         outfname="plots/$(adder)-m1.png"
         column=2
)
do_stuff(df, 
         [],
         [],
         outfname="plots/$(adder)-m2.png"
         column=2
)
