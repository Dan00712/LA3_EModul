using Statistics

using DataFrames
using CSV
using Plots

const ΔU = 0.01 # V

adder = "Stab2"
df = CSV.File("data/$(adder)/total.csv") |>  DataFrame

function do_stuff(df, du_big = [], du_small = []; outfname, column=2, rel_MBR=1)
    M = df[:, 1]
    dU = df[:, column]

    # du = α * M
    γ = M ./ dU
    Δγ = M ./ (dU.^2) .* ΔU
    println(γ)
    γ = mean(γ)
    Δγ = mean(Δγ)
    p = plot(; xlabel="Masse/g", ylabel="Uₛ/V")
    scatter!(p, M, dU, label="Messpunkte")
    plot!(p, M, M./γ, label="Ausgleichsgerade")

    Δm(du) = Δγ * du + γ*ΔU
    savefig(p, outfname)

    println("γ: $(γ)")
    println("M1 $(du_small .* γ * rel_MBR)")
    println("\t$(mean(du_small .* γ * rel_MBR))")
    println("\terr: $(Δm.(du_small))")
    println("M2 $(du_big .* γ * rel_MBR)")
    println("\t$(mean(du_big .* γ * rel_MBR))")
    println("\terr: $(Δm.(du_big))")
end


# 2V5
println("2V5:")
do_stuff(df, 
         [1.7, 1.69] ./2,       # big
         [1.4 , 1.41] ./2,       # small
         outfname="plots/$(adder)-2V5.png",
         column=2,
         rel_MBR=4
)
# 5V
println("5V:")
do_stuff(df, 
         [3.47, 3.50],       # big 
         [2.9 , 2.9],      # small
         outfname="plots/$(adder)-5V.png",
         column=3,
         rel_MBR=4,
)
