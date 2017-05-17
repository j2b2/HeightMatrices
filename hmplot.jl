import PyPlot
plt = PyPlot
plt.ion();plt.figure("ASM", figsize=(10,10))
plt.subplots_adjust(left=0.04, right=0.98, bottom=0.03, top=0.97)

function plot_fpl(h::Matrix{Int};
    color = "blue", linewidth = 0.8, anti = false, circuit = true)
    n = size(h, 1)
    plt.axis([-0.5, n + 0.5, -0.5, n + 0.5])
    u = fpl_arcs(h, anti = anti)
    circuit || (u = fpl_paths(u, n - 1))
    for arc in u
        plt.plot([p[2] for p in arc],[n - p[1] for p in arc],
            color = color, linewidth = linewidth)
    end
    return u
end

hue = ["red","green","blue"]
function plot_path(h::Matrix{Int}, range_paths = 1:3, color = "";
    linewidth = 1.4, circuit = true)
    n = size(h, 1) - 1
    plt.axis([-0.5, n + 1.5, -0.5, n + 1.5])
    u = fpl_arcs(h)
    v = fpl_paths(u, n, circuit = circuit)
    rated = sort([(i,length(p)-1) for (i,p) in enumerate(v)],
        by = x->x[2],rev = true)
    lr = rated[range_paths]
    isa(lr, Array) && (lr = [r[2] for r in rated[range_paths]])
    plt.title("$lr")
    for i in range_paths
        j = rated[i][1]
        path = v[j]
        c = color
        if c == ""
            t = 1 + (i-1) % length(hue)
            c = hue[t]
        end
        plt.plot([p[2] for p in path], [n+1-p[1] for p in path],
            color = c, linewidth = linewidth)
    end
    return rated
end

hue6 = ["grey", "gold", "cyan", "green", "red", "blue"]
function plot_vertices(h::Matrix{Int}, range_vertices = 5:6; markersize = 0)
    n = size(h, 1)
    plt.axis([-0.5, n + 0.5, -0.5, n + 0.5])
    markersize == 0 && (markersize = div(1000, n))
    T = six_vertex(h)
    for t in range_vertices
        y, x, b = findnz(T .== t)
        plt.scatter(x, n-y, s=markersize, color=hue6[t])
    end
    return T
end

function plot_toggles(h::Matrix{Int}, parity = 2; markersize = 0)
    n = size(h, 1)
    plt.axis([-0.5, n + 0.5, -0.5, n + 0.5])
    markersize == 0 && (markersize = div(1000, n))
    if parity in [0, 2]
        T = toggles(h, 0)
        y, x, t = findnz(T)
        plt.scatter(x - 0.5, n + 0.5 - y, s = markersize, color = "red")
    end
    if parity in [1, 2]
        T = toggles(h, 1)
        y, x, t = findnz(T)
        plt.scatter(x - 0.5, n + 0.5 - y, s = markersize, color = "blue")
    end
    return T
end
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
