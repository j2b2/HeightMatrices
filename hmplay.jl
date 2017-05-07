include("hm.jl")
# julia working module -> hm
@time h=backward_sample(128,4,verbose=1)
countnz(toggles(h,0))
alpha(h,-1)

include("hmplot.jl")
plot_fpl(h)
plot_path(h,1:9)
plot_path(h,5,"red")
plot_path(h,7,"green")
plot_path(h,4,"blue")
plot_path(h,9,"grey")
plot_vertices(h,5:6)
plot_vertices(h,1:4,markersize=6)
plot_toggles(h,markersize=12)
plt.cla()

hue=["red","green","green","blue","blue","blue","red","green"]
u=fpl_arcs(h)

c=corners(h)

sum(sum.(c))/2^16
1-pi/4
center(h,64)

@time h=backward_sample(64)
using BenchmarkTools
@benchmark six_vertex(h)
@benchmark center(h)
@benchmark asm_to_hm(hm_to_asm(h))
@benchmark toggles(h)
A=hm_to_asm(h)
@benchmark count(i->i<0,A)
@benchmark countnz(A .< 0)
@benchmark countnz(A)

testsample(backward_sample,5,42900)


print_matrix(h)
print_matrix(toggles(h))


@code_native boundary(5)
@code_warntype boundary(5)

using Primes
factor(11520)
"abc"*"cde"
