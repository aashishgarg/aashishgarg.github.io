---
layout: post
share: true
title: "DS programs in ruby"
modified: 2018-07-16T08:20:50-04:00
categories: rails
excerpt:
tags: []
image:
  feature:
date: 2018-07-16T08:20:50-04:00
---

#### Linked List

```ruby
class Node
  attr_accessor :next
  attr_reader :value

  def initialize(value)
    @value = value
    @next = nil
  end

  def to_s
    "Node with value: #{@value}"
  end
end

class LinkedList
  attr_accessor :head

  def initialize
    @head = nil
  end

  def append(value)
    node = Node.new(value)
    if @head
      find_tail.next = node
    else
      @head = node
    end
  end

  def find_tail
    node = @head
    return node if !node.next
    while(node = node.next)
      return node if !node.next
    end
  end

  def append_after(target, value)
    node = find(target)
    return unless node
    old_next = node.next
    node.next = Node.new(value)
    node.next.next = old_next
  end

  def delete(value)
    if @head.value == value
      @head = @head.next
      return
    end
    node = find_before(value)
    node.next = node.next.next
  end

  def find(value)
    node = @head
    return false if !node.next
    return node if node.value == value
    while(node = node.next)
      return node if node.value == value
    end
  end

  def find_before(value)
    node = @head
    return false if !node.next
    return @head if @head.next.value == value
    while(node = node.next)
      return node if node.next && node.next.value == value
    end
  end

  def print
    node = @head
    to_be_printed = "#{node.value} "
    while(node = node.next)
      to_be_printed << "-> #{node.value}"
    end
    puts to_be_printed
  end
end

node = Node.new(1)
1.upto(99) do |i|
  eval("Node.last(node).next = Node.new(i + 1)")
end

puts Node.node_list node
puts Node.node_list Node.reverse(node)

```

#### Queue

```ruby

class Queue
  def initialize(size)
    @size = size
    @store = Array.new(@size)
    @head, @tail = @store.length - 1, 0
  end

  def dequeue
    if empty?
      nil
    else
      @tail += 1
      dequeued = @store[@head]
      @store.unshift(nil)
      @store.pop
      dequeued
    end
  end

  def enqueue(element)
    if full? or element.nil?
      nil
    else
      @tail -= 1
      @store[@tail] = element
      self
    end
  end

  def size
    @size
  end

  def tail
    @store[@tail]
  end

  def head
    @store[@head]
  end

  private
  def empty?
    @head == -1 && @tail == 0
  end

  def full?
    @tail.abs == @size
  end
end

```

#### Stack

```ruby

class Stack
  def initialize(size)
    @size = size
    @store = Array.new(@size)
    @top = -1
  end

  def pop
    if empty?
      raise 'StackUnderflow'
    else
      popped = @store[@top]
      @store[@top] = nil
      @top -= 1
      popped
    end
  end

  def push(element)
    if full? || element.nil?
      raise 'StackOverflow'
    else
      @top += 1
      @store[@top] = element
      self
    end
  end

  def size
    @size
  end

  def look
    @store[@top]
  end

  private
  def empty?
    @top == -1
  end

  def full?
    @top == @size - 1
  end
end

```

#### Searching

```ruby

class Searching
  def initialize(array, element)
    @array = Sorting.new(array).bubble_sort
    @element = element
  end

  def binary_search(first = 0, last = @array.length - 1)
    # ---- Complexity ----- #
    # Worst Case Time Complexity [ Big-O ]: O(log n)
    # --------------------- #
    mid = (first + last) / 2
    if @element < @array[first] || @element > @array[last]
      'Element not found'
    else
      if @element < @array[mid]
        binary_search(first, @array[mid])
      elsif @element > @array[mid]
        binary_search(@array[mid], last)
      elsif @element == @array[mid]
        return mid
      end
    end
  end
end

```

#### Sorting

