---
layout: post
share: true
title: "Difference between p, print and puts in ruby"
modified: 2015-12-20T08:20:50-04:00
categories: ruby
excerpt:
tags: []
image:
  feature:
date: 2015-12-20T08:20:50-04:00
---

Difference between p, print and puts in ruby is something which a new ruby learner comes across with.

But I have seen many times an expert doesn't feel very comfortable or able to tell you the exact difference these three.

In simple words - 

print and puts return nil.
While p return whatever it is given in print. 

```ruby
a = puts "Hello"   #(prints line and takes the control to next line.)
b = print "Hello"  #(prints line and takes the control to the end of the line.)

#=> Here value of a and b would be nil. 

c = p "Hello"      #(prints line and takes the control to next line.)

#=> Here value of c would be "Hello".
```
