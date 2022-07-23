# 累積和
class Array
    def accumulate
        ar = [self[0]]
        for i in 1...self.size
            ar[i] = ar[i-1] + self[i]
        end
        return ar
    end
end

class Accumulation
    def initialize(ar)
        @ar = ar.accumulate
        @ar.unshift 0
    end
    def sum(*arg)
        if arg.size == 2
            return @ar[arg[1]+1] - @ar[arg[0]]
        elsif arg.size == 1
            arg = arg[0]
            if arg.is_a?(Range)
                if arg.exclude_end?
                    return @ar[arg.end] - @ar[arg.begin]
                else
                    return @ar[arg.end+1] - @ar[arg.begin]
                end
            elsif arg.is_a?(Integer)
                return @ar[arg+1]
            end
        end
    end
end



# 使用時はこの上の部分をコピペする
#-------------------------------------------
# 以下使用例
ar = [1, 2, 4, 5, 8, 2]
p ar.accumulate             # 累積和の配列を返す
acc = Accumulation.new(ar)  # 累積和計算用のオブジェクト作成
p acc
p acc.sum(1, 4)             # ar[1]からar[4]までの合計
p acc.sum(3)                # ar[0]からar[3]までの合計
p acc.sum(1..4)             # ar[1]からar[4]までの合計
p acc.sum(1...4)            # ar[1]からar[3]までの合計