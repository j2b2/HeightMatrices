# include("hm.jl")
using hm
# julia set working module -> hm
using HDF5
h=h5read("/home/betrema/Julia/ASM/save/256-07.h5","hm")
h=h5read("save/256-07.h5","hm")

@time h=backward_sample(128,4,verbose=1)
h5write("/home/betrema/Julia/ASM/save/128-03.h5","hm",h)
count.(!iszero, [toggles(h,i) for i in 0:1])
count(!iszero, toggles(h,2))/2^16
[alpha(h,i) for i in [-1,1]]
alpha(h,0)/2^16

include("hmplot.jl")
plot_fpl(h, circuit=false)
plot_fpl(h,anti=true,color="red",linewidth = 5)
plot_fpl(h,linewidth = 3)
plot_fpl(h,circuit=false)
plot_path(h,1:4)
u=plot_path(h,4,"gold")
u=plot_path(h,6,"gold",circuit=false)
reshape(u[1:30],5,6)
plot_vertices(h,5:6)
plot_vertices(h,2:3)
plot_toggles(h)
plot_toggles(h,markersize=128)
plot_vertices(h,1:6,markersize=200)
plt.cla()

hue=["red","green","blue","blue"]
hue6 = ["silver", "gold", "cyan", "green", "red", "blue"]

for i in 1:128
    plt.cla()
    gyration!(h,1)
    plot_path(h,1:4)
    plt.pause(0.1)
end

gyration!(h,-1)

c=corners(h);sum(sum.(c))/2^16
1-pi/4
center(h,64),center(h)
c

@time h=backward_sample(64)
using BenchmarkTools
@benchmark six_vertex(h)
@benchmark fpl_arcs(h)
@benchmark asm_to_hm(hm_to_asm(h))
@benchmark toggles(h)
A=hm_to_asm(h)
@benchmark count(i->i<0,A)
@benchmark countnz(A .< 0)
@benchmark countnz(A)

testsample(backward_sample,5,42900)

@code_native boundary(5)
@code_warntype boundary(5)

h=backward_sample(64)
plot_fpl(h,color="red")
plt.cla()
fpl_paths(h)

h=[0 1 2 3 4; 1 2 3 2 3; 2 1 2 3 2; 3 2 1 2 1;4 3 2 1 0]
s=inflate(h)
b=segment_bottom(s)
t=segment_top(s)
r=segment_rand(s)
d=dict_hm(5)
sum(values(d))

deflate(h)
delta_list(3)
