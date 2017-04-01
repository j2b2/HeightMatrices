include("hm.jl")

import PyPlot
plt = PyPlot
plt.ion();plt.figure("FPL", figsize=(10,10))
plt.subplots_adjust(left=0.02, right=0.98, bottom=0.02, top=0.98)
begin
  plt.cla()
  plt.axis([-0.5, n+1.5, -0.5, n+1.5])
  plt.xticks([])
  plt.yticks([])
  for arc in u
    plt.plot([p[2] for p in arc],[n+1-p[1] for p in arc],
      color="blue", linewidth=0.8)
  end
end

n=128
@time h=backward_sample(n,verbose=1)
u=fpl_arcs(h)
v=fpl_paths(u,n,circuits=true)
alpha(h)

rated=sort([(i,length(p)-1) for (i,p) in enumerate(v)],
  by=x->x[2],rev=true)
reshape(rated[1:30],5,6)
hue=["red","green","green","blue","blue","blue","blue","green"]

for i in 1:8
  j = rated[i][1]
  path = v[j]
  plt.plot(
    [p[2] for p in path],
    [n+1-p[1] for p in path],
    color=hue[i], linewidth=1.4)
end

track=(119,"green")
track=(119,"red")
track=(179,"blue")
path=v[track[1]]
plt.plot(
  [p[2] for p in path],
  [n+1-p[1] for p in path],
  color=track[2], linewidth=1.4)

using Plots
pyplot()
plot(xlims = (0, n+1), ylims = (0, n+1))
for arc in u
    plot!([p[2] for p in arc],[n+1-p[1] for p in arc],color=:blue,labels="")
end
plot!()

v[[14,52,34]]
2*(1755+128)
