---
layout: post
share: true
title: "DS programs in ruby"
modified: 2018-07-16T08:20:50-04:00
categories: blog
excerpt:
tags: []
image:
  feature:
date: 2018-07-16T08:20:50-04:00
---

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

#### Sorting

```ruby
# Algorithm complexity sequence -
# O(1) -> O(logn) -> O(n) -> O(nlogn) -> O(n*n) -> O(n*n*n) -> (O(2 exp n) or O(10 exp n))

class Array
  def apply_bubble_sort
    # ------------------------------------------------------------------- #
    # go for (n-1) passes and compare two adjacent elements successively
    # and interchange them if required.
    # ------------------------------------------------------------------- #

    (1..self.length).each do |counter|
      (0..(self.length - counter - 1)).each do |count|
        if self[count] > self[count + 1]
          self[count], self[count + 1] = self[count + 1], self[count]
        end
      end
    end
  end

  def apply_selection_sort
    # ------------------------------------------------------------------- #
    # go for (n-1) passes and keep selecting the smallest element of each pass
    # and replace with first element of array for that pass.
    # ------------------------------------------------------------------- #

    (self.length - 1).times do |i|
      min_index = i

      (i + 1).upto(self.length - 1) do |j|
        min_index = j if self[j] < self[i]
      end

      self[i], self[min_index] = self[min_index], self[i] if min_index != i
    end
  end
end
```


