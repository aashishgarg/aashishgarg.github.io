---
layout: post
share: true
title: "Partial application and curring in ruby"
modified: 2018-07-31T08:20:50-04:00
categories: ruby
excerpt:
tags: []
image:
  feature:
date: 2018-07-31T02:20:50-04:00
---

**Partial function application** is calling a function with some number of arguments, in order to get a function back that will take that many less arguments. 

**Currying** is taking a function that takes n arguments, and splitting it into n functions that take one argument. 


```ruby
a = proc { |x| proc { |y| proc { |z| x + y + z } } }

b = a.call(1)
#-> #<Proc:0x000055840ba2a9b0@(irb):23>

c = b.call(2)
#-> #<Proc:0x000055840b9f6d90@(irb):23>

c.call(3)
# 6


# Curring - 
a.curry[1][2]
#-> #<Proc:0x000055840b8a8a10@(irb):23>

a.curry[1][2][4]
# 7
```

