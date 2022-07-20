

class OrderedMultiSet
  include Enumerable

  def self.[](ar)
    self.new(ar)
  end

  BucketRatio = 50
  RebuildRatio = 170

  def initialize(ar = nil)
    ar = [] unless ar
    ar = ar.sort unless (0...ar.size.pred).all? {|i| ar[i] <= ar[i+1]}
    __build(ar)
  end

  # 要素数を返す
  def size
    @size
  end

  # 要素xを追加する
  def add(x)
    if @size == 0
      @a = [[x]]
      @size = 1
      return 
    end
    a = __find_bucket(x)
    i = a.bsearch_index {|aj| aj >= x} || a.size
    a.insert(i, x)
    @size += 1
    __build if a.size > @a.size * RebuildRatio
    true
  end

  # 要素xを１個削除する
  def delete(x)
    return if @size == 0
    a = __find_bucket(x)
    i = a.bsearch_index {|aj| aj >= x}
    return false if !i || a[i] != x
    a.delete_at(i)
    @size -= 1
    __build if a.size == 0
    true
  end

  # 要素xを全部削除
  def delete_all(x)
    count(x).times { delete(x) }
  end

  # 要素xが存在するか確認する
  def include?(x)
    return false if @size == 0
    a = __find_bucket(x)
    i = a.bsearch_index {|aj| aj >= x} 
    i && a[i] == x
  end

  # 数える
  def count(x)
    return self.count_lteq(x) - self.count_lt(x)
  end

  # x番目に小さい要素を取得(0始まり)
  def nth(x)
    raise IndexError.new if x < 0
    @a.each do |a|
      return a[x] if x < a.size
      x -= a.size
    end
    raise IndexError.new
  end

  # x番目に大きい要素を取得(0始まり)
  def nth_larger(x)
    raise IndexError.new if x < 0
    x =  @size - 1 - x
    @a.each do |a|
      return a[x] if x < a.size
      x -= a.size
    end
    raise IndexError.new
  end


  # xより大きい最も近い値(less than)
  def lt(x)
    @a.reverse_each do |a|
      return a[(a.bsearch_index {|aj| aj >= x}||a.size) - 1] if a[0] < x
    end
    nil
  end
  # x以下で最も近い値(less than or equal)
  def lteq(x)
    @a.reverse_each do |a|
      return a[(a.bsearch_index {|aj| aj > x}||a.size)  - 1] if a[0] <= x
    end
    nil
  end

  # xより大きく最も近い値(greater than)
  def gt(x)
    @a.each do |a|
      return a[a.bsearch_index {|aj| aj > x}] if a[-1] > x
    end
    nil
  end
  
  # x以上で最も近い値(greater than or equal)
  def gteq(x)
    @a.each do |a|
      return a[a.bsearch_index {|aj| aj >= x}] if a[-1] >= x
    end
    nil
  end

  # xより小さい要素数を数える。(count less than)
  def count_lt(x)
    ans = 0
    @a.each do |a|
      return ans + a.bsearch_index {|aj| aj >= x} if a[-1] >= x
      ans += a.size
    end
    ans
  end

  # x以下の要素数を数える。(count less than or equal)
  def count_lteq(x)
    ans = 0
    @a.each do |a|
      return ans + a.bsearch_index {|aj| aj > x} if a[-1] > x
      ans += a.size
    end
    ans
  end

  # xより大きい要素を数える。(count greater than)
  def count_gt(x)
    self.size - count_lteq(x)
  end

  # x以上の要素を数える (count greater than or equal)
  def count_gteq(x)
    self.size - count_lteq(x.pred)
  end

  # eachメソッド
  def each(&block)
    @a.each do |a|
      a.each do |ai|
        yield ai
      end
    end
  end

  # 最大
  def max
    return nil if @size == 0
    @a.last.last
    #self.nth(@size.pred)
  end

  # 最小
  def min
    return nil if @size == 0
    @a.first.first
    #self.nth(0)
  end

  # 最小を取得の上、取り除く
  def shift
    return nil if size == 0
    ans = min
    delete(ans) if ans
    ans
  end

  # 最大を取得の上取り除く
  def pop
    return nil if size == 0
    ans = max
    delete(ans) if ans
    ans
  end

  def inspect
    "OrderedMultiSet[#{self.to_a.join(", ")}]"
  end


  private

  def __build(a = nil)
    a = @a.flatten unless a
    @size = a.size
    bucket_size = Math.sqrt(@size.to_f / BucketRatio).ceil.to_i
    @a = (0...bucket_size).map {|i|
      a[(@size * i / bucket_size)...(@size*(i+1)/bucket_size)]
    }
  end

  def __find_bucket(x)
    @a.each do |a|
      return a if x <= a[-1]
    end
    @a[-1]
  end
