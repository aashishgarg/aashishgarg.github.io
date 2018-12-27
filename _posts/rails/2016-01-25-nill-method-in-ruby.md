---
layout: post
share: true
title: "nil? method in ruby in ruby"
modified: 2016-01-25T08:20:50-04:00
categories: blog
excerpt:
tags: []
image:
  feature:
date: 2016-01-25T08:20:50-04:00
---

.nil? on anything in ruby returns true or false based on whether its value is nil or not.

Remember only false and nil return nil in ruby. Nothing else returns nil. 

```ruby
  0.nil?              #=> false
  [].nil?             #=> false
  "false".nil?        #=> false
  nil.nil?            #=> true
  false.nil?          #=> true
```
