---
layout: post
share: true
title: "New features in Ruby 2.3.X"
modified: 2017-11-06T08:20:50-04:00
categories: ruby
excerpt:
tags: []
image:
  feature:
date: 2017-11-06T08:20:50-04:00
---

Some new syntax's were introduced in Ruby 2.3.0 to make coding simpler.

#### Safe navigation operator

A new operator(&.) has been introduced. If the object calling a method is nil then it does not raise an error instead return nil. It really saves the developer from nil handling conditions in a chain.

```ruby
a = nil
a.upcase
#=> NoMethodError: undefined method `upcase' for nil:NilClass

a = nil
a&.upcase
#=> nil
```

#### Array#dig and Hash#dig

Now we can access nested elements in array nad hashes in much simpler manner.

```ruby
list = [
    [2, 3],
    [5, 7, 9],
    [ [11, 13], [17, 19] ]
]

list.dig(1, 2)    #=> 9
list.dig(2, 1, 0) #=> 17
list.dig(0, 3)    #=> nil
list.dig(4, 0)    #=> nil


 dict = {
    a: { x: 23, y: 29 },
    b: { x: 31, z: 37 }
}

dict.dig(:a, :x) #=> 23
dict.dig(:b, :z) #=> 37
dict.dig(:b, :y) #=> nil
dict.dig(:c, :x) #=> nil

```

#### Hash comparison

Hashes now have the comparison operator on them. If you see (a>=b), it is checking if all the key-value pairs in b are present in a.

```ruby
{ x: 1, y: 2 } >= { x: 1 } #=> true
{ x: 1, y: 2 } >= { x: 2 } #=> false
{ x: 1 } >= { x: 1, y: 2 } #=> false
#=> nil
```

#### Hash#fetch_values

It fetches the values corresponding to the list of keys we pass in. It works like (Hash#values_at). The difference is that #values_at returns nil if key does not exist while #fetch_values raises keyError for the keys that does not exist.

```ruby
h = { foo: 1, bar: 2, baz: 3}
h.fetch_values(:foo, :bar) #=> [1, 2]
h.values_at(:foo, :quux)    #=> [1, nil]
h.fetch_values(:foo, :quux) #=> raise KeyError
#=> nil
```

#### Numeric#positive? and Numeric#Negative?

These functions have been around in Rails core extensions and now have been included in the ruby.

```ruby
1.positive?  #=> true
-1.negative? #=> true
#=> nil
```
