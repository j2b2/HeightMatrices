include("hm.jl")

h=asm_to_hm([0 0 1 0; 1 0 -1 1; 0 1 0 0; 0 0 1 0])
hm_to_asm(h)
h2=inflate(h)
alpha(h)
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

using Primes
factor(11520)

include("hmplot.jl")
hue
n=128
@time h=backward_sample(n,verbose=1)
plot_reset(n)
plot_fpl(h)
plot_vertices(h, markersize=20)
plot_vertices(h, [1,4,5,6])
plot_vertices(h, 2)
hue[3]="green"
