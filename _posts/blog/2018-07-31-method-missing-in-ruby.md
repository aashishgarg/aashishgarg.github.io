---
layout: post
share: true
title: ":method_missing in rails"
modified: 2018-07-31T08:20:50-04:00
categories: blog
excerpt:
tags: []
image:
  feature:
date: 2018-07-31T02:20:50-04:00
---

When we call any random method on any object in rails which is not defined then rails handles it through a method **method_missing**.
We can utilize the :method_missing in our code like below code - 

```ruby
class MyClass
  def method_missing(method, *args)
    puts "You called: #{method}(#{args.join(', ')})"
    puts 'You also passed a block' if block_given?
  end
end
MyClass.new.non_existing_method # => You called: non_existing_method()
MyClass.new.non_existing_method 'a', 123, :c # => You called: non_existing_method(a, 123, c)
MyClass.new.non_existing_method(:a, :b, :c) { puts 'a block' } # => You called: non_existing_method(a, b, c)
# => You also passed a block
```
