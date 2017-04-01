include("hm.jl")

h=asm_to_hm([0 0 1 0; 1 0 -1 1; 0 1 0 0; 0 0 1 0])
hm_to_asm(h)
h2=inflate(h)
alpha(h)
p4=corners(six_vertex(h))
println(p4)
[sum(p) for p in p4]
14731/2^16
1-pi/4

n=64
h=backward_sample(n)
u=fpl_arcs(h)
v=fpl_paths(u,n)
println(sort([length(t)-1 for t in v]))
println(latex_arcs(u))
large=[(i,length(t)-1) for (i,t) in enumerate(v) if length(t)>300]
sort(large,by=x->x[2])

v=fpl_paths(u,n,circuits=true)
v[65]

i=65;println(latex_path(v[i]))
v[i][[1,end]]

mean(length(a)-1 for a in u)
sum(length(a)-1 for a in u)
2^14
d=testsample(forward_sample,3,11200)

using BenchmarkTools
@benchmark six_vertex(h)
@benchmark fpl_arcs(h)
@benchmark fpl_paths(u,n)
@benchmark inflate(h)

@time forward_sample(32)
@time backward_sample(64)
@time backward_sample(128)

@code_native boundary(5)
@code_warntype boundary(5)
