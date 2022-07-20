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



# 使い方
ar = [1, 2, 4, 5, 8, 2]
acc = Accumulation.new(ar)
p acc
p acc.sum(1, 4)
p acc.sum(3)
p acc.sum(1..4)
p acc.sum(1...4)