---
layout: post
share: true
title: "instance_eval method in ruby"
modified: 2018-07-30T08:20:50-04:00
categories: blog
excerpt:
tags: []
image:
  feature:
date: 2018-07-30T05:20:50-04:00
---

**:instance_eval** in ruby allows to execute a block in the contect of another object.

```ruby
class Foo
  def initialize
    @z = 1
  end
end
foo = Foo.new
foo.instance_eval do
  puts self # => #<Foo:0x7d15e891>
  puts @z # => 1
end
new_value = 2
foo.instance_eval { @z = new_value }
foo.instance_eval { puts @z } # => 2

# There is also `instance_exec` which works the same way but allows passing arguments to the block
class Foo
  def initialize
    @x = 1
    @y = 2
  end
end
Foo.new.instance_exec(3) { |arg| (@x + @y) * arg } # => 9
```
