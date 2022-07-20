# Original: https://github.com/universato/ac-library-rb/blob/main/lib/priority_queue.rb
# Slightly changed class strcture from original version
#
# Priority Queue
# Reference: https://github.com/python/cpython/blob/master/Lib/heapq.py
#
class PriorityQueue
  # By default, the priority queue returns the maximum element first.
  # If a block is given, the priority between the elements is determined with it.
  # For example, the following block is given, the priority queue returns the minimum element first.
  # `GeneralPriorityQueue.new { |x, y| x < y }`
  #
  # A heap is an array for which a[k] <= a[2*k+1] and a[k] <= a[2*k+2] for all k, counting elements from 0.
  def initialize(array = [], &comp)
    @heap = array
    raise "Block is necessary" unless @comp
    heapify
  end

  attr_reader :heap

  # Push new element to the heap.
  def push(item)
    shift_down(0, @heap.push(item).size - 1)
  end

  alias << push
  alias append push

  # Pop the element with the highest priority.
  def pop
    latest = @heap.pop
    return latest if empty?

    ret_item = heap[0]
    heap[0] = latest
    shift_up(0)
    ret_item
  end

  # Get the element with the highest priority.
  def get
    @heap[0]
  end

  alias top get

  # Returns true if the heap is empty.
  def empty?
    @heap.empty?
  end

  private

  def heapify
    (@heap.size / 2 - 1).downto(0) { |i| shift_up(i) }
  end

  def shift_up(pos)
    end_pos = @heap.size
    start_pos = pos
    new_item = @heap[pos]
    left_child_pos = 2 * pos + 1

    while left_child_pos < end_pos
      right_child_pos = left_child_pos + 1
      if right_child_pos < end_pos && @comp.call(@heap[right_child_pos], @heap[left_child_pos])
        left_child_pos = right_child_pos
      end
      # Move the higher priority child up.
      @heap[pos] = @heap[left_child_pos]
      pos = left_child_pos
      left_child_pos = 2 * pos + 1
    end
    @heap[pos] = new_item
    shift_down(start_pos, pos)
  end

  def shift_down(star_pos, pos)
    new_item = @heap[pos]
    while pos > star_pos
      parent_pos = (pos - 1) >> 1
      parent = @heap[parent_pos]
      break if @comp.call(parent, new_item)

      @heap[pos] = parent
      pos = parent_pos
    end
    @heap[pos] = new_item
  end
end

class PriorityQueue::Max < PriorityQueue
  def initialize(array = [])
    @heap = array
    heapify
  end
  def shift_up(pos)
    end_pos = @heap.size
    start_pos = pos
    new_item = @heap[pos]
    left_child_pos = 2 * pos + 1

    while left_child_pos < end_pos
      right_child_pos = left_child_pos + 1
      if right_child_pos < end_pos && @heap[right_child_pos] > @heap[left_child_pos]
        left_child_pos = right_child_pos
      end
      # Move the higher priority child up.
      @heap[pos] = @heap[left_child_pos]
      pos = left_child_pos
      left_child_pos = 2 * pos + 1
    end
    @heap[pos] = new_item
    shift_down(start_pos, pos)
  end

  def shift_down(star_pos, pos)
    new_item = @heap[pos]
    while pos > star_pos
      parent_pos = (pos - 1) >> 1
      parent = @heap[parent_pos]
      break if parent > new_item

      @heap[pos] = parent
      pos = parent_pos
    end
    @heap[pos] = new_item
  end

  def max
    @heap[0]
  end
end

class PriorityQueue::Min < PriorityQueue
  def initialize(array = [])
    @heap = array
    heapify
  end
  def shift_up(pos)
    end_pos = @heap.size
    start_pos = pos
    new_item = @heap[pos]
    left_child_pos = 2 * pos + 1

    while left_child_pos < end_pos
      right_child_pos = left_child_pos + 1
      if right_child_pos < end_pos && @heap[right_child_pos] < @heap[left_child_pos]
        left_child_pos = right_child_pos
      end
      # Move the higher priority child up.
      @heap[pos] = @heap[left_child_pos]
      pos = left_child_pos
      left_child_pos = 2 * pos + 1
    end
    @heap[pos] = new_item
    shift_down(start_pos, pos)
  end

  def shift_down(star_pos, pos)
    new_item = @heap[pos]
    while pos > star_pos
      parent_pos = (pos - 1) >> 1
      parent = @heap[parent_pos]
      break if parent < new_item

      @heap[pos] = parent
      pos = parent_pos
    end
    @heap[pos] = new_item
  end

  def min
    @heap[0]
  end
end


##################################
# 使い方
# 以下の２つをがある。
# PriorityQueue::Min.new
# PriorityQueue::Max.new
# Minの方は最初値を取得、Maxは最大値を取得できる

q = PriorityQueue::Min.new
# または配列から
# a = [3,5,2,4,9]
# q = PriorityQueue::Min.new(a)

# 5を追加
q.push 5
# 10を追加
q.push 10
# 2を追加
q.push 2
# 7を追加
q.push 7
# 最小値求める(削除はしない)
p q.min
# 最小値求めてそれを削除
p q.pop
# 8を追加
q.push 8
# 最小値求めてそれを削除
p q.pop
# 最小値求めてそれを削除
p q.pop
# 最小値求めてそれを削除
p q.pop
# 最小値求めてそれを削除
p q.pop

q = PriorityQueue::Max.new
# または配列から
# a = [3,5,2,4,9]
# q = PriorityQueue::Min.new(a)

q.push 5
q.push 10
q.push 2
q.push 7
# 最大値求める(削除はしない)
p q.max
# 最大値求めてそれを削除
p q.pop
# 8を追加
q.push 8
# 最大値求めてそれを削除
p q.pop
# 最大値求めてそれを削除
p q.pop
# 最大値求めてそれを削除
p q.pop
# 最大値求めてそれを削除
p q.pop
