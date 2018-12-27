---
layout: post
share: true
title: "Ruby’s Binding Class (binding objects)"
modified: 2018-07-20T08:20:50-04:00
categories: ruby
excerpt:
tags: []
image:
  feature:
date: 2018-07-20T02:20:50-04:00
---

A **Binding** is a whole scope packaged as an object. The idea is that you can create a Binding to capture the local scope 
and carry it around. Later, you can execute code in that scope by using the Binding object in conjunction with eval( ), 
instance_eval( ), or class_eval( ). You can create a binding with the Kernel#binding() method.

Instances of the binding class capture the environment bindings(variables, methods and self) at any point of a ruby program, 
so the binding can be reused later, when the scope has changed.

```ruby
class A
  def hi
    @a = 'a'
    b = 'b'
    binding
  end
end
 
binding = A.new.hi # returns a binding object
eval("b.concat('aaaaa')", binding) # => "baaaaa"
eval("self", binding) # => "baaaaa" # => #<A:0x007f87022c8ce8 @a="a">
eval("instance_variable_get('@a')", binding) # => "a"
```

The TOPLEVEL_BINDING object stores a reference to the top level scope.

```ruby
@blah = 'moo'
module M
  def self.hi
    eval("@blah", TOPLEVEL_BINDING)
  end
end
 
M::hi # => 'moo'
```

The binding class also defines an eval() method that can be used on binding objects.

```ruby
class Cat
  def sad
    sound = 'meow'
    binding
  end
end
 
binding = Cat.new.sad
binding.eval("sound") # => 'meow'
 
# Kernel#eval() can be used instead of Binding#eval()
eval("sound", binding) # => 'meow'
```
