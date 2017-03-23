module hm

function boundary(n::Int)
    h = zeros(Int, n, n)
    for i in 1:n
        h[1,i] = i-1
        h[i,1] = i-1
        h[n,i] = n-i
        h[i,n] = n-i
    end
    h
end

function min_hm(n::Int)
    h = zeros(Int, n+1, n+1)
    for k = 1:n
        for i = 1:n+1-k
            h[i,i+k] = k
            h[i+k,i] = k
        end
    end
    h
end

function max_hm(n::Int)
    h = zeros(Int, n+1, n+1)
    for i = 1:n+1
        h[i,n+2-i] = n
    end
    for k = 1:n-1
        for i = 1:k+1
            h[i,k+2-i] = k
            h[n+2-i,n-k+i] = k
        end
    end
    h
end

function join_hm(h1::Matrix{Int}, h2::Matrix{Int})
    h = copy(h1)
    for k in eachindex(h)
        x = h2[k]
        h1[k] < x && (h[k] = x)
    end
    h
end

function meet_hm(h1::Matrix{Int}, h2::Matrix{Int})
    h = copy(h1)
    for k in eachindex(h)
        x = h2[k]
        x < h1[k] && (h[k] = x)
    end
    h
end

function asm_to_hm(A::Matrix{Int})
    n = size(A,1)
    h = boundary(n+1)
    for i in 2:n
        for j in 2:n
            if A[i-1,j-1] == 0
                h[i,j] = h[i,j-1]+h[i-1,j]-h[i-1,j-1]
            else
                h[i,j] = h[i-1,j-1]
            end
        end
    end
    h
end

function hm_to_asm(h::Matrix{Int})
    n = size(h,1) - 1
    A = zeros(Int, n, n)
    for i in 1:n
        for j in 1:n
            d1 = h[i,j+1] - h[i,j]
            d2 = h[i+1,j+1] - h[i+1,j]
            (d1 + d2 == 0) && (A[i,j] = d1)
        end
    end
    A
end

function six_vertex(h::Matrix{Int})
    n = size(h,1) - 1
    T = zeros(Int, n, n)    # matrix of tiles
    for i in 1:n
        for j in 1:n
            tile = view(h,i:i+1,j:j+1)
            x = tile[1]
            k = 1
            for t in 2:4
                y = tile[t]
                if y < x
                    x = y
                    k = t
                end
            end
            tile[5-k] == x && (k += 4)
            T[i,j] = k
        end
    end
    T
end

immutable Arrow
    source::Vector{Int}
    direction::Vector{Int}
end

function Base.show(io::IO, a::Arrow)
    print(io, a.source, "->", a.direction)
end

function fpl_arrows(h::Matrix{Int}; anti::Bool = false)
    zero = anti?1:0
    T = six_vertex(h)
    n = size(T,1)
    fa = Vector{Arrow}()
    for i in 1:n
        for j in 1:n
            t = T[i,j]
            if (i+j)%2 == zero
                t in (1,3,5) && push!(fa,Arrow([i,j],[-1,0]))
                t in (2,4,5) && push!(fa,Arrow([i,j],[1,0]))
            else
                t in (1,2,5) && push!(fa,Arrow([i,j],[0,-1]))
                t in (3,4,5) && push!(fa,Arrow([i,j],[0,1]))
            end
        end
    end
    fa
end

typealias Point Tuple{Int,Int}
typealias Path Vector{Point}

function fpl_arcs(h::Matrix{Int}; anti::Bool = false)
    zero = anti?1:0
    T = six_vertex(h)
    n = size(T,1)
    arcs = Vector{Path}()
    for i in 1:n
        for j in 1:n
            T[i,j] != 5 && continue
            for d in (-1,1)
                a = Path([(i,j)])
                i1,j1 = i,j
                if (i+j)%2 == zero
                    j1 += d
                    even = false
                else
                    i1 += d
                    even = true
                end
                push!(a,(i1,j1))
                while 1 <= i1 <= n && 1 <= j1 <= n
                    t = T[i1,j1]
                    t == 6 && break
                    if even
                        if t==1 || t==3
                            j1 -= 1
                        else
                            j1 += 1
                        end
                    else
                        if t==1 || t==2
                            i1 -= 1
                        else
                            i1 += 1
                        end
                    end
                    push!(a,(i1,j1))
                    even = !even
                end
                push!(arcs,a)
            end
        end
    end
    arcs
