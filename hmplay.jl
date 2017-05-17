include("hm.jl")
# julia set working module -> hm
using HDF5
h=h5read("save/256f.h5","hm")

@time h=backward_sample(256,4,verbose=1)
h5write("save/256-04.h5","hm",h)
countnz.([toggles(h,i) for i in 0:1])
[alpha(h,i) for i in [-1,1]]

include("hmplot.jl")
plot_fpl(h,circuit=false)
plot_path(h,1:6,circuit=false)
u=plot_path(h,7:11,"gold",circuit=false)
reshape(u[1:30],5,6)
plot_vertices(h,5:6)
plot_vertices(h,2:3)
plot_toggles(h,markersize=12)
plot_toggles(h)
plt.cla()

hue=["red","green","blue","green","blue"]

h0=copy(h)
for i in 1:256
    plt.cla()
    gyration!(h)
    plot_path(h,1:5)
    plt.pause(0.1)
end

c=corners(h);sum(sum.(c))/2^16
1-pi/4
center(h,64),center(h)
c

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

@code_native boundary(5)
@code_warntype boundary(5)

h8=backward_sample(8)
plt.cla();plot_fpl(gyration(h8,-1),linewidth=2)
plot_fpl(h8,color="red")
plot_fpl(half_gyration(h8,0))
plt.cla()

u=[2,5,1]
sort!(u)
u
