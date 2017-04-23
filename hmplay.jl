include("hm.jl")

d=testsample(backward_sample,5,42900)

include("hmplot.jl")
hue6
n=128
@time h=backward_sample(n,4,verbose=1)
plot_fpl(h)
plot_paths(h,1:7)
plot_paths(h,9,"green")
plot_paths(h,10,"lime")
plot_vertices(h, 5:6)
plot_vertices(h, 2:3)
plot_toggles(h)
plt.cla()
hue=["red","green","blue","red","blue","blue"]

u=fpl_arcs(h)

p4=corners(six_vertex(h))
println(p4)
[sum(p) for p in p4]

n=256
m=24
c=zeros(Int,m,m,6)
begin
    m2=div(m,2)
    n2=div(n,2)
    for k in 1:4
        @time h=backward_sample(n,verbose=1)
        t=view(six_vertex(h), n2-m2+1:n2+m2, n2-m2+1:n2+m2)
        for i in 1:m
            for j in 1:m
                c[i,j,t[i,j]]+=1
            end
        end
        s1=sum(c,1)
        s12=sum(c,(1,2))
        for k in 1:6 println(k,s1[:,:,k],s12[:,:,k]) end
    end
end

s12=sum(c,(1,2))
for k in 1:6 println(k,s1[:,:,k],s12[:,:,k]) end

c12=view(c,7:18,7:18,:)
s1=sum(c12,1)
s12=sum(c12,(1,2))
for k in 1:6 println(k,s1[:,:,k],s12[:,:,k]) end

@time h=backward_sample(64)
using BenchmarkTools
@benchmark six_vertex(h)
@benchmark asm_to_hm(hm_to_asm(h))
@benchmark toggles(h)
print_matrix(h)
print_matrix(toggles(h))


@code_native boundary(5)
@code_warntype boundary(5)

using Primes
factor(11520)
"abc"*"cde"
