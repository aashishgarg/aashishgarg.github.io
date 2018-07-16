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


