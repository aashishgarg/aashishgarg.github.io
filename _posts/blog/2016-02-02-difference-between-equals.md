---
layout: post
title: "Difference between == and === and eql? and equal? in ruby"
modified:
categories: blog
excerpt:
tags: []
image:
  feature:
date: 2016-02-02T08:20:50-04:00
---

(==) compares the value of objects and returns true/false 
(eql?) compares the value of objects and returns true/false

```ruby
  'ashish' == 'ashish'   #=> true
  'ashish'.eql?('ashish')   #=> true
```

(equal?) compares the object_id and return true/false

```ruby
  'ashish'.equal?('ashish')   #=> false
  1.equal?(1)   #=> true
  :ashish.equal?(:ashish)   #=> true 
```

(===) compares whether right hand side object belongs to the Class on left hand side or class of object on left hand side.

```ruby
  'ashish' === 'ashish'  #=> true
  String === 'ashish'    #=> true
```
