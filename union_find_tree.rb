class UnionFind
    def initialize(n)
        @parents = Array.new(n, -1)
    end
    
    # 根を返す
    def find_root(x)
        return x if @parents[x] < 0
        return @parents[x] = find_root(@parents[x])
    end

    # サイズを返す
    def size(x)
        return -@parents[find_root(x)]
    end

    # 木を併合
    def unite(x, y)
        x = find_root(x)
        y = find_root(y)
        return false if x == y
        # サイズver.
        if size(x) < size(y)
            x, y = y, x
        end
        @parents[x] += @parents[y]
        @parents[y] = x
        return true
    end

    # 同じ木か？
    def same?(x, y)
        return find_root(x) == find_root(y)
    end
end