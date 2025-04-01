using ArgParse
using CSV, DataFrames
using Printf

const g = 9.81  # N/kg
const N = 2
A(d, D) = missing # TODO implement area


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
        "-MBR"
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

df = CSV.read(stdin, DataFrame)

F = m * g       # N
σ = F/A(d, D)   # N /mm^2

dUs = df[(df[:,1] .>= start_t) .&& (df[:, 1] =<. stop_t), :]
dU = mean(dUs)

ϵ = MBR/1000 * N * dU/V    # mV/V * () * V/V = ()
E = σ/ϵ

@printf "F: %f\nσ: %f\nΔU: %f\nϵ: %f\nE: %f\n" F σ ϵ E
