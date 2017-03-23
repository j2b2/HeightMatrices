include("hm.jl")

h=asm_to_hm([0 0 1 0; 1 0 -1 1; 0 1 0 0; 0 0 1 0])
hm_to_asm(h)
h2=inflate(h)
alpha(h)

h=backward_sample(128)
u=fpl_arcs(h)
v=fpl_paths(u,128)
println(sort([length(t)-1 for t in v]))
println(latex_arcs(u))
large=[(i,length(t)-1) for (i,t) in enumerate(v) if length(t)>300]
sort(large,by=x->x[2])

i=65;println(latex_path(v[i]))
v[i][[1,end]]

mean(length(a) for a in u)
sum(length(a)-1 for a in u)
2^14

d=testsample(forward_sample,3,11200)

using BenchmarkTools
@benchmark six_vertex(h)
@benchmark fpl(h)

@time forward_sample(32)
@time backward_sample(64)
@time backward_sample(128)

@code_native boundary(5)
@code_warntype boundary(5)

(3670-256)*4/pi
(942-128)*4/pi