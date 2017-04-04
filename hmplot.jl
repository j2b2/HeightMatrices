import PyPlot
plt = PyPlot
plt.ion();plt.figure("FPL", figsize=(10,10))
plt.subplots_adjust(left=0.02, right=0.98, bottom=0.02, top=0.98)

function plot_reset(n::Int)
    plt.cla()
    plt.axis([-0.5, n + 1.5, -0.5, n + 1.5])
    plt.xticks([])
    plt.yticks([])
end

function plot_fpl(h::Matrix{Int}; color = "blue", linewidth = 0.8)
    n = size(h, 1) - 1
    u = fpl_arcs(h)
    for arc in u
        plt.plot([p[2] for p in arc],[n+1-p[1] for p in arc],
            color = color, linewidth = linewidth)
    end
end

hue = ["cyan", "gold", "chartreuse", "grey", "red", "blue"]
function plot_vertices(h::Matrix{Int}, range_vertices = 5:6; markersize = 0)
    n = size(h, 1) - 1
    markersize == 0 && (markersize = div(1000, n))
    T = six_vertex(h)
    for i in 1:n
        for j in 1:n
            t = T[i,j]
            t in range_vertices || continue
            plt.scatter(j, n+1-i, s=markersize, color=hue[t])
        end
    end
end
#
#
# rated=sort([(i,length(p)-1) for (i,p) in enumerate(v)],
#   by=x->x[2],rev=true)
# reshape(rated[1:30],5,6)
# hue=["red","blue","green","red","blue","green","green","blue"]
#
# for i in 1:8
#   j = rated[i][1]
#   path = v[j]
#   plt.plot(
#     [p[2] for p in path],
#     [n+1-p[1] for p in path],
#     color=hue[i], linewidth=1.4)
# end
#
# track=(558,"green")
# track=(119,"green")
# track=(222,"blue")
# path=v[track[1]]
# plt.plot(
#   [p[2] for p in path],
#   [n+1-p[1] for p in path],
#   color=track[2], linewidth=1)
#
#
#
# using Plots
# pyplot()
# plot(xlims = (0, n+1), ylims = (0, n+1))
# for arc in u
#     plot!([p[2] for p in arc],[n+1-p[1] for p in arc],color=:blue,labels="")
# end
# plot!()
#
# v[[14,52,34]]
