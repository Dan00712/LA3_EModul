using ArgParse
using Printf

using Statistics
using CSV, DataFrames

const g = 9.81  # N/kg
const N = 2     # ()
function A(d, D) 
    @assert d <= D

    1/2 * (d *sqrt(D^2-d^2) + D^2 * atan(d/sqrt(D^2-d^2)))
end

function parse_cli()
    s = ArgParseSettings()
    @add_arg_table s begin
        "-D"
            help="Width of the tie rod"
            arg_type = Float64
        "-d"
            help="height of the tie rod"
            arg_type = Float64
        "-V"
            help="the voltage of the meassurement"
            arg_type = Float64
        "--MBR"
             help="the MBR setting"
             arg_type = Float64
             default=0.05
         "-m"
            help="the mass of the weight"
            arg_type = Float64
         "--startt"
            help="the start time to take data from"
            arg_type = Float64
         "--stopt"
            help="the stop time to take data from"
            arg_type = Float64
         "file"
            help="the input csv file"
            arg_type = String
            default="-"
    end
    parse_args(s)
end

parsed_args = parse_cli()
D = parsed_args["D"]
d = parsed_args["d"]
V = parsed_args["V"]
MBR = parsed_args["MBR"]
m = parsed_args["m"]

start_t = parsed_args["startt"]
stop_t = parsed_args["stopt"]

df = CSV.read(let
                  f = parsed_args["file"]
                  if f == "-"
                      stdin
                  else
                      fp = open(f, "r")
                      atexit(()->close(fp))
                      fp
                  end
              end,
              DataFrame; header=false)
println(df)

F = m * g       # N
σ = F/A(d, D)   # N /mm^2

Ujs = df[(df[:,1] .>= start_t) .&& (df[:, 1] .<= stop_t), 2] # [V]
Uj = mean(Ujs)  # V

ϵ = MBR/1000 * N * Uj/V    # mV/V * () * V/V = () = m/m
E = σ/ϵ                    # N/mm^2 /()

@printf "A:\t%8.4f\tmm^2\n" A(d, D)
@printf "F:\t%8.4f\tN\n" F
@printf "σ:\t%8.4f\tN/mm^2\n" σ 
@printf "ϵ:\t%.3e\tm/m\n" ϵ 
@printf "E:\t%.3f\tN/mm^2\n" E


