---
layout: post
share: true
title: "Module namespace interpolation in rails"
modified: 2018-07-29T08:20:50-04:00
categories: ruby
excerpt:
tags: []
image:
  feature:
date: 2018-07-29T05:20:50-04:00
---

```ruby
type = 'baz'
Foo::Bar.const_get(type.capitalize).new
# => new instance of Foo::Bar::Baz
```
