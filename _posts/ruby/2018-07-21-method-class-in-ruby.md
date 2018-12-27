---
layout: post
share: true
title: "Method class in ruby"
modified: 2018-07-21T08:20:50-04:00
categories: ruby
excerpt:
tags: []
image:
  feature:
date: 2018-07-21T02:20:50-04:00
---

Ruby methods can be accessed as objects that are bound to a class. Methods aren’t technically objects in Ruby, but you can wrap them in objects.

```ruby
class A
  def hi
    'A#hi'
  end
end
 
method = A.new.method(:hi)
p method # => #<Method: A#hi>
p method.call # => 'A#hi'
```
Method objects can be compared with other method object, called, and unbound from an object.
 
```ruby
class Cow
  def moo
    'A method'
  end
end
 
c = Cow.new
method = c.method(:moo)
method == c.method(:moo) # => true
method.call # => 'A method'
unbound = method.unbind # => #<UnboundMethod: Cow#moo>
unbound.call # => error because UnboundMethod objects cannot be called
unbound.bind(c) # rebind the unbound method to the c object
```




