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

c=zeros(Int,24,24,6)
begin
    n=128
    for k in 1:10
        @time h=backward_sample(n,verbose=1)
        t=view(six_vertex(h), 53:76, 53:76)
        for i in 1:24
            for j in 1:24
                c[i,j,t[i,j]]+=1
            end
        end
    end
end
sum(c)
s1=sum(c,1)
s12=sum(c,(1,2))
for k in 1:6 println(k,s1[:,:,k],s12[:,:,k]) end
s[:,:,1]
sum(c,(1,2))

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