end




# 使用時はこの上の部分をコピペする
#-------------------------------------------
# 以下使用例
# 試作バージョン1 2022-06-01
# 試作バージョン2 2022-06-06
#   * rank rrankを削除(無意味なので)
#   * count_gt, count_gteqを追加 
# 参考: https://github.com/tatyam-prime/SortedSet/blob/main/SortedSet.py

a = [4, 4, 1, 6, 7,20]
set = OrderedMultiSet.new(a)
# 配列を指定しないと空の集合
# set = OrderedMultiSet.new
p set
set.add(5) # 5 を追加
set.add(6) # 6 を追加
set.delete(7) # 7を追加
p set
p set.size # 全体の個数
p set.nth(1)
p set.count(4)  # 4 個数
p set.count_lt(4)  # 4未満の個数
p set.count_lteq(4)  # 4以下の個数
p set.lt(4)  # 4より小さい最も近い数
p set.lteq(4)  # 4以下の最も近い数
p set.gt(4)  # 4より小さい最も近い数
p set.gteq(4)  # 4以上の最も近い数
p set
p set.min  # 最小
p set.max  # 最大
p set.shift  # 最小を取り出して、削除
p set.pop  # 最大を取り出して、削除
p set
puts "min"
p set.min  # 最小
puts "max"
p set.max  # 最大
p set.shift  # 最小を取り出して、削除
p set.pop  # 最大を取り出して、削除
p set
p set.min  # 最小
p set.max  # 最大
p set.shift  # 最小を取り出して、削除
p set.pop  # 最大を取り出して、削除
p set
p set.min  # 最小
p set.max  # 最大

# Enumerableのメソッドは全部使える
# https://docs.ruby-lang.org/ja/latest/class/Enumerable.html 
#
# 以下、メソッドが正常のチェックの
def validity_check1
  a = Array.new(100) { rand(1..100) }
  set = OrderedMultiSet.new(a)
  1000.times do 
    x = rand(-100..300)
    a.push x
    set.add x
    if a.max != set.max
      puts "Error"
      exit
    end
    if a.min != set.min
      puts "Error"
      exit
    end
  end
  puts "Check1 OK"
end
def validity_check2
  a = Array.new(100) { rand(1..100) }
  set = OrderedMultiSet.new(a)
  1000.times do 
    x = rand(-100..300)
    a.push x
    set.add x
    a.sort!
    i = rand(0..100)
    if a.count {|x| x <= i} != set.count_lteq(i)
      puts "Error"
      exit
    end
    if a.count {|x| x < i} != set.count_lt(i)
      puts "Error"
      exit
    end
    if a.count {|x| x > i} != set.count_gt(i)
      puts "Error"
      exit
    end
    if a.count {|x| x >= i} != set.count_gteq(i)
      puts "Error"
      exit
    end
    if a.count(i) != set.count(i)
      puts "Error"
      exit
    end
  end
  puts "Check2 OK"
end
def validity_check3
  a = Array.new(100) { rand(1..100) }
  set = OrderedMultiSet.new(a)
  1000.times do 
    x = rand(-100..300)
    a.push x
    set.add x
    a.sort!
    i = rand(0..100)
    if a[i] != set.nth(i)
      puts "nth Error"
      exit
    end
    if a[-(i+1)] != set.nth_larger(i)
      puts "Error"
      exit
    end
  end
  puts "Check3 OK"
end
validity_check1
validity_check2
validity_check3


