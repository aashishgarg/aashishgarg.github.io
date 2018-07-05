---
layout: post
share: true
title: "New methods introduced in ruby 2.5"
modified: 2017-12-06T08:20:50-04:00
categories: blog
excerpt:
tags: []
image:
  feature:
date: 2017-12-05T08:20:50-04:00
---

### Ruby 2.5
Ruby 2.5 was released on 25 Dec 2017. A lot of improvements were introduced in this release. 
New methods were part of this improvements.

#### How we handle modal in application efficiently

* New methods on array

** prepend

```ruby
a = nil
a.upcase
#=> NoMethodError: undefined method `upcase' for nil:NilClass

a = nil
a&.upcase
#=> nil
```

Thanks for reading!!!