```ruby

class Sorting
  def initialize(array)
    @original_array = array
    @array = array
  end

  def print
    puts '------ Unsorted Array ----'
    puts @original_array.to_s
    puts '------ Sorted Array ------'
    puts @array.to_s
    puts '--------------------------'
  end

  def bubble_sort
    # Start by comparing the first element with second, if its greater then swap both. And go on further.
    # ---- Complexity ----- #
    # (n-1) + (n-2) + (n-3) + ..... + 3 + 2 + 1
    # Sum = n(n-1)/2
    # i.e O(n2)
    # --------------------- #
    # Average Time Complexity [Big-theta]: O(n2)
    # Worst Case Time Complexity [ Big-O ]: O(n2)
    # Best Case Time Complexity [Big-omega]: O(n)
    # Space Complexity: O(1)
    (1..(@array.length - 2)).each do |num|
      swapped = false
      (0..(@array.length - num - 1)).each do |i|
        if @array[i] > @array[i + 1]
          swapped = true
          @array[i], @array[i + 1] = @array[i + 1], @array[i]
        end
      end
      break unless swapped
    end
    @array
  end
  def selection_sort
    # Find smallest element in array and swap with first element. And go on to sort further.
    # Worst Case Time Complexity [ Big-O ]: O(n2)
    # Best Case Time Complexity [Big-omega]: O(n2)
    # Average Time Complexity [Big-theta]: O(n2)
    # Space Complexity: O(1)
    (0..@array.length - 1).each do |num|
      smallest = num
      (num..@array.length - 1).each do |i|
        if @array[i] < @array[smallest]
          smallest = i
        end
      end
      @array[num], @array[smallest] = @array[smallest], @array[num]
    end
    @array
  end

  def insertion_sort
    # Worst Case Time Complexity [ Big-O ]: O(n2)
    # Best Case Time Complexity [Big-omega]: O(n)
    # Average Time Complexity [Big-theta]: O(n2)
    # Space Complexity: O(1)
    (1..@array.length - 1).each do |i|
      j = i
      while (j > 0) && (@array[j - 1] > @array[j])
        @array[j - 1], @array[j] = @array[j], @array[j - 1]
        j -= 1
      end
    end
    @array
  end

  def merge_sort(list = @array)
    # Divide and Conquer: Keep dividing array until solo elements are not present, then merge in sorted manner.
    # Worst Case Time Complexity [ Big-O ]: O(n*log n)
    # Best Case Time Complexity [Big-omega]: O(n*log n)
    # Average Time Complexity [Big-theta]: O(n*log n)
    # Space Complexity: O(n)
    return list if list.size <= 1
    mid = list.size / 2
    left = list.take(mid)
    right = list.drop(mid)
    merge(merge_sort(left), merge_sort(right))
  end

  private
  def merge(left, right)
    sorted = []
    until left.empty? || right.empty?
      if left.first <= right.first
        sorted << left.shift
      else
        sorted << right.shift
      end
    end
    @array = sorted.concat(left).concat(right)
  end
end

```

#### Triangle programs

```ruby
class Figures
  attr_accessor :size

  def initialize(size)
    self.size = size
  end

  # ======================================== #
  def right_angle_triangle
    (1..self.size).each do |counter|
      counter.times.each do
        print "*"
      end
      puts
    end
  end

  # ======================================== #
  def equilateral_triangle
    (1..self.size).each do |counter|
      (self.size - counter).times do
        print " "
      end

      (2 * counter - 1).times.each do
        print "*"
      end

      puts
    end
  end

  # ======================================== #
  def facing_triangles
    (1..self.size).each do |counter|
      (counter).times do |count|
        print count + 1
      end
      (2 * (self.size - counter)).times do
        print " "
      end
      (counter).times do |count|
        print count + 1
      end
      puts
    end
  end

  # ======================================== #
  def mirror_image
    (1..self.size).each do |counter|
      counter.times do |count|
        print count + 1
      end
      (2 * (self.size - counter)).times do
        print " "
      end
      (counter).times do |count|
        print counter - count
      end
      puts
    end
  end
end
```

