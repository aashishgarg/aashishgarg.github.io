---
layout: post
share: true
title: "Difference between && and (and) in Ruby"
modified: 2015-12-27T08:20:50-04:00
categories: blog
excerpt:
tags: []
image:
  feature:
date: 2015-12-27T08:20:50-04:00
---

Till the date I used to believe that in ruby && and (and) are completely replaceable but in actual its not the case 
at all.

**Difference** 

Precedence of the operators is point to note/remember here.

&& has a higher precedence over = and (and).
while
(and) has a lower precedence over = and &&.

```ruby
  a = true and false #(Here a = true will be evaluated first and and the value of a becomes true.)
  a = true && false  #(Here true && false will be evaluated first and the value of a becomes false.)
```

### Same is the case with || and or. ###
