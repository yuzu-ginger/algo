# 二分探索ラッパー

class Array
    def lt(x)           # x未満の最も近い要素，なければnil
        num = (self.bsearch_index {|i| !(i<x)} || self.size) - 1
        return num < 0 ? nil : self[num]
    end

    def lt_index(x)     # x未満の最も近い要素の場所，なければnil
        num = (self.bsearch_index {|i| !(i<x)} || self.size) - 1
        num = nil if num < 0
        return num
    end

    def lteq(x)         # x以下の最も近い要素，なければnil
        num = (self.bsearch_index {|i| !(i<=x)} || self.size) - 1
        return num < 0 ? nil : self[num]
    end

    def lteq_index(x)   # x以下の最も近い要素の場所，なければnil
        num = (self.bsearch_index {|i| !(i<=x)} || self.size) - 1
        num = nil if num < 0
        return num
    end

    def gt(x)           # xよりの最も近い要素，なければnil
        self.bsearch{|i| i > x} || nil
    end

    def gt_index(x)     # xより大きい最も近い要素の場所，なければnil
        self.bsearch_index{|i| i > x}  || nil
    end

    def gteq(x)         # x以上の最も近い要素，なければnil
        self.bsearch{|i| i >= x} || nil
    end

    def gteq_index(x)   # x以上の最も近い要素の場所，なければnil
        self.bsearch_index{|i| i >= x}  || nil
    end

    def near(x)         # xに最も近い要素
        num = self.bsearch_index{|i| i >= x} || self.size - 1
        num_1 = [num - 1, 0].max
        if (self[num_1] - x).abs >= (self[num] - x).abs
            return self[num]
        else
            return self[num_1]
        end
    end
    
    def near_index(x)   # xに最も近い要素の場所
        num = self.bsearch_index{|i| i >= x} || self.size - 1
        num_1 = [num - 1, 0].max
        if (self[num_1] - x).abs >= (self[num] - x).abs
            return num
        else
            return num_1
        end
    end

    def count_lt(x)     # x未満の個数
        num = self.bsearch_index{|i| i >= x} || self.size
        return [num, 0].max
    end

    def count_lteq(x)   # x以下の個数
        num = self.bsearch_index{|i| i > x} || self.size
        return [num, 0].max
    end

    def count_gt(x)     # xより大きい要素の個数
        num = self.bsearch_index{|i| i > x} || self.size
        return self.size - num
    end

    def count_gteq(x)   # x以上の個数
        num = self.bsearch_index{|i| i >= x} || self.size
        return self.size - num
    end

    def count_teq(*arg) # x以上y以下(x, y)の個数, (Range)の個数
        if arg.size == 2
            num_low = self.bsearch_index{|i| i >= arg[0]} || self.size
            num_up = self.bsearch_index{|i| i > arg[1]} || self.size
        elsif arg.size == 1
            arg = arg[0]
            num_low = self.bsearch_index{|i| i >= arg.begin} || self.size
            if arg.exclude_end? 
                num_up = self.bsearch_index{|i| i >= arg.end} || self.size
            else
                num_up = self.bsearch_index{|i| i > arg.end} || self.size
            end
        end
        return num_up - num_low
    end
end





# 使用時はこの上の部分をコピペする
#-------------------------------------------
# 以下使用例
ar = [1,5,11,12,25]
x = 1
y = 25
p ar

# x未満の最も近いもの，なければnil
p ar.lt(x)           # 要素
p ar.lt_index(x)     # 場所

# x以下の最も近いもの，なければnil
p ar.lteq(x)         # 要素
p ar.lteq_index(x)   # 場所

# xよりの最も近いもの，なければnil
p ar.gt(x)           # 要素
p ar.gt_index(x)     # 場所

# x以上の最も近いもの，なければnil
p ar.gteq(x)         # 要素
p ar.gteq_index(x)   # 場所

# xに最も近いもの
p ar.near(x)         # 要素
p ar.near_index(x)   # 場所

# x未満の個数
p ar.count_lt(x)

# x以下の個数
p ar.count_lteq(x)

# xより大きい要素の個数
p ar.count_gt(x)

# x以上の個数
p ar.count_gteq(x)

# x以上y以下の要素の個数
p ar.count_teq(x, y)
p ar.count_teq(x..y)

# x以上y未満の要素の個数
p ar.count_teq(x...y)