end

function borderpoints(n::Int)
  a = n%2 == 0 ? 1 : 2
  u = [[(i,0) for i in 1:2:n]; [(n+1,j) for j in a:2:n]]
  a = n%2 == 0 ? n : n-1
  u = [u; [(i,n+1) for i in n:-2:1]; [(0,j) for j in a:-2:1]]
end

function fpl_paths(arc::Vector{Path}, n::Int)
  d1 = Dict{Point,Vector{Int}}()
  d2 = Dict{Point,Vector{Int}}()
  for (i,a) in enumerate(arc)
    p = a[1]
    if haskey(d1,p)
      d1[p][2] = i
    else
      d1[p] = [i,i]
    end
    p = a[end]
    if haskey(d2,p)
      d2[p][2] = i
    else
      d2[p] = [i,i]
    end
  end
  visited = falses(arc)
  v = Vector{Path}()
  for p in borderpoints(n)
    i = d2[p][1]
    visited[i] && continue
    u = reverse(arc[i])
    visited[i] = true
    forward = true
    p = u[end]
    while 1<=p[1]<=n && 1<=p[2]<=n
      i,j = forward ? d1[p] : d2[p]
      visited[i] && (i = j)
      a = arc[i]
      visited[i] = true
      forward || (a =reverse(a))
      u = vcat(u, a[2:end])
      p = a[end]
      forward = !forward
    end
    push!(v,u)
  end
  v
end

function latex_arcs(arcs::Vector{Path})
    command = ""
    for a in arcs
        row1,col1 = a[1]
        row2,col2 = a[2]
        if row1==row2
            col1 += (col2-col1)*0.1
        else
            row1 += (row2-row1)*0.1
        end
        line = "\\draw [arc] ($col1,$(-row1)) -- "
        a2 = a[2:end]   # pour Juno !!!
        for p in a2
            row, col = p
            x = col
            y = -row
            line *= "($x,$y) -- "
        end
        line = line[1:end-4] * ";\n"
        command *= line
    end
    command
end

function latex_path(trail::Path)
    command = "\\draw [path] "
    for p in trail
      row, col = p
      x = col
      y = -row
      command *= "($x,$y) -- "
    end
    command = command[1:end-4] * ";\n"
end

function corners(T::Matrix{Int})
    n = size(T,1)
    p1 = Vector{Int}()
    p = zeros(Int,n)
    for i in 1:n
        j = 1
        while T[i,j] == 1
            j += 1
        end
        j == 1 && break
        push!(p1, j-1)
        p[j-1] += 1
    end
    p2 = Vector{Int}()
    for i in 1:n
        j = n
        while T[i,j] == 2
            j -= 1
        end
        j == n && break
        push!(p2, n-j)
        p[n-j] += 1
    end
    p3 = Vector{Int}()
    for i in n:-1:1
        j = 1
        while T[i,j] == 3
            j += 1
        end
        j == 1 && break
        push!(p3, j-1)
        p[j-1] += 1
    end
    p4 = Vector{Int}()
    for i in n:-1:1
        j = n
        while T[i,j] == 4
            j -= 1
        end
        j == n && break
        push!(p4, n-j)
        p[n-j] += 1
    end
    p1,p2,p3,p4
end

function alpha(h::Matrix{Int})
    A = hm_to_asm(h)
    count(i->i<0, A)
end

function inflate(h::Matrix{Int})
    n = size(h,1)
    hplus = boundary(n+1)
    for i in 2:n
        for j in 2:n
            x = h[i,j-1]
            y = h[i,j]
            if x < y
                hplus[i,j] = y
                continue
            end
            x = h[i-1,j-1]
            y = h[i-1,j]
            if y < x
                hplus[i,j] = x
            else
                hplus[i,j] = -1
            end
        end
    end
    hplus
end

function deflate(h::Matrix{Int})
    n = size(h,1)
    hminus = boundary(n-1)
    for i in 2:n-2
        for j in 2:n-2
            x = h[i,j]
            y = h[i,j+1]
            if x < y
                hminus[i,j] = x
                continue
            end
            x = h[i+1,j]
            y = h[i+1,j+1]
            if y < x
                hminus[i,j] = y
            else
                hminus[i,j] = -1
            end
        end
    end
    hminus
