---
layout: post
share: true
title: "=== Triple equal in ruby"
modified: 2018-07-31T08:20:50-04:00
categories: blog
excerpt:
tags: []
image:
  feature:
date: 2018-07-31T02:20:50-04:00
---

```ruby
a === b
```
 It means If (a) describes a set, would (b) a member of that set?
 
```ruby
(1..5) === 3           # => true
(1..5) === 6           # => false

Integer === 42          # => true
Integer === 'fourtytwo' # => false

/ell/ === 'Hello'     # => true
/ell/ === 'Foobar'    # => false
```




