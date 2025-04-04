using Statistics

using DataFrames
using CSV
using Plots

adder = "Stab1"
df = CSV.File("data/$(adder)/total.csv") |>  DataFrame

function do_stuff(df, du_big = [], du_small = []; outfname, column=2, rel_MBR=1)
    M = df[:, 1]
    dU = df[:, column]

    # du = α * M
    γ = M ./ dU
    println(γ)
    γ = mean(γ)
    p = plot(; xlabel="Masse/g", ylabel="Uₛ/V")
    scatter!(p, M, dU ./2, label="Messpunkte")
    plot!(p, M, M./γ ./2, label="Ausgleichsgerade")

    savefig(p, outfname)

    println("γ: $(γ) g/V")
    println("M1 $(du_small .* γ * rel_MBR)")
    println("\t$(mean(du_small .* γ * rel_MBR))")
    println("M2 $(du_big .* γ * rel_MBR)")
    println("\t$(mean(du_big .* γ * rel_MBR))")
end


# 2V5
println("2V5:")
do_stuff(df, 
         [1.8, 1.79],       # big
         [1.61, 1.6],       # small
         outfname="plots/$(adder)-2V5.png",
         column=2,
         rel_MBR=2
)
# 5V
println("5V:")
do_stuff(df, 
         [3.44, 3.56],       # big 
         [3.04 ,3.139],      # small
         outfname="plots/$(adder)-5V.png",
         column=3,
)