end

function segment_bottom(h::Matrix{Int})
    h2 = copy(h)
    i = find(h .< 0)
    h2[i] = h2[i .- 1] .- 1
    h2
end

function segment_top(h::Matrix{Int})
    h2 = copy(h)
    i = find(h .< 0)
    h2[i] = h2[i .- 1] .+ 1
    h2
end

function segment_elt(h::Matrix{Int}, k::Int)
    h2 = copy(h)
    i = find(h .< 0)
    # eps .= 2 .* Base.digits(k, 2, length(i)) .- 1
    eps = 2 * Base.digits(k-1, 2, length(i)) - 1
    h2[i] = h2[i .- 1] .+ eps
    h2
end

function segment_rand(h::Matrix{Int})
    h2 = copy(h)
    i = find(h .< 0)
    eps = rand([-1,1], length(i))
    h2[i] = h2[i .- 1] .+ eps
    h2
end

function rand_inflations(n)
    h = [0 1; 1 0]
    for i = 1:n-1
        h = segment_rand(inflate(h))
    end
    h
end

function dict_hm(n::Int)
    h = [0 1; 1 0]
    D = [Dict{Matrix{Int}, Int}(h => 1)]
    for k = 2:n
        push!(D,Dict{Matrix{Int}, Int}())
        d = D[k]
        for h in keys(D[k-1])
            seg = inflate(h)
            j = count(i->i<0,seg)
            for i in 1:2^j
                h1 = segment_elt(seg,i)
                if haskey(d,h1)
                    d[h1] += 1
                else
                    d[h1] = 1
                end
            end
        end
    end
    D
end

function toggle!(h::Matrix{Int}, i, j, delta)
    y = h[i-1,j]
    if y == h[i+1,j] && y == h[i,j-1] && y == h[i,j+1]
        h[i,j] = y + delta
    end
end

function markov_coupled!(h1::Matrix{Int}, h2::Matrix{Int})
    n = size(h1,1)
    for parity in 0:1
        for j in 2:n-1
            for i in 2:n-1
                if (i+j)%2 == parity
                    delta = rand([-1,1])
                    # print("$delta ")
                    toggle!(h1, i, j, delta)
                    toggle!(h2, i, j, delta)
                end
            end
        end
    end
end

function forward_sample(n; verbose=0)
    h1, h2 = min_hm(n),max_hm(n)
    k = 0
    while h1 != h2
        k += 1
        markov_coupled!(h1,h2)
        if n<8 && verbose>1
            println("$h1 $k")
            println("$h2")
        end
    end
    verbose>0 ? (h1,k) : h1
end

function backward_sample(n; verbose=0)
    const pmax = 10
    seed = rand(UInt32, pmax)
    # n2 = div(n*n, 4)
    n2 = div(n*n, 2)
    r = 4
    while r < n2; r *= 2 end
    run = [r]
    for p in 1:pmax-1
        push!(run, r)
        r *= 2
    end
    for pass in 1:pmax
        p = pass
        h1, h2 = min_hm(n),max_hm(n)
        while p > 0
            srand(seed[p])
            r = run[p]
            verbose>1 && println("$p, $r :")
            for k in 1:r
                markov_coupled!(h1,h2)
                verbose>1 && println()
            end
            p -= 1
        end
        h1 == h2 && return verbose>0 ? (h1, run[pass:-1:1]) : h1
    end
end

function testsample(sample, n, k)
    d = Dict{Matrix{Int}, Int}()
    for i in 1:k
        h,t = sample(n)
        h = hm_to_asm(h)
        if haskey(d,h)
            d[h]+=1
        else
            d[h]=1
        end
    end
    d
end

function delta_list(n)
    u = [()]
    for i in 1:n
        v = [(-1,x...) for x in u]
        u = [v; [(1,x...) for x in u]]
    end
    u
end

function print_matrix(h::Matrix{Int})
    sup = 1 + maximum(h)
    w = 1 + ceil(Int, log10(sup))
    m, n = size(h)
    for i in 1:m
        for j in 1:n
            if w < 3
                @printf("%2d", h[i,j])
            elseif w < 4
                @printf("%3d", h[i,j])
            else
                @printf("%4d", h[i,j])
            end
        end
        println()
    end
end

end # module
