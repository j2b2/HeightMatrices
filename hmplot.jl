include("hm.jl")

import PyPlot
plt = PyPlot
plt.ion()
plt.figure("FPL", figsize=(10,10))
plt.subplots_adjust(left=0.02, right=0.98, bottom=0.02, top=0.98)
begin
  plt.cla()
  plt.axis([-0.5, n+1.5, -0.5, n+1.5])
  plt.xticks([])
  plt.yticks([])
  for arc in u
    plt.plot([p[2] for p in arc],[n+1-p[1] for p in arc], color="blue", linewidth=1)
  end
end

n=64
h=backward_sample(n)
u=fpl_arcs(h)
v=fpl_paths(u,n)

rated=sort([(i,length(p)) for (i,p) in enumerate(v)],
  by=x->x[2],rev=true)
println(rated)
col=["red","blue","green","green","blue","green"]

for i in 1:6
  j = rated[i][1]
  path = v[j]
  plt.plot(
    [p[2] for p in path],
    [n+1-p[1] for p in path],
    color=col[i], linewidth=2)
end

t[1][1]
v[14]

using Plots
pyplot()
plot(xlims = (0, n+1), ylims = (0, n+1))
for arc in u
    plot!([p[2] for p in arc],[n+1-p[1] for p in arc],color=:blue,labels="")
end
plot!()

v[[14,52,34]]
