---
layout: post
share: true
title: "class_eval method in ruby"
modified: 2018-07-30T08:20:50-04:00
categories: blog
excerpt:
tags: []
image:
  feature:
date: 2018-07-30T05:20:50-04:00
---

**:class_eval** method is one of the way to define the class re-opening code in a more flexible manner.
It works on any variable that references a class whereas re-opening a class requires defining a constant.

```ruby
# Classic class re-opening style
class String
  def m
    puts 'hello!'
  end
end

# Class eval style
# The extra code is used to make the example a bit more re-usable/abstracted
def add_method_to_class(the_class)
  the_class.class_eval do
    def m
      puts 'hello!'
    end
  end
end

add_method_to_class String
'abc'.m # => hello!
```